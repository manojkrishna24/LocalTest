trigger CaseAfterInsertTrigger on Case (after insert) {
    for (Case caseRecord : Trigger.new)
    {
        String caseId = caseRecord.Id;
        String caseNumber1 = caseRecord.CaseNumber;
        boolean isExcel = caseRecord.IsExcelRecord__c;
        
        if(caseRecord.Line_of_Business__c=='FTTH' && String.isNotBlank(caseRecord.GPON_Id__c) && caseRecord.GPON_Id__c.length()>0)
        {
            ServiceCloudUtil.createFTTHComponentsForCase(caseRecord,'GPON');
        }
        if(caseRecord.Line_of_Business__c=='FTTH' && String.isNotBlank(caseRecord.FATNumber__c) && caseRecord.FATNumber__c.length()>0)
        {
            ServiceCloudUtil.createFTTHComponentsForCase(caseRecord,'FAT');
        }
    }
}