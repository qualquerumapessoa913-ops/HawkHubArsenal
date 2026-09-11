-- ============================================================
-- GUN MODS – Rapid Fire + No Recoil (SEM auto-fire)
-- ============================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GunMods = {}
GunMods.rapidFire = false
GunMods.noRecoil = false

local FIRE_FIELDS = {"FireRate", "FireDelay", "RateOfFire"}

local function setField(tool, field, value)
    pcall(function()
        local prop = tool[field]
        if prop == nil then return end
        if typeof(prop) == "number" then
            -- ignorado
        elseif typeof(prop) == "Instance" then
            pcall(function() prop.Value = value end)
        end
    end)
end

local modified = {}

function GunMods:start()
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")

        if not tool then
            modified = {}
            return
        end

        local key = tool
        if not modified[key] then
            modified[key] = {rapid = false, recoil = false}
        end

        if GunMods.rapidFire and not modified[key].rapid then
            for _, field in ipairs(FIRE_FIELDS) do
                setField(tool, field, 0.03)
            end
            modified[key].rapid = true
        elseif not GunMods.rapidFire and modified[key].rapid then
            modified[key].rapid = false
        end

        if GunMods.noRecoil and not modified[key].recoil then
            pcall(function()
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local n = v.Name:lower()
                        if n:find("recoil") or n:find("kick") or n:find("spread") then
                            v.Value = 0
                        end
                    end
                end
            end)
            modified[key].recoil = true
        elseif not GunMods.noRecoil and modified[key].recoil then
            modified[key].recoil = false
        end
    end)
end

return GunMods