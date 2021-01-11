package ui;

class CharText extends Flow {
    var texts = [];
    var c: Character;
    var s: CharacterStats;

    public function new(parent: Object, c: Character) {
        super(parent);
        layout = Vertical;
        horizontalAlign = Middle;
        verticalAlign = Top;
        paddingHorizontal = cast Main.ME.scene.width / 100;
        for (i in 0...10) {
            addText();
        }
        this.c = c;
        this.s = c.stats;
        texts[0].textColor = 0xFF0000;
        texts[1].textColor = 0xFFFF00;
    }

    function addText() {
        var t = new Text(Assets.fontLarge, this);
        texts.push(t);
    }

    public function refresh() {
        var avgDamage = Std.int(s.damageDealt / s.hits * 100) / 100;
        texts[0].text = 'Average damage per hit: ${avgDamage}';
        var initWins = Std.int(s.initWins / Combat.ME.fightCount * 100);
        texts[1].text = 'Initiative %: ${initWins}%';
        var accuracy = Std.int(s.hits / s.attempts * 100);
        texts[2].text = 'Accuracy: ${accuracy}%';
    }

    public function reset() {

    }
}