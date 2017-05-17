using Toybox.Application as App;

class HassIQApp extends App.AppBase {
	var state = new HassIQState();
	var view;
	var delegate;
	var host = "home:8123";

	function initialize() {
		AppBase.initialize();
	}

	function onStart(state) {
		self.state.load(getProperty("state"));

		var selected = getProperty("selected");
		if (selected != null) {
			for (var i=0; i<self.state.entities.size(); ++i) {
				if (self.state.entities[i][:entity_id].equals(selected)) {
					self.state.selected = self.state.entities[i];
					break;
				}
			}
		}

		onSettingsChanged();
	}

	// onStop() is called when your application is exiting
	function onStop(state) {
		setProperty("state", self.state.save());

		var selected = null;
		if (self.state.selected != null) {
			selected = self.state.selected[:entity_id];
		}
		setProperty("selected", selected);
	}

	function onSettingsChanged() {
		state.setHost(host ? host : getProperty("host"));
	}

	function getInitialView() {
		view = new HassIQView(state);
		delegate = new HassIQDelegate(state);
		
		onSettingsChanged();
		
		return [ view, delegate ];
	}
}
