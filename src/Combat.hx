import hxd.Res;
import ui.FightText;
import en.Character.CharacterState;


enum CombatState {
    FIGHTING;
    COMPLETE;
}

class Combat {
    public static var ME: Combat;
    public var state: CombatState;
    public var fightCount = 0;

    var chars: Array<Character>;
    var attackingIndex: Int;
    var att: Character;
    var def: Character;
    
    public function new(combatants: Array<Character>) {
        ME = this;
        chars = combatants;
    }

    public function init() {
        setStates(CHARGING);
        attackingIndex = 1;
        changeAttacker();
        startFight();
    }

    function changeAttacker() {
        def = chars[attackingIndex];
        attackingIndex = (attackingIndex + 1) % 2;
        att = chars[attackingIndex];
    }

    function setStates(s: CharacterState) {
        for (c in chars) c.state = s;
    }

    function reset() {
        setStates(RESTING);
        state = COMPLETE;
        att.stats.wins += 1;
        Game.ME.upperText.updateText();
        Game.ME.delayer.addS("between-fights", () -> {
            startFight();
        }, 2);
        Game.ME.ericText.reset();
        Game.ME.ericText.refresh();
        Game.ME.jamesText.reset();
        Game.ME.jamesText.refresh();
    }

    function prepare() {
        if (att.stats.health <= 0 || def.stats.health <= 0) {
            reset();
        } else {
            changeAttacker();
            setStates(CHARGING);
        }
        att.cancelVelocities();
        def.cancelVelocities();
    }

    function d20(modifier: Int) {
        return Std.int(Math.random() * 20) + modifier;
    }

    function clash() {
        att.stats.attempts += 1;
        if (d20(att.stats.toHit) > def.stats.armorClass) {
            var d = att.stats.damage();
            att.stats.damageDealt += d;
            att.stats.hits += 1;
            def.stats.health = Std.int(Math.max(def.stats.health - d, 0));
            def.updateHealthText();
            Game.ME.ericText.refresh();
            Game.ME.jamesText.refresh();
            FightText.ME.hit(att, d);
        } else {
            FightText.ME.miss(att);
        }
        setStates(RETURNING);
        att.cancelVelocities();
        def.cancelVelocities();
        punchSfx();
    }

    function punchSfx() {
        var x = Math.random();
        if (x < .02) {
            Res.sfx.bleat.play(.5);
        }
        var fxList = [
            Res.sfx.punch0,
            Res.sfx.punch1,
            Res.sfx.punch2,
            Res.sfx.punch3,
            Res.sfx.slap,
        ];
        fxList[Std.int(x * fxList.length)].play();
    }

    public function fixedUpdate() {}

    function initiativeRoll() {
        att = Game.ME.eric;
        def = Game.ME.james;
        attackingIndex = 0;
        var inits = [0, 0];
        while (inits[0] == inits[1]) {
            inits = [d20(Game.ME.james.stats.initiative), d20(Game.ME.eric.stats.initiative)];
        }
        if (inits[0] > inits[1]) {
            changeAttacker();
        }
        FightText.ME.addText('   ', 0x00FFFFf);
        FightText.ME.addText('${att.stats.name} has won initiative.', 0xFFFF00);
    }

    function startFight() {
        state = FIGHTING;
        att.stats.initWins++;
        fightCount++;
        initiativeRoll();
        for (c in chars) {
            c.stats.health = c.stats.maxHealth;
            c.state = CHARGING;
            c.updateHealthText();
        }
        if (Game.ME.ericText != null) {
            Game.ME.ericText.refresh();
            Game.ME.jamesText.refresh();
        }
    }

    public function update() {
        if (state == FIGHTING) {
            if (att.readyToCharge && att.state == RETURNING) {
                prepare();
            }
            if (att.readyToReturn && att.state == CHARGING) {
                clash();
            }
        }
    }
}
