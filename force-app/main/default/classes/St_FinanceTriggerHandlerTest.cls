@IsTest
private class St_FinanceTriggerHandlerTest {

    @testSetup
    static void setupData(){
        sitetracker__Site__c site = new sitetracker__Site__c();
        insert site;

        sitetracker__Project_Template__c strkTemplate = new sitetracker__Project_Template__c();
        strkTemplate.name = 'Generic';
        strkTemplate.sitetracker__Active__c = true;
        strkTemplate.sitetracker__SiteTraker_Object__c = 'sitetracker__Project__c';
        insert strkTemplate;

        sitetracker__Project__c proj = new sitetracker__Project__c();
        proj.sitetracker__ProjectTemplate__c = strkTemplate.Id;
        proj.sitetracker__Site__c = site.Id;
        insert proj;
    }

    @isTest
    static void testBasicTriggerFunctions() {
        sitetracker__project__c project = [SELECT Id from sitetracker__project__c limit 1];

        Test.startTest();

        List<sitetracker__finance__c> finList = new List<sitetracker__finance__c>();

        sitetracker__finance__c fin1 = new sitetracker__finance__c(
            sitetracker__Amount__c = 1000,
            sitetracker__Project_Link__c = project.Id
        );

        sitetracker__finance__c fin2 = new sitetracker__finance__c(
            sitetracker__Amount__c = 1000,
            sitetracker__Project_Link__c = project.Id
        );

        sitetracker__finance__c fin3 = new sitetracker__finance__c(
            sitetracker__Project_Link__c = project.Id,
            sitetracker__Amount__c = 1000
        );

        finList.add(fin1);
        finList.add(fin2);
        finList.add(fin3);
        insert finList;

        Test.stopTest();
        finList = [SELECT Id FROM sitetracker__finance__c WHERE sitetracker__Project_Link__c =: project.Id];
        System.assertEquals(3, finlist.size());

        finList[0].sitetracker__Amount__c = 200;
        update finList[0];

        finList = [SELECT Id FROM sitetracker__finance__c WHERE sitetracker__Project_Link__c =: project.Id AND sitetracker__Amount__c = 200];
        System.assertEquals(1, finlist.size());

        delete finList;

        finList = [SELECT Id FROM sitetracker__finance__c WHERE sitetracker__Project_Link__c =: project.Id];
        System.assertEquals(2, finlist.size());
    }
}