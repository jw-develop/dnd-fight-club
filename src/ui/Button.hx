package ui;

import h2d.Font;
import h2d.Tile;
import hxd.Res;
import h2d.Interactive;
import h2d.Flow;

class Button {
    private var interactive: Interactive;
    private var textObj: h2d.Text;
    public var flow: Flow;

    public function new(text: String, flow: Flow, ?onClick: (e : hxd.Event) -> Void) {
        textObj = new h2d.Text(Assets.fontLarge, flow);
		textObj.text = text;
        textObj.textColor = Const.BASE_GREEN;
        this.flow = flow;
        flow.padding = 10;
        if (flow.enableInteractive == true) {
            interactive = flow.interactive;
            interactive.cursor = Button;
        } else {
            interactive = new Interactive(textObj.calcTextWidth(text), textObj.textHeight, textObj);
        }
        interactive.onClick = (e: hxd.Event) -> {
            // Res.audio.blip1.play(.5);
            onClick(e);
        }
        interactive.onOver = (e) -> {
            textObj.textColor = Const.UI_BUTTON_HOVER_COLOR;
        }
        interactive.onOut = (e) -> {
            textObj.textColor = Const.BASE_GREEN;
        }
    }

    public function addHover(onHover: (e : hxd.Event) -> Void) {
        interactive.onOver = onHover;
    }

    public function setColor(c: Int) {
        textObj.textColor = c;
    }

    public function setText(t: String) {
        textObj.text = t;
        interactive.width = textObj.calcTextWidth(t);
    }

    public function setFont(f: Font) {
        textObj.font = f;
    }

    public function getText() {
        return textObj.text;
    }
}
