@IsTest
private class St_PermitTriggerHandlerTest {
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

        sitetracker__Project__c project = new sitetracker__Project__c(
            sitetracker__ProjectTemplate__c = templates[0].Id,
            sitetracker__Site__c = site.Id
        );
        insert project;
    }

    @IsTest
    static void testTriggerBasicFunctions(){
        Test.startTest();
            sitetracker__Permit__c permit = new sitetracker__Permit__c();
            permit.Name = 'Test Permit 1';
            permit.Project__c  = [SELECT Id from sitetracker__Project__c limit 1].Id;
            permit.Permit_Type__c = 'Easements';
            insert permit;

        Test.stopTest();
        List<sitetracker__Permit__c> permits = [SELECT Id
                    FROM sitetracker__Permit__c];
        System.assertEquals(1, permits.size());

        permits[0].Permit_Type__c = 'BAA';
        update permits;

        permits = [SELECT Id, Permit_Type__c
                    FROM sitetracker__Permit__c];

        System.assertEquals('BAA', permits[0].Permit_Type__c);

        delete permits;

        permits = [SELECT Id, Permit_Type__c
                    FROM sitetracker__Permit__c];
        System.assertEquals(0, permits.size());

    }


}