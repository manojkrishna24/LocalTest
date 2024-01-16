@isTest
public class ScheduledFlowTestClass {
	@isTest
    static void testScheduledFlow() {
        Test.startTest();
        String jobId = System.schedule('TestScheduledFlow', '0 0 * * * ?', new ScheduledFlow());
        Test.stopTest();
    }
}