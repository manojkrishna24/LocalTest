/*************************************************************************************************
 * SITETRACKER, INC. (“Sitetracker”) CONFIDENTIAL
 * Unpublished Copyright (c) 2013-2019 SITETRACKER, INC., All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of Sitetracker.
 * The intellectual and technical concepts contained herein are proprietary to Sitetracker and
 * may be covered by U.S. and Foreign Patents, patents in process, and are protected by trade
 * secret or copyright law.
 *
 * Dissemination of this information or reproduction of this material is strictly forbidden unless
 * prior written permission is obtained from Sitetracker. Access to the source code contained
 * herein is hereby forbidden to anyone except current Sitetracker employees, managers or
 * contractors who have executed Confidentiality and Non-disclosure agreements explicitly
 * covering such access.
 *
 * The copyright notice above does not evidence any actual or intended publication or disclosure
 * of this source code, which includes information that is confidential and/or proprietary, and
 * is a trade secret, of Sitetracker.
 *
 * @description St_ActivityTriggerHandlerTest
 *
 *
 * @author <A HREF="mailto:aratnaparkhe@sitetracker.com">Aditya Ratnaparkhe</A>
 *
 ***************************************************************************************************/

@IsTest
private class St_ActivityTriggerHandlerTest {
	@TestSetup
	static void setupTestData() {
		stdraw__Approval_Process_Template__c approvalProcessTemplate = new stdraw__Approval_Process_Template__c(
			stdraw__Approval_Process_Template_Name__c = 'Test class Template'
		);
		insert approvalProcessTemplate;

		stdraw__Steps_Template__c step = new stdraw__Steps_Template__c(
			stdraw__Step_Template_Number__c = 1,
			stdraw__Step_Template_Name__c = 'First Step',
			stdraw__Approval_Process_Template__c = approvalProcessTemplate.Id,
			stdraw__Approval_Type__c = 'First'
		);
		insert step;

		stdraw__Approver_Template__c approver = new stdraw__Approver_Template__c(
			stdraw__User__c = UserInfo.getUserId(),
			stdraw__Notify_Only__c = false,
			stdraw__Step_Template__c = step.Id
		);
		insert approver;

		sitetracker__Project_Template__c template = new sitetracker__Project_Template__c(
            Name = 'Test Template',
            sitetracker__Active__c = true
		);
		insert template;

		List<sitetracker__Project_Milestone__c> milestones = new List<sitetracker__Project_Milestone__c>();
		milestones.add( new sitetracker__Project_Milestone__c(
			sitetracker__sObjectType__c = String.valueOf( sitetracker__Project__c.SObjectType ),
			sitetracker__Forecast_Field_API_Name__c = Schema.SObjectType.sitetracker__Project__c.fields.sitetracker__Project_Start_Date_F__c.localName,
			sitetracker__Actual_Field_API_Name__c = Schema.SObjectType.sitetracker__Project__c.fields.sitetracker__Project_Start_Date_A__c.localName,
			Name = 'Project Start'
		));

		insert milestones;

        List<sitetracker__Activity_Template__c> activityTemplates = new List<sitetracker__Activity_Template__c>();

        sitetracker__Activity_Template__c actTemplate = new sitetracker__Activity_Template__c(
            sitetracker__Project_Template__c = template.Id,
            sitetracker__Project_Milestone__c = milestones[0].Id,
            sitetracker__Activity_Type__c = 'Milestone',
            Name = milestones[0].Name,
            Requires_Approval__c = TRUE,
            Auto_Submit_for_Approval__c = TRUE,
            Approval_Process_Template__c = approvalProcessTemplate.Id,
            sitetracker__Order__c = 1
        );

		activityTemplates.add( actTemplate );

		insert activityTemplates;

		sitetracker__Site__c site = new sitetracker__Site__c(
			Name = 'Test site'
		);
		insert site;

		sitetracker__Project__c project = new sitetracker__Project__c(
			sitetracker__Site__c = site.Id,
			sitetracker__ProjectTemplate__c = template.Id,
			sitetracker__Project_Start_Date_F__c = System.today()
		);
		insert project;
	}

