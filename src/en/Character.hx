package en;

import h2d.Text;
import h3d.mat.Texture;

enum CharacterState {
    RESTING;
    CHARGING;
    RETURNING;
}

class Character extends Entity {
    public var stats: CharacterStats;
    public var state: CharacterState;

    var origin: {x: Float, y: Float};
    var center: {x: Float, y: Float};
    var direction: Int = 0;
    var speed = 2;
    var healthText: Text;

    public function new(x: Float, y: Float, image: Texture, stats: CharacterStats) {
        super(0, 0);
        setPosPixel(x, y);
        spr.setCenterRatio();
        origin = {x: (x + Main.ME.scene.width * .5) / 2, y: y};
        center = {x: Main.ME.scene.width * .5, y: Main.ME.scene.height * .25};
        direction = (origin.x - center.x < 0) ? 1 : -1;
        state = CHARGING;
        spr.setTexture(image);
        sprScaleX = sprScaleY = 1 / (hei / (Main.ME.scene.height * .03));
        this.stats = stats;
        createHealthText();
    }

    function createHealthText() {
        healthText = new Text(Assets.fontMedium, spr);
        healthText.setPosition(0, spr.getSize().height / 2 + 5);
        healthText.textColor = 0x00BB00;
        updateHealthText();
    }

    public function updateHealthText() {
        healthText.text = stats.health + "";
    }

    override function fixedUpdate() {
        super.fixedUpdate();
        if (state == CHARGING) {
            dx += direction * speed;
        }
        if (state == RETURNING) {
            dx += -direction * speed;
        }
    }

    public var readyToReturn = false;
    public var readyToCharge = false;
    override function update() {
        super.update();
        if (this == Game.ME.james) {
            readyToReturn = footX < center.x + 100;
            readyToCharge = footX > origin.x;
        } else {
            readyToReturn = footX > center.x - 100;
            readyToCharge = footX < origin.x;
        }
    }
}
