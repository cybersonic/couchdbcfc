component{
	
	
	function init(host="localhost", port="", db){
		
		variables.host = host;
		variables.port = port;
		variables.db = db;
		variables.mainurl = "http://#host#:#port#/";
		variables.dbserver = "http://#host#:#port#/#db#";
		
		return this;
	}
	
	/* Main http call for all functions */
	function relax(stArgs, aParams=[]){
		var relax = new HTTP(argumentCollection=stArgs);
			for(p in aParams){
				relax.addParam(p)
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
	function bulkDocs(Struct documents=[]){
		var dburl = variables.dbserver & "/_bulk_docs";
		
			var relax = new HTTP(url=dburl, method="POST");
				relax.addParam(type="header", name="Content-Type", value="application/json");
				relax.addParam(type="BODY", value=SerializeJSON(documents), label="text/json");
				var res1 = relax.send().getPrefix();
			return DeSerializeJSON(result);
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
	
	function unsafe_instert(id, document){
			var update = new HTTP(url="#variables.dbserver#/#arguments.id#", method="PUT");
				update.addParam(type="BODY", value=SerializeJSON(document));
			var insres = update.send().getPrefix();
			return insres;
	}
	
	
	function deleteDatabase(){
		var command = {
			url=variables.dbserver,
			method="DELETE"
		};
		return relax(command);
	}
	function createDatabase(){

			var create = new HTTP(url="#variables.mainurl#/#variables.db#", method="PUT");
				create.addParam(type="BODY", value=variables.db);
			var rCreate = create.send().getPrefix();
			return rCreate;
	}
	
	function delete(id, rev){
			var	command = {
				url = variables.dbserver & "/" & arguments.id & "?rev=" & arguments.rev,
				method = "delete"
			};
		return relax(command);
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