@IsTest
private class SwiftShipDeliveryEstimateSyncBatchTest {
    @IsTest
    static void copiesParcelEstimateToDelivery() {
        Sender__c sender = new Sender__c(
            Name = 'Batch Test Sender',
            Sender_Email__c = 'test@example.com'
        );
        insert sender;

        Receiver__c receiver = new Receiver__c(
            Name = 'Batch Test Receiver',
            Receiver_Email__c = 'test@example.com'
        );
        insert receiver;

        Parcel__c parcel = new Parcel__c(
            Status__c = 'In Transit',
            Weight__c = 1.0,
            Estimated_Delivery__c = Date.today().addDays(5),
            Sender__c = sender.Id,
            Receiver__c = receiver.Id
        );
        insert parcel;

        Delivery__c delivery = new Delivery__c(
            Parcel__c = parcel.Id,
            Estimated_Delivery__c = Date.today()
        );
        insert delivery;

        Test.startTest();
        Database.executeBatch(new SwiftShipDeliveryEstimateSyncBatch(), 1);
        Test.stopTest();

        Delivery__c synced = [
            SELECT Estimated_Delivery__c
            FROM Delivery__c
            WHERE Id = :delivery.Id
        ];
        System.assertEquals(parcel.Estimated_Delivery__c, synced.Estimated_Delivery__c);
    }
}
