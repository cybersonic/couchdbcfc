CouchDBCFC
==========

CouchDB.cfc is a simple Railo Server CFC to access documents and views for CouchDB http://couchdb.apache.org/

It allows CFML based applications to easily and quickly access Couch Databases.


Installation
------------

All you need to do is instantiate CouchDB.cfc as a singleton, passing it the host, port and database you want to use:


 <cfscript>
   application.couch = new CouchDB("localhost", "5984", "myDB");
 </cfscript>


Then you can use the following methods:

 <cfscript>
	//Get a document 
	myDoc = application.couch.getDocment("id");
	
	//get the results of a view
	myView = application.couch.getView("viewname");
	
	//design of the view 
	myViewDesign = application.couch.getViewDesign("viewname");
	
	stMyDoc = {
		_id = "elvis",
		name = "Elvis Prestley",
		songs = ["Are you lonesome tonight", "Jailhouse Rock"]
	}
	
	
	//update an existing document
	result = application.couch.update("elvis", stMyDoc);
	
	//insert a new document
	result = application.couch.insert("elvis", stMyDoc);
	
	
	//delete a document
	application.couch.delete("elvis");
	
	
	//delete all documents
	application.couch.deleteAll();
	
 </cfscript>	




