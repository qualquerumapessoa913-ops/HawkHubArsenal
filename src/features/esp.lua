-- ============================================================
-- ESP – Apenas inimigos
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESP = {}
ESP.enabled = false
ESP.data = {}

local function createESP(player)
    if ESP.data[player] then return end
    if not player.Character then return end
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = player.Character
    highlight.FillColor = Color3.fromRGB(255, 60, 60)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Parent = player.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HawkESP"
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Parent = player.Character

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.fromScale(1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    nameLabel.TextSize = 14
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = billboard

    ESP.data[player] = {highlight = highlight, billboard = billboard}
end

local function removeESP(player)
    local d = ESP.data[player]
    if d then
        if d.highlight then d.highlight:Destroy() end
        if d.billboard then d.billboard:Destroy() end
        ESP.data[player] = nil
    end
end

function ESP:start()
    RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
                if ESP.enabled then
                    createESP(player)
                    local d = ESP.data[player]
                    if d and d.billboard then
                        local head = player.Character:FindFirstChild("Head")
                        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if head and myHRP then
                            local dist = math.floor((head.Position - myHRP.Position).Magnitude)
                            local label = d.billboard:FindFirstChildOfClass("TextLabel")
                            if label then
                                label.Text = player.Name .. " [" .. dist .. "m]"
                            end
                        end
                    end
                else
                    removeESP(player)
                end
            else
                removeESP(player)
            end
        end
    end)
end

return ESP