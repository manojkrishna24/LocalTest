@isTest
public class ServiceCloudUtilTest {
    @isTest
    static void ServiceCloudUtilTest() {
        String emailDescription = 'PFB the incident details Incident Id : INC002 \n Impacted Section Name for IRU  :SiteID-MUM_AIR_OHFC_5G1122_MA5968_CircuitID-ETMUM00000062 \n Summary : Section CHENNAI/MYL is having link down Actual Incident Time : 2023-08-22 11:00:00.000 \n';
        String CircuitId = ServiceCloudUtil.getCircuitId(emailDescription);
        String IncidentId=ServiceCloudUtil.getIncidentId(emailDescription);
        String Descp ='Actual Incident Time : 11/20/2023 8:00:23 PM \n';
        String incidentTime=ServiceCloudUtil.getActualIncidentTime(Descp);
        //System.assertEquals('AIR-MH-MUM-SM/SHAM-RAHU-2/201906', CircuitId);
        //System.assertEquals('INC002',IncidentId);    
    }
    
    @isTest
    static void setLob(){
        Case c1=new Case(Origin='EmailOHFC');
        Case c2=new Case(Origin='EmailSmallCell');
        Case c3=new Case(Origin='EmailUG');
        Case c4=new Case(Origin='EmailFTTH');
        ServiceCloudUtil.setLOB(c1);
        ServiceCloudUtil.setLOB(c2);
        ServiceCloudUtil.setLOB(c3);
        ServiceCloudUtil.setLOB(c4);
        
    }
    @isTest
    static void testSetFTTHFields() {
        Case thisCase = new Case(
            Description='REMEDY NEW INCIDENT ALERT Incident: INC0001413465959, Status: Assigned, Site: Mumbai, Summary: FTTH-Nokia PON Port:MSG-G1:R1.S1.LT1.PON13 MSG-G1 Loss Of Signal  Loss Of Signal , Actual Incident Time: 9/23/2023 7:32:43 PM, Impact: DSL 20 Voice 20, Assigned To: FTTH O&M Mumbai, MSAN IP/Port Details: MSG-G1/1/14, P_OBD: MSG1801, S_OBD: MSG18010202,MSG18010203,MSG18010205, BCL_ID:FAT789'
        );
        insert thisCase;
        ServiceCloudUtil.setFTTHFields(thisCase);
        
        Case c2 = new Case(
            Description='Incident: INC000141967592, Status: Assigned, Site: Mumbai, Summary: Multiple INACT alarms at PDE-H1, Actual Incident Time: 10/5/2023 2:37:19 PM'
        );
        insert c2;
        ServiceCloudUtil.setFTTHFields(c2);
        
        Case c3 = new Case(
            Description='REMEDY NEW INCIDENT ALERT Incident: INC0001413465959, Status: Assigned, Site: Mumbai, Summary: FTTH-Nokia Mobility Port:MSG-G1:R1.S1.LT1 MSG-G1 Loss Of Signal  Loss Of Signal , Actual Incident Time: 9/23/2023 7:32:43 PM, Impact: DSL 20 Voice 20, Assigned To: FTTH O&M Mumbai, MSAN IP/Port Details: MSG-G1/1/14, P_OBD: MSG1801, S_OBD: MSG18010202,MSG18010203,MSG18010205, BCL_ID:FAT789'
        );
        insert c3;
        ServiceCloudUtil.setFTTHFields(c3);
    }
	
    @isTest
    static void testGetftthAccountId() {
        GPON__c gponRecord = new GPON__c(
            GPONId__c = 'MSG-G1/1/14'
           // Primary_Customer_Name__c = '0017100000GtmvdAAB'
        );
        insert gponRecord;
        Contact contactRecord = new Contact(
            AccountId = gponRecord.Primary_Customer_Name__c,
            LastName='Abc',
            IsPrimaryContact__c = true
        );
        insert contactRecord;
        Case thisCase = new Case(
            GPON_Id__c = 'MSG-G1/1/14'
            
        );
        insert thisCase;

        ServiceCloudUtil.getftthAccountId(thisCase);
        Case updatedCase = [SELECT AccountId, ContactId FROM Case WHERE Id = :thisCase.Id];

        //System.assertEquals(gponRecord.Primary_Customer_Name__c, updatedCase.AccountId);
        //System.assertEquals(contactRecord.Id, updatedCase.ContactId);     
    }
    
