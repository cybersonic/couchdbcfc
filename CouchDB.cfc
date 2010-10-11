component{
	
	
	function init(host="localhost", port="", db){
		variables.dbserver = "http://#host#:#port#/#db#";
		return this;
	}
	
	/* Main http call for all functions */
	function relax(stArgs, aParams=[]){
		var relax = new HTTP(argumentCollection=stArgs);
			for(p in aParams){
				myRes.addParam(p)
			}
		var result = relax.send().getPrefix().filecontent;
		return DeSerializeJSON(result);
	}
	
	function getDocument(id){
		return relax({url=variables.dbserver & "/" & id});
	}
	
	function getView(viewname, key=""){
		var dburl = variables.dbserver & "/_design/#viewname#/_view/#viewname#";

	
		
		if(Len(key)){
			dburl = dburl & '?key="#key#"';
		}
		return relax({url=dburl});
	}
	
	function getViewDesign(viewname){
		return relax({url=variables.dbserver & "/_design/" & viewname});
	}
	
	function update(id, document){
			var update = new HTTP(url="#variables.dbserver#/#arguments.id#", method="PUT");
				update.addParam(type="BODY", value=SerializeJSON(document));
			var insres = update.send().getPrefix();
			return insres;
	}
	
	function insert(id, document){
		//Get it first...
		var check = new HTTP(url="#variables.dbserver#/#arguments.id#", method="GET").send().getPrefix();
	
		//if it doesn't exist, safe to insert
		if(check.status_code EQ 404){
			var insert = new HTTP(url="#variables.dbserver#/#arguments.id#", method="PUT");
				insert.addParam(type="BODY", value=SerializeJSON(document));
			var res = insert.send().getPrefix();
		}
		//It must exist! Let's get the revision
		else {
			document["_rev"] = DeSerializeJSON(check.filecontent)._rev; // _rev is case-sensitive
			//
			var update = new HTTP(url="#variables.dbserver#/#arguments.id#", method="PUT");
				update.addParam(type="BODY", value=SerializeJSON(document));
			var insres = update.send().getPrefix();
		}
	}
	
	function delete(id, rev){
			var	command = {
				url = variables.dbserver & "/" & arguments.id & "?rev=" & arguments.rev,
				method = "delete"
			};
			relax(command);
	}
	
	function deleteAll(){
		var command = {
			url=variables.dbserver & "/" & "_all_docs",
			method="get"
		}
		var allDocs = relax(command);
		for(var d in allDocs.rows){
			delete(d.id, d.value.rev);
		}
	}
}