public class CE_EBReadingSubmeterClosureDate {
    public static List<List<EB_Reading__c>> CreateEBReading(List<EB_Reading__c> TriggerNewList){
        List<EB_Reading__c> listToBeUpdated = new List<EB_Reading__c>();
         List<EB_Reading__c> listToBeInserted = new List<EB_Reading__c>();
         List<List<EB_Reading__c>> FinalList = new List<List<EB_Reading__c>>();
        for(EB_Reading__c eb :TriggerNewList){
            EB_Reading__c neweb = new EB_Reading__c();
            neweb.End__c=eb.End__c;
            neweb.End_Reading__c=eb.End_Reading__c;
            neweb.Amount__c=eb.Amount__c;
            neweb.Due_date__c=eb.Due_date__c;
            neweb.Payment_Date__c=eb.Payment_Date__c;
            neweb.Overdue_Charges__c=eb.Overdue_Charges__c;
            neweb.Site_Name__c=eb.Site_Name__c;
            neweb.Start__c=eb.Submeter_Closure_Date__c+1;
            neweb.Submeter_Closure_Date__c=eb.Submeter_Closure_Date__c;
            neweb.Payment_Type__c='Own meter';
            
           
        	
            eb.End_Reading__c=eb.End_Reading__c-2;
           	eb.End__c=eb.Submeter_Closure_Date__c;
       
            neweb.Start_Reading__c=eb.End_Reading__c+1;
            
            
			listToBeUpdated.add(eb);            
           listToBeInserted.add(neweb);
        }
FinalList.add(listToBeInserted);
FinalList.add(listToBeUpdated);
        System.debug('Submeter:');
        for(EB_Reading__c eb : listToBeUpdated){
            System.debug(eb);
        }
 		return FinalList;  
}

}