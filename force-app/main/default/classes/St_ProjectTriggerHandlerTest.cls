@IsTest
private class St_ProjectTriggerHandlerTest {


     @TestSetup
    static void setupTestData(){

        List<sitetracker__Project_Template__c> templates = new List<sitetracker__Project_Template__c>();

        templates.add( new sitetracker__Project_Template__c(
            Name = 'Test Template',
            sitetracker__Active__c = true
        ));

        insert templates;

        List<sitetracker__Project_Milestone__c> milestones = new List<sitetracker__Project_Milestone__c>();

        milestones.add( new sitetracker__Project_Milestone__c(
            sitetracker__sObjectType__c = String.valueOf( sitetracker__Project__c.SObjectType ),
            sitetracker__Actual_Field_API_Name__c = Schema.SObjectType.sitetracker__Project__c.fields.sitetracker__Project_Start_Date_A__c.localName,
            sitetracker__Forecast_Field_API_Name__c = Schema.SObjectType.sitetracker__Project__c.fields.sitetracker__Project_Start_Date_F__c.localName,
            Name = 'Project Start'
        ));

        insert milestones;

        List<sitetracker__Activity_Template__c> activityTemplates = new List<sitetracker__Activity_Template__c>();

        activityTemplates.add(  new sitetracker__Activity_Template__c(
            sitetracker__Activity_Type__c = 'Milestone',
            sitetracker__Project_Milestone__c = milestones[ 0 ].Id,
            sitetracker__Project_Template__c = templates[ 0 ].Id,
            Name = milestones[ 0 ].Name,
            sitetracker__Order__c = 10
        ));

        insert activityTemplates;

        sitetracker__Site__c site = new sitetracker__Site__c(
            Name = 'Test Site'
        );
        insert site;

    }

    @istest private static void testBasicTriggerFunction(){

        List<sitetracker__Project_Template__c> templates = [SELECT Id FROM sitetracker__Project_Template__c limit 1];
        System.assertEquals(1, templates.size());

        List<sitetracker__Site__c> sites = [SELECT Id FROM sitetracker__Site__c limit 1];
        System.assertEquals(1, sites.size());

        Test.startTest();
        sitetracker__Project__c project = new sitetracker__Project__c(
            sitetracker__ProjectTemplate__c = templates[0].Id,
            sitetracker__Site__c = sites[0].Id
        );
        insert project;

        List<sitetracker__Project__c> projects = [SELECT Id FROM sitetracker__Project__c];
        System.assertEquals(1, projects.size());

        projects[0].sitetracker__Project_Start_Date_F__c = Date.today();
        update projects;

        projects = [SELECT Id, sitetracker__Project_Start_Date_F__c FROM sitetracker__Project__c];
        System.assertEquals(1, projects.size());
        System.assertEquals(Date.today(), projects[0].sitetracker__Project_Start_Date_F__c);

        delete projects;
        projects = [SELECT Id, sitetracker__Project_Start_Date_F__c FROM sitetracker__Project__c];
        System.assertEquals(0, projects.size());

        Test.stopTest();
    }
}