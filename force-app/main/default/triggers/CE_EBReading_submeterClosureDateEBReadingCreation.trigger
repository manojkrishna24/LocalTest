trigger CE_EBReading_submeterClosureDateEBReadingCreation on EB_Reading__c (after insert) {
    System.debug('Inside CE_EBReading_submeterClosureDateEBReadingCreation Trigger');
    List<List<EB_Reading__c>> FinalListToBeUpdated = new List<List<EB_Reading__c>>();
    List<Id> listOfEBReadingIds = new List<Id>();
    
    for(EB_Reading__c eb:Trigger.New){
        if(eb.Submeter_Closure_Date__c!=null && eb.End__c>eb.Submeter_Closure_Date__c && eb.Start__c<eb.Submeter_Closure_Date__c){
           // listOfEBWithSCDate.add(eb);
            listOfEBReadingIds.add(eb.Id);
        }
    }
    List<EB_Reading__c> listOfEBWithSCDate =[SELECT Id,Payment_Date__c,Due_date__c,Amount__c,End_Reading__c,End__c,Overdue_Charges__c,Site_Name__c,Start__c,Payment_Type__c,Submeter_Closure_Date__c from EB_Reading__c where Id in:listOfEBReadingIds];
    if(listOfEBWithSCDate!=null && listOfEBWithSCDate.size()>0){
        FinalListToBeUpdated = CE_EBReadingSubmeterClosureDate.CreateEBReading(listOfEBWithSCDate);
        
    }
    if(FinalListToBeUpdated!=null && FinalListToBeUpdated.size()>=2){
        update FinalListToBeUpdated[1];
        insert FinalListToBeUpdated[0];
    }
       
}