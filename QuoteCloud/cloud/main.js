var xmlReader = require('cloud/xmlreader.js');
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
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
			return saveQuote( response, 'json' );
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
            //return saveQuote( response, 'xml' );
            return response;
        },
        error: function(response){
            console.log("Request failed with error " + JSON.stringify(response));
        }
	}).then( function( response ){
        saveQuote( response, 'xml' ).then(function(quote){
            status.success("successfully saved quotes from StandS4 " + quote);
        });
        //status.success("successfully downloaded quotes from StandS4 " + JSON.stringify(response));
    }, function(error){
        status.error("Failed to download quotes from StandS4 \n Error: " + JSON.stringify(error));
    });
});

//Send out a notification whenever a new Quote is created
Parse.Cloud.afterSave("Quote", function(request){
    var author = request.object.get('author');
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo('deviceType','ios');

    Parse.Push.send({
        where: pushQuery,
        data:{ alert: "New Quote by " + author + " added." }
    }, {
        success: function(){ console.log("Successfully sent the push notification for new quote by " + author); },
        error: function(error){ throw "Got an error " + error.code + " : " + error.message + " for author " + author; }
    });
});

function saveQuote( response, type ){
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
    var quote = new Quote();
    quote.set('author',json["source"]);
    quote.set('quote', json["quote"]);
    quote.save(null,{
        success: function(quote){
            console.log("Successfully saved quote: " + quote.quote + " to DB");
            promise.resolve(quote);
        },
        error: function(gamescore, error){
            console.error(error);
            promise.reject(error);
        }
    });
    return promise;
}
