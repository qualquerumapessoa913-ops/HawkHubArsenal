-- MAIN - TEST HAWK ARSENAL EDITION

local UI = require(script.Parent.ui)
local Aimbot = require(script.Parent.features.aimbot)
local SilentAim = require(script.Parent.features.silentaim)
local Hitbox = require(script.Parent.features.hitbox)
local ESP = require(script.Parent.features.esp)
local AutoKill = require(script.Parent.features.autokill)
local GunMods = require(script.Parent.features.gunmods)
local Backstab = require(script.Parent.features.backstab)

-- Inicia as features
Aimbot:start()
SilentAim:start()
Hitbox:start()
ESP:start()
AutoKill:start()
GunMods:start()
Backstab:start()

-- Cria a Interface
local Window = UI.new({
    Name = "TEST HAWK",
    Subtitle = "Arsenal Edition"
})

-- Aba COMBAT
local CombatTab = Window:CreateTab({ name = "Combat", icon = "⚔️" })
Window:CreateSection(CombatTab, "Aim")
Window:CreateToggle(CombatTab, {
    name = "Aimbot (Legit)",
    currentValue = false,
    callback = function(v) Aimbot.enabled = v end
})
Window:CreateSlider(CombatTab, {
    name = "FOV",
    min = 20, max = 400, currentValue = 100,
    callback = function(v) Aimbot.fov = v end
})
Window:CreateSlider(CombatTab, {
    name = "Smoothness",
    min = 0, max = 100, currentValue = 15,
    callback = function(v) Aimbot.smoothness = v / 100 end
})
Window:CreateDropdown(CombatTab, {
    name = "Target Part",
    options = {"Head", "UpperTorso", "HumanoidRootPart"},
    callback = function(v) Aimbot.targetPart = v end
})
Window:CreateToggle(CombatTab, {
    name = "Silent Aim",
    currentValue = false,
    callback = function(v) SilentAim.enabled = v end
})
Window:CreateToggle(CombatTab, {
    name = "Hitbox Expander",
    currentValue = false,
    callback = function(v) Hitbox.enabled = v end
})
Window:CreateSlider(CombatTab, {
    name = "Hitbox Size",
    min = 1, max = 10, currentValue = 3,
    callback = function(v) Hitbox.size = v end
})
Window:CreateToggle(CombatTab, {
    name = "Backstab",
    currentValue = false,
    callback = function(v) Backstab.enabled = v end
})
Window:CreateToggle(CombatTab, {
    name = "Auto Kill",
    currentValue = false,
    callback = function(v) AutoKill.enabled = v end
})

-- Aba VISUALS
local VisualsTab = Window:CreateTab({ name = "Visuals", icon = "👁️" })
Window:CreateToggle(VisualsTab, {
    name = "ESP (Enemies Only)",
    currentValue = false,
    callback = function(v) ESP.enabled = v end
})

-- Aba WEAPON
local WeaponTab = Window:CreateTab({ name = "Weapon", icon = "🔫" })
Window:CreateToggle(WeaponTab, {
    name = "Rapid Fire",
    currentValue = false,
    callback = function(v) GunMods.rapidFire = v end
})
Window:CreateToggle(WeaponTab, {
    name = "No Recoil",
    currentValue = false,
    callback = function(v) GunMods.noRecoil = v end
})

-- Notificação de boas-vindas
task.wait(0.5)
Window:Notify("Test Hawk", "Arsenal Edition carregado!", 3)

print("[Test Hawk] Arsenal Edition carregado com sucesso!")