var TiStoreView = require('com.dezinezync.storeview');
var appID = "284910350";

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var button = Ti.UI.createButton({
	title: "Open Ap in AppStore"
});

TiStoreView.addEventListener('loading', function(e) {
	console.log(e);
});

TiStoreView.addEventListener('willshow', function(e) {
	console.log(e);
});

TiStoreView.addEventListener('willdimiss', function(e) {
	console.log(e);
});

TiStoreView.addEventListener('error', function(e) {
	console.log(e);
});

button.addEventListener("click", function() {
	
	Ti.API.info("Showing store for AppID: " + appID);

	TiStoreView.openProductDialog({
        'id': appID // SKStoreProductParameterITunesItemIdentifier
    });
});

win.add(button);
win.open();
