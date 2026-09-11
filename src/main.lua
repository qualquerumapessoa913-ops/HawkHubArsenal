-- ============================================================
-- HAWK HUB ARSENAL – MAIN
-- ============================================================
local UserInputService = game:GetService("UserInputService")

local UI = require(script.Parent.ui)
local Aimbot = require(script.Parent.features.aimbot)
local Hitbox = require(script.Parent.features.hitbox)
local ESP = require(script.Parent.features.esp)
local AutoKill = require(script.Parent.features.autokill)
local GunMods = require(script.Parent.features.gunmods)
local Backstab = require(script.Parent.features.backstab)

local Settings = {
    uiScale = 1,
    resizeKeybind = Enum.KeyCode.K,
    minimizeKeybind = Enum.KeyCode.M,
}

Aimbot:start()
Hitbox:start()
ESP:start()
AutoKill:start()
GunMods:start()
Backstab:start()

local Window = UI.new({
    Name = "HAWK HUB",
    Subtitle = "Arsenal Edition"
})

-- COMBAT
local CombatTab = Window:CreateTab({ name = "Combat", icon = "⚔️" })

Window:CreateSection(CombatTab, "Aimbot (Silent)")
Window:CreateToggle(CombatTab, {
    name = "Aimbot (Silent)",
    currentValue = false,
    callback = function(v) Aimbot.enabled = v end
})
Window:CreateSlider(CombatTab, {
    name = "Aimbot FOV",
    min = 20, max = 400, currentValue = 120,
    callback = function(v) Aimbot.fov = v end
})
Window:CreateToggle(CombatTab, {
    name = "Mostrar FOV Circle",
    currentValue = true,
    callback = function(v) Aimbot.showFov = v end
})
Window:CreateDropdown(CombatTab, {
    name = "Aim Part",
    options = {"Head", "UpperTorso", "HumanoidRootPart"},
    currentOption = "Head",
    callback = function(v) Aimbot.targetPart = v end
})

Window:CreateSection(CombatTab, "Combat Extras")
Window:CreateToggle(CombatTab, {
    name = "Head Expander",
    currentValue = false,
    callback = function(v) Hitbox.enabled = v end
})
Window:CreateSlider(CombatTab, {
    name = "Head Size Multiplier",
    min = 1, max = 10, currentValue = 4,
    callback = function(v) Hitbox.size = v end
})
Window:CreateToggle(CombatTab, {
    name = "Backstab (Press E)",
    currentValue = false,
    callback = function(v) Backstab.enabled = v end
})
Window:CreateToggle(CombatTab, {
    name = "Auto Kill",
    currentValue = false,
    callback = function(v) AutoKill.enabled = v end
})
Window:CreateSlider(CombatTab, {
    name = "Auto Kill Range",
    min = 10, max = 500, currentValue = 100,
    callback = function(v) AutoKill.range = v end
})

-- VISUALS
local VisualsTab = Window:CreateTab({ name = "Visuals", icon = "👁️" })
Window:CreateSection(VisualsTab, "ESP")
Window:CreateToggle(VisualsTab, {
    name = "ESP (Enemies Only)",
    currentValue = false,
    callback = function(v) ESP.enabled = v end
})

-- WEAPON
local WeaponTab = Window:CreateTab({ name = "Weapon", icon = "🔫" })
Window:CreateSection(WeaponTab, "Gun Mods")
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

-- SETTINGS
local SettingsTab = Window:CreateTab({ name = "Settings", icon = "⚙️" })
Window:CreateSection(SettingsTab, "Interface")

local resizeLabel = Window:CreateLabel(SettingsTab, { text = "Resize Keybind: K" })
local minimizeLabel = Window:CreateLabel(SettingsTab, { text = "Minimize Keybind: M" })

Window:CreateButton(SettingsTab, {
    name = "Change Resize Keybind",
    callback = function()
        Window:Notify("Hawk Hub", "Pressione qualquer tecla...", 3)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Settings.resizeKeybind = input.KeyCode
                resizeLabel.Text = "Resize Keybind: " .. input.KeyCode.Name
                conn:Disconnect()
                Window:Notify("Hawk Hub", "Resize: " .. input.KeyCode.Name, 2)
            end
        end)
    end
})

Window:CreateButton(SettingsTab, {
    name = "Change Minimize Keybind",
    callback = function()
        Window:Notify("Hawk Hub", "Pressione qualquer tecla...", 3)
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Settings.minimizeKeybind = input.KeyCode
                minimizeLabel.Text = "Minimize Keybind: " .. input.KeyCode.Name
                conn:Disconnect()
                Window:Notify("Hawk Hub", "Minimize: " .. input.KeyCode.Name, 2)
            end
        end)
    end
})

Window:CreateButton(SettingsTab, {
    name = "Reset Keybinds (K / M)",
    callback = function()
        Settings.resizeKeybind = Enum.KeyCode.K
        Settings.minimizeKeybind = Enum.KeyCode.M
        resizeLabel.Text = "Resize Keybind: K"
        minimizeLabel.Text = "Minimize Keybind: M"
        Window:Notify("Hawk Hub", "Keybinds resetados", 2)
    end
})

Window:CreateSection(SettingsTab, "Info")
Window:CreateLabel(SettingsTab, { text = "K = Redimensionar UI" })
Window:CreateLabel(SettingsTab, { text = "M = Minimizar UI" })
Window:CreateLabel(SettingsTab, { text = "E = Backstab (se ativo)" })
Window:CreateLabel(SettingsTab, { text = "⚠ Use em conta alternativa!", color = Color3.fromRGB(255, 180, 60) })

-- KEYBINDS
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Settings.resizeKeybind then
        Settings.uiScale = (Settings.uiScale == 1) and 1.4 or 1
        Window:SetScale(Settings.uiScale)
    end
    if input.KeyCode == Settings.minimizeKeybind then
        Window:ToggleMinimize()
    end
end)

task.wait(0.5)
Window:Notify("Hawk Hub", "Arsenal Edition carregado!", 3)

print("[Hawk Hub] Arsenal Edition carregado!")