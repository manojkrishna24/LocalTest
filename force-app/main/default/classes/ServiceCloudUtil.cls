public class ServiceCloudUtil {
    //public static boolean firstRun = true; //for Case after update trigger that fires twice - to check by flag
    public static String getCircuitId(String emailDescription)
    {
        String circuitId = '',incidentId='',siteId='';
        if(String.isBlank(emailDescription)) return circuitId;
        String[] arr = emailDescription.split('\n'); 
        System.debug('SC array :' + arr.size());
            for(Integer i=0;i<arr.size();i++){
                String lcase = arr[i].substringBefore(':').toLowerCase();
                List<String> cids=new List<String>();
                System.debug('array'+arr[i]);
                if(lcase.contains('impacted')){
                    String ImpactedLine = arr[i].substringAfter(':');
                    System.debug('ImpactedLine'+ImpactedLine);
                    if(ImpactedLine.contains('CircuitID')){
                    	circuitId=ImpactedLine.substringAfter('CircuitID-').substringBefore('\n').trim();
                    	System.debug('Circuit Id-' + circuitId);
                    }
                    if(!ImpactedLine.contains('CircuitID') && !ImpactedLine.contains('SiteID')){
                        circuitId=arr[i].substringAfter(':').substringBefore('\n').trim();
                        System.debug('Circuit Id' + circuitId);
                        break;
                    }
                    break;
                }
                else if(lcase.contains('circuit id') || lcase.contains('circuitid'))
                {
                    circuitId=arr[i].substringAfter(':').substringBefore('\n').trim();
                    System.debug('Circuit Id' + circuitId);
                    break;
                }
        	}
        return circuitId;   
    }
    public static String getCircuitId2(String emailDescription)
    {
        String circuitId = '',incidentId='',siteId='';
        if(String.isBlank(emailDescription)) return circuitId;
        String[] arr = emailDescription.split('\n'); 
        System.debug('SC array :' + arr.size());
            for(Integer i=0;i<arr.size();i++){
                String lcase = arr[i].substringBefore(':').toLowerCase();
                List<String> cids=new List<String>();
                System.debug('array'+arr[i]);
                if(lcase.contains('impacted')){
                    String ImpactedLine = arr[i].substringAfter(':');
                    System.debug('ImpactedLine'+ImpactedLine);
                    
                    if(ImpactedLine.contains('SiteID')){
                        siteId=ImpactedLine.substringAfter('SiteID-').substringBefore('_CircuitID').trim();
                        System.debug('SiteId -'+siteId);
                    }
                    break;
                }
        	}
        return siteId;   
    }
    public static String getIncidentId(String emailDescription)
    {
        String incidentId = '';
        if(String.isBlank(emailDescription)) return incidentId;
        String[] arr = emailDescription.split('\n'); 
            for(Integer i=0;i<arr.size();i++){
                String lcase = arr[i].substringBefore(':').toLowerCase();
                System.debug('array'+arr[i]);
                if(lcase.contains('incident id') || lcase.contains('incidentid')){
                     incidentId=arr[i].substringAfter(':').substringBefore('\n').trim();
                     System.debug('Incident Id' + incidentId);
                    break;
                }
                
            }
        System.debug('Incident id is :'+incidentId);
        return incidentId;   
    }
    
    public static String getActualIncidentTime(String emailDescription)
    {
        String incidentTime = '';
        if(String.isBlank(emailDescription)) return incidentTime;
        String[] arr = emailDescription.split('\n'); 
            for(Integer i=0;i<arr.size();i++){
                String lcase = arr[i].substringBefore(':').toLowerCase();
                System.debug('array'+arr[i]);
                if(lcase.contains('incident time') || lcase.contains('incidenttime')){
                     incidentTime=arr[i].substringAfter(':').substringBefore('\n').trim();
                     System.debug('Incident Time' + incidentTime);
                    break;
                }
            }
        incidentTime = incidentTime.substring(0,incidentTime.lastIndexOf(':'))+incidentTime.substring(incidentTime.lastIndexOf(' '));
        String month=incidentTime.substring(0,incidentTime.indexOf('/'));
		String day = incidentTime.substring(incidentTime.indexOf('/')+1,incidentTime.lastIndexOf('/'));
        incidentTime=day+'/'+month+'/'+incidentTime.substring(incidentTime.lastIndexOf('/')+1).replaceFirst(' ',',');
        Datetime dt=DateTime.parse(incidentTime);
        System.debug('Incident Time is :'+incidentTime);
        System.debug('After Converting to DateTime : '+dt.format('yyyy-MM-dd HH:mm:ss'));
        return dt.format('yyyy-MM-dd HH:mm:ss');
    }

    public static void setLOB(Case thisCase)
    {
        if(thisCase.Origin=='EmailOHFC')
        {
            thisCase.Line_of_Business__c='OHFC';
            thisCase.Origin='Email';
        }else if(thisCase.Origin=='EmailSmallCell')
        {
            thisCase.Line_of_Business__c='Small Cell';
            thisCase.Origin='Email';
            thisCase.Case_Type__c='Issue';
        }else if(thisCase.Origin=='EmailUG')
        {
            thisCase.Line_of_Business__c='UG';
            thisCase.Origin='Email';
        }else if(thisCase.Origin=='EmailFTTH')
        {
            thisCase.Line_of_Business__c='FTTH';
            thisCase.Origin='Email';
        }
    }
    
    /*public static void setQueue(Case thisCase)
    {
        List<Group> queueObjs = [SELECT Id, Name, Email FROM Group WHERE Name = 'NOC' and Type='Queue']; //Id of the NOC queue defined in queues
        if(queueObjs.size()>0)
        {
            thisCase.OwnerId = queueObjs[0].Id; // dev NOC queue Id '00GC3000000m9aTMAQ';
            System.debug('queue id :' + thisCase.OwnerId);
        }
    }*/
    
    public static String getQueueId()
    {
        String QueueId = '';
        List<Group> queueObjs = [SELECT Id, Name, Email FROM Group WHERE Name = 'NOC' and Type='Queue']; //Id of the NOC queue defined in queues
        if(queueObjs.size()>0)
        {
            QueueId = queueObjs[0].Id;	// dev NOC queue Id '00GC3000000m9aTMAQ';
            System.debug('get queue id in Service Cloud Util Class called before insert of a case :' + QueueId);
        }
        return QueueId;
    }
    
    public static void setFTTHFields(Case thisCase)
    {
        System.debug('into setFTTHFields');
        String customerMessage = thisCase.Description;
        String incidentId = customerMessage.substringAfter('Incident:').substringBefore('Status:').trim();
        incidentId = incidentId.replaceAll(',','');
        String summary = customerMessage.substringAfter('Summary:').substringBefore('Actual Incident Time:').trim();
    	//thisCase.FTTHCaseType__c = 'PON';
        if(summary.contains('PON'))
            thisCase.FTTHCaseType__c = 'PON';
        if(summary.contains('INACT'))
			thisCase.FTTHCaseType__c = 'INACT';
        if(summary.contains('Mobility'))
            thisCase.FTTHCaseType__c = 'Mobility';
        String gpon = customerMessage.substringAfter('MSAN IP/Port Details:').substringBefore(', P_OBD:').trim();
        thisCase.GPON_Id__c = gpon; //comma separated GPON Ids from customer
        String FATs = customerMessage.substringAfter('S_OBD:').substringBefore(', BCL_ID:').trim();
        String FATNumbers = '';
        String[] FATArray = FATs.split(',');
        for (Integer i = 0; i<FATArray.size(); i++) //prepare a comma separated FAT list
        {
        	if(!FATArray[i].contains('Unknown') && !FATArray[i].contains('NULL')) //skip if value is unknown or null
            {
                if(FATArray[i].length()==11)
           			FATNumbers = FATNumbers + FATArray[i].substring(0,FATArray[i].length()-2) + ',';
                else
                    FATNumbers = FATNumbers + FATArray[i] + ',';
            }   
        }
        if(FATNumbers.length()>0)
        	FATNumbers = FATNumbers.substring(0,FATNumbers.length()-1); //to remove the last comma
        thisCase.FATNumber__c = FATNumbers; //comma separated FAT Numbers from customer
    }
	
    public static void createFTTHComponentsForCase(Case thisCase, String component)
    {
        System.debug('into create FTTH Component');
        if(component=='GPON')
            setGPONComponent(thisCase);
        else if(component=='FAT')
            setFATComponent(thisCase);
        
    }
    @TestVisible
    private static void setGPONComponent(Case thisCase)
    {
        String gpon = thisCase.GPON_Id__c;
        String[] gpons = gpon.split(',');
        for(Integer i=0;i<gpons.size();i++)
        {
			String gponNumber = gpons[i].trim();            
            List<GPON__c> gponMasterObj = [SELECT GPONId__c, InstallationAddress__c, FDCLocation__c, IsMobilityConnected__c, FieldEngineer__c, Circles__c, RSU__c, Latitude__c, Longitude__c FROM GPON__c where GPONId__c=:gponNumber];
            System.debug('gponsize'+gponMasterObj.size());
        	if(gponMasterObj.size()>0)
            {
                CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='GPON';
                CFC.ComponentId__c = gponMasterObj[0].GPONId__c;
                CFC.Case__c=thisCase.Id;
                CFC.InstallationAddress__c = gponMasterObj[0].InstallationAddress__c;
                CFC.FDCLocation__c = gponMasterObj[0].FDCLocation__c;
                CFC.IsMobilityConnected__c = gponMasterObj[0].IsMobilityConnected__c;
                CFC.FieldEngineer__c = gponMasterObj[0].FieldEngineer__c;
                CFC.Circle__c = gponMasterObj[0].Circles__c;
                CFC.IsReported__c=true;
                CFC.Latitude__c= gponMasterObj[0].Latitude__c;
                CFC.Longitude__c= gponMasterObj[0].Longitude__c;
                insert CFC;
            }
        }
    }
    @TestVisible
    private static void setFATComponent(Case thisCase)
    {
        String FAT = thisCase.FATNumber__c;
        String[] FATs = FAT.split(',');
        for(Integer i=0;i<FATs.size();i++)
        {
            System.debug('service cloud FAT count : '+ FATs[i]);
            String fatNumber = FATs[i].trim();
            List<FAT__c> FATMasterObj = [SELECT GPONId__c, FATNumber__c, FATFullAddress__c, FATLocation__c, FDCLocation__c, IsMobilityConnected__c,Latitude__c,Longitude__c FROM FAT__c where FATNumber__c=:fatNumber];
        	if(FATMasterObj.size()>0)
            {
                System.debug('service cloud FAT count1 : '+ fatNumber + ' ' + FATMasterObj[0].FATNumber__c);
                CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='FAT';
                CFC.Latitude__c= FATMasterObj[0].Latitude__c;
                CFC.Longitude__c= FATMasterObj[0].Longitude__c;
                CFC.FDCLocation__c=FATMasterObj[0].FDCLocation__c;
                CFC.ComponentId__c = FATMasterObj[0].FATNumber__c;
                CFC.Case__c=thisCase.Id;
                CFC.InstallationAddress__c= FATMasterObj[0].FATFullAddress__c;
                CFC.Location__c=FATMasterObj[0].FATLocation__c;
                CFC.IsMobilityConnected__c = FATMasterObj[0].IsMobilityConnected__c;
                if(FAT.contains(FATMasterObj[0].FATNumber__c)) //may not be required as we retrieve only the issues that are affected
                    CFC.IsReported__c=true;
                else
                    CFC.IsReported__c=false;
                insert CFC;
            }
        }
    }
    
    public static void checkForDuplicate(Case thisCase)
    {
        String LOB = thisCase.Line_of_Business__c;
        String CaseType = thisCase.Case_Type__c;
        List<Case> caseObj;
        if(LOB=='OHFC' && CaseType=='Issue')
       		caseObj = [SELECT Id,CaseNumber,Status,CreatedDate from Case where Circuit_ID__c=:thisCase.Circuit_ID__c and Line_of_Business__c=:LOB and (Status!='Resolved' and Status!='Closed' and Status!='Rework' and Status!='Duplicate') and Case_Type__c='Issue' order by CreatedDate desc];
        else if(LOB=='FTTH' && CaseType=='Issue')
            caseObj = [SELECT Id,CaseNumber,Status,CreatedDate from Case where GPON_Id__c=:thisCase.GPON_Id__c and Line_of_Business__c=:LOB and (Status!='Resolved' and Status!='Closed' and Status!='Rework' and Status!='Duplicate') and Case_Type__c='Issue' order by CreatedDate desc];
        else if(LOB=='UG' && CaseType=='Issue')
            System.debug('Route Name'+thisCase.RouteName__c);
            caseObj = [SELECT Id,CaseNumber,Status,CreatedDate from Case where ((Circuit_ID__c=:thisCase.Circuit_ID__c and Circuit_ID__c!=null) or (CustomerCircuitId__c=:thisCase.CustomerCircuitId__c and CustomerCircuitId__c!=null) or(RouteName__c=:thisCase.RouteName__c and RouteName__c!=null)) and Line_of_Business__c=:LOB and (Status!='Resolved' and Status!='Closed' and Status!='Rework' and Status!='Duplicate') and Case_Type__c='Issue' order by CreatedDate desc];
        
        if(CaseType=='Issue' && caseObj.size()>0) //duplicate open case
        {
            thisCase.Status='Duplicate';
            thisCase.OriginalCaseNumber__c = caseObj[0].CaseNumber;
            thisCase.ParentId=caseObj[0].Id;
        }
    }
    
    /*public static void getohfcAccountId(Case thisCase){
        String circuitId = thisCase.CircuitId__c;
        List<Circuit__c> circuitObj =[Select Primary_Customer_Name__c from Circuit__c where CircuitId__c =:circuitId];
        if(segmentObj.size()>0){
            thisCase.AccountId=segmentObj[0].Primary_Customer_Name__c;
            String accountId = thisCase.AccountId;
            List<Contact> contactObj=[Select Id from Contact where AccountId=:accountId and IsPrimaryContact__c=true];
            if(contactObj.size()>0)
            	thisCase.ContactId=contactObj[0].Id;
        }
    }*/
    
    public static void getftthAccountId(Case thisCase){
        String gponId = thisCase.GPON_Id__c;
        List<GPON__c> gponObj =[Select Primary_Customer_Name__c from GPON__c where GPONId__c =:gponId];
        if(gponObj.size()>0){
            thisCase.AccountId=gponObj[0].Primary_Customer_Name__c;
            String accountId = thisCase.AccountId;
        	List<Contact> contactObj=[Select Id from Contact where AccountId=:accountId and IsPrimaryContact__c=true];
        	if(contactObj.size()>0)
            	thisCase.ContactId=contactObj[0].Id;
            	System.debug(thisCase.ContactId);
        }
    }
}