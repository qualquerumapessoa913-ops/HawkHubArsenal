-- ============================================================
-- HELPERS
-- ============================================================
local Helpers = {}

local Players = game:GetService("Players")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

function Helpers.getCharacter()
    return LocalPlayer.Character
end

function Helpers.getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

function Helpers.getHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function Helpers.safeFind(parent, name)
    if not parent then return nil end
    return parent:FindFirstChild(name)
end

function Helpers.isOnScreen(position)
    local cam = workspace.CurrentCamera
    local screenPos, onScreen = cam:WorldToViewportPoint(position)
    return onScreen and screenPos.Z > 0
end

function Helpers.clickMouse()
    pcall(function()
        VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.03)
        VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
    pcall(function()
        mouse1click()
    end)
end

function Helpers.getEnemies()
    local enemies = {}
    local myTeam = LocalPlayer.Team
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= myTeam then
            table.insert(enemies, player)
        end
    end
    return enemies
end

function Helpers.getClosestEnemy(maxDist)
    maxDist = maxDist or math.huge
    local myHRP = Helpers.getHRP()
    if not myHRP then return nil end
    local closest = nil
    local closestDist = maxDist
    for _, player in ipairs(Helpers.getEnemies()) do
        local head = Helpers.safeFind(player.Character, "Head")
        if head then
            local dist = (head.Position - myHRP.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
    end
    return closest
end

return Helpers