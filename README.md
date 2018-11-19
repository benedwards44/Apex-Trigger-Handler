# Apex-Trigger-Handler
Generic Trigger Manager class for centralisation and management of triggers

[Deploy to Org](https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-Trigger-Handler)

## Example

Once installed, your triggers should follow this pattern:
```
trigger Account on Account (
    before insert, before update, before delete, 
    after insert, after update, after delete, after undelete
) {

    // Pass immediately to the Handler class for processing
    new AccountTriggerHandler().execute(Trigger_Manager__c.getInstance().Account__c);
}
```

Note: `Trigger_Manager__c.getInstance().Account__c` refers to a Custom Setting called `Trigger_Manager__c` with a field `Account__c` to manage whether the trigger should be enabled or disabled.

And then `AccountTriggerHandler`:
```
public with sharing class LeadTriggerHandler extends TriggerHandler {

    public override void beforeInsert() {

        doSomeLogic();
    }

    public override void beforeUpdate() {

        doSomeLogic();
    }

    ...

    private void doSomeLogic() {

        ...
    }

}
```
