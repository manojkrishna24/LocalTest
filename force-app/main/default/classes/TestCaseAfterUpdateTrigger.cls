@isTest
public class TestCaseAfterUpdateTrigger {
    
    @testSetup static void setdata(){
        //Test.setMock(HttpCalloutMock.class, new HttpResponseGenerator());
        /*User u = new User(LastName='FEUser',Email='FE@gmail.com',Alias='FE',Username='FE123@gmail.com',CommunityNickName='FE User');
        insert u;*/
       /* Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        System.debug(p);
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='cefestandarduser@testorg.com');
        insert u;*/
        Case testcase=new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '1',
            IsExcelRecord__c = true,
            Origin='Telegram',
           // FieldEngineerUser__c=u.Id,
            Status='New',
            HoldReason__c='Access issue'
        );
        insert testcase;
    }
    @isTest static void testmethod1(){
        Case myCase=[SELECT Id FROM Case LIMIT 1];
        //myCase.FieldEngineerUser__c='005C7000000IXRgIAO';
        myCase.Subject='Resolved';
        update myCase;
    }
    /*@isTest static void testmethod2(){
        Case myCase=[SELECT Id FROM Case LIMIT 1];
        //myCase.FieldEngineerUser__c='005C7000000IXRgIAO';
        myCase.Status='In Progress';
        myCase.ContactId = '003C700000DADFoIAP';
        update myCase;
    }*/
}

//String responseBody = System.Test.isRunningTest() ? TicketWrapperClass.mockedTicketResponse(ticketInputList) :EventHandler.insertDataApiCall(Eventhandler.HerokuURL + Eventhandler.HerokuAPIMap.get('getTicket'), ticketInputList);