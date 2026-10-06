---
# SwiftShip Tracker

A Salesforce-based parcel booking, tracking and delivery management system built
as a group project (Salesforce Developer Program, SkillWallet).

## Team
Arun Adhithya G, Abinaya N S, Atchaya P, Aarthika P, Naveen S

## What is included
- ParcelDeliveryEstimateSyncTrigger - after-update trigger on Parcel__c that
  detects changed estimated delivery dates.
- SwiftShipDeliveryEstimateSyncBatch - batch job that corrects Delivery__c
  estimated dates that differ from the parent Parcel__c.
- SwiftShipDeliveryEstimateSyncBatchTest - unit test for the batch (passes).

## Not included
Flows, custom objects, reports and dashboards live in the Salesforce org and are
described in the project document.

## Status
Working: parcel status updates, tracking flow, operations dashboard, batch test.
Planned: notifications to each parcel's receiver, customer portal, AI agent.

## Demo and report
See the demo video and project document in this repository.
---
