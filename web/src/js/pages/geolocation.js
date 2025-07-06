document.addEventListener('DOMContentLoaded', function() {
    const locationDisplay = document.getElementById('location-display');

    if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(async (position) => {
            const latitude = position.coords.latitude;
            const longitude = position.coords.longitude;

            // Display raw coordinates initially
            locationDisplay.innerHTML = `Latitude: <strong>${latitude.toFixed(4)}</strong>, Longitude: <strong>${longitude.toFixed(4)}</strong><br>Finding address...`;

            try {
                // OpenStreetMap Nominatim API for reverse geocoding
                // Usage Policy: https://operations.osmfoundation.org/policies/nominatim/
                // IMPORTANT: Replace 'your-email@example.com' with an actual, unique email address
                // associated with your application for Nominatim's User-Agent policy.
                const nominatimUrl = `https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latitude}&lon=${longitude}`;
                
                const response = await fetch(nominatimUrl, {
                    headers: {
                        'User-Agent': 'StockVision-App/1.0 (your-email@example.com)' // <--- IMPORTANT: Update this!
                    }
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                
                const data = await response.json();
                
                if (data && data.address) {
                    const address = data.address;
                    let locationText = '';
                    // Prioritize more specific location details
                    if (address.city) locationText += address.city;
                    else if (address.town) locationText += address.town;
                    else if (address.village) locationText += address.village;
                    else if (address.hamlet) locationText += address.hamlet; // Smaller settlement
                    else if (address.suburb) locationText += address.suburb; // Suburb

                    if (address.state) locationText += `, ${address.state}`;
                    if (address.country) locationText += `, ${address.country}`;

                    if (locationText) {
                        locationDisplay.innerHTML = `You are near: <strong>${locationText}</strong>`;
                    } else {
                        locationDisplay.innerHTML = `Location detected (Lat: <strong>${latitude.toFixed(4)}</strong>, Lon: <strong>${longitude.toFixed(4)}</strong>). <br>Could not resolve a detailed address.`;
                    }
                } else {
                    locationDisplay.innerHTML = `Location detected (Lat: <strong>${latitude.toFixed(4)}</strong>, Lon: <strong>${longitude.toFixed(4)}</strong>). <br>No detailed address found.`;
                }

            } catch (error) {
                console.error('Error fetching address from Nominatim:', error);
                locationDisplay.innerHTML = `<span class="error-message">Error resolving address. Lat: <strong>${latitude.toFixed(4)}</strong>, Lon: <strong>${longitude.toFixed(4)}</strong>.</span>`;
            }

        }, (error) => {
            // Geolocation API error handling
            let errorMessage;
            switch(error.code) {
                case error.PERMISSION_DENIED:
                    errorMessage = "Location access denied. Please enable location services for this site.";
                    break;
                case error.POSITION_UNAVAILABLE:
                    errorMessage = "Location information is unavailable.";
                    break;
                case error.TIMEOUT:
                    errorMessage = "The request to get user location timed out. Please try again.";
                    break;
                case error.UNKNOWN_ERROR:
                    errorMessage = "An unknown error occurred while detecting your location.";
                    break;
                default:
                    errorMessage = "An unexpected error occurred.";
            }
            locationDisplay.innerHTML = `<span class="error-message">${errorMessage}</span>`;
            console.error('Geolocation Error:', error);
        }, {
            enableHighAccuracy: true, // Request more precise location
            timeout: 10000,           // 10 seconds timeout
            maximumAge: 0             // Don't use cached position, get fresh data
        });
    } else {
        locationDisplay.innerHTML = "<span class='error-message'>Geolocation is not supported by your browser.</span>";
    }
});