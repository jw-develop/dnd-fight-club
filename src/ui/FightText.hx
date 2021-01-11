package ui;

class FightText extends Flow {
    public static var ME: FightText;

    public function new(parent: Object) {
        ME = this;
        super(parent);
        layout = Vertical;
        horizontalAlign = Middle;
        minWidth = cast Main.ME.scene.width / 6;
    }

    public function addText(s: String, c: Int) {
        var t = new Text(Assets.fontLarge, this);
        t.text = s;
        t.textColor = c;
        addChildAt(t, 0);
        if (numChildren > 20) {
            removeChild(getChildAt(numChildren - 1));
        }
    }

    public function hit(c: Character, d: Int) {
        var hitTexts = [
            '${c.stats.name} just swung for the moon for ${d}.',
            'With an epic swing ${c.stats.name} dealt ${d}.',
            '${c.stats.name} roundhouse kicked for ${d}.',
            '${d} damage? ${c.stats.name} must be all out of bubble gum.',
        ];
        var i = Std.int(Math.random() * hitTexts.length);
        addText(hitTexts[i], 0xFF0000);
    }

    public function miss(c: Character) {
        var missTexts = [
            '${c.stats.name} just whiffed so bad.',
            'With an epic swing ${c.stats.name} dealt no damage at all.',
            '${c.stats.name} has had a bad day.',
            '${c.stats.name} is afraid of armour.',
            '${c.stats.name} dealt no damage, bruh.',
            '${c.stats.name} ... And uh, that\'s about it.',
            'A goat would do better than ${c.stats.name}.',
        ];
        var i = Std.int(Math.random() * missTexts.length);
        addText(missTexts[i], 0x00FFFFF);
    }
}