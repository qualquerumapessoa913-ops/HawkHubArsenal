-- ============================================================
-- GUN MODS – Rapid Fire + No Recoil
-- ============================================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GunMods = {}
GunMods.rapidFire = false
GunMods.noRecoil = false

-- Tenta setar um valor em qualquer campo (number ou object.Value)
local function trySet(obj, fieldName, value)
    pcall(function()
        local field = obj[fieldName]
        if field == nil then return end
        if typeof(field) == "number" then
            -- É um número direto (não dá pra modificar, pula)
            return
        end
        if typeof(field) == "Instance" then
            -- É um objeto (NumberValue, IntValue, etc)
            pcall(function() field.Value = value end)
        else
            -- Tenta atribuir direto
            pcall(function() obj[fieldName] = value end)
        end
    end)
end

function GunMods:start()
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                -- Rapid Fire
                if GunMods.rapidFire then
                    trySet(tool, "FireRate", 0.01)
                    trySet(tool, "FireDelay", 0.01)
                    trySet(tool, "RateOfFire", 0.01)
                    trySet(tool, "FireRateValue", 0.01)
                    trySet(tool, "FireDelayValue", 0.01)
                end

                -- No Recoil
                if GunMods.noRecoil then
                    trySet(tool, "Recoil", 0)
                    trySet(tool, "Kickback", 0)
                    trySet(tool, "RecoilValue", 0)
                    trySet(tool, "RecoilAmount", 0)
                    trySet(tool, "CameraRecoil", 0)

                    -- Também procura por NumberValues dentro da tool
                    pcall(function()
                        for _, v in ipairs(tool:GetDescendants()) do
                            if v:IsA("NumberValue") or v:IsA("IntValue") then
                                local lowerName = v.Name:lower()
                                if lowerName:find("recoil") or lowerName:find("kick") or lowerName:find("spread") then
                                    v.Value = 0
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)
end

return GunMods