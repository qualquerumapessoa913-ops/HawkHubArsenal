-- ============================================================
-- AIMBOT (SILENT) – Tiro vai pro inimigo sem travar a câmera
-- FOV Circle segue o mouse (as 4 setinhas)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Aimbot = {}
Aimbot.enabled = false
Aimbot.fov = 120
Aimbot.targetPart = "Head"
Aimbot.showFov = true

-- ============================================================
-- FOV CIRCLE (segue o mouse)
-- ============================================================
local fovCircle = nil

local function createFovCircle()
    if fovCircle then fovCircle:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AimbotFOV"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local circle = Instance.new("Frame")
    circle.Name = "Circle"
    circle.BackgroundTransparency = 1
    circle.Size = UDim2.new(0, Aimbot.fov * 2, 0, Aimbot.fov * 2)
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = circle

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = circle

    fovCircle = circle
end

-- ============================================================
-- DETECTAR INIMIGO DENTRO DO FOV DO MOUSE
-- ============================================================
local function getTargetInFov()
    local mousePos = UserInputService:GetMouseLocation()
    local closest, closestDist = nil, Aimbot.fov
    local myTeam = LocalPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= myTeam then
            local part = player.Character:FindFirstChild(Aimbot.targetPart)
                or player.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = {player = player, screenPos = screenPos}
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================================
-- SILENT AIM – Move o mouse, clica, volta
-- ============================================================
local function shootAt(target)
    if not target then return end

    local mousePos = UserInputService:GetMouseLocation()
    local targetX, targetY = target.screenPos.X, target.screenPos.Y

    -- Move o mouse pro alvo
    pcall(function()
        VirtualInput:SendMouseMoveEvent(targetX, targetY, 0, game)
    end)

    task.wait(0.01)

    -- Clica
    pcall(function()
        VirtualInput:SendMouseButtonEvent(targetX, targetY, 0, true, game, 0)
        task.wait(0.01)
        VirtualInput:SendMouseButtonEvent(targetX, targetY, 0, false, game, 0)
    end)
    pcall(mouse1click)

    task.wait(0.01)

    -- Volta o mouse
    pcall(function()
        VirtualInput:SendMouseMoveEvent(mousePos.X, mousePos.Y, 0, game)
    end)
end

function Aimbot:start()
    createFovCircle()

    -- Atualiza FOV circle toda frame (segue o mouse)
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

    -- Quando clicar, se tiver inimigo no FOV, redireciona o tiro
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not Aimbot.enabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

        local target = getTargetInFov()
        if target then
            shootAt(target)
        end
    end)
end

return Aimbot