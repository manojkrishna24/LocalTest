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
 * @description St_ActivityTriggerHandler
 * This class is intentionally named different (St_) as otherwise it conflicts with the packaged
 * class with the same name (StActivityTriggerHandler) and causes namespace issues when referenced
 * in the Sitetracker Object CMT
 *
 * @author <A HREF="mailto:aratnaparkhe@sitetracker.com">Aditya Ratnaparkhe</A>
 *
 ***************************************************************************************************/

global without sharing class St_ActivityTriggerHandler implements sitetracker.StITrigger {

    Map<Id, Map<Id, String>> activityIdTemplateIdName = new Map<Id, Map<Id, String>>();

    String approvalProcessFieldInstance = Schema.SObjectType.sitetracker__Activity__c.fields.Approval_Process__c.localName;
    Map<Id, Id> autoSubmitProcessIdMap = new Map<Id, Id>();

    global void initialize( String sObjectName ) {
    }

    global void bulkBefore() {
    }

    global void bulkAfter() {

    }

    global void beforeInsert( SObject so ) {

    }

    global void afterInsert( SObject so ) {
        sitetracker__Activity__c newActivity = ( sitetracker__Activity__c ) so;

        if ( newActivity.Requires_Approval__c && newActivity.Approval_Process_Template__c != null ) {
            this.connectApprovalProcessToActivity( newActivity );
        }
    }

    global void beforeUpdate( SObject oldSo, SObject newSo ) {

    }

    global void afterUpdate( SObject oldSo, SObject newSo ) {
        sitetracker__Activity__c oldActivity = ( sitetracker__Activity__c ) oldSo;
        sitetracker__Activity__c newActivity = ( sitetracker__Activity__c ) newSo;

        if ( newActivity.Requires_Approval__c && newActivity.Approval_Process_Template__c != null && newActivity.Approval_Process__c == null ) {
            this.connectApprovalProcessToActivity( newActivity );
        }

        if((oldActivity.sitetracker__ActualDate__c != newActivity.sitetracker__ActualDate__c) // actual date has changed
            && oldActivity.sitetracker__ActualDate__c == null
            && newActivity.Auto_Submit_for_Approval__c){
            this.autoSubmitProcessIdMap.put( newActivity.Id, newActivity.Approval_Process__c );
        }
    }

    global void beforeDelete( SObject so ) {
    }

    global void afterDelete( SObject so ) {

    }

    global void andFinally() {

        // Handle Approval Process Assignment
        if ( Trigger.isAfter
            && !Trigger.isDelete
            && !this.activityIdTemplateIdName.isEmpty() ) {

            stdraw.Approval_Process_Factory factory = new stdraw.Approval_Process_Factory();
            factory.createApprovalProcessIdFromTemplate( this.activityIdTemplateIdName, 'Approval_Process__c' );
        }

        if( Trigger.isUpdate && !this.autoSubmitProcessIdMap.isEmpty() && !System.isFuture() && !System.isBatch()){
            stdraw.MassSubmitApprovalProcessBatchJob b = new stdraw.MassSubmitApprovalProcessBatchJob( this.autoSubmitProcessIdMap.values() );
        }

    }

    /**
     * Connects the Approval process instance to the supplied activity
     *
     * @param activity
     */
    public void connectApprovalProcessToActivity( sitetracker__Activity__c activity ) {

        String approvalProcessTemplateId = activity.Approval_Process_Template__c;

        if ( approvalProcessTemplateId != null ) {
            Map<Id, String> templateMap = new Map<Id, String>();
            templateMap.put( approvalProcessTemplateId, activity.Name );
            this.activityIdTemplateIdName.put( activity.Id, templateMap );
        }
    }
}