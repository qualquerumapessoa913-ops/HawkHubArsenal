local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local Hitbox = {}
Hitbox.enabled = false
Hitbox.size = 5 -- Multiplicador de tamanho

function Hitbox:expandPlayer(player)
    if not player.Character or player == LocalPlayer then return end
    local head = player.Character:FindFirstChild("Head")
    if head and not head:FindFirstChild("HitboxExpander") then
        -- Aumenta o tamanho da hitbox da cabeça
        local originalSize = head.Size
        head.Size = originalSize * self.size
        -- Marca para não expandir novamente
        local marker = Instance.new("BoolValue", head)
        marker.Name = "HitboxExpander"
    end
end

function Hitbox:restorePlayer(player)
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if head and head:FindFirstChild("HitboxExpander") then
        local marker = head:FindChild("HitboxExpander")
        -- Restaura o tamanho original (a lógica exata depende de como o jogo gerencia a hitbox)
        marker:Destroy()
    end
end

function Hitbox:start()
    RunService.Heartbeat:Connect(function()
        if not self.enabled then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                self:expandPlayer(player)
            end
        end
    end)
end

return Hitbox