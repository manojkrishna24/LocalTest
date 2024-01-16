trigger TSOLicenseAssign on User (before delete, before insert, before update, after delete, after insert, after undelete, after update) {
    sitetracker.StTriggerFactory.createAndExecuteHandler(TSOUserTriggerHandler.class);
}