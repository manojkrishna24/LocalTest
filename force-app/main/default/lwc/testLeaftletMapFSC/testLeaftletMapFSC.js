import { LightningElement, api, track, wire } from "lwc";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";
import LEAFLET from "@salesforce/resourceUrl/leafletFSC";
import { FlowAttributeChangeEvent } from "lightning/flowSupport";
import getSiteCandidates from "@salesforce/apex/LeafletMapFSCController.getSiteCandidates";
import { getRecord } from "lightning/uiRecordApi";
import candidateMarker from "@salesforce/resourceUrl/geolocation_candidate_marker";
import defaultMarker from "@salesforce/resourceUrl/geolocation_default_marker";
import siteMarker from "@salesforce/resourceUrl/geolocation_site_marker";
const MAP_HEIGHT = 500;
const DRAGGABLE_ZINDEX = 10000;
const SITE_ZINDEX = 0;
const CANDIDATE_ZINDEX = 5000;

let lastDraggableMarker = null;

function getDraggableMarker(
  mapResult,
  draggable,
  popupText,
  defaultMarkerIcon
) {
  console.log("newDraggableMarker() draggable:", draggable);

  let lat = mapResult.lat;
  let lng = mapResult.lng;

  if (mapResult.map.hasLayer(lastDraggableMarker)) {
    mapResult.map.removeLayer(lastDraggableMarker);
    console.log("Removing existing draggable marker.");
  }

  let marker = L.marker([lat, lng], {
    zIndexOffset: DRAGGABLE_ZINDEX,
    draggable: draggable,
    icon: defaultMarkerIcon,
  });
  marker.bindPopup(popupText);

  if (draggable) {
    marker.on("move", function (e) {
      mapResult.lat = e.latlng.lat;
      mapResult.lng = e.latlng.lng;
      marker.bindPopup(popupText);
    });
  }
  lastDraggableMarker = marker;
  return marker;
}

export default class TestLeaftletMapFSC extends LightningElement {
  @track showMap = false;
  @track mapResult = {
    map: null, //temp leaflet map obj
    lat: null, //temp latitude
    lng: null, //temp longitude
  };
  @track showPinpointCurrentLocButton;
  @api popupTextValue;
  @api currentLocationButtonLabel;
  @api required;
  @api draggable;

  @api recordId;

  @track errorMessage;
  @api showError() {
    return Boolean(this.errorMessage);
  }

  siteRecord;
  siteCandidates;

  siteMarkerUrl = siteMarker;
  candidateMarkerUrl = candidateMarker;
  defaultMarkerUrl = defaultMarker;

  siteMarkerIcon = null;
  candidateMarkerIcon = null;
  defaultMarkerIcon = null;

  mapInitiated = false;
  tileLayer = null;

  currentLocationStatus = {
    fetchingLocation: false,
  };

  @api
  get latitude() {
    const attributeLatitudeChangeEvent = new FlowAttributeChangeEvent(
      "latitude",
      this.mapResult.lat
    );
    this.dispatchEvent(attributeLatitudeChangeEvent);
    return this.mapResult.lat;
  }
  set latitude(value) {
    this.mapResult.lat = value;
  }
  @api
  get longitude() {
    const attributeLongitudeChangeEvent = new FlowAttributeChangeEvent(
      "longitude",
      this.mapResult.lng
    );
    this.dispatchEvent(attributeLongitudeChangeEvent);
    return this.mapResult.lng;
  }
  set longitude(value) {
    this.mapResult.lng = value;
  }
  @api
  validate() {
    if (
      (this.required && this.latitude != null && this.longitude != null) ||
      !this.required
    ) {
      return { isValid: true };
    } else {
      return {
        isValid: false,
        errorMessage: "Please make sure Latitude and Longitude are filled",
      };
    }
  }

  connectedCallback() {
    this.showMap = true;
    this.initMap();
    console.log("TestLeaftletMapFSC v3 Connected.");

    if (this.currentLocationButtonLabel) {
      this.showPinpointCurrentLocButton = true;
    }
  }

