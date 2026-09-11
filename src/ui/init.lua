-- ============================================================
-- HAWK HUB UI – Custom Library (COMPLETA)
-- ============================================================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local UI = {}
UI.__index = UI

local Theme = {
    Background = Color3.fromRGB(13, 13, 18),
    Surface = Color3.fromRGB(20, 20, 28),
    SurfaceLight = Color3.fromRGB(32, 32, 42),
    Primary = Color3.fromRGB(0, 200, 255),
    Success = Color3.fromRGB(0, 230, 118),
    Danger = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(240, 240, 250),
    TextDim = Color3.fromRGB(130, 130, 150),
    Border = Color3.fromRGB(40, 40, 55),
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
}

function UI.new(config)
    local self = setmetatable({}, UI)
    self.config = config or {}
    self.tabs = {}
    self.currentTab = nil
    self.dragging = false
    self.dragStart = nil
    self.frameStart = nil

    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "HawkHubUI"
    self.gui.ResetOnSpawn = false
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    self.main = Instance.new("Frame")
    self.main.Size = UDim2.new(0, 620, 0, 440)
    self.main.Position = UDim2.new(0.5, -310, 0.5, -220)
    self.main.BackgroundColor3 = Theme.Background
    self.main.BorderSizePixel = 0
    self.main.Parent = self.gui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.5
    mainStroke.Parent = self.main

    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://5028857084"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.55
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = 0
    shadow.Parent = self.main

    -- Header
    self.header = Instance.new("Frame")
    self.header.Size = UDim2.new(1, 0, 0, 45)
    self.header.BackgroundColor3 = Theme.Surface
    self.header.BorderSizePixel = 0
    self.header.Parent = self.main

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = self.header

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 12)
    headerFix.Position = UDim2.new(0, 0, 1, -12)
    headerFix.BackgroundColor3 = Theme.Surface
    headerFix.BorderSizePixel = 0
    headerFix.Parent = self.header

    self.title = Instance.new("TextLabel")
    self.title.Size = UDim2.new(0, 200, 0, 22)
    self.title.Position = UDim2.new(0, 20, 0, 4)
    self.title.BackgroundTransparency = 1
    self.title.Font = Theme.FontBold
    self.title.Text = config.Name or "HAWK HUB"
    self.title.TextColor3 = Theme.Text
    self.title.TextSize = 16
    self.title.TextXAlignment = Enum.TextXAlignment.Left
    self.title.Parent = self.header

    self.subtitle = Instance.new("TextLabel")
    self.subtitle.Size = UDim2.new(0, 200, 0, 20)
    self.subtitle.Position = UDim2.new(0, 20, 0, 22)
    self.subtitle.BackgroundTransparency = 1
    self.subtitle.Font = Theme.Font
    self.subtitle.Text = config.Subtitle or ""
    self.subtitle.TextColor3 = Theme.Primary
    self.subtitle.TextSize = 11
    self.subtitle.TextXAlignment = Enum.TextXAlignment.Left
    self.subtitle.Parent = self.header

    -- Botão Minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -75, 0.5, -15)
    minimizeBtn.BackgroundColor3 = Theme.SurfaceLight
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "−"
    minimizeBtn.Font = Theme.FontBold
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 18
    minimizeBtn.Parent = self.header

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minimizeBtn

    minimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)

    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    closeBtn.BackgroundColor3 = Theme.SurfaceLight
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.Font = Theme.FontBold
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 16
    closeBtn.Parent = self.header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Danger}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SurfaceLight}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self.gui:Destroy()
    end)

    -- Sidebar
    self.sidebar = Instance.new("Frame")
    self.sidebar.Size = UDim2.new(0, 150, 1, -45)
    self.sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.sidebar.BackgroundColor3 = Theme.Surface
    self.sidebar.BorderSizePixel = 0
    self.sidebar.Parent = self.main

    -- Content
    self.content = Instance.new("Frame")
    self.content.Size = UDim2.new(1, -170, 1, -65)
    self.content.Position = UDim2.new(0, 160, 0, 55)
    self.content.BackgroundTransparency = 1
    self.content.Parent = self.main

    self.scroll = Instance.new("ScrollingFrame")
    self.scroll.Size = UDim2.new(1, 0, 1, 0)
    self.scroll.BackgroundTransparency = 1
    self.scroll.BorderSizePixel = 0
    self.scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.scroll.ScrollBarThickness = 4
    self.scroll.ScrollBarImageColor3 = Theme.Primary
    self.scroll.ScrollBarImageTransparency = 0.5
    self.scroll.Parent = self.content

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.scroll

    self:MakeDraggable(self.header, self.main)
    return self
end

