@isTest
public class TestCaseComponentAfterInsertTrigger {
    @isTest static void testmethod1(){
        Case testcase=new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '0O2-Z1/3/10',
            IsExcelRecord__c = true,
            Origin='Telegram',
            //FieldEngineerUser__c='005C7000000IXRZIA4',
            Status='New',
            HoldReason__c='Access issue',
            FTTHCaseType__c='PON'
        );
       	insert testcase;
        Case myCase = [SELECT Id FROM Case LIMIT 1];
        CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='GPON';
                CFC.ComponentId__c = '0O2-Z1/3/10';
                CFC.Case__c= myCase.Id;
                CFC.InstallationAddress__c = '-Flat No AL6/7/9 Room No 9,Omkar Apartment,Airoli Sector 5,Navi Mumbai,,Th,ane,Maharashtra,400708,,Thane,Maharashtra,400708';
                CFC.FDCLocation__c = 'FDC ON-TERRACE-OMKAR APARTMENT BUILDING NO 07';
                CFC.IsMobilityConnected__c = false;
               // CFC.FieldEngineer__c = '00571000002DNIbAAO';
                //CFC.Circle__c = 'a39710000007ohdAAA';
                CFC.IsReported__c=true;
                CFC.Latitude__c= '19.148418';
                CFC.Longitude__c= '72.9941';
                insert CFC;
    }
     @isTest static void testmethod2(){
        Case testcase=new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '0O2-Z1/3/10',
            IsExcelRecord__c = true,
            Origin='Telegram',
            //FieldEngineerUser__c='005C7000000IXRZIA4',
            Status='New',
            HoldReason__c='Access issue'
        );
       	insert testcase;
        Case myCase = [SELECT Id FROM Case LIMIT 1];
        CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='FAT';
                CFC.ComponentId__c = '0O2-Z1/3/10';
                CFC.Case__c= myCase.Id;
                CFC.InstallationAddress__c = '-Flat No AL6/7/9 Room No 9,Omkar Apartment,Airoli Sector 5,Navi Mumbai,,Th,ane,Maharashtra,400708,,Thane,Maharashtra,400708';
                CFC.FDCLocation__c = 'FDC ON-TERRACE-OMKAR APARTMENT BUILDING NO 07';
                CFC.IsMobilityConnected__c = false;
                //CFC.FieldEngineer__c = '00571000002DNIbAAO';
                //CFC.Circle__c = 'a39710000007ohdAAA';
                CFC.IsReported__c=true;
                CFC.Latitude__c= '19.148418';
                CFC.Longitude__c= '72.9941';
                insert CFC;
    }
    @isTest static void testmethod3(){
        Case testcase=new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '0O2-Z1/3/10',
            IsExcelRecord__c = true,
            Origin='Telegram',
            //FieldEngineerUser__c='005C7000000IXRZIA4',
            Status='New',
            HoldReason__c='Access issue',
            FTTHCaseType__c='PON',
            FTTHInformation__c = 'Test method 3'
        );
       	insert testcase;
        Case myCase = [SELECT Id FROM Case LIMIT 1];
        CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='GPON';
                CFC.ComponentId__c = '0O2-Z1/3/10';
                CFC.Case__c= myCase.Id;
                CFC.InstallationAddress__c = '-Flat No AL6/7/9 Room No 9,Omkar Apartment,Airoli Sector 5,Navi Mumbai,,Th,ane,Maharashtra,400708,,Thane,Maharashtra,400708';
                CFC.FDCLocation__c = 'FDC ON-TERRACE-OMKAR APARTMENT BUILDING NO 07';
                CFC.IsMobilityConnected__c = false;
               // CFC.FieldEngineer__c = '00571000002DNIbAAO';
               // CFC.Circle__c = 'a39710000007ohdAAA';
                CFC.IsReported__c=true;
                CFC.Latitude__c= '19.148418';
                CFC.Longitude__c= '72.9941';
                insert CFC;
    }
    @isTest static void testmethod4(){
        Case testcase=new Case(
            Line_of_Business__c = 'FTTH',
            GPON_Id__c = '0O2-Z1/3/10',
            IsExcelRecord__c = true,
            Origin='Telegram',
            //FieldEngineerUser__c='005C7000000IXRZIA4',
            Status='New',
            HoldReason__c='Access issue',
            FTTHInformation__c = 'Test Method 4'
        );
       	insert testcase;
        Case myCase = [SELECT Id FROM Case LIMIT 1];
        CaseFTTHComponent__c CFC = new CaseFTTHComponent__c();
                CFC.ComponentType__c='FAT';
                CFC.ComponentId__c = '0O2-Z1/3/10';
                CFC.Case__c= myCase.Id;
                CFC.InstallationAddress__c = '-Flat No AL6/7/9 Room No 9,Omkar Apartment,Airoli Sector 5,Navi Mumbai,,Th,ane,Maharashtra,400708,,Thane,Maharashtra,400708';
                CFC.FDCLocation__c = 'FDC ON-TERRACE-OMKAR APARTMENT BUILDING NO 07';
                CFC.IsMobilityConnected__c = false;
              //  CFC.FieldEngineer__c = '00571000002DNIbAAO';
                //CFC.Circle__c = 'a39710000007ohdAAA';
                CFC.IsReported__c=true;
                CFC.Latitude__c= '19.148418';
                CFC.Longitude__c= '72.9941';
                insert CFC;
    }
}