local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local GunMods = {}
GunMods.rapidFire = false
GunMods.noRecoil = false

-- Modificação de armas
function GunMods:modifyTools()
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            -- Rapid Fire
            if self.rapidFire then
                pcall(function()
                    tool.FireRate = 0.01 -- Valor extremamente baixo para disparo rápido
                end)
            end
            -- No Recoil (remove a força de recuo)
            if self.noRecoil then
                pcall(function()
                    tool.Recoil = 0
                end)
            end
        end
    end
end

function GunMods:start()
    RunService.Heartbeat:Connect(function()
        self:modifyTools()
    end)
end

return GunMods