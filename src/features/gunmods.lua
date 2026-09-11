-- ============================================================
-- GUN MODS – Rapid Fire + No Recoil (CORRIGIDO)
-- ============================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GunMods = {}
GunMods.rapidFire = false
GunMods.noRecoil = false

local function trySet(obj, fieldName, value)
    pcall(function()
        local field = obj[fieldName]
        if field == nil then return end
        if typeof(field) == "number" then
            -- número direto, não modifica
            obj[fieldName] = value
        elseif typeof(field) == "Instance" then
            pcall(function() field.Value = value end)
        end
    end)
end

local lastToolModified = nil
local lastFireRate = nil

function GunMods:start()
    -- Só aplica modificação quando trocar de tool (evita spam)
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool ~= lastToolModified then
            lastToolModified = currentTool
            lastFireRate = nil
        end

        if not currentTool then return end

        if GunMods.rapidFire then
            if lastFireRate ~= 0.01 then
                lastFireRate = 0.01
                trySet(currentTool, "FireRate", 0.01)
                trySet(currentTool, "FireDelay", 0.01)
                trySet(currentTool, "RateOfFire", 0.01)
                trySet(currentTool, "FireRateValue", 0.01)
                trySet(currentTool, "FireDelayValue", 0.01)
                trySet(currentTool, "Cooldown", 0.01)
            end
        else
            lastFireRate = nil
        end

        if GunMods.noRecoil then
            pcall(function()
                for _, v in ipairs(currentTool:GetDescendants()) do
                    if v:IsA("NumberValue") or v:IsA("IntValue") then
                        local lowerName = v.Name:lower()
                        if lowerName:find("recoil") or lowerName:find("kick") or lowerName:find("spread") then
                            v.Value = 0
                        end
                    end
                end
            end)
        end
    end)
end

return GunMods