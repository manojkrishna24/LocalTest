@isTest
public with sharing class StPackageLicenseManagerTest {
 
private static PackageLicense testPackage;
    private static PackageLicense siteLicensedPackage;
 
    private static void testPrep() {
        List<PackageLicense> installedPackages =  [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses FROM PackageLicense WHERE AllowedLicenses != 0];
        if(installedPackages.size() > 0) {
            testPackage = installedPackages.get(0);
        }
 
        List<PackageLicense> installedSitePackages =  [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses FROM PackageLicense WHERE AllowedLicenses = 0];
        if(installedSitePackages.size() > 0) {
            siteLicensedPackage = installedSitePackages.get(0);
        }
    }
 
    static testMethod void testItBaby(){
        testPrep();
        Test.startTest();
 
        StPackageLicenseManager plm = new StPackageLicenseManager('Sitetracker_Package');
        Boolean b = plm.isPackageInstalled();
 
        if(siteLicensedPackage != null){
            plm = new StPackageLicenseManager(siteLicensedPackage.NamespacePrefix);
            Boolean isSiteLicense = plm.isSiteLicense();
        } else{
            siteLicensedPackage = new PackageLicense();
            //siteLicensedPackage.allowedLicenses = 100;
            //siteLicensedPackage.usedLicenses = 99;
            plm = new StPackageLicenseManager(siteLicensedPackage.NamespacePrefix);
            Boolean isSiteLicense = plm.isSiteLicense();
        }
 
        //Boolean hasAvailableLicense()
        plm = new StPackageLicenseManager(testPackage.NamespacePrefix);
        Boolean hasAvailableLicense = plm.hasAvailableLicense();
 
        User u = [SELECT ID FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        plm.hasPackageLicenseAssigned(u.Id);
 
        List<User> users = [SELECT ID FROM User WHERE IsActive = true LIMIT 5];
        Set<Id> userIds = new Set<Id>();
        for(User user: users){
            userIds.add(user.Id);
        }
        plm.assignPackageLicense(userIds);
        plm.revokePackageLicense(userIds);
 
        Test.stopTest();
    }
}