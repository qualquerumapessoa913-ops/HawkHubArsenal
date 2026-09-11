-- ============================================================
-- BACKSTAB – Equipa faca, teleporta atrás, mata (Keybind E)
-- ============================================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local Backstab = {}
Backstab.enabled = false
Backstab.keybind = Enum.KeyCode.E

local function findKnife()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("dagger") or n:find("blade") then
                    return tool, true
                end
            end
        end
    end

    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("knife") or n:find("dagger") or n:find("blade") then
                    return tool, false
                end
            end
        end
    end
    return nil, false
end

local function equipKnife()
    local knife, equipped = findKnife()
    if not knife then return nil end
    if not equipped then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum:EquipTool(knife) end)
            task.wait(0.15)
        end
    end
    return knife
end

local function getClosestEnemy(maxDist)
    maxDist = maxDist or 60
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local closest, closestDist = nil, maxDist
    local myTeam = LocalPlayer.Team
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= myTeam then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < closestDist then
                    closestDist = d
                    closest = player
                end
            end
        end
    end
    return closest
end

local function doBackstab()
    local target = getClosestEnemy()
    if not target or not target.Character then return end

    local knife = equipKnife()
    if not knife then return end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not myHRP then return end

    local behindCFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
    myHRP.CFrame = behindCFrame
    task.wait(0.08)

    pcall(function() knife:Activate() end)
    task.wait(0.05)

    pcall(function()
        VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.02)
        VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
    pcall(function() mouse1click() end)
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