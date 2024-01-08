import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getRecord } from "lightning/uiRecordApi";

//define the field values to be retrieved
const FIELDS = [
  "Account.Name",
  "Account.BillingStreet",
  "Account.BillingCity",
  "Account.BillingState",
  "Account.BillingPostalCode",
  "Account.BillingCountry"
];

export default class DisplayMapInFlow extends LightningElement {
  @api recordId; //if this component is used other than flow then it will be used
  @api sfdcRecordId; //this is passed from flow
  @api zoomLevel; //this is passed from flow

  account; //internal variable to store the account data
  mapMarkers = []; //this is used on HTML for attribute value

  //This method check the values passed into the component
  connectedCallback() {
    this.recordId = !!this.recordId ? this.recordId : this.sfdcRecordId;
    this.zoomLevel = !!this.zoomLevel ? this.zoomLevel : 6;
  }

  //fetch record details based on recordId
  @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
  wiredRecord({ error, data }) {
    if (data) {
      this.account = data;
      //prepare marker to display on map
      this.mapMarkers = [
        {
          location: {
            Street: this.account.fields.BillingStreet.value,
            City: this.account.fields.BillingCity.value,
            State: this.account.fields.BillingState.value,
            PostalCode: this.account.fields.BillingPostalCode.value,
            Country: this.account.fields.BillingCountry.value
          },
          icon: "custom:custom26",
          title: this.account.fields.Name.value
        }
      ];
    } else if (error) {
      let message = "Unknown error";
      if (Array.isArray(error.body)) {
        message = error.body.map((e) => e.message).join(", ");
      } else if (typeof error.body.message === "string") {
        message = error.body.message;
      }
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error loading Account",
          message,
          variant: "error"
        })
      );
    }
  }
}