  @wire(getRecord, {
    recordId: "$recordId",
    fields: [
      "sitetracker__Site__c.sitetracker__Location__Latitude__s",
      "sitetracker__Site__c.sitetracker__Location__Longitude__s",
      "sitetracker__Site__c.Name",
    ],
  })
  getSiteRecordWireHandler({ error, data }) {
    if (data) {
      console.log("getSiteRecordWireHandler data:", data);
      this.siteRecord = data;
      this.refreshMap();
    } else if (error) {
      // console.log("getSiteRecordWireHandler error:", error);
    }
  }

  @wire(getSiteCandidates, { siteId: "$recordId" })
  siteCandidatesWireHandler({ error, data }) {
    if (data) {
      // console.log("getSiteCandidates data:", data);
      this.siteCandidates = data;
      this.refreshMap();
    }
  }

  initMap() {
    let mapResult = this.mapResult;
    let tileLayer = this.tileLayer;
    Promise.all([
      loadStyle(this, LEAFLET + "/leaflet.css"),
      loadScript(this, LEAFLET + "/leaflet.js"),
    ])
      .then(() => {
        this.template.querySelectorAll(
          "div"
        )[1].style.height = `${MAP_HEIGHT}px`;

        this.loadMarkerIcons();
        let container = this.template.querySelectorAll("div")[1];
        let map = L.map(container, {
          zoomControl: true,
          touchZoom: "center",
          tap: false,
        });

        tileLayer = L.tileLayer(
          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          {
            maxZoom: 20,
            subdomains: ["mt0", "mt1", "mt2", "mt3"],
            attribution:
              '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
          }
        );
        tileLayer.addTo(map);

        mapResult.map = map;

        this.drawMap();

        this.mapInitiated = true;
      })
      .catch((error) => {
        alert(
          "Error lib loading\nPlease contact your Administrator. trace : " +
            error
        );
      });
  }

  loadMarkerIcons() {
    this.siteMarkerIcon = L.icon({
      iconUrl: this.siteMarkerUrl,
      iconSize: [25, 41], // size of the icon
      iconAnchor: [12, 41], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -41], // point from which the popup should open relative to the iconAnchor
    });

