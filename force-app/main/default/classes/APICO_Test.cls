@isTest
private class APICO_Test{
    @isTest static  void APICO_Mock1() {
        Test.SetMock(HttpCallOutMock.class, new APICalloutMock());
        APICO.callJBonResolved('',true);
    }                
}