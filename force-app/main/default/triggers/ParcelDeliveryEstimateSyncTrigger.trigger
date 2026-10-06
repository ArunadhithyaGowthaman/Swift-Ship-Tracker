trigger ParcelDeliveryEstimateSyncTrigger on Parcel__c (after update) {
    Set<Id> changedParcelIds = new Set<Id>();
    Map<Id, Date> estimatesByParcelId = new Map<Id, Date>();

    for (Parcel__c currentParcel : Trigger.new) {
        Parcel__c priorParcel = Trigger.oldMap.get(currentParcel.Id);
        if (currentParcel.Estimated_Delivery__c != priorParcel.Estimated_Delivery__c) {
            changedParcelIds.add(currentParcel.Id);
            estimatesByParcelId.put(currentParcel.Id, currentParcel.Estimated_Delivery__c);
        }
    }

    if (changedParcelIds.isEmpty()) {
        return;
    }

    List<Delivery__c> deliveriesToUpdate = new List<Delivery__c>();
    for (Delivery__c delivery : [
        SELECT Id, Parcel__c, Estimated_Delivery__c
        FROM Delivery__c
        WHERE Parcel__c IN :changedParcelIds
    ]) {
        Date parcelEstimate = estimatesByParcelId.get(delivery.Parcel__c);
        if (delivery.Estimated_Delivery__c != parcelEstimate) {
            delivery.Estimated_Delivery__c = parcelEstimate;
            deliveriesToUpdate.add(delivery);
        }
    }

    if (!deliveriesToUpdate.isEmpty()) {
        update deliveriesToUpdate;
    }
}
