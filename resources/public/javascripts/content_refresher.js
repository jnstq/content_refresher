// TODO Add Authenticity Token, parameters: {authenticity_token:checkContentRefresherOptions.form_authenticity_token}

var updateInProgress = false

function checkContentRefresher() {
  if(!updateInProgress){
  	updateInProgress = true
  	new Ajax.Request(checkContentRefresherOptions.pull_path, {
  	  method:'get',  	  
  	  onSuccess: function(transport){
  	     var json = transport.responseText.evalJSON();
  	     if(json.updated_at != checkContentRefresherOptions.updated_at){
           new Ajax.Request(checkContentRefresherOptions.refresh_path, {method:'get', asynchronous:true, evalScripts:true});
  			 }
  			 checkContentRefresherOptions.updated_at = json.updated_at;
  			 $(checkContentRefresherOptions.error_tag_id).hide();
  	   },
       onFailure: function(transport){
         $(checkContentRefresherOptions.error_tag_id).show();
       }
  	});
  	updateInProgress = false
	}
	setTimeout("checkContentRefresher();", checkContentRefresherOptions.every);	
}