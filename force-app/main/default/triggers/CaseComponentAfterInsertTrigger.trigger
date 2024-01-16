trigger CaseComponentAfterInsertTrigger on CaseFTTHComponent__c (after insert) {
    
    System.debug('After Insert Trigger for Casecomponent');
    	
    for(CaseFTTHComponent__c casecomponent : Trigger.New){
        CaseFTTHComponent__c caseid=[SELECT Case__c FROM CaseFTTHComponent__c WHERE Id=:casecomponent.Id];
        Case caserecord=[SELECT Id,FTTHInformation__c,Case_Type__c,FTTHCaseType__c FROM Case WHERE Id=:caseid.Case__c];
        String FDCLocation='', MapLink='';
        if(String.IsNotBlank(casecomponent.FDCLocation__c))
            FDCLocation = casecomponent.FDCLocation__c;
        if(casecomponent.ComponentMapLink__c!=null)
          	MapLink=casecomponent.ComponentMapLink__c.replace('_HL_ENCODED_','').replace('_HL__blank_HL_','');
        
        if(casecomponent.ComponentType__c == 'GPON'){
            if(String.IsBlank(caserecord.FTTHInformation__c))
                caserecord.FTTHInformation__c='\nGPON - '+casecomponent.ComponentId__c+'\nInstallation Address - '
                +casecomponent.InstallationAddress__c+'\nFDC Location - '+FDCLocation+'\n';
            else
                caserecord.FTTHInformation__c+='\nGPON - '+casecomponent.ComponentId__c+'\nInstallation Address - '
                +casecomponent.InstallationAddress__c+'\nFDC Location - '+FDCLocation+'\n';
            if(caseRecord.FTTHCaseType__c=='PON' || caseRecord.FTTHCaseType__c=='PONMobility')
                caserecord.FTTHInformation__c+='Map Link - '+MapLink+'\n';
        }
        else if(casecomponent.ComponentType__c == 'FAT'){
            if(String.IsBlank(caserecord.FTTHInformation__c))
            {
                caserecord.FTTHInformation__c='\nFAT - '+casecomponent.ComponentId__c+
                    '\nInstallation Address - '+casecomponent.InstallationAddress__c+
                    '\nFAT Location - '+casecomponent.Location__c+'\nMap Link - '+MapLink+
                    '\nFDC Location - '+FDCLocation;
            }else
            {
                caserecord.FTTHInformation__c+='\n\nFAT - '+casecomponent.ComponentId__c+
                    '\nInstallation Address - '+casecomponent.InstallationAddress__c+
                    '\nLocation - '+casecomponent.Location__c+'\nMap Link - '+MapLink+
                    '\nFDC Location - '+FDCLocation;                
            }
        }
        update caserecord;
    }
}