    this.candidateMarkerIcon = L.icon({
      iconUrl: this.candidateMarkerUrl,
      iconSize: [25, 41], // size of the icon
      iconAnchor: [12, 41], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -41], // point from which the popup should open relative to the iconAnchor
    });

    this.defaultMarkerIcon = L.icon({
      iconUrl: this.defaultMarkerUrl,
      iconSize: [25, 41], // size of the icon
      iconAnchor: [12, 41], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -41], // point from which the popup should open relative to the iconAnchor
    });
  }

  addDraggableMarker(map, mapResult) {
    let lat = this.latitude;
    let lng = this.longitude;
    let currentLocationStatus = this.currentLocationStatus;
    let defaultMarkerIcon = this.defaultMarkerIcon;
    let siteRecord = this.siteRecord;

    const POPUPTEXTVAL = this.popupTextValue;
    const DRAGGABLE = this.draggable;
    console.log("DRAGGABLE:", DRAGGABLE);
    console.log(
      "addDraggableMarker() currentLocationStatus.fetchingLocation:",
      currentLocationStatus.fetchingLocation
    );
    if (lat == null && lng == null && !currentLocationStatus.fetchingLocation) {
      currentLocationStatus.fetchingLocation = true;
      console.log("Fetching current location.");
      map
        .locate({ setView: true, enableHighAccuracy: true, maximumAge: 10000 })
        .on("locationfound", function (e) {
          currentLocationStatus.fetchingLocation = false;
          console.log("Found current location.");
          console.log("Setting Current lat long to draggable marker.");
          mapResult.lat = e.latitude;
          mapResult.lng = e.longitude;
          map.setView([mapResult.lat, mapResult.lng], 18);

          let marker = getDraggableMarker(
            mapResult,
            DRAGGABLE,
            POPUPTEXTVAL,
            defaultMarkerIcon
          );

          marker.addTo(map);
          console.log("Added draggable marker:", marker);
        })
        .on("locationerror", function (e) {
          currentLocationStatus.fetchingLocation = false;
          console.log(
            "Could not access location\nPlease allow access to your location"
          );
          if (siteRecord) {
            console.log("Setting site lat lng for draggable marker.");
            const siteLatitude =
              Number(
                siteRecord.fields.sitetracker__Location__Latitude__s.value
              ) + 0.0001;
            const siteLongitude =
              Number(
                siteRecord.fields.sitetracker__Location__Longitude__s.value
              ) + 0.0001;
            console.log("Current Site Location:", siteLatitude, siteLongitude);
            mapResult.lat = siteLatitude;
            mapResult.lng = siteLongitude;
            map.setView([siteLatitude, siteLongitude], 18);

            let marker = getDraggableMarker(
              mapResult,
              DRAGGABLE,
              POPUPTEXTVAL,
              defaultMarkerIcon
            );
            marker.addTo(map);
            console.log("Added draggable marker:", marker);
          }
        });
    } else if (!currentLocationStatus.fetchingLocation) {
      console.log("Selected Lat Lng already exists.");
      map.setView([lat, lng], 18);

      mapResult.lat = lat;
      mapResult.lng = lng;

      let marker = getDraggableMarker(
        mapResult,
        DRAGGABLE,
        POPUPTEXTVAL,
        defaultMarkerIcon
      );
      marker.addTo(map);
      console.log("Added draggable marker:", marker);
    }
  }

  drawMap() {
    let mapResult = this.mapResult;

    let map = mapResult.map;

    // Add draggable Marker
    this.addDraggableMarker(map, mapResult);

    // Add Site Marker
    if (this.siteRecord) {
      const siteLatitude =
        this.siteRecord.fields.sitetracker__Location__Latitude__s.value;
      const siteLongitude =
        this.siteRecord.fields.sitetracker__Location__Longitude__s.value;
      const popupText = this.siteRecord.fields.Name.value;
      let siteId = this.siteRecord.id;
      console.log("siteId:", siteId);

      if (siteLatitude && siteLongitude) {
        console.log(
          "Add Site Marker: ",
          popupText,
          siteLatitude,
          siteLongitude
        );
        const marker = L.marker([siteLatitude, siteLongitude], {
          icon: this.siteMarkerIcon,
          zIndexOffset: SITE_ZINDEX,
        });
        const popup = `<a href="${siteId}">${popupText}</a>`;
        console.log("Site popup:", popup);
        marker.bindPopup(popup);

        marker.addTo(map);
      }
    }

    // Add Site Candidates Marker
    if (this.siteCandidates) {
      for (let siteCandidate of this.siteCandidates) {
        const siteCandidateLat =
          siteCandidate.sitetracker__Location__Latitude__s;
        const siteCandidateLong =
          siteCandidate.sitetracker__Location__Longitude__s;
        const popupText = siteCandidate.Name;
        // console.log(
        //   "Add Site Candidate Marker: ",
        //   popupText,
        //   siteCandidateLat,
        //   siteCandidateLong
        // );
        const marker = L.marker([siteCandidateLat, siteCandidateLong], {
          icon: this.candidateMarkerIcon,
          zIndexOffset: CANDIDATE_ZINDEX,
        });
        marker.bindPopup(popupText);
        marker.addTo(map);
      }
    }
  }

  refreshMap() {
    if (this.mapResult.map && this.siteRecord && this.siteCandidates) {
      //this.mapResult.map.off();
      //this.mapResult.map.remove();
      // Clear all layers
      this.mapResult.map.eachLayer((layer) => {
        if (!layer === this.tileLayer) {
          this.mapResult.map.removeLayer(layer);
        }
      });
      this.drawMap();
    }
  }

  searchUserLocation(event) {
    if (!this.showMap) {
      this.showMap = true;
      this.initMap();
    } else {
      this.mapResult.lat = null;
      this.mapResult.lng = null;
      this.refreshMap();
    }
  }
}