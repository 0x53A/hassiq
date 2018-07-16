using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class HassIQView extends Ui.View {
	var state;

	function initialize(state) {
		self.state = state;

		View.initialize();
	}

	function onLayout(dc) {
		onStateUpdated(state);

		requestUpdate();
	}

	function requestUpdate() {
		self.state.update(method(:onStateUpdated));
	}

	function onStateUpdated(state) {
		Ui.requestUpdate();
   	}

	function onUpdate(dc) {
		if (state.entities) {
			var size = state.entities.size();
			var layout = new [size];
			var count = 0;
			var height = dc.getHeight();
			var fontHeight = dc.getFontHeight(Gfx.FONT_TINY);

			// Only show as many entities as we have room for
			for(var i=0; i<size && (count*fontHeight)<height; ++i) {
				var entity = state.entities[i];
				var drawable = entity[:drawable];

				if (drawable == null) { continue; }

				layout[count] = drawable;
				count++;
			}

			for(var i=0; i<count; ++i) {
				layout[i].setLocation(Ui.LAYOUT_HALIGN_CENTER, (height / 2) + (-count * fontHeight / 2 + i * fontHeight));
			}

			setLayout(layout.slice(0,count));
		} else {
			var error = new WatchUi.Text({
				:text => "Status:" + state.status,
				:color => Graphics.COLOR_WHITE,
				:font => Graphics.FONT_LARGE,
				:locX => WatchUi.LAYOUT_HALIGN_CENTER,
				:locY => WatchUi.LAYOUT_VALIGN_CENTER
			});
			setLayout([error]);
		}

		View.onUpdate(dc);

		/* Selected is fairly meaningless now that we always go to the menu upon action press
		if (state.selected != null) {
			var drawable = state.selected[:drawable];
			var x = (dc.getWidth() - drawable.width)/2;
   			var y = drawable.locY;
			dc.drawRectangle(x, y, drawable.width, drawable.height);
		}
		*/

		var color = Gfx.COLOR_YELLOW;
		if (state.status != 0) {
			if (state.status == 200) {
				color = Gfx.COLOR_GREEN;
			} else {
				color = Gfx.COLOR_RED;
			}
		}
		dc.setColor(color, color);
		dc.fillRectangle(0, dc.getHeight() - 4, dc.getWidth(), 4);
	}
}
