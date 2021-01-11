package en;

typedef CharacterStats = {
    name: String,
    initiative: Int,
    health: Int,
    maxHealth: Int,
    toHit: Int,
    damage: () -> Int,
    armorClass: Int,
    wins: Int,
    hits: Int,
    attempts: Int,
    damageDealt: Int,
    initWins: Int
}