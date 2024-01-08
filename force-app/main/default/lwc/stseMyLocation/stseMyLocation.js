import { LightningElement, api, track } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';

export default class MyGeolocation extends LightningElement {
    @track _latitude;
    @track _longitude;
    @track _altitude;
    @track _accuracy;
    @track _altitudeAccuracy;
    @track error;
    @track _location; 

    updateInterval;
    watchId;

    connectedCallback() {
        this.startGeolocationUpdates();
    }

    disconnectedCallback() {
        this.stopGeolocationUpdates();
    }

    @api 
    get location(){
        return this._location;
    }

    @api
    get latitude() {
        return this._latitude;
    }

    @api
    get longitude() {
        return this._longitude;
    }

    @api
    get altitude() {
        return this._altitude;
    }

    @api
    get accuracy() {
        return this._accuracy;
    }

    @api
    get altitudeAccuracy() {
        return this._altitudeAccuracy;
    }

    startGeolocationUpdates() {
        // Update location every 5 seconds
        this.updateInterval = setInterval(() => {
            this.updateLocation();
        }, 5000);

        // Watch position for any significant change
        if ('geolocation' in navigator) {
            this.watchId = navigator.geolocation.watchPosition(
                (position) => this.updateGeolocation(position),
                (error) => this.handleError(error)
            );
        } else {
            this.error = 'Geolocation is not supported by this browser.';
            this.dispatchEvent(new FlowAttributeChangeEvent('error', this.error));
        }
    }

    stopGeolocationUpdates() {
        clearInterval(this.updateInterval);
        if (this.watchId !== undefined) {
            navigator.geolocation.clearWatch(this.watchId);
        }
    }

    updateLocation() {
        if ('geolocation' in navigator) {
            navigator.geolocation.getCurrentPosition(
                (position) => this.updateGeolocation(position),
                (error) => this.handleError(error)
            );
        } else {
            this.error = 'Geolocation is not supported by this browser.';
            this.dispatchEvent(new FlowAttributeChangeEvent('error', this.error));
        }
    }

    getLocation(){
        this.updateLocation();
    }

    updateGeolocation(position) {
        this._location = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
            altitude: position.coords.altitude,
            accuracy: position.coords.accuracy,
            altitudeAccuracy: position.coords.altitudeAccuracy
        };
        this.dispatchEvent(new FlowAttributeChangeEvent('location', this._location));

        this._latitude = position.coords.latitude;
        this._longitude = position.coords.longitude;
        this._altitude = position.coords.altitude;       
        this._accuracy = position.coords.accuracy;       
        this._altitudeAccuracy = position.coords.altitudeAccuracy;        
    }

    handleError(error) {
        this.error = `ERROR(${error.code}): ${error.message}`;
        this.dispatchEvent(new FlowAttributeChangeEvent('error', this.error));
    }
}