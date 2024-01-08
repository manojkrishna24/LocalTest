trigger CE_SiteProposal_UpdateVersion on Site_Proposal__c (before insert,before update) {
  		Site_Proposal__c sp =Trigger.new[0];
Id customer = sp.Customer__c; 
Id sitename = sp.Site_Name__c;
Id project = sp.Project__c;
    Id recId = sp.Id;
   if (Trigger.isBefore) {
        if (Trigger.isInsert) {
 			AggregateResult maxVersionResult = [SELECT MAX(Version__c) maxVersion FROM Site_Proposal__c WHERE Customer__c = :customer AND Project__c = :project AND Site_Name__c=:sitename];
			System.debug(maxVersionResult);
    		Decimal maxVersion = (Decimal)maxVersionResult.get('maxVersion');
    		Decimal latestVersion =1;	
    		if(maxVersion!= null){
            	latestVersion=maxVersion+1;
        	}
   			sp.Version__c=latestVersion;  
        }}
    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            AggregateResult maxVersionResult = [SELECT MAX(Version__c) maxVersion FROM Site_Proposal__c WHERE Customer__c = :customer AND Project__c = :project AND Site_Name__c=:sitename AND Id!=:recId];
			System.debug(maxVersionResult);
    		Decimal maxVersion = (Decimal)maxVersionResult.get('maxVersion');
    		Decimal latestVersion =1;	
    		if(maxVersion!= null){
            	latestVersion=maxVersion+1;
        	}
   			sp.Version__c=latestVersion;  
            
        }}
    
}