function UI:MakeDraggable(handle, target)
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = true
            self.dragStart = input.Position
            self.frameStart = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if self.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - self.dragStart
            target.Position = UDim2.new(
                self.frameStart.X.Scale,
                self.frameStart.X.Offset + delta.X,
                self.frameStart.Y.Scale,
                self.frameStart.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.dragging = false
        end
    end)
end

function UI:ToggleMinimize()
    self.minimized = not self.minimized
    local targetSize = self.minimized and UDim2.new(0, 620, 0, 45) or UDim2.new(0, 620, 0, 440)
    TweenService:Create(self.main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = targetSize
    }):Play()
    self.sidebar.Visible = not self.minimized
    self.content.Visible = not self.minimized
end

function UI:CreateTab(config)
    local tab = {}
    tab.name = config.name
    tab.icon = config.icon or ""

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, 10 + (#self.tabs * 42))
    btn.BackgroundColor3 = Theme.Surface
    btn.BorderSizePixel = 0
    btn.Text = "  " .. tab.icon .. "   " .. tab.name
    btn.Font = Theme.Font
    btn.TextColor3 = Theme.TextDim
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = self.sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseEnter:Connect(function()
        if self.currentTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.SurfaceLight}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.currentTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Surface}):Play()
        end
    end)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = self.scroll

    local cLayout = Instance.new("UIListLayout")
    cLayout.FillDirection = Enum.FillDirection.Vertical
    cLayout.Padding = UDim.new(0, 6)
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Parent = container

    tab.container = container
    tab.btn = btn

    btn.MouseButton1Click:Connect(function()
        if self.currentTab then
            self.currentTab.container.Visible = false
            TweenService:Create(self.currentTab.btn, TweenInfo.new(0.15), {
                BackgroundColor3 = Theme.Surface,
                TextColor3 = Theme.TextDim
            }):Play()
        end
        self.currentTab = tab
        tab.container.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Primary,
            TextColor3 = Theme.Text
        }):Play()
    end)

    table.insert(self.tabs, tab)

    if #self.tabs == 1 then
        task.wait(0.05)
        btn.MouseButton1Click:Fire()
    end

    return tab
end

function UI:CreateSection(tab, name)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -10, 0, 26)
    section.BackgroundTransparency = 1
    section.Parent = tab.container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 26)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Theme.FontBold
    label.Text = name:upper()
    label.TextColor3 = Theme.Primary
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    return section
end

function UI:CreateToggle(tab, config)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 40)
    holder.BackgroundColor3 = Theme.Surface
    holder.BorderSizePixel = 0
    holder.Parent = tab.container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Theme.Font
    label.Text = config.name
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 44, 0, 24)
    switchBg.Position = UDim2.new(1, -58, 0.5, -12)
    switchBg.BackgroundColor3 = Theme.SurfaceLight
    switchBg.BorderSizePixel = 0
    switchBg.Parent = holder

    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = Theme.Text
    knob.BorderSizePixel = 0
    knob.Parent = switchBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = config.currentValue or false
    local function updateVisual()
        local targetColor = state and Theme.Success or Theme.SurfaceLight
        local targetPos = state and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
    end
    updateVisual()

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = holder

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        if config.callback then config.callback(state) end
    end)

    return {set = function(v) state = v updateVisual() if config.callback then config.callback(v) end end}
end

function UI:CreateButton(tab, config)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Theme.Surface
    btn.BorderSizePixel = 0
    btn.Text = config.name
    btn.Font = Theme.Font
    btn.TextColor3 = Theme.Text
    btn.TextSize = 13
    btn.Parent = tab.container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Primary}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Surface}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        if config.callback then config.callback() end
    end)
    return btn
end

function UI:CreateSlider(tab, config)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 55)
    holder.BackgroundColor3 = Theme.Surface
    holder.BorderSizePixel = 0
    holder.Parent = tab.container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1
    label.Font = Theme.Font
    label.Text = config.name
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.65, 0, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Theme.FontBold
    valueLabel.Text = tostring(config.currentValue or config.min or 0)
    valueLabel.TextColor3 = Theme.Primary
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -28, 0, 6)
    barBg.Position = UDim2.new(0, 14, 0, 38)
    barBg.BackgroundColor3 = Theme.SurfaceLight
    barBg.BorderSizePixel = 0
    barBg.Parent = holder

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    local min = config.min or 0
    local max = config.max or 100
    local value = config.currentValue or min

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Primary
    fill.BorderSizePixel = 0
    fill.Parent = barBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local knobSlider = Instance.new("Frame")
    knobSlider.Size = UDim2.new(0, 14, 0, 14)
    knobSlider.Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7)
    knobSlider.BackgroundColor3 = Theme.Primary
    knobSlider.BorderSizePixel = 0
    knobSlider.Parent = barBg

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knobSlider

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.Parent = holder

    local dragging = false

    local function updateFromMouse()
        local mouse = UserInputService:GetMouseLocation()
        local barPos = barBg.AbsolutePosition
        local barSize = barBg.AbsoluteSize
        local relativeX = math.clamp((mouse.X - barPos.X) / barSize.X, 0, 1)
        local newValue = math.floor(min + (max - min) * relativeX)
        value = newValue
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        knobSlider.Position = UDim2.new(relativeX, -7, 0.5, -7)
        valueLabel.Text = tostring(newValue)
        if config.callback then config.callback(newValue) end
    end

    clickArea.MouseButton1Down:Connect(function()
        dragging = true
        updateFromMouse()
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then updateFromMouse() end
    end)

    return {set = function(v)
        value = math.clamp(v, min, max)
        local rel = (value - min) / (max - min)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knobSlider.Position = UDim2.new(rel, -7, 0.5, -7)
        valueLabel.Text = tostring(value)
    end}
