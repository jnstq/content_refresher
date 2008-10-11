// TODO Add Authenticity Token, parameters: {authenticity_token:checkContentRefresherOptions.form_authenticity_token}

var updateInProgress = false

function checkContentLoop(){
	if(!updateInProgress){
		updateInProgress = true
		checkContentRefresher();
	  updateInProgress = false
	}
	setTimeout("checkContentLoop();", checkContentRefresherOptions.every);	
}

function checkContentRefresher() {
 	new Ajax.Request(checkContentRefresherOptions.pull_path, {
 	  method:'get',  	  
 	  onSuccess: function(transport){
 	     var json = transport.responseText.evalJSON();
 	     if(json.updated_at != checkContentRefresherOptions.updated_at){
          reloadContent()
 			 }
 			 checkContentRefresherOptions.updated_at = json.updated_at;
 			 $(checkContentRefresherOptions.error_tag_id).hide();
 	   },
      onFailure: function(transport){
        $(checkContentRefresherOptions.error_tag_id).show();
      }
 	});
}

function reloadContent(){
  new Ajax.Request(checkContentRefresherOptions.refresh_path, {method:'get', asynchronous:true, evalScripts:true});  
}

function reloadContentLoop(){
	reloadContent();
	setTimeout("reloadContent();", checkContentRefresherOptions.every);		
}