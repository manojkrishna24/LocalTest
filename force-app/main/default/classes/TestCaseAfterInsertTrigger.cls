@isTest
public class TestCaseAfterInsertTrigger {
    @isTest
    static void testForGPON() {
        Case testCase = new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '0O2-Z1/3/10',
            IsExcelRecord__c = true,
            Origin='Email'
        );

        Test.startTest();
        insert testCase;
        Test.stopTest();

        Case insertedCase = [SELECT Id, GPON_Id__c FROM Case WHERE Id = :testCase.Id LIMIT 1];

        System.assertEquals('0O2-Z1/3/10', insertedCase.GPON_Id__c);
    }

    @isTest
    static void testForFAT() {
        Case testCase = new Case(
            Line_of_Business__c = 'FTTH',
            FATNumber__c = 'ZAV080101',
            IsExcelRecord__c = False          
        );

        Test.startTest();
        insert testCase;
        Test.stopTest();

        Case insertedCase = [SELECT Id, FATNumber__c FROM Case WHERE Id = :testCase.Id LIMIT 1];

        System.assertEquals('ZAV080101', insertedCase.FATNumber__c);
    }
    /*@isTest
    static void testForFAT1() {
        Case testCase = new Case(
            Line_of_Business__c = 'UG',
            IsExcelRecord__c = False,
            Origin='Email',
            Subject='Proactive Ticket',
            Description='Actual Incident Time : 11/20/2024 8:00:23 PM \nSchedule Down Time : 2024-11-23 08:00:00\nSchedule Up Time : 2024-11-24 10:00:00\n'
        );
        Test.startTest();
        insert testCase;
        Test.stopTest();        
    }
    @isTest
    static void testForFAT2() {
        Case testCase = new Case(
            Line_of_Business__c = 'FTTH',
            IsExcelRecord__c = False,
            Origin='Email',
            Subject='Proactive Ticket',
            Description='GPON Id : 0JB-H1//0/15 \n Schedule Down Time : 2024-11-23 08:00:00\nSchedule Up Time : 2024-11-24 10:00:00\n'
        );
        Test.startTest();
        insert testCase;
        Test.stopTest();        
    }*/
    @isTest
    static void testForFAT3() {
        Case testCase = new Case(
            Line_of_Business__c = 'FTTH',
            Description='MSAN IP/Port Details ,Schedule Down Time : 2024-11-23 08:00:00\nSchedule Up Time : 2024-11-24 10:00:00\n'
        );
        Test.startTest();
        insert testCase;
        Test.stopTest();        
    }
    @isTest
    static void testForFAT4() {
        Case testCase = new Case(
            Line_of_Business__c = 'FTTH'
        );
        Test.startTest();
        insert testCase;
        Test.stopTest();        
    }
    
    @isTest
    static void testForcontainsPON(){
        case testCase = new Case(
        	Line_of_Business__c = 'FTTH',
            FTTHCaseType__c='PONMobility',
            FATNumber__c = 'ZAV080101',
            GPON_Id__c='XOT-H1/2/7,0D3-H1/2/8',
            IsExcelRecord__c = False
        );
        Test.startTest();
        insert testCase;
        testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        update testCase;
        Test.stopTest();
    }
    @isTest
    static void testForEqualPON(){
        case testCase = new Case(
        	Line_of_Business__c = 'FTTH',
            FTTHCaseType__c='PON',
            FATNumber__c = 'ZAV080101',
            GPON_Id__c='XOT-H1/2/7,0D3-H1/2/8',
            IsExcelRecord__c = False
        );
        Test.startTest();
        insert testCase;
        /*CaseFTTHComponent__c testComponent = new CaseFTTHComponent__c(
            ComponentId__c = '0E9020104',
            Name='a3771000000HHCZ',
            Case__c='50071000008j2U5AAI',
            ComponentType__c = 'GPON',
            IsMobilityConnected__c = true
        );
        insert testComponent;*/
        testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        update testCase;
        Test.stopTest();
    }
    @isTest
    static void testForEqualINACT(){
        case testCase = new Case(
        	Line_of_Business__c = 'FTTH',
            FTTHCaseType__c='INACT',
            FATNumber__c = 'ZAV080101',
            GPON_Id__c='XOT-H1/2/7,0D3-H1/2/8',
            IsExcelRecord__c = False
        );
        Test.startTest();
        insert testCase;
        testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        update testCase;
        Test.stopTest();
    }
    @isTest
    static void testForSmallCell(){
        case testCase = new Case(
        	Line_of_Business__c = 'Small Cell',
            IsExcelRecord__c = true,
            Origin='Email'
        );
        Test.startTest();
        insert testCase;
        Test.stopTest();
    }
    @isTest
    static void testForOHFC(){
        Account acc= new Account( 
            Name='Airtel',
            DomainName__c='springfive.com'
        );
        insert acc;
        List<Account> accId=[Select Id from Account LIMIT 1];
        System.debug( 'Account Id -'+accId[0].Id);
        Contact con=new Contact(
            AccountId=accId[0].Id,
            FirstName='ABC',
            LastName='-CE',
            IsPrimaryContact__c =true,
            Email='cloudExtel@springfive.com',
            Line_of_business__c='OHFC'
        );
  
        insert con;
        
        case testCase = new Case(
        	Line_of_Business__c = 'OHFC',
            Origin='Email',
            IsExcelRecord__c = False,
            Subject='Proactive Ticket',
            SuppliedEmail='abc@springfive.com',
            Description='Hi Team, The below path is down \n Circuit Id : MUM_ENT_ATL_025.1 \n Actual Incident Time : 11/20/2024 8:00:23 PM\n Schedule Down Time : 2024-11-23 08:00:00\nSchedule Up Time : 2024-11-24 10:00:00\n '
        );
        Test.startTest();
        insert testCase;
        testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        update testCase;
        Test.stopTest();
    }
    @isTest
    static void testForOHFCTele(){
        case testCase = new Case(
        	Line_of_Business__c = 'OHFC',
            Origin='Telegram',
            IsExcelRecord__c = False,
            TelegramGroupId__c='-4003172960'
        );
        Test.startTest();
        insert testCase;
        testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        update testCase;
        Test.stopTest();
    }
    /*@isTest
    static void testForBeforeInsert(){
        case testCase = new Case(
        	Line_of_Business__c = 'FTTH',
            FTTHCaseType__c='INACT',
            FATNumber__c = 'ZAV080101',
            GPON_Id__c='XOT-H1/2/7,0D3-H1/2/8',
            Description='MSAN IP/Port Details',
            IsExcelRecord__c = False
        );
        Test.startTest();
        insert testCase;
       // testCase =[Select Id,Line_of_Business__c,FTTHCaseType__c FROM Case Where Id=:testCase.Id];
        //update testCase;
        Test.stopTest();
    }*/
    
    @isTest
    static void testEmailMessageOnInsert(){
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        /*insert testContact;      
        Case cs=new Case(
        Subject='null',
        Line_of_Business__c='Small Cell',
        Origin='Email',
        Status='Missing Details',
        IsExcelRecord__c =false);
        insert cs;*/
       
        EmailMessage em = new EmailMessage(
        Subject='null',
        //ParentId = cs.Id,
        TextBody='Schedule Down Time : 2024-11-23 08:00:00\nSchedule Up Time : 2024-11-24 10:00:00 \n');
        insert em;
        
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    static void testEmailMessageOnInsert1() {
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert testContact;

        // Create a test Case
        Case testCase = new Case(
            Subject = 'Test Subject',
            Line_Of_Business__c = 'Small Cell',
            ContactId = testContact.Id
        );
        insert testCase;

        // Create a test Email
        EmailMessage testEmail = new EmailMessage(
            Subject = 'Test Email',
            ParentId = testCase.Id
        );
        insert testEmail;
        Test.SetMock(HttpCallOutMock.class, new APICalloutMock());
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    static void testEmailMessageOnInsert11() {
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert testContact;

        // Create a test Case
        Case testCase = new Case(
            Subject = 'Test Subject',
            Line_Of_Business__c = 'Small Cell',
            ContactId = testContact.Id
        );
        insert testCase;

        // Create a test Email
        EmailMessage testEmail = new EmailMessage(
            Subject = 'Test Email',
            ParentId = testCase.Id
        );
        insert testEmail;
        
                // Creating test Account and Opportunity
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity', StageName='Prospecting', CloseDate=System.today(), AccountId=acc.Id);
        insert opp;
        
        // Creating a ContentVersion
        ContentVersion content = new ContentVersion();
        content.Title = 'Airtel';
        content.PathOnClient = 'Test_File.xlsx';
        Blob bodyBlob = Blob.valueOf('Dummy Content for Excel File');
        content.VersionData = bodyBlob;
        insert content;
        
        
        // Creating a ContentDocument
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.LinkedEntityId = testEmail.Id; // Linking to the EmailMsg
        contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId;
        contentLink.ShareType = 'V'; // Set the ShareType as required ('V' for Viewer)
        contentLink.Visibility = 'AllUsers'; // Set the Visibility as required
        insert contentLink;
        
        // Creating ContentDocument record
        ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id = :contentLink.ContentDocumentId and FileExtension=:'xlsx' LIMIT 1];
        // Perform any necessary operations on the ContentDocument if needed
        // You might need to set additional fields or perform actions here

        Test.SetMock(HttpCallOutMock.class, new APICalloutMock());
        Test.startTest();
        Test.stopTest();
    }
    @isTest
    static void testEmailMessageOnInsert2() {
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@test.com'
        );
        insert testContact;

        // Create a test Case
        Case testCase = new Case(
            Subject = 'Test Subject',
            Line_Of_Business__c = 'Small Cell',
            ContactId = testContact.Id
        );
        insert testCase;

        // Create a test Email
        EmailMessage testEmail = new EmailMessage(
            Subject = 'Test Email',
            ParentId = testCase.Id
        );
        insert testEmail;
        
                // Creating test Account and Opportunity
        Account acc = new Account(Name='Test Account');
        insert acc;
        
        Opportunity opp = new Opportunity(Name='Test Opportunity', StageName='Prospecting', CloseDate=System.today(), AccountId=acc.Id);
        insert opp;
        
        // Creating a ContentVersion
        ContentVersion content = new ContentVersion();
        content.Title = 'SITEDOWN';
        content.PathOnClient = 'Test_File.xlsx';
        Blob bodyBlob = Blob.valueOf('Dummy Content for Excel File');
        content.VersionData = bodyBlob;
        insert content;
        
        
        // Creating a ContentDocument
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.LinkedEntityId = testEmail.Id; // Linking to the EmailMsg
        contentLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :content.Id].ContentDocumentId;
        contentLink.ShareType = 'V'; // Set the ShareType as required ('V' for Viewer)
        contentLink.Visibility = 'AllUsers'; // Set the Visibility as required
        insert contentLink;
        
        // Creating ContentDocument record
        ContentDocument contentDoc = [SELECT Id FROM ContentDocument WHERE Id = :contentLink.ContentDocumentId and FileExtension=:'xlsx' LIMIT 1];
        // Perform any necessary operations on the ContentDocument if needed
        // You might need to set additional fields or perform actions here

        Test.SetMock(HttpCallOutMock.class, new APICalloutMock());
        Test.startTest();
        Test.stopTest();
    }
   
}