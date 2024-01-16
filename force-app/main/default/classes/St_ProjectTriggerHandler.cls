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
 * @description St_ProjectTriggerHandler
 *
 *
 * @author <A HREF="mailto:aratnaparkhe@sitetracker.com">Aditya Ratnaparkhe</A>
 *
 ***************************************************************************************************/

global with sharing class St_ProjectTriggerHandler extends sitetracker.StTriggerHandler {

    global override void initializeExtended( String sObjectName ) {

    }

    global override void bulkBeforeExtended() {

    }

    global override void bulkAfterExtended() {

    }

    global override void beforeInsertExtended( SObject so ) {


    }

    global override void afterInsertExtended( SObject so ) {

    }

    global override void beforeUpdateExtended( SObject oldSo, SObject newSo ) {


    }

    global override void afterUpdateExtended( SObject oldSo, SObject newSo ) {

    }

    global override void beforeDeleteExtended( SObject so ) {}

    global override void afterDeleteExtended( SObject so ) {}

    global override void andFinallyExtended() {
        if(Trigger.isAfter){
            //rollup project to program
            StFiberStruct fiberStructure = new StFiberStruct(Trigger.new);

            //rollup project to site
            StRollupDataProcessor processor = new StRollupDataProcessor( String.valueOf(sitetracker__Project__c.SObjectType), Trigger.old, Trigger.new, Trigger.isDelete );

            if( processor.checkHasRollupActionsAvailable() ){
                processor.executeRollupActions();
            }
        }
    }

}