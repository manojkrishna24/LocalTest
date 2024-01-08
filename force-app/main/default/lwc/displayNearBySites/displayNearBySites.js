import { LightningElement, wire, api } from 'lwc';
import getCurrentSite from '@salesforce/apex/CurrentSiteController.getCurrentSite';

const COLUMNS = [
    { label: 'Site Name', fieldName: 'lwcNameUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' }, target: '_self' } },
    { label: 'OPCO ID', fieldName: 'Opcoid__c'},
   // { label: 'Address', fieldName: 'sitetracker__Street_Address__c', type: 'text' },
    { label: 'Latitude', fieldName: 'sitetracker__Location__Latitude__s' },
    { label: 'Longitude', fieldName: 'sitetracker__Location__Longitude__s' },
    { label: 'Status', fieldName: 'sitetracker__Site_Status__c'}
];

export default class CurrentSiteLWC extends LightningElement {
    @api recordId; // Pass the recordId 
    filteredSites = [];
    columns = COLUMNS;

    @wire(getCurrentSite, { recordId: '$recordId' })
    wiredGetCurrentSite({ error, data }) {
        if (data) {
            this.filteredSites = data.map(row => {
                const lwcNameUrl = `/${row.Id}`;
                return { ...row, lwcNameUrl };
            });
        } else if (error) {
            console.error('Error loading sites:', error);
        }
    }

    // Getter to determine whether to show the datatable
    get showDatatable() {
        return this.filteredSites.length > 0;
    }
}