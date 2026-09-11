local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local AutoKill = {}
AutoKill.enabled = false

function AutoKill:getClosestEnemy()
    local closest = nil
    local closestDist = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

function AutoKill:killTarget(player)
    if not player or not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myHRP then
        -- Teleporta para trás do inimigo
        myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
        task.wait(0.1)
        -- Executa a ação de matar (simulada com um clique ou acionamento de ferramenta)
        -- ...
    end
end

function AutoKill:start()
    RunService.Heartbeat:Connect(function()
        if not self.enabled then return end
        local target = self:getClosestEnemy()
        if target then
            self:killTarget(target)
        end
    end)
end

return AutoKill