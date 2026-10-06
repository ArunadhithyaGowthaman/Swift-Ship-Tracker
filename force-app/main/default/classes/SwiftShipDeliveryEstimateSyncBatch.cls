public with sharing class SwiftShipDeliveryEstimateSyncBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Estimated_Delivery__c, Parcel__r.Estimated_Delivery__c
            FROM Delivery__c
            WHERE Parcel__c != null
        ]);
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        List<Delivery__c> updates = new List<Delivery__c>();
        for (SObject item : scope) {
            Delivery__c d = (Delivery__c)item;
            if (d.Estimated_Delivery__c != d.Parcel__r.Estimated_Delivery__c) {
                updates.add(new Delivery__c(
                    Id = d.Id,
                    Estimated_Delivery__c = d.Parcel__r.Estimated_Delivery__c
                ));
            }
        }
        if (!updates.isEmpty()) {
            Database.SaveResult[] res = Database.update(updates, false);
            for (Database.SaveResult s : res) {
                if (!s.isSuccess()) {
                    for (Database.Error e : s.getErrors()) {
                        System.debug(LoggingLevel.ERROR, 'BATCH_ERR|'
                            + e.getStatusCode() + '|' + e.getMessage()
                            + '|fields=' + e.getFields());
                    }
                }
            }
        }
    }

    public void finish(Database.BatchableContext context) {
    }
}
