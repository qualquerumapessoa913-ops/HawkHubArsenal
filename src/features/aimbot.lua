-- ============================================================
-- AIMBOT (LEGIT) – Mira suave no Head do inimigo
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Aimbot = {}
Aimbot.enabled = false
Aimbot.fov = 120
Aimbot.smoothness = 0.18
Aimbot.visibleCheck = false
Aimbot.wallCheck = false
Aimbot.targetPart = "Head"

local function getClosestEnemy()
    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
    local closest, closestDist = nil, Aimbot.fov
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild(Aimbot.targetPart) or player.Character:FindFirstChild("Head")
            if head then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

function Aimbot:start()
    RunService.RenderStepped:Connect(function()
        if not Aimbot.enabled then return end
        local target = getClosestEnemy()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                local goal = CFrame.new(Camera.CFrame.Position, head.Position)
                Camera.CFrame = Camera.CFrame:Lerp(goal, Aimbot.smoothness)
            end
        end
    end)
end

return Aimbot