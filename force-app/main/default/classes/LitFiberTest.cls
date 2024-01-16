@IsTest
private class LitFiberTest {

    @IsTest static void testmethod1() {
        Sobject newTemplate = Schema.getGlobalDescribe().get('sitetracker__Project_Template__c').newSObject();
        newTemplate.put('Name', 'Test Template');
        newTemplate.put('sitetracker__Active__c', True);
        newTemplate.put('sitetracker__SiteTraker_Object__c', 'sitetracker__Project__c');
        insert newTemplate;
        Sobject site = Schema.getGlobalDescribe().get('sitetracker__Site__c').newSObject();
        site.put('Name', 'Test Site');
        insert site;
        Sobject project = Schema.getGlobalDescribe().get('sitetracker__Project__c').newSObject();
        project.put('sitetracker__Site__c', site.id);
        project.put('sitetracker__ProjectTemplate__c', newTemplate.get('Id'));
        project.put('sitetracker__Project_Template__c', newTemplate.get('Name'));
        project.put('sitetracker__Project_Type__c', 'Test Template');
        insert project;
        SObject sObj = Schema.getGlobalDescribe().get('Lit_Fiber__c').newSObject();
        Sobj.put('Project__c', project.get('Id'));
        insert sObj;
        system.assert(sObj.id != null);
        sObj.put('Name', 'hello');
        update sObj;
        SObject sObj1 = Schema.getGlobalDescribe().get('Lit_Fiber__c').newSObject();
        Sobj1.put('Project__c', project.get('Id'));
        Boolean errorFound = false;
        try {
            insert Sobj1;
        }catch (Exception ex) {
            errorFound = true;
        }
        System.assertEquals(true, errorFound);
        errorFound = false;
        try {
            Sobj1.put('Name', 'ADfadbfakndbfaldkfbadkfnbakdfbakfjbakDFJBadkfjbadADfadbfakndbfaldkfbadkfnbakdfbakfjbakDFJBadkfjbadADfadbfakndbfaldkfbadkfnbakdfbakfjbakDFJBadkfjbadADfadbfakndbfaldkfbadkfnbakdfbakfjbakDFJBadkfjbadADfadbfakndbfaldkfbadkfnbakdfbakfjbakDFJBadkfjbad');
            insert Sobj1;
        }catch (Exception ex) {
            errorFound = true;
        }
        System.assertEquals(true, errorFound);
        delete sObj;
    }
}