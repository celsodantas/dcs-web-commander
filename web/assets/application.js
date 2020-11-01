var mymap = L.map('theaterMap', {zoomSnap: 0, zoomDelta: 0.25, wheelPxPerZoomLevel: 220}).setView([43.05, 39.40], 7);

L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 12,
    minZoom: 7.5,
    id: 'celsodantas/ckgxw7aad1m1519msfaop1316',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: 'pk.eyJ1IjoiY2Vsc29kYW50YXMiLCJhIjoiY2tnNWk4ZWlpMGcyZzJ5bDdjZTU5c2IwdCJ9.1dK2LqeGzVzILLxUToadzg'
}).addTo(mymap);

// mymap.on("click", function (event) {
//   // TODO: send event to server with latlog info
//   // First step is to send a command to spawn aircrafts at this location
//   console.log(event)
// })

var exportData = null;
var markers = [];
var airports = [{
    name: 'Kobuleti',
    lat: 41.93,
    lon: 41.86444,
}, {
    name: 'Kutaisi',
    lat: 42.1775,
    lon: 42.48277,
}, {
    name: 'Batumi',
    lat: 41.6094,
    lon: 41.60027,
}, {
    name: 'Senaki-Kolkhi',
    lat: 42.24055,
    lon: 42.04833,
}];

$(function () {
    airports.forEach(function (airport) {
        // var icon = L.icon({ iconUrl: 'assets/airport-circle.png', iconSize: [25, 25] })
        var iconHtml =  `
            <div class="airportMarker"> 
                <img class="icon" src="assets/airport-circle.png"> 
                <div class="name">${airport.name}</div>
            </div> 
        `
        var icon = L.divIcon({className: 'airportIcon', html: iconHtml});
        
        var marker = L.marker([airport.lat, airport.lon], { icon: icon, zIndexOffset: -1 });
        marker.addTo(mymap);
    })

    var updateView = function (exportData) {
        markers.forEach(function (m) {
            mymap.removeLayer(m);
        });

        $.each(exportData.units, function (key, data) {
            if (data.isAir && !data.inAir) { return }
           
            var icon = null;
            
            if (data.isAir) 
            {
                if (data.coalition == 2) {
                    icon = L.icon({ iconUrl: 'assets/jet-blue.png', iconSize: [25, 25], className: "radarSignalIcon" })    
                } else {
                    icon = L.icon({ iconUrl: 'assets/jet-red.png', iconSize: [25, 25], className: "radarSignalIcon" })    
                }    
            } else {
                if (data.coalition == 2) {
                    icon = L.icon({ iconUrl: 'assets/dot-blue.png', iconSize: [12, 12], className: "radarSignalIcon" })    
                } else {
                    icon = L.icon({ iconUrl: 'assets/dot-red.png', iconSize: [12, 12], className: "radarSignalIcon" })    
                }    
            }
            
            // var icon = L.divIcon({className: 'radarSignalIcon', html: '&nbsp;'});
            var heading = data.heading - 90.0; // hack bc of the icon orientation is pointing RIGHT. TODO: fix the icon to point UP

            var markerOptions = { icon: icon, rotationAngle: heading }
            if (data.isAir) {
                markerOptions.zIndexOffset = 99999;
            }

            var marker = L.marker([data.lat, data.lon], markerOptions);

            marker.addTo(mymap);
            markers.push(marker)

            var unitInfoPopupTemplate = "";
            unitInfoPopupTemplate += "<p> callsign: "+ data.callsign +"</p>";
            unitInfoPopupTemplate += "<p> height: "+ data.height +"</p>";

            marker.bindPopup(unitInfoPopupTemplate)
        
        })
    }

    var fetchData = function () {
        $.get("/data/export.json?"+ $.now(), function (data) {
            exportData = data;
            updateView(exportData)
        });
    };

    fetchData();
    setInterval(fetchData, 2000);
})