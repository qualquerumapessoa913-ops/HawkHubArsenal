local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local ESP = {}
ESP.enabled = false
ESP.highlights = {}

function ESP:addHighlight(player)
    if not player.Character or self.highlights[player] then return end
    local h = Instance.new("Highlight")
    h.Adornee = player.Character
    h.FillColor = Color3.fromRGB(255, 60, 60) -- Vermelho para inimigos
    h.FillTransparency = 0.5
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0
    h.Parent = player.Character
    self.highlights[player] = h
end

function ESP:removeHighlight(player)
    if self.highlights[player] then
        self.highlights[player]:Destroy()
        self.highlights[player] = nil
    end
end

function ESP:update()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Verifica se é um inimigo (time diferente)
            if player.Team ~= LocalPlayer.Team then
                if self.enabled then
                    self:addHighlight(player)
                else
                    self:removeHighlight(player)
                end
            else
                -- Remove o ESP se for do mesmo time
                self:removeHighlight(player)
            end
        end
    end
end

function ESP:start()
    RunService.Heartbeat:Connect(function()
        self:update()
    end)
end

return ESP