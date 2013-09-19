var TiStoreView = require('com.dezinezync.storeview');
Ti.API.info("module is => " + TiStoreView);

// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var appID = "284910350";

var button = Ti.UI.createButton({
	title: "Open App"
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

	TiStoreView.showStore(appID);

});

win.add(button);
win.open();