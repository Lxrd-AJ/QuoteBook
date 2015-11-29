
exports.findQuotes = function(){
    //Get all the quotes
    // var Quote = Parse.Object.extend("Quote");
    // var quote = new Quote();
    var quotesQuery = new Parse.Query("Quote");
    quotesQuery.limit(1000);
    //quotesQuery.orderByDescending("createdAt");
    return quotesQuery.find();
}

exports.convertResultToMap = function(quotes){
    var hashMap = {};
    for( var i = 0; i < quotes.length; i++ ){
        var author = quotes[i].get('author');
        var quote = quotes[i]; //quotes[i].get('quote');
        if( !hashMap[author] ){ hashMap[author] = []; }
        hashMap[author].push(quote);
    }
    return hashMap;
}

exports.createAuthorsFromMap = function(map){
    var Author = Parse.Object.extend("Author");

    for( var key in map ){
        if(map.hasOwnProperty(key)){
            var author = new Author();
            author.set("name",key);
            //console.log("Setting up author " + key );
            author.save(null,{
                success: function(author){
                    console.log("Successfully saved author: " + author.get('name'));
                    //Set all the quotes as children of this author
                    var quotes = map[key]
                    quotes.forEach(function(quote){
                        quote.set("parent",author);
                        quote.save();
                    })
                },error: function(author,error){
                    console.error("Failed to save author: " + author);
                    console.error(error);
                }
            });
        }
    }
}

exports.updateQuoteWithAuthor = function(quote,author){
    var promise = new Parse.Promise();
    if( !author ){console.error("No Author for quote"); return; }
    quote.set("parent",author);
    quote.set("executeTriggers",false);
    quote.save(null,{
        success: function(quote){ promise.resolve(quote); },
        error: function(err){ promise.reject(err); }
    });
    return promise
}

exports.getAuthorForQuote = function(quote){
    var authorName = quote.get("author");
    var Author = Parse.Object.extend("Author");
    var authorQuery = new Parse.Query(Author);
    authorQuery.equalTo("name",authorName);
    return authorQuery.first().then(function(author){
        return this.updateQuoteWithAuthor(quote,author);
    }.bind(this));
}
