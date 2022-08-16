public without sharing class accountTriggerHandler implements TriggerHandler{
    
    private boolean triggerIsExecuting;
    private integer TriggerSize;

    public AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<SObject> newRecords) {
        // code block
    }
    public void beforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        // code block
    }
    public void beforeDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        // code block
    }
    public void afterInsert(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        // code block

    }
    public void afterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<ID, SObject> oldRecordMap, Map<ID, SObject> newRecordMap) {
        // code block
    }
    public void afterDelete(List<SObject> oldRecords, Map<ID, SObject> oldRecordMap) {
        // code block
    }
    public void afterUndelete(List<SObject> newRecords, Map<ID, SObject> newRecordMap) {
        // code block
    }


}
