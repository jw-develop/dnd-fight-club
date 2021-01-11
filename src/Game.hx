import hxd.Res;
import ui.CharText;
import ui.UpperText;
import ui.FightText;
import dn.Process;
import hxd.Key;

class Game extends Process {
	public static var ME : Game;

	public var ca : dn.heaps.Controller.ControllerAccess;
	public var fx : Fx;
	public var camera : Camera;
	public var scroller : h2d.Layers;
	public var hud : ui.Hud;
	public var f: Flow;

	public var eric: Character;
	public var james: Character;
	public var fightText: FightText;
	public var ericText: CharText;
	public var jamesText: CharText;
	public var fightsQueued: Int;
	public var upperText: UpperText;

	public function new() {
		super(Main.ME);
		ME = this;
		ca = Main.ME.controller.createAccess("game");
		ca.setLeftDeadZone(0.2);
		ca.setRightDeadZone(0.2);
		createRootInLayers(Main.ME.root, Const.DP_BG);

		scroller = new h2d.Layers();
		root.add(scroller, Const.DP_BG);
		scroller.filter = new h2d.filter.ColorMatrix(); // force rendering for pixel perfect

		camera = new Camera();
		fx = new Fx();
		hud = new ui.Hud();

		f = new Flow(root);
		f.fillWidth = true;
		f.horizontalAlign = Middle;
		f.horizontalSpacing = 600;
		Process.resizeAll();

		new Background();

		var ericStats = {
			name: "Andoril",
			initiative: 3,
			maxHealth: 25,
			health: 25,
			toHit: 5,
			damage: () -> Std.int(Math.random() * 8) + 3,
			armorClass: 16,
			wins: 0,
			hits: 0,
			attempts: 0,
			damageDealt: 0,
			initWins: 0
		}

		var jamesStats = {
			name: "Friedman",
			initiative: 1,
			maxHealth: 25,
			health: 22,
			toHit: 4,
			damage: () -> Std.int(Math.random() * 6) + Std.int(Math.random() * 6) + 2,
			armorClass: 16,
			wins: 0,
			hits: 0,
			attempts: 0,
			damageDealt: 0,
			initWins: 0
		}

		var jamesC = [Main.ME.scene.width * .8, Main.ME.scene.height * .35];
		var ericC = [Main.ME.scene.width * .2, Main.ME.scene.height * .35];
		james = new Character(jamesC[0], jamesC[1], Assets.james, jamesStats);
		eric = new Character(ericC[0], ericC[1], Assets.eric, ericStats);

		var lowerFlow = new Flow(root);
		lowerFlow.setPosition(0, Main.ME.scene.height * .55);
		lowerFlow.minHeight = cast Main.ME.scene.height * .65;
		lowerFlow.minWidth = Main.ME.scene.width;
		lowerFlow.verticalAlign = Top;
		lowerFlow.horizontalAlign = Middle;
		
		ericText = new CharText(lowerFlow, eric);
		var c = new Combat([eric, james]);
		fightText = new FightText(lowerFlow);
		ericText.refresh();
		jamesText = new CharText(lowerFlow, james);
		jamesText.refresh();

		upperText = new UpperText(root);
		upperText.updateText();
		delayer.addS("before-start", () -> {
			c.init();
		}, 3);
		Res.sfx.bleat.play(.5);
	}

	public function onCdbReload() {}

	override function onResize() {
		super.onResize();
		scroller.setScale(Const.SCALE);
	}

	function gc() {
		if( Entity.GC==null || Entity.GC.length==0 )
			return;

		for(e in Entity.GC)
			e.dispose();
		Entity.GC = [];
	}

	override function onDispose() {
		super.onDispose();

		fx.destroy();
		for(e in Entity.ALL)
			e.destroy();
		gc();
	}

	override function preUpdate() {
		super.preUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.preUpdate();
	}

	override function postUpdate() {
		super.postUpdate();

		for(e in Entity.ALL) if( !e.destroyed ) e.postUpdate();
		gc();
	}

	override function fixedUpdate() {
		super.fixedUpdate();

		Background.ME.fixedUpdate();
		for(e in Entity.ALL) if( !e.destroyed ) e.fixedUpdate();
	}

	override function update() {
		super.update();

		Combat.ME.update();
		for(e in Entity.ALL) if( !e.destroyed ) e.update();

		if( !ui.Console.ME.isActive() && !ui.Modal.hasAny() ) {
			#if hl
			// Exit
			if( ca.isKeyboardPressed(Key.ESCAPE) )
				if( !cd.hasSetS("exitWarn",3) )
					trace(Lang.t._("Press ESCAPE again to exit."));
				else
					hxd.System.exit();
			#end

			// Restart
			if( ca.selectPressed() )
				Main.ME.startGame();
		}
	}
}

