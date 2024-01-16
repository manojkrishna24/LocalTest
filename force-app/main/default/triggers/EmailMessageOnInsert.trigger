trigger EmailMessageOnInsert on EmailMessage (after insert) {
	System.debug('after email insert in Email Message Insert class');
    for (EmailMessage thisMail : Trigger.new)
    {
        System.debug('in Email Message on Insert ' + thisMail.ParentId + 'thisMailId : '+ thisMail.Id);
        String emailSubject = thisMail.Subject;
        String emailDescription = thisMail.TextBody;
        String parentCaseId = thisMail.ParentId; //parent of email message - new child case id
        System.debug(emailSubject);
        if(emailSubject.contains('Sandbox: ') && emailSubject.contains('New Child Case'))
        {
            /*String scheduleDownTime = emailDescription.substringAfter('Schedule Down Time :').substringBefore('\n').trim();
            String scheduleUpTime = emailDescription.substringAfter('Schedule Up Time :').substringBefore('\n').trim();
            String caseNumberOld = emailSubject.substringAfter('Sandbox: ').substringBefore(' New Child Case');
            List<Case> caseObjs = [SELECT Id FROM Case WHERE Id =:parentCaseId];
            if(caseObjs.size()>0)
            {
                caseObjs[0].ScheduleDownTime__c = DateTime.valueOf(scheduleDownTime);
                caseObjs[0].ScheduleUpTime__c = DateTime.valueOf(scheduleUpTime);
                caseObjs[0].Status='Assigned';
                System.debug(scheduleDownTime);
                update caseObjs[0];
             }*/
        }
        if(String.isNotBlank(parentCaseId)) //invokes Jitterbit API call wrapper class for Small Cell
        {
            System.debug('parent - ' + parentCaseId);
            Case caseObj = [SELECT Id, CECaseNumber__c, ContactId, Subject, Line_Of_Business__c FROM Case WHERE Id =:parentCaseId];
            System.debug('Email Class - '+ caseObj.ContactId);
            if(caseObj!=null && caseObj.Line_of_Business__c=='Small Cell')
            {
                ExcelToCaseAPI.makeGetCallout(caseObj.ContactId,caseObj.Subject,caseObj.Id,thisMail.Id);
            }
        }
    }
}