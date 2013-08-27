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

button.addEventListener("click", function() {
	
	Ti.API.info("Showing store for AppID: " + appID);

	TiStoreView.showStore(appID);

});

win.add(button);
win.open();