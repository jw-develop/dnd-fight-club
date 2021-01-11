package ui;

class UpperText extends Flow {
    public var ericText: Text;
    public var jamesText: Text;

    public function new(parent: Object) {
        super(parent);
        layout = Vertical;
        horizontalAlign = Middle;
        var upper = new Flow(this);
        var lower = new Flow(this);
        lower.horizontalAlign = Middle;
        lower.horizontalSpacing = cast Main.ME.scene.width * .02;
        setPosition(0, Main.ME.scene.height * .05);
        minWidth = cast 2 * Main.ME.scene.width / 3;
        setScale(1.5);
        
        var title = new Text(Assets.fontLarge, upper);
        title.textColor = 0xFF0000;
        title.text = "DND FIGHT CLUB";
        title.setScale(3);
        ericText = new Text(Assets.fontLarge, lower);
        ericText.textColor = Const.BASE_GREEN;
        jamesText = new Text(Assets.fontLarge, lower);
        jamesText.textColor = Const.BASE_GREEN;
    }

    public function updateText() {
        ericText.text = "Andoril: " + Game.ME.eric.stats.wins;
        jamesText.text = "Friedman: " + Game.ME.james.stats.wins;
    }
}