/***********************************************************************************************
 *  Copyright (c) 2018 Sitetracker
 *   This code is the sole property of Sitetracker and may not be distributed
 *   or modified without prior written consent from an authorized representative
 *   from Sitetracker.
 *   All rights reserved.
 *
 *  This class provides methods to work with packaged licenses
 *  @author <A HREF="mailto:tmay@sitetracker.com">T.May</A>
 ************************************************************************************************/
public with sharing class StPackageLicenseManager {
 
    /********************** PUBLIC METHODS AND ATTRIBUTES ***************************/
    /* This enum holds the list of return options describing the result */
    public enum PackageLicenseManagerResult  {
                                                SPECIFIED_PACKAGE_NOT_INSTALLED,
                                                PACKAGE_SITE_LICENSE_ASSIGNED,
                                                PACKAGE_LICENSE_ALREADY_ASSIGNED_TO_USER,
                                                PACKAGE_LICENSE_NOT_ASSIGNED_TO_USER,
                                                PACKAGE_LICENSES_NOT_AVAILABLE,
                                                PACKAGE_LICENSE_ASSIGNED,
                                                PACKAGE_LICENSE_REMOVED,
                                                ERROR_ASSIGNING_PACKAGE_LICENSE,
                                                ERROR_REMOVING_PACKAGE_LICENSE
                                            }
 
 
    /* Constructor allowing specification of the namespace for the package to use */
    public StPackageLicenseManager(String packageNamespace) {
        this.packageNamespace = packageNamespace;
    }
 
    /* This method will indicate if the package specified in the constructor is installed in the source org */
    public Boolean isPackageInstalled() {
        return packageLicense != null;
    }
 
    /* This method will indicate if the package specified in the constructor is set up as a Site License */
    public Boolean isSiteLicense() {
        return packageLicense != null && packageLicense.allowedLicenses == -1;
    }
 
    /* This method will indicate if the package specified in the constructor has available licenses */
    public Boolean hasAvailableLicense() {
        return packageLicense.AllowedLicenses > packageLicense.UsedLicenses;
    }
 
    /* This method will return true if the specified user has a packaged license assigned */
    public Boolean hasPackageLicenseAssigned(Id userId) {
        return getUserPackageLicense(userId) != null;
    }
 
    /*
     * This method will attempt to assign the specified package license to the specified user(s)
     * Id userId - The Id of the user to assign a package license to
     * @returns a Map of User Ids, PackageLicenseManagerResult describing the state of the assignment
    */
    public Map<Id, PackageLicenseManagerResult> assignPackageLicense(Set<Id> userIds) {
        Map<Id, PackageLicenseManagerResult> results = new Map<Id, PackageLicenseManagerResult>();
        for(Id userId : userIds) {
            PackageLicenseManagerResult result = assignPackageLicense(userId);
            results.put(userId, result);
        }
        return results;
    }
 
    /*
     * This method will attempt to assign the specified package license to the specified user(s)
     * Id userId - The Id of the user to assign a package license to
     * @returns a PackageLicenseManagerResult describing the state of the assignment
    */
    public PackageLicenseManagerResult assignPackageLicense(Id userId) {
 
        if( isPackageInstalled() == false ) {
            return PackageLicenseManagerResult.SPECIFIED_PACKAGE_NOT_INSTALLED;
        }
 
        if( isSiteLicense() ) {
            return PackageLicenseManagerResult.PACKAGE_SITE_LICENSE_ASSIGNED;
        }
 
        if( hasPackageLicenseAssigned(userId) ) {
            return PackageLicenseManagerResult.PACKAGE_LICENSE_ALREADY_ASSIGNED_TO_USER;
        }
 
        if( hasAvailableLicense() == false ) {
            return PackageLicenseManagerResult.PACKAGE_LICENSES_NOT_AVAILABLE;
        }
 
        return insertPackageLicense(userId);
 
    }
 
    /* This method will attempt to assign the specified package license to the specified user(s) */
    public  Map<Id, PackageLicenseManagerResult> revokePackageLicense(Set<Id> userIds) {
        Map<Id, PackageLicenseManagerResult> results = new Map<Id, PackageLicenseManagerResult>();
        for(Id userId : userIds) {
            PackageLicenseManagerResult result = revokePackageLicense(userId);
            results.put(userId, result);
        }
        return results;
    }
 
    /* This method will attempt to assign the specified package license to the specified user(s) */
    public PackageLicenseManagerResult revokePackageLicense(Id userId) {
 
        if( isPackageInstalled() == false ) {
            return PackageLicenseManagerResult.SPECIFIED_PACKAGE_NOT_INSTALLED;
        }
 
        if( isSiteLicense() ) {
            return PackageLicenseManagerResult.PACKAGE_SITE_LICENSE_ASSIGNED;
        }
 
        if( !hasPackageLicenseAssigned(userId) ) {
            return PackageLicenseManagerResult.PACKAGE_LICENSE_NOT_ASSIGNED_TO_USER;
        }
 
        return deletePackageLicense(userId);
 
    }
 
    /********************** PRIVATE METHODS AND ATTRIBUTES ***************************/
    /* The namespace of the package you are working with */
    private String packageNamespace;
 
    /* Caches the PackageLicense object for the given namespace */
    private PackageLicense packageLicense {
        get {
            if(packageLicense == null) {
                try {
                    packageLicense = [SELECT Id, AllowedLicenses, UsedLicenses FROM PackageLicense WHERE NamespacePrefix =: packageNamespace];
                }
                catch(QueryException que) {} //No results
            }
            return packageLicense;
        }
        set;
    }
 
    /* Cache the user licenses available.  Key: The ID of the user | Value: The UserPackageLicense */
    private Map<Id, UserPackageLicense> userLicenseMap {
        get {
            if(userLicenseMap == null) {
                userLicenseMap = new Map<Id, UserPackageLicense>();
                List<UserPackageLicense> existingLicenses = [SELECT id, UserId FROM UserPackageLicense WHERE PackageLicenseId =: packageLicense.Id];
                for(UserPackageLicense license : existingLicenses) {
                    userLicenseMap.put(license.UserId, license);
                }
            }
            return userLicenseMap;
        }
        set;
    }
 
    /* These methods will return the UserPackageLicense if the specified user has a packaged license assigned */
    private UserPackageLicense getUserPackageLicense(Id userId) {
        return userLicenseMap.containsKey(userId) ? userLicenseMap.get(userId) : null;
    }
 
    /* This method will perform the insert of a UserPackageLicense for the specified namespace and userId */
    private PackageLicenseManagerResult insertPackageLicense(Id userId) {
        try {
            insert new UserPackageLicense(UserId = userId, PackageLicenseId = packageLicense.id);
            return PackageLicenseManagerResult.PACKAGE_LICENSE_ASSIGNED;
        }
        catch(Exception e) {
            System.debug('Error assigning package license: ' + e.getMessage() );
            return PackageLicenseManagerResult.ERROR_ASSIGNING_PACKAGE_LICENSE;
        }
    }
 
    /* This method will perform the deletion of a UserPackageLicense for the specified namespace and userId */
    private PackageLicenseManagerResult deletePackageLicense(Id userId) {
        UserPackageLicense existingLicense = getUserPackageLicense(userId);
        try {
            delete existingLicense;
            userLicenseMap.remove(userId); // remove the item from the license map
            return PackageLicenseManagerResult.PACKAGE_LICENSE_REMOVED;
        }
        catch(Exception e) {
            System.debug('Error removing package license: ' + e.getMessage() );
            return PackageLicenseManagerResult.ERROR_REMOVING_PACKAGE_LICENSE;
        }
    }
 
}