    @isTest
    static void testduplicate(){
      Case c02=new Case(
        Case_Type__c='Issue',
        Line_of_Business__c='FTTH');
        insert c02;
        ServiceCloudUtil.checkForDuplicate(c02);
        
        Case c03=new Case(
        Case_Type__c='Issue',
        Line_of_Business__c='UG');
        insert c03;
        ServiceCloudUtil.checkForDuplicate(c03);  
        
        Case c04=new Case(
        Case_Type__c='Issue',
        Line_of_Business__c='OHFC');
        ServiceCloudUtil.checkForDuplicate(c04);
    }
    
    @isTest
    static void testSetGPONComponent() {
        // Create a test GPON__c record
        GPON__c gponRecord = new GPON__c(
            GPONId__c = 'TestGPON123',
            InstallationAddress__c = 'Test Address',
            FDCLocation__c = 'Test FDCLocation',
            IsMobilityConnected__c = true,
            //FieldEngineer__c = '00571000002DNIbAAO',
            //Circles__c = 'a39710000007ohdAAA',
            RSU__c = 'TGP'
        );
        insert gponRecord;

        // Create a test Case with GPON_Id__c
        Case thisCase = new Case(GPON_Id__c = 'TestGPON123');
        insert thisCase;

        // Call the private method setGPONComponent
        ServiceCloudUtil.setGPONComponent(thisCase);

        // Query the created CaseFTTHComponent__c record
        CaseFTTHComponent__c createdComponent = [SELECT Id, ComponentId__c, Case__c, InstallationAddress__c, FDCLocation__c, IsMobilityConnected__c, FieldEngineer__c FROM CaseFTTHComponent__c WHERE Case__c = :thisCase.Id];

    }

    @isTest
    static void testCreateFTTHComponentsForCaseGPON() {
        // Create a test Case
        Case thisCase = new Case(
            GPON_Id__c = 'TestGPON123,TestGPON456',
            FTTHCaseType__c = 'PON'
        );
        insert thisCase;

        // Call createFTTHComponentsForCase to create GPON components
        ServiceCloudUtil.createFTTHComponentsForCase(thisCase, 'GPON');

        // Query the created CaseFTTHComponent__c records
        List<CaseFTTHComponent__c> createdComponents = [SELECT Id, ComponentId__c, Case__c FROM CaseFTTHComponent__c WHERE Case__c = :thisCase.Id];

    }
	/*@isTest
    static void testSetFATComponent() {
        // Create a test GPON__c record
        FAT__c fatRecord = new FAT__c(
            Name='ZAV130101',
            GPONId__c = 'TestGPON123',
            FATNumber__c = 'ZAV130101,ZAV130102',
            //GPON__c='a3C71000003LoiuEAC',
            FATFullAddress__c = 'Test Address',
            FATLocation__c = 'Test FATLocation',
            FDCLocation__c = 'Test FDCLocation',
            IsMobilityConnected__c = true
        );
        insert fatRecord;

        // Create a test Case with GPON_Id__c
        Case thisCase = new Case(FATNumber__c = 'TestFAT123');
        insert thisCase;

        // Call the private method setGPONComponent
        ServiceCloudUtil.setFATComponent(thisCase);

        Test.startTest();
        ServiceCloudUtil.setFATComponent(thisCase);
        Test.stopTest();
    }*/

    @isTest
    static void testCreateFTTHComponentsForCaseFAT() {
        // Create a test Case
        Case thisCase = new Case(
            GPON_Id__c = 'TestGPON123,TestGPON456',
            FATNumber__c = 'ZAV130101,ZAV130102',
            FTTHCaseType__c = 'PON'
        );
        insert thisCase;

        // Call createFTTHComponentsForCase to create GPON components
        ServiceCloudUtil.createFTTHComponentsForCase(thisCase, 'FAT');

        // Query the created CaseFTTHComponent__c records
        List<CaseFTTHComponent__c> createdComponents = [SELECT Id, ComponentId__c, Case__c FROM CaseFTTHComponent__c WHERE Case__c = :thisCase.Id];

    }
}