	static testMethod void TestBasicTriggerFunctions() {
        Test.startTest();
		List<sitetracker__Project__c> projects = [
			SELECT Id, Name,
			(
				SELECT Id, Name, sitetracker__Activity_Template__c, Requires_Approval__c, Approval_Process_Template__c, sitetracker__Forecast_Date__c, sitetracker__ActualDate__c, Approval_Process__c
				FROM sitetracker__Activities__r
				WHERE Name =: 'Project Start'
				LIMIT 1
			)
			FROM sitetracker__Project__c
		];
		System.assertEquals( 1, projects.size() );
		System.assertEquals( 1, projects[ 0 ].sitetracker__Activities__r.size() );

		List<sitetracker__Activity__c> activities = projects[ 0 ].sitetracker__Activities__r;
		delete activities;

		activities = [
			SELECT Id
			FROM sitetracker__Activity__c
			WHERE sitetracker__Project__c =: projects[ 0 ].Id
		];
		System.assertEquals( 0, activities.size() );

		List<sitetracker__Activity_Template__c> templates = [ SELECT Id FROM sitetracker__Activity_Template__c WHERE Name = 'Project Start' LIMIT 1 ];
		System.assertEquals( 1, templates.size() );

		sitetracker__Activity__c activity = new sitetracker__Activity__c(
			sitetracker__Activity_Template__c = templates[ 0 ].Id,
			sitetracker__Project__c = projects[ 0 ].Id
		);
		insert activity;

		activity.sitetracker__Forecast_Date__c = System.today().addDays( 30 );
        update activity;
        Test.stopTest();
	}

	static testMethod void TestApprovalProcessAssignmentAndAutoSubmit()	{
        List<sitetracker__Activity__c> activities = [
            SELECT Id, Approval_Process_Template__c, Requires_Approval__c,Auto_Submit_for_Approval__c,
                    Approval_Process__c, sitetracker__ActualDate__c
			FROM sitetracker__Activity__c
			WHERE Approval_Process_Template__c !=: NULL
        ];

        System.assertEquals( 1, activities.size() );
        System.assertEquals( null, activities[0].sitetracker__ActualDate__c);
        System.assertNotEquals( null, activities[ 0 ].Approval_Process__c );
        System.assertEquals( TRUE, activities[0].Requires_Approval__c );
        System.assertEquals( TRUE, activities[0].Auto_Submit_for_Approval__c );

        Test.startTest();

        activities[ 0 ].sitetracker__ActualDate__c = System.today();
        update activities;
        Test.stopTest();
        List<stdraw__Steps__c> insertedSteps = [SELECT Id
                                                FROM stdraw__Steps__c
                                                WHERE stdraw__Approval_Process__c =: activities[ 0 ].Approval_Process__c];
        System.assertEquals(1, insertedSteps.size());
	}

	static testMethod void TestAssignApprovalProcessOnUpdate(){
        Test.startTest();
		List<sitetracker__Activity__c> activities = [
			SELECT Id, Approval_Process_Template__c, Requires_Approval__c, Approval_Process__c
			FROM sitetracker__Activity__c
			WHERE Approval_Process_Template__c !=: NULL
			LIMIT 1
		];
		System.assertEquals( 1, activities.size() );
		System.assertNotEquals( null, activities[ 0 ].Approval_Process__c );

		activities[ 0 ].Approval_Process__c = null;
		update activities;

        System.assertNotEquals( null, [ SELECT Id, Name, Approval_Process__c FROM sitetracker__Activity__c WHERE Id =: activities[ 0 ].Id LIMIT 1 ].Approval_Process__c );
        Test.stopTest();
	}
}