import h2d.Bitmap;
import h2d.Scene;
import h2d.col.Bounds;
import h3d.scene.Graphics;
import hxd.Math;
import h2d.Graphics;


class Background extends h2d.Layers {
    public static var ME: Background;
    var spr: HSprite;
    var scene: Scene;
    public var bounds: Bounds;

    public function new() {
        ME = this;
        scene = Main.ME.scene;
        super();
        spr = new HSprite();
        Game.ME.scroller.add(spr, Const.DP_BG);
        spr.setTexture(Assets.background);
        var wid = scene.width * 2;
        spr.setScale(wid / spr.getSize().width);
        spr.setPosition(-Main.ME.scene.width, -Main.ME.scene.height);
        spr.alpha = .3;
        dirs = [Rand.list([-1,1]), Rand.list([-1,1])];
        bounds = new Bounds();
        bounds.set(-Main.ME.scene.width, -Main.ME.scene.height * 2, Main.ME.scene.width * .25, Main.ME.scene.height * .25);
    }

	var dirs: Array<Int>;
	public function fixedUpdate() {
		if (spr.x < bounds.xMin + 10) dirs[0] = 1;
		if (spr.y < bounds.yMin + 10) dirs[1] = 1;
		if (spr.x > bounds.xMax - 10) dirs[0] = -1;
        if (spr.y > bounds.yMax - 10) dirs[1] = -1;
		spr.x += dirs[0] * 5;
        spr.y += dirs[1] * 5;
	}
}