end

function UI:CreateDropdown(tab, config)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -10, 0, 40)
    holder.BackgroundColor3 = Theme.Surface
    holder.BorderSizePixel = 0
    holder.Parent = tab.container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Theme.Font
    label.Text = config.name
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local currentLabel = Instance.new("TextLabel")
    currentLabel.Size = UDim2.new(0.4, 0, 1, 0)
    currentLabel.Position = UDim2.new(0.55, 0, 0, 0)
    currentLabel.BackgroundTransparency = 1
    currentLabel.Font = Theme.FontBold
    currentLabel.Text = (config.currentOption or config.options[1]) .. "  ▾"
    currentLabel.TextColor3 = Theme.Primary
    currentLabel.TextSize = 13
    currentLabel.TextXAlignment = Enum.TextXAlignment.Right
    currentLabel.Parent = holder

    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, -10, 0, 0)
    dropdown.BackgroundColor3 = Theme.SurfaceLight
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.Visible = false
    dropdown.Parent = tab.container

    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 8)
    dCorner.Parent = dropdown

    local dLayout = Instance.new("UIListLayout")
    dLayout.Padding = UDim.new(0, 2)
    dLayout.Parent = dropdown

    local isOpen = false

    for i, option in ipairs(config.options) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, -8, 0, 32)
        opt.Position = UDim2.new(0, 4, 0, 4 + (i - 1) * 34)
        opt.BackgroundColor3 = Theme.SurfaceLight
        opt.BorderSizePixel = 0
        opt.Text = option
        opt.Font = Theme.Font
        opt.TextColor3 = Theme.Text
        opt.TextSize = 13
        opt.Parent = dropdown

        opt.MouseEnter:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Primary}):Play()
        end)
        opt.MouseLeave:Connect(function()
            TweenService:Create(opt, TweenInfo.new(0.1), {BackgroundColor3 = Theme.SurfaceLight}):Play()
        end)

        opt.MouseButton1Click:Connect(function()
            currentLabel.Text = option .. "  ▾"
            if config.callback then config.callback(option) end
            isOpen = false
            TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 0)}):Play()
            task.wait(0.2)
            dropdown.Visible = false
        end)
    end

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 1, 0)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Text = ""
    toggleBtn.Parent = holder

    toggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            dropdown.Visible = true
            TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, #config.options * 34 + 8)}):Play()
        else
            TweenService:Create(dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, 0)}):Play()
            task.wait(0.2)
            dropdown.Visible = false
        end
    end)

    return {set = function(v) currentLabel.Text = v .. "  ▾" end}
end

function UI:CreateLabel(tab, config)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Theme.Font
    label.Text = config.text
    label.TextColor3 = config.color or Theme.TextDim
    label.TextSize = config.size or 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tab.container
    return label
end

function UI:Notify(title, content, duration)
    duration = duration or 3
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(1, 20, 0, 100)
    notif.BackgroundColor3 = Theme.Surface
    notif.BorderSizePixel = 0
    notif.Parent = self.gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Primary
    stroke.Thickness = 1
    stroke.Parent = notif

    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -20, 0, 22)
    titleL.Position = UDim2.new(0, 12, 0, 8)
    titleL.BackgroundTransparency = 1
    titleL.Font = Theme.FontBold
    titleL.Text = title
    titleL.TextColor3 = Theme.Primary
    titleL.TextSize = 13
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.Parent = notif

    local contentL = Instance.new("TextLabel")
    contentL.Size = UDim2.new(1, -20, 0, 20)
    contentL.Position = UDim2.new(0, 12, 0, 30)
    contentL.BackgroundTransparency = 1
    contentL.Font = Theme.Font
    contentL.Text = content
    contentL.TextColor3 = Theme.Text
    contentL.TextSize = 12
    contentL.TextXAlignment = Enum.TextXAlignment.Left
    contentL.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 100)
    }):Play()

    task.wait(duration)

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 0, 100)
    }):Play()
    task.wait(0.3)
    notif:Destroy()
end

return UI