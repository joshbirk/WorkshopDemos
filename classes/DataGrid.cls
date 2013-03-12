public with sharing class DataGrid {

	public ID recordId {get; set;}
	public String query {get;set;}
	public String caption {get;set;}

	public DataGrid() {}
	
	@RemoteAction
	static public List<SObject> soql(String soql) {
	//	soql = String.escapeSingleQuotes(soql);
		return Database.query(soql);
	}

}