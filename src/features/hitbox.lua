-- ============================================================
-- HEAD EXPANDER – Aumenta a hitbox da cabeça dos inimigos
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Hitbox = {}
Hitbox.enabled = false
Hitbox.size = 4
Hitbox.originalSizes = {}

local function expand(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end
    if not Hitbox.originalSizes[player] then
        Hitbox.originalSizes[player] = head.Size
    end
    local origSize = Hitbox.originalSizes[player]
    head.Size = Vector3.new(origSize.X * Hitbox.size, origSize.Y * Hitbox.size, origSize.Z * Hitbox.size)
    head.Transparency = 0.7
    head.CanCollide = false
    head.Massless = true
end

local function restore(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if head and Hitbox.originalSizes[player] then
        head.Size = Hitbox.originalSizes[player]
        head.Transparency = 0
        head.CanCollide = true
    end
end

function Hitbox:start()
    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if Hitbox.enabled then
                    expand(player)
                else
                    restore(player)
                end
            end
        end
    end)
end

return Hitbox