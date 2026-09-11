local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local Aimbot = {}
Aimbot.enabled = false
Aimbot.fov = 100
Aimbot.smoothness = 0.15
Aimbot.targetPart = "Head"

function Aimbot:getClosestEnemy()
    local closest = nil
    local closestDist = self.fov
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(self.targetPart)
            if part and part:IsA("BasePart") then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
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
        if not self.enabled then return end
        local target = self:getClosestEnemy()
        if target and target.Character then
            local part = target.Character:FindFirstChild(self.targetPart)
            if part then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, self.smoothness)
            end
        end
    end)
end

return Aimbot