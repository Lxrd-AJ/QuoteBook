var xmlReader = require('cloud/xmlreader.js');
var SchemaUpdate = require('cloud/update_schema.js');

// Parse.initialize("z3rPfifyHvVjZh2U9KsWOEQz9GOWPOYc1o8LCfDk","FwQhD5OP1XXVQyztjq1mj3ujw7TGWM8C3JkHuEKf");//"AppID,JS_key"

Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.define("Update_Schema", function(request,response){
    SchemaUpdate.findQuotes().then(function(quotes){
        var hashMap = SchemaUpdate.convertResultToMap(quotes);
        console.log(hashMap);
        //SchemaUpdate.createAuthorsFromMap(hashMap);
        //response.success( hashMap );
    });
});

Parse.Cloud.job("fetchQuotes", function(request,status){
	status.message("Currently executing the job");
	Parse.Cloud.httpRequest({
		url: "http://www.iheartquotes.com/api/v1/random",
		params: {
			"format":"json",
			"max_lines":"10",
			"max_characters":"65",
		},
		success: function( response ){
			return saveQuote( response, 'json' , 'iHeartQuotes');
		},
		error: function( response ){
			console.log("Request failed with response code" + response.status );
		}
	}).then( function( response ){
		//Job success
		status.success("Downloaded quote successfully " + response);
	}, function( error ){
		status.error("Failed to download quote from iheartquotes @" + new Date().toLocaleDateString('en-GB') +"\n" + JSON.stringify(error));
	});
});
// "source": "prog_style+joel_on_software"

Parse.Cloud.job("fetchQuotesFromStandS4", function(request,status){
	status.message("Fetching Quotes from StandS4");
    var uid = "3916";
    var tokenID = "BdMqLvNaGKj7phuX";
    var query = "";
    var searchtype = "RANDOM"; //or SEARCH , AUTHOR
	Parse.Cloud.httpRequest({
		url: "http://www.stands4.com/services/v2/quotes.php?uid="+uid+"&tokenid="+tokenID+"&searchtype="+searchtype,
        success: function(response){
            return response;
        },
        error: function(response){
            console.log("Request failed with error " + JSON.stringify(response));
        }
	}).then( function( response ){
        saveQuote( response, 'xml', 'StandS4' ).then(function(quote){
            status.success("successfully saved quotes from StandS4 " + quote);
        });
        //status.success("successfully downloaded quotes from StandS4 " + JSON.stringify(response));
    }, function(error){
        status.error("Failed to download quotes from StandS4 \n Error: " + JSON.stringify(error));
    });
});

Parse.Cloud.beforeSave("Author", function(request,response){
    var newAuthor = request.object;
    var authorQuery = new Parse.Query("Author")
    authorQuery.limit(1000);
    //Prevent Duplicate authors
    authorQuery.find().then(function(authors){
        var authorNotExists = authors.every(function(author){
            return author.get('name') !== newAuthor.get('name');
        });
        if( authorNotExists ){ response.success(); }
        else{ console.log("Duplicate Author"); response.error(); }
    });
});

Parse.Cloud.beforeSave("Quote", function(request,response){
    var Quote = Parse.Object.extend("Quote");
    var query = new Parse.Query(Quote);
    var limit = 1000;
    var skip = 0;
    var found = false;
    query.limit(limit);
    var newQuote = request.object;
    //Find the total number of quotes in the database
    query.count({
        success: function(count){
            console.log("Quotes Count " + count);
            if( count > limit ){ //default parse query limit
                console.log("Count of Quotes greater than 1000");
                var diff = count - limit;
                while( (diff > 0) && !found ){
                    if(limit <= diff){ query.limit(limit); }
                    else{ query.limit(diff); }
                    validateQuotesWithQuery(query,response);

                    diff -= limit; skip += limit;
                    query.skip(skip);
                }
            }else{
                console.log("Quotes count not greater than " + limit);
                validateQuotesWithQuery(query,response);
            }
        },error: function(error){
            console.error( error );
        }
    });

    function validateQuotesWithQuery( query,response ){
        //By default a query limits itself to 100, check if more and go beyond!
        query.find({
            success: function(quotes){
                //Prevent Duplicate quotes
                for( var i = 0; i < quotes.length; i++ ){
                    var quote = quotes[i];
                    if( quote.get('quote') === newQuote.get('quote') ){
                        if( quote.get('author') === newQuote.get('author') ){
                            //response.error();
                            found = true; break;
                        }
                    }
                }
                if(!found){response.success()}
                else{ response.error("Quote already exists")}
            },
            error: function(error){
                console.error(error);
                response.error("An Error occurred while trying to fetch the quotes");
            }
        });
    }

});

//Send out a notification whenever a new Quote is created
Parse.Cloud.afterSave("Quote", function(request){
    var author = request.object.get('author');
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo('deviceType','ios');

    Parse.Push.send({
        where: pushQuery,
        data:{
            alert: "New Quote by " + author + " added.",
            objectID: request.object.id
        }
    }, {
        success: function(){ console.log("Successfully sent the push notification for new quote by " + author); },
        error: function(error){ throw "Got an error " + error.code + " : " + error.message + " for author " + author; }
    });
});

function saveQuote( response, type, source ){
    Parse.Cloud.useMasterKey();
    var promise = new Parse.Promise();
    var json = {};
    if (type === 'xml'){
        //console.log(response);
        xmlReader.read( response.text, function(err,res){
            if(err){ console.error(err); }
            json.source = res.results.result.author.text();
            json.quote = res.results.result.quote.text();
        });
    }else{ json = response.data; }

    var Quote = Parse.Object.extend("Quote");
    var Author = Parse.Object.extend("Author")
    var authorQuery = new Parse.Query(Author);
    var quote = new Quote();

    quote.set('author',json["source"]);
    quote.set('quote', json["quote"]);
    quote.set('source', source);

    authorQuery.equalTo("name",json["source"]);
    authorQuery.first({
        success: function(author){
            quote.set('parent',author);
            saveQuote(quote);
        },error: function(error){
            //create a new author
            var author = new Author();
            author.set('name',json["source"]);
            quote.set("parent",author); //Trust issues
            author.save(null,{
                success: function(author){
                    quote.set("parent",author);
                    saveQuote(quote);
                }
            })
        }
    });

    function saveQuote(quote){
        quote.save(null,{
            success: function(quote){
                console.log("Successfully saved quote: " + quote.get('author') + " to DB");
                promise.resolve(quote);
            },
            error: function(quote, error){
                console.error(error);
                promise.reject(error);
            }
        });
    }

    return promise;
}
