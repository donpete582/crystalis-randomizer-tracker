IMAGE_PATH = "minimal/images/"

function initCustomItems()
    local swordOfWind = SwordItem("Sword of Wind", "wind", "images/items/swordofwind.png", IMAGE_PATH .. "items/swordofwind_inactive.png",
        {"none","ballofwind","braceletofwind"})
    local swordOfFire = SwordItem("Sword of Fire", "fire", "images/items/swordoffire.png", IMAGE_PATH .. "items/swordoffire_inactive.png",
        {"none","balloffire","braceletoffire"})
    local swordOfWater = SwordItem("Sword of Water", "water", "images/items/swordofwater.png", IMAGE_PATH .. "items/swordofwater_inactive.png",
        {"none","ballofwater","braceletofwater"})
    local swordOfThunder = SwordItem("Sword of Thunder", "thunder", "images/items/thundernowarp.png", IMAGE_PATH .. "items/swordofthunder_inactive.png",
        {"none","ballofthunder","braceletofthunder"})

    local bossBadges = {"1_left.png", "2_right.png"}
    local kelbesque = DoubleStateItem("Kelbesque", "kelbesque", IMAGE_PATH .. "bosses/kelbesque.png", bossBadges)
    local sabera = DoubleStateItem("Sabera", "sabera", IMAGE_PATH .. "bosses/sabera.png", bossBadges)
    local mado = DoubleStateItem("Mado", "mado", IMAGE_PATH .. "bosses/mado.png", bossBadges)

    local bowBadges = {"moon.png", "sun.png"}
    local bowsOfSunAndMoon = DoubleStateItem("Bows of Sun and Moon", "sun_moon", IMAGE_PATH .. "items/bowofsunmoon.png", bowBadges)
end