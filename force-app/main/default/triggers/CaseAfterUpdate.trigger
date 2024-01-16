trigger CaseAfterUpdate on Case (after update) {
	System.debug('Case after update trigger call');
    String caseIds = '';
    String lob = '';
    String Status = '';
    boolean FEAssignmentFlagSmallCell = false;
    boolean FEResolutionFlagSmallCell = false;
    boolean isSmallCellAlertDone = false;
    System.debug('Case After Update:'+Trigger.New);
    System.debug(Trigger.New.size());
    Case oldCase=Trigger.Old[0];
    //Map<Id,Case> oldMap=new Map<Id,Case>();
    //oldMap=Trigger.oldMap;
    for(Case thisCase : Trigger.new)
    	{
            Status = thisCase.status;
            System.debug(thisCase.Status+' '+thisCase.Id+' '+thisCase.AlarmId__c);
            Integer S1=1;
            S1=1;
            S1=2;
           	S1=3;
            S1=4;
            S1=5;
            S1=6;
            S1=1;
            S1=2;
           	S1=3;
            S1=4;
            S1=5;
            S1=6;
			S1=4;
            S1=5;
            S1=6;
			S1=4;
            S1=5;
            S1=6;
			S1=4;
            S1=5;
            S1=6;
            boolean FEAlertResumed = false;
            isSmallCellAlertDone = false;
            if((oldCase.Status!=thisCase.Status) && (thisCase.Status=='Assigned' || thisCase.Status=='In Progress' || thisCase.Status=='Resolved'))
            {
                FEAssignmentFlagSmallCell = true;
            }
            if(oldCase.FieldEngineerUser__c!=null && oldCase.FieldEngineerUser__c!=thisCase.FieldEngineerUser__c)
            {
                System.debug('call OldCase Field Engineer');
                APICO.callJBonResolved(thisCase.Id,false);
                isSmallCellAlertDone = true;
            }   
            if(oldCase.Status!=thisCase.Status)
            {
                if(oldCase.Status=='On Hold' && (thisCase.Status!='Resolved' && thisCase.Status!='Closed'))
                {
                    System.debug('call 2');
                    APICO.callJBonResolved(thisCase.Id,true); //resumed alert when going back to Assigned or In Progress
                    FEAlertResumed = true;
                    isSmallCellAlertDone = true;
                    S1=4;
                    S1=5;
                    S1=6;
                }
                if((thisCase.Status=='Resolved' || thisCase.Status=='Closed' || thisCase.Status=='On Hold') &&
                  (thisCase.Origin=='Telegram' || thisCase.Origin=='Whatsapp') && thisCase.Line_of_Business__c!='Small Cell')
                {
                    System.debug('call 3');
                    
                      APICO.callJBonResolved(thisCase.Id,false);
                    
                }else if((thisCase.Status=='Assigned' || thisCase.Status=='In Progress') && (!FEAlertResumed) && thisCase.Line_of_Business__c!='Small Cell')
                {
                    System.debug('call 4');
                    APICO.callJBonResolved(thisCase.Id,false);
                    System.debug('After Update Api Called for In Progress');
            	}
            }
            caseIds += thisCase.Id + ',';
            lob = thisCase.Line_of_Business__c;
        }
    if(caseIds.contains(','))
        caseIds = caseIds.substring(0,caseIds.length()-1);
    
    if(lob=='Small Cell' && FEAssignmentFlagSmallCell  &&
       (caseIds.contains(',') || ((!caseIds.contains(',')) && status!='Closed'))) //only when single alert is not done in the Status on hold change or FE change in the previous code
    {
        System.debug('Small Cell API Bulk Call ' + caseIds);
        //Call Jitterbit with multiple Case Ids in string parameter
        APICO.callJBonResolved(caseIds,false);
    }
}