-- ============================================================
-- AUTO KILL – Teleporta atrás e executa
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local AutoKill = {}
AutoKill.enabled = false
AutoKill.range = 100

local function getWeapon()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then return tool end
    end
    return nil
end

local function killTarget(player)
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myHRP then
        myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
        task.wait(0.05)
        local tool = getWeapon()
        if tool then
            pcall(function() tool:Activate() end)
        end
        pcall(function()
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        pcall(mouse1click)
    end
end

function AutoKill:start()
    RunService.Heartbeat:Connect(function()
        if not AutoKill.enabled then return end
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - myHRP.Position).Magnitude < AutoKill.range then
                    killTarget(player)
                    break
                end
            end
        end
    end)
end

return AutoKill