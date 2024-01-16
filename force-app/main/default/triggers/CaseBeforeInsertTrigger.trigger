/**
 * This trigger is on insert of a Case Object
 * To extract the Email Body which is available with Case' Description field when Salesforce receives the email
 * and parse the contents
 * */

trigger CaseBeforeInsertTrigger on Case (before insert) {
    List<String> cirId=new List<String>();
    String NOCQueueId = ServiceCloudUtil.getQueueId();
    for (Case thisCase : Trigger.new){
        System.debug('case number:'+thisCase.CaseNumber);
        System.debug('Case ID:'+thisCase.Id);
        boolean isExcel = thisCase.IsExcelRecord__c;
        String emailSubject = thisCase.Subject;
        String emailDescription = thisCase.Description;
        if(String.isBlank(emailDescription))
           emailDescription = '';
        System.debug('email : '+ emailDescription);
        System.debug('Contact Id :' + thisCase.ContactId);
        String contactId = thisCase.ContactId;
        ServiceCloudUtil.setLOB(thisCase);
        String lob = thisCase.Line_of_Business__c;
        String ToAddress = '', SourceID1 = '';
        thisCase.OwnerId = System.Label.OwnerIdQueue; //NOCQueueId;	//'00G71000000sOv0EAE'; //UAT NOC Queue //Prod - 00GC7000000N8UdMAK
        if(thisCase.Origin=='Web'){
                if(lob=='OHFC' || lob=='UG')
               {
                   if(String.isBlank(thisCase.CircuitId2__c)){
                       thisCase.CircuitId2__c=thisCase.Circuit_ID__c;
                   }
                system.debug('CBI - thisCase.Circuit_ID__c'+thisCase.Circuit_ID__c);
                system.debug('CBI - thisCase.Circuit_ID__c2'+thisCase.CircuitId2__c);

               }               
            }
        
        if(thisCase.Origin=='Email' && isExcel==false)
        {
            if(lob=='OHFC' || lob=='UG')
            {
                String circuitId = ServiceCloudUtil.getCircuitId(emailDescription);
                String circuitId2=ServiceCloudUtil.getCircuitId2(emailDescription);
                thisCase.Circuit_ID__c=circuitId;
                if(String.isBlank(circuitId2)){
                	thisCase.CircuitId2__c=circuitId;                    
                }
                else{
                    thisCase.CircuitId2__c=circuitId2;

                }
                System.debug('Id From serviceCloudUtil' + circuitId);
                system.debug('CBI - thisCase.Circuit_ID__c'+thisCase.Circuit_ID__c);
                System.debug('Id From serviceCloudUtil2' + circuitId2);
                system.debug('CBI - thisCase.Circuit_ID__c2'+thisCase.CircuitId2__c);
                thisCase.Case_Type__c = 'Issue';
                String incidentId = ServiceCloudUtil.getIncidentId(emailDescription);
                thisCase.Customer_TID__c=incidentId;
                String outageStartTime = ServiceCloudUtil.getActualIncidentTime(emailDescription);
                thisCase.Outage_Start_Time_Customer__c=DateTime.valueOf(outageStartTime);
                if(emailSubject.contains('Proactive Ticket') && (String.isBlank(thisCase.ParentId)))
                {
                    thisCase.Case_Type__c='Proactive';
                    String scheduleDownTime = emailDescription.substringAfter('Schedule Down Time :').substringBefore('\n').trim();
                    String scheduleUpTime = emailDescription.substringAfter('Schedule Up Time :').substringBefore('\n').trim();
                    thisCase.ScheduleDownTime__c = DateTime.valueOf(scheduleDownTime);
                    thisCase.ScheduleUpTime__c = DateTime.valueOf(scheduleUpTime);
                }
                else if(emailSubject.contains('Proactive Ticket')) //if it is coming from an email for Child Ticket creation - Parent Id will be available and comes to this loop
                {
                    thisCase.Case_Type__c='Proactive';
                }
            }
            
            
            if(lob=='FTTH' && emailSubject.contains('Proactive Ticket') && (String.isBlank(thisCase.ParentId)))
            {
                String gponId = '';
                if(emailDescription.contains('GPON Id :'))
            		gponId = emailDescription.substringAfter('GPON Id :').substringBefore('\n').trim();
                thisCase.GPON_Id__c = gponId;
                thisCase.Case_Type__c='Proactive';
                String scheduleDownTime = emailDescription.substringAfter('Schedule Down Time :').substringBefore('\n').trim();
                String scheduleUpTime = emailDescription.substringAfter('Schedule Up Time :').substringBefore('\n').trim();
                thisCase.ScheduleDownTime__c = DateTime.valueOf(scheduleDownTime);
                thisCase.ScheduleUpTime__c = DateTime.valueOf(scheduleUpTime);  
            }
            System.debug('CaseEmail -'+thisCase.ContactEmail);
            if(thisCase.Origin=='Email' && String.isBlank(thisCase.ContactId)){
                String suppliedEmail=thisCase.SuppliedEmail;
                String DomainName=suppliedEmail.substringAfter('@').substringBefore('\n').trim();
                System.debug('Domain Name -'+DomainName);
                System.debug('Line Of Business - '+thisCase.Line_of_Business__c);
                List<Account> acc=[Select Id,Name from Account where DomainName__c =: DomainName];
                System.debug(acc);
                List<Contact> cont=[Select Id,Name,Email from Contact where AccountId=:acc[0].Id and IsPrimaryContact__c =true and Line_of_business__c=:thisCase.Line_of_Business__c];
                
                thisCase.AccountId=acc[0].Id;
                thisCase.ContactId=cont[0].Id;
                
        	}
        }
        String siteId1 = '';
        if(thisCase.Origin=='Email' && thisCase.Line_of_Business__c=='Small Cell') //check this loop if required
        {
            if(isExcel==true)
            {
                siteId1 = thisCase.Site_ID__c;
                thisCase.Case_Type__c = 'Issue';
                String tempContact = thisCase.TempContactEmail__c;
           		thisCase.Description=thisCase.Subject;
             }
        }
        
        if(thisCase.Line_of_Business__c=='FTTH' && String.isNotBlank(thisCase.Description) && thisCase.Description.contains('MSAN IP/Port Details'))
        {
            thisCase.Line_of_Business__c='FTTH';
            ServiceCloudUtil.setFTTHFields(thisCase);
        }
        if(thisCase.Line_of_Business__c!='Small Cell')
        	ServiceCloudUtil.checkForDuplicate(thisCase);
        
        if(thisCase.Line_of_Business__c=='OHFC' && String.isBlank(thisCase.ContactId)){
            //ServiceCloudUtil.getohfcAccountId(thisCase);
        }
        
       if(thisCase.Line_of_Business__c=='FTTH' && String.isBlank(thisCase.ContactId)){
          ServiceCloudUtil.getftthAccountId(thisCase);
           if(String.isBlank(thisCase.SuppliedEmail)){
               thisCase.SuppliedEmail=System.Label.TelegramDefaultWebMail;
               thisCase.IsInitialCustomerIdentified__c=False;
               System.debug('FTTH no contact loop in before insert' + thisCase.SuppliedEmail);
           }
       }
        
        if(thisCase.Origin=='Telegram' && (thisCase.Line_of_Business__c =='OHFC' || thisCase.Line_of_Business__c =='UG')){
            
            thisCase.CircuitId2__c=thisCase.Circuit_ID__c;
        }
        
        if(thisCase.Origin=='Telegram' && String.isBlank(thisCase.ContactId) && (thisCase.Line_of_Business__c =='OHFC' || thisCase.Line_of_Business__c =='UG')){
            String groupId=thisCase.TelegramGroupId__c;
            thisCase.CircuitId2__c=thisCase.Circuit_ID__c;
            System.debug('Telegram Circuit Id2 -'+thisCase.CircuitId2__c);
            String gpId=groupId.substring(1);
            String textlabel='Telegram_'+gpId;
            String label=System.Label.get('',textlabel,'');
            thisCase.ContactId=label;
            
        }
        
        if(thisCase.Origin=='WhatsApp' && (thisCase.Line_of_Business__c =='OHFC' || thisCase.Line_of_Business__c =='UG')){
            
            thisCase.CircuitId2__c=thisCase.Circuit_ID__c;
        }
        
        if(thisCase.Origin=='WhatsApp' && String.isBlank(thisCase.ContactId)&& (thisCase.Line_of_Business__c =='OHFC' || thisCase.Line_of_Business__c =='UG')){
            String WpgrpId=thisCase.WhatsappGroupId__c;
            System.debug('GrpId '+WpgrpId);
            thisCase.CircuitId2__c=thisCase.Circuit_ID__c;
            String grpId=WpgrpId.replaceAll('[!@#$%^&*()-.]', '_');
            String textLabel='WhatsApp_'+grpId;
            String cusLabel=System.Label.get('',textlabel,'');
            System.debug('Custom Label - ' +cusLabel);
            thisCase.ContactId=cusLabel;
        }
        
        //System.debug('Label : ' + System.Label.get('','TelegramDefaultWebMail',''));
        
        /*if(thisCase.Origin=='Web' && thisCase.Line_of_Business__c=='UG') Route Name Logic is not required
        {
            String routeName = thisCase.RouteName__c;
            if(String.isNotBlank(routeName) && routeName.contains(' TO '))
                thisCase.RouteName__c=routeName.replace(' TO ','-');
       }*/
    }
}