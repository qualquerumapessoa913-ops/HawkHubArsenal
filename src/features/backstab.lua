-- ============================================================
-- BACKSTAB – Toggle: teleporta atrás e mata com faca
-- ============================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local Backstab = {}
Backstab.enabled = false
Backstab.keybind = Enum.KeyCode.E

local function getKnife()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then return tool end
    end
    return nil
end

local function doBackstab()
    local closest, closestDist = nil, 50
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    if closest and closest.Character then
        local hrp = closest.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            myHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, 2)
            task.wait(0.05)
            local knife = getKnife()
            if knife then
                pcall(function() knife:Activate() end)
            end
            pcall(function()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.02)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            pcall(mouse1click)
        end
    end
end

function Backstab:start()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not Backstab.enabled then return end
        if input.KeyCode == Backstab.keybind then
            doBackstab()
        end
    end)
end

return Backstab