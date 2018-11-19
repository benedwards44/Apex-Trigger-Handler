/**
* @author Ben Edwards (ben@edwards.nz)
* @date 2016-06-07
* @description Test class for the generic TriggerHandler class
*
* CHANGE LOG
**/
@isTest
public class TriggerHandlerTest {

    private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';

    private static String lastMethodCalled;

    private static TriggerHandlerTest.TestHandler handler;

    static {
        
        handler = new TriggerHandlerTest.TestHandler();
        // override its internal trigger detection
        handler.isTriggerExecuting = true;
    }

    /***************************************
     * unit tests
     ***************************************/

    // contexts tests

    @isTest
    static void testBeforeInsert() {
        beforeInsertMode();
        handler.execute(true);
        System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    }

    @isTest
    static void testBeforeUpdate() {
        beforeUpdateMode();
        handler.execute(true);
        System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
    }

    @isTest
    static void testBeforeDelete() {
        beforeDeleteMode();
        handler.execute(true);
        System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
    }

    @isTest
    static void testAfterInsert() {
        afterInsertMode();
        handler.execute(true);
        System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
    }

    @isTest
    static void testAfterUpdate() {
        afterUpdateMode();
        handler.execute(true);
        System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
    }

    @isTest
    static void testAfterDelete() {
        afterDeleteMode();
        handler.execute(true);
        System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
    }

    @isTest
    static void testAfterUndelete() {
        afterUndeleteMode();
        handler.execute(true);
        System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
    }

    @isTest
    static void testRunOnce() {
        system.assert(TriggerHandler.runOnce());
        system.assert(!TriggerHandler.runOnce());
    }


    @isTest
    static void testVirtualMethods() {
        TriggerHandler h = new TriggerHandler();
        h.beforeInsert();
        h.beforeUpdate();
        h.beforeDelete();
        h.afterInsert();
        h.afterUpdate();
        h.afterDelete();
        h.afterUndelete();
    }

    /***************************************
     * testing utilities
     ***************************************/

    private static void resetTest() {
        lastMethodCalled = null;
    }

    // modes for testing

    private static void beforeInsertMode() {
        handler.setTriggerContext('before insert', true);
    }

    private static void beforeUpdateMode() {
        handler.setTriggerContext('before update', true);
    }

    private static void beforeDeleteMode() {
        handler.setTriggerContext('before delete', true);
    }

    private static void afterInsertMode() {
        handler.setTriggerContext('after insert', true);
    }

    private static void afterUpdateMode() {
        handler.setTriggerContext('after update', true);
    }

    private static void afterDeleteMode() {
        handler.setTriggerContext('after delete', true);
    }

    private static void afterUndeleteMode() {
        handler.setTriggerContext('after undelete', true);
    }

    // test implementation of the TriggerHandler

    private class TestHandler extends TriggerHandler {

        public override void beforeInsert() {
            TriggerHandlerTest.lastMethodCalled = 'beforeInsert';
        }

        public override void beforeUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
        }

        public override void beforeDelete() {
            TriggerHandlerTest.lastMethodCalled = 'beforeDelete';
        }

        public override void afterInsert() {
            TriggerHandlerTest.lastMethodCalled = 'afterInsert';
        }

        public override void afterUpdate() {
            TriggerHandlerTest.lastMethodCalled = 'afterUpdate';
        }

        public override void afterDelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterDelete';
        }

        public override void afterUndelete() {
            TriggerHandlerTest.lastMethodCalled = 'afterUndelete';
        }

    }
    
}
