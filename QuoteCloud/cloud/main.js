
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
			var json = response.data;
			var Quote = Parse.Object.extend("Quote");
			var quote = new Quote();
			quote.save({
				author: json["source"],
				quote: json["quote"]
			});
		},
		error: function( response ){
			console.log("Request failed with response code" + response.status );
		}
	}).then( function(){
		//Job success
		status.success("Downloaded quote successfully");
	}, function( error ){
		status.error("Failed to download quote");
	});
})

// "source": "prog_style+joel_on_software"