global with sharing class TSOUserTriggerHandler implements sitetracker.StITrigger {
 
    StPackageLicenseManager manager = new StPackageLicenseManager( 'sitetracker' );
  global TSOUserTriggerHandler() {
  }
  public void initialize(String sObjectTypeName) {
  }
  public void bulkBefore() {
  }
  public void bulkAfter() {
  }
  public void beforeInsert(SObject newSo) {
  }
  public void beforeUpdate(SObject oldSo, SObject newSo) {
  }
  public void beforeDelete(SObject so) {}
  public void afterInsert(SObject newSo) {
      User user = ( User )newSo;
 
        Boolean isActive = user.IsActive;
        Boolean hasLicenseAssigned = manager.hasPackageLicenseAssigned( user.Id );
        Boolean hasLicenseAvailable = manager.hasAvailableLicense();
 
        /*
        *    When a user is activated on insert
         */
        if( isActive && !hasLicenseAssigned && hasLicenseAvailable ){
            manager.assignPackageLicense( user.Id );
        }
  }
  public void afterUpdate(SObject oldSo, SObject newSo) {
    User newUser = ( User )newSo;
        User oldUser = ( User )oldSo;
        Boolean isActive = newUser.IsActive;
        Boolean activeChanged = newUser.IsActive != oldUser.IsActive;
        Boolean hasLicenseAssigned = manager.hasPackageLicenseAssigned( newUser.Id );
        Boolean hasLicenseAvailable = manager.hasAvailableLicense();
        /*
        *    When a user is reactivated / activated on update
         */
        if( isActive && activeChanged && !hasLicenseAssigned && hasLicenseAvailable ){
            manager.assignPackageLicense( newUser.Id );
        }
        /*
        *    When a user is deactivated
        */
        else if( !isActive && activeChanged && hasLicenseAssigned ){
            manager.revokePackageLicense( newUser.Id );
        }
  }
  public void afterDelete(SObject so) {}
  public void andFinally() {
  }
}