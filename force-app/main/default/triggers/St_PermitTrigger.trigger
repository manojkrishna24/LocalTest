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
 * @description St_PermitTrigger
 *
 *
 * @author <A HREF="mailto:aratnaparkhe@sitetracker.com">Aditya Ratnaparkhe</A>
 *
 ***************************************************************************************************/
trigger St_PermitTrigger on sitetracker__Permit__c (after delete, after insert, after undelete, after update, before delete, before insert, before update){
    sitetracker.StTriggerFactory.createAndExecuteHandler(St_PermitTriggerHandler.class, 'sitetracker__Permit__c');
}