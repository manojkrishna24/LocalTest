public with sharing class CESmallCellDecomTriggerHandler extends sitetracker.StSubProjectExtendableTriggerHandler {
    public virtual override void bulkBeforeExtended(){}
    public virtual override void bulkAfterExtended(){}
    public virtual override void beforeInsertExtended(SObject newObject){}
    public virtual override void beforeUpdateExtended(SObject oldObject, SObject newObject){}
    public virtual override void beforeDeleteExtended(SObject so){}
    public virtual override void afterUpdateExtended(SObject oldObject, SObject newObject){}
    public virtual override void afterInsertExtended(SObject newObject){}
    public virtual override void afterDeleteExtended(SObject so){}
    public virtual override void andFinallyExtended(){}
  }