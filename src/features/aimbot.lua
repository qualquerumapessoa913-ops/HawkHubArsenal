-- ============================================================
-- AIMBOT SILENT – Move o mouse pro HEAD do inimigo, atira, volta
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Aimbot = {}
Aimbot.enabled = false
Aimbot.fov = 120
Aimbot.targetPart = "Head"
Aimbot.showFov = true

-- FOV Circle
local fovGui, fovCircle

local function createFovCircle()
    if fovGui then fovGui:Destroy() end
    fovGui = Instance.new("ScreenGui")
    fovGui.Name = "AimbotFOV"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    fovCircle = Instance.new("Frame")
    fovCircle.BackgroundTransparency = 1
    fovCircle.Size = UDim2.new(0, Aimbot.fov * 2, 0, Aimbot.fov * 2)
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Parent = fovGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = fovCircle

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = fovCircle
end

-- Inimigo dentro do FOV do mouse
local function getTarget()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, closestDist = nil, Aimbot.fov
    local myTeam = LocalPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= myTeam then
            local part = player.Character:FindFirstChild(Aimbot.targetPart)
                or player.Character:FindFirstChild("Head")
            if part then
                local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closest = {player = player, part = part, sp = sp}
                    end
                end
            end
        end
    end
    return closest
end

-- Silent aim: move o mouse, atira, volta
local function silentShoot(target)
    if not target then return end

    local current = UserInputService:GetMouseLocation()
    local targetX, targetY = math.floor(target.sp.X), math.floor(target.sp.Y)
    local currentX, currentY = math.floor(current.X), math.floor(current.Y)

    -- Move o mouse pro alvo
    pcall(function() mousemoverel(targetX - currentX, targetY - currentY) end)
    pcall(function() VirtualInput:SendMouseMoveEvent(targetX, targetY, 0, game) end)

    task.wait(0.04) -- espera o mouse registrar

    -- Atira no alvo
    pcall(function()
        VirtualInput:SendMouseButtonEvent(targetX, targetY, 0, true, game, 0)
        task.wait(0.02)
        VirtualInput:SendMouseButtonEvent(targetX, targetY, 0, false, game, 0)
    end)
    pcall(function() mouse1down() task.wait(0.02) mouse1up() end)

    task.wait(0.02)

    -- Volta o mouse
    pcall(function() mousemoverel(currentX - targetX, currentY - targetY) end)
    pcall(function() VirtualInput:SendMouseMoveEvent(currentX, currentY, 0, game) end)
end

function Aimbot:start()
    createFovCircle()

    RunService.RenderStepped:Connect(function()
        if fovCircle then
            if not Aimbot.showFov or not Aimbot.enabled then
                fovCircle.Visible = false
            else
                fovCircle.Visible = true
                local m = UserInputService:GetMouseLocation()
                fovCircle.Position = UDim2.new(0, m.X, 0, m.Y)
                fovCircle.Size = UDim2.new(0, Aimbot.fov * 2, 0, Aimbot.fov * 2)
            end
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not Aimbot.enabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local target = getTarget()
        if target then
            silentShoot(target)
        end
    end)
end

return Aimbot