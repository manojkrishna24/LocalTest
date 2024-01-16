trigger CaseBeforeUpdate on Case (before update) {
	System.debug('Case before update trigger call');
    System.debug('Case Before Update:'+Trigger.New);
    System.debug(Trigger.New.size());
    for (Case thisCase : Trigger.new)
        {
            System.debug('Before Update :'+thisCase.Status+' '+thisCase.AlarmId__c);
            if(String.isNotBlank(thisCase.AccountId) && String.isBlank(thisCase.EntitlementId))
            {
                List<Entitlement> entitlementObjs = [SELECT Id, Name from Entitlement where AccountId=:thisCase.AccountId AND Status=:'Active'];
                if(entitlementObjs.size()>0)
                {
                    thisCase.EntitlementId = entitlementObjs[0].Id;
                }
            }
            if((thisCase.Line_of_Business__c=='OHFC'||thisCase.Line_of_Business__c=='UG') && (thisCase.IssueCounter__c==null))
            {
                String CircuitId = thisCase.Circuit_ID__c;
                System.debug('circuitId'+thisCase.Circuit_ID__c);
                List <Case> caseObjs = [SELECT Id, CECaseNumber__c, CreatedDate from Case where Circuit_ID__c=:CircuitId and Case_Type__c='Issue' and  CreatedDate =LAST_N_DAYS:30];
            	if(caseObjs.size()>0)
                {
                    System.debug('caseObjs.size() : ' + caseObjs.size());
                    thisCase.IssueCounter__c = caseObjs.size();
                }
            }
            
            if(thisCase.Line_of_Business__c=='FTTH' && String.isNotBlank(thisCase.FTTHCaseType__c))
            {	
                System.debug('intoFTTH before update');
                if(thisCase.FTTHCaseType__c.contains('PON') || thisCase.FTTHCaseType__c.contains('INACT'))
                {
                    Integer S1=1;
            		S1=1;
                    S1=2;
                    S1=3;
                    S1=4;
                    Integer thisMonth = System.today().month();
                    String GPONs = thisCase.GPON_Id__c;
                    if(GPONs.contains(','))
                        GPONs = GPONS.substringbefore(',');
                    if(thisCase.IssueCounter__c==null){
                        List<CaseFTTHComponent__c> CFC = [SELECT Id, ComponentId__c, CreatedDate FROM CaseFTTHComponent__c where ComponentType__c='GPON' and ComponentId__c =:GPONs and  CreatedDate =LAST_N_DAYS:30 ];
                        System.debug(CFC.size());
                        if(CFC.size()>0)
                        {
                            thisCase.IssueCounter__c = CFC.size();    
                        }
                    }                   
                }
                if(thisCase.FTTHCaseType__c=='PON')
                {
                    List<CaseFTTHComponent__c> CFC = [SELECT Id, ComponentId__c FROM CaseFTTHComponent__c where Case__c=:thisCase.Id and ComponentType__c='GPON' and IsMobilityConnected__c=true];
                	if(CFC.size()>0)
                        thisCase.FTTHCaseType__c='PONMobility';
                }else if(thisCase.FTTHCaseType__c=='INACT')
                {
                    List<CaseFTTHComponent__c> CFC = [SELECT Id, ComponentId__c FROM CaseFTTHComponent__c where Case__c=:thisCase.Id and ComponentType__c='FAT' and IsMobilityConnected__c=true];
                	if(CFC.size()>0)
                        thisCase.FTTHCaseType__c='INACTMobility';
                }
            }
        }
}