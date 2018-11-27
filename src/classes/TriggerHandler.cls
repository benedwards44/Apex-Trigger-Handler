/**
* @author Ben Edwards (ben@edwards.nz)
* @date 10th October 2016
* @description General Handler class for all triggers
*               Trigger design framework taken from https://github.com/kevinohara80/sfdc-trigger-framework
* 
* CHANGE LOG
**/
public virtual class TriggerHandler {
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;

    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;

    // Static Booleans to control recursion
    public static Boolean beforeInsertHasRun = false;
    public static Boolean afterInsertHasRun = false;
    public static Boolean beforeUpdateHasRun = false;
    public static Boolean afterUpdateHasRun = false;


    // Constructor
    public TriggerHandler() {
        this.setTriggerContext();
    }

    /***************************************
    * public instance methods
    ***************************************/

    // Default to always run
    public void execute () {
        execute(true);
    }

    // Handle Boolean (usually set via Custom Setting) to specify whether trigger is enabled or not.
    public void execute (Boolean isEnabled) {

        if (isEnabled) {

            // dispatch to the correct handler method
            if (this.context == TriggerContext.BEFORE_INSERT) {

                this.beforeInsert();

                // Set boolean to control recursion
                beforeInsertHasRun = true;
            } 
            else if (this.context == TriggerContext.BEFORE_UPDATE) {

                this.beforeUpdate();

                // Set boolean to control recursion
                afterInsertHasRun = true;
            }
            else if (this.context == TriggerContext.BEFORE_DELETE) {

                this.beforeDelete();

                // Set boolean to control recursion
                beforeUpdateHasRun = true;
            } 
            else if (this.context == TriggerContext.AFTER_INSERT) {

                this.afterInsert();

                // Set boolean to control recursion
                afterUpdateHasRun = true;
            } 
            else if (this.context == TriggerContext.AFTER_UPDATE) {

                this.afterUpdate();
            } 
            else if (this.context == TriggerContext.AFTER_DELETE) {

                this.afterDelete();
            } 
            else if (this.context == TriggerContext.AFTER_UNDELETE) {

                this.afterUndelete();
            }
        }
    }


    /***************************************
        * private instancemethods
    ***************************************/

    @TestVisible
    private void setTriggerContext() {

        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {

        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } 
        else {
            this.isTriggerExecuting = true;
        }

        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
            this.context = TriggerContext.BEFORE_INSERT;
        } 
        else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')){
            this.context = TriggerContext.BEFORE_UPDATE;
        } 
        else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')) {
            this.context = TriggerContext.BEFORE_DELETE;
        } 
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')) {
            this.context = TriggerContext.AFTER_INSERT;
        } 
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')) {
            this.context = TriggerContext.AFTER_UPDATE;
        } 
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')) {
            this.context = TriggerContext.AFTER_DELETE;
        }
        else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')) {
            this.context = TriggerContext.AFTER_UNDELETE;
        }
    }

    /***************************************
    * context methods
    ***************************************/

    // Returns TRUE if the provided field has changed
    public static Boolean hasChangedField (String field, sObject record, sObject recordOld) {
        return hasChangedFields(new List<String>{field}, record, recordOld);
    }

    // Returns TRUE if a value of one of the specified fields has changed
    public static Boolean hasChangedFields (String[] fieldZ, sObject record, sObject recordOld) {

        // See if any fields have changed
        for (String field:fieldZ) {
            if (record.get(field) != recordOld.get(field)){
                return true;
            }
        }
        return false;
    }


    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert(){}
    @TestVisible
    protected virtual void beforeUpdate(){}
    @TestVisible
    protected virtual void beforeDelete(){}
    @TestVisible
    protected virtual void afterInsert(){}
    @TestVisible
    protected virtual void afterUpdate(){}
    @TestVisible
    protected virtual void afterDelete(){}
    @TestVisible
    protected virtual void afterUndelete(){}

    /***************************************
    * public utility methods
    ***************************************/

    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
        AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
        AFTER_UNDELETE
    }
}
