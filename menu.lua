-- Roblox Script for Delta Executor by DUBI
-- Features: Unique Futuristic GUI, RGB Modes, Config Settings, Animation
-- Note: Use at your own risk, as scripting violates Roblox Terms of Service

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Config System
local config = {
    Colors = {Primary = Color3.fromRGB(0, 120, 255), Secondary = Color3.fromRGB(255, 100, 0), Accent = Color3.fromRGB(0, 255, 100), RGBMode = true, RGBSpeed = 0.1},
    Effects = {Scale = 1.1, Transparency = 0.3},
    AutoFeatures = {AutoPlant = false, AutoCollect = false, Teleport = false}
}
local function saveConfig()
    local json = HttpService:JSONEncode(config)
    writefile("DUBI_Config.json", json)
end
local function loadConfig()
    if isfile("DUBI_Config.json") then
        local json = readfile("DUBI_Config.json")
        local success, result = pcall(function() return HttpService:JSONDecode(json) end)
        if success then config = result end
    end
end
loadConfig()

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "DUBI_FuturisticHub"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 400)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
mainFrame.BackgroundTransparency = config.Effects.Transparency
mainFrame.BackgroundColor3 = config.Colors.Primary
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = config.Colors.Accent
uiStroke.Transparency = 0.5

-- Animated Appearance
mainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 350, 0, 400), Transparency = config.Effects.Transparency}):Play()

-- Title with Notification
local titleFrame = Instance.new("Frame", mainFrame)
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.BackgroundColor3 = config.Colors.Secondary
titleFrame.BorderSizePixel = 0
Instance.new("UICorner", titleFrame).CornerRadius = UDim.new(0, 10)

local titleLabel = Instance.new("TextLabel", titleFrame)
titleLabel.Size = UDim2.new(1, -20, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "DUBI's Futuristic Hub"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 22

local notifyLabel = Instance.new("TextLabel", titleFrame)
notifyLabel.Size = UDim2.new(1, -20, 0, 30)
notifyLabel.Position = UDim2.new(0, 10, 0, 30)
notifyLabel.Text = "Script Loaded by DUBI - 08:50 PM PDT, 06/27/2025"
notifyLabel.TextColor3 = Color3.new(1, 1, 1)
notifyLabel.BackgroundTransparency = 1
notifyLabel.Font = Enum.Font.SourceSans
notifyLabel.TextSize = 14
TweenService:Create(notifyLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
delay(3, function() TweenService:Create(notifyLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 1}):Play() end)

-- Control Buttons with Animation
local closeButton = Instance.new("TextButton", titleFrame)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
closeButton.MouseEnter:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play() end)
closeButton.MouseLeave:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 40)}):Play() end)
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), Transparency = 1}):Play()
    delay(0.5, function() mainFrame.Visible = false miniFrame.Visible = true end)
end)

local minimizeButton = Instance.new("TextButton", titleFrame)
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -100, 0, 10)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 8)
minimizeButton.MouseEnter:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 45, 0, 45)}):Play() end)
minimizeButton.MouseLeave:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 40)}):Play() end)
minimizeButton.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 350, 0, 60)}):Play()
    for i = 1, #contentFrames do contentFrames[i].Visible = false end
end)

-- Tab System with RGB and Animation
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 60)
tabFrame.BackgroundTransparency = 1

local tabs = {
    {Name = "Features", Selected = true},
    {Name = "ESP", Selected = false},
    {Name="Settings", Selected = false}
}

local function createTabButton(name, index)
    local button = Instance.new("TextButton", tabFrame)
    button.Size = UDim2.new(0.33, -4, 1, 0)
    button.Position = UDim2.new(index * 0.33, 4, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = tabs[index + 1].Selected and config.Colors.Primary or Color3.fromRGB(50, 50, 70)
    button.Font = Enum.Font.SourceSansSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.33, -2, 1, -2)}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.33, -4, 1, 0)}):Play() end)
    button.MouseButton1Click:Connect(function()
        for i, tab in pairs(tabs) do
            tabs[i].Selected = (i == index + 1)
            TweenService:Create(tabButtons[i], TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = tabs[i].Selected and config.Colors.Primary or Color3.fromRGB(50, 50, 70)}):Play()
        end
        for i = 1, #contentFrames do
            contentFrames[i].Visible = false
            if i == index + 1 then
                TweenService:Create(contentFrames[i], TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Visible = true}):Play()
            end
        end
    end)
    return button
end

local tabButtons = {}
for i, tab in pairs(tabs) do
    tabButtons[i] = createTabButton(tab.Name, i - 1)
end

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 0, 290)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = config.Effects.Transparency
contentFrame.BackgroundColor3 = config.Colors.Primary
contentFrame.Visible = false
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)

local contentFrames = {}
for i, tab in pairs(tabs) do
    local frame = contentFrame:Clone()
    frame.Parent = mainFrame
    frame.Visible = tab.Selected
    contentFrames[i] = frame
end

-- Mini Frame (Collapsed State)
local miniFrame = Instance.new("Frame", gui)
miniFrame.Size = UDim2.new(0, 50, 0, 50)
miniFrame.BackgroundColor3 = config.Colors.Primary
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 10)

local miniLabel = Instance.new("TextLabel", miniFrame)
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.Text = "DUBI"
miniLabel.TextColor3 = Color3.new(1, 1, 1)
miniLabel.BackgroundTransparency = 1
miniLabel.Font = Enum.Font.SourceSansBold
miniLabel.TextSize = 16
miniLabel.MouseEnter:Connect(function() TweenService:Create(miniFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 55, 0, 55)}):Play() end)
miniLabel.MouseLeave:Connect(function() TweenService:Create(miniFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 50, 0, 50)}):Play() end)
miniLabel.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    mainFrame.Visible = true
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 350, 0, 400)}):Play()
    for i = 1, #contentFrames do
        if tabs[i].Selected then contentFrames[i].Visible = true end
    end
end)

-- Function to Create Toggle Button with RGB
local function createToggleButton(parent, text, yPos, default, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = default and config.Colors.Accent or config.Colors.Secondary
    button.Text = text .. " (" .. (default and "ON" or "OFF") .. ")"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.92, 0, 0, 52)}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0.9, 0, 0, 50)}):Play() end)
    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = text .. " (" .. (state and "ON" or "OFF") .. ")"
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = state and config.Colors.Accent or config.Colors.Secondary}):Play()
        callback(state)
        config.AutoFeatures[text:gsub(" ", "")] = state
        saveConfig()
    end)
    return button
end

-- Function to Create Slider
local function createSlider(parent, text, yPos, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 70)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans

    local slider = Instance.new("TextButton", frame)
    slider.Size = UDim2.new(1, -10, 0, 30)
    slider.Position = UDim2.new(0, 5, 0, 20)
    slider.BackgroundColor3 = config.Colors.Accent
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)
    local value = default
    slider.MouseButton1Down:Connect(function(x)
        local relX = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        label.Text = text .. ": " .. value
        callback(value)
        config[text:gsub(" ", "")] = value
        saveConfig()
        TweenService:Create(slider, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Secondary}):Play()
        wait(0.1)
        TweenService:Create(slider, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Accent}):Play()
    end)
    return frame
end

-- Function to Create Color Picker
local function createColorPicker(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 70)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSans

    local colorFrame = Instance.new("TextButton", frame)
    colorFrame.Size = UDim2.new(1, -10, 0, 30)
    colorFrame.Position = UDim2.new(0, 5, 0, 20)
    colorFrame.BackgroundColor3 = default
    Instance.new("UICorner", colorFrame).CornerRadius = UDim.new(0, 5)
    colorFrame.MouseButton1Click:Connect(function()
        local h, s, v = math.random(), 0.7, 0.9
        local color = Color3.fromHSV(h, s, v)
        colorFrame.BackgroundColor3 = color
        callback(color)
        if text == "Primary Color" then config.Colors.Primary = color
        elseif text == "Secondary Color" then config.Colors.Secondary = color
        elseif text == "Accent Color" then config.Colors.Accent = color end
        mainFrame.BackgroundColor3 = config.Colors.Primary
        titleFrame.BackgroundColor3 = config.Colors.Secondary
        uiStroke.Color = config.Colors.Accent
        saveConfig()
    end)
    return frame
end

-- RGB Animation
local function updateRGB()
    while config.Colors.RGBMode and task.wait(config.RGBSpeed) do
        local h = tick() % 1
        local color = Color3.fromHSV(h, 0.7, 0.9)
        mainFrame.BackgroundColor3 = color
        titleFrame.BackgroundColor3 = Color3.fromHSV(h + 0.3, 0.7, 0.9)
        uiStroke.Color = Color3.fromHSV(h + 0.6, 0.7, 0.9)
        for i, button in pairs(tabButtons) do
            if tabs[i].Selected then
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
            end
        end
    end
end
spawn(updateRGB)

-- Functions
local sellPos = CFrame.new(90.08035, 0.98381, 3.02662, 6e-05, 1e-06, 1, -0.0349, 0.999, 1e-06, -0.999, -0.0349, 6e-05)
local function findRemote(eventName)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():match(eventName:lower()) then
            return v
        end
    end
    return nil
end

local function startAutoPlant()
    local plantEvent = findRemote("PlantSeed")
    while config.AutoFeatures.AutoPlant and task.wait(0.5) do
        for _, seed in pairs(LocalPlayer.Backpack:GetChildren()) do
            if seed:IsA("Tool") and seed.Name:match("Seed") then
                seed.Parent = LocalPlayer.Character
                if plantEvent then pcall(function() plantEvent:FireServer(seed.Name) end) end
                task.wait(0.1)
            end
        end
    end
end

local function startAutoCollect()
    local harvestEvent = findRemote("HarvestPlant")
    while config.AutoFeatures.AutoCollect and task.wait(0.3) do
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant.Name:match("Plant") and plant:IsA("Model") then
                local root = plant:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if harvestEvent then pcall(function() harvestEvent:FireServer(plant) end) end
                end
            end
        end
    end
end

local function startTeleport()
    while config.AutoFeatures.Teleport and task.wait(0.5) do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = sellPos end
    end
end

-- Features Tab GUI
local yPosFeatures = 10
createToggleButton(contentFrames[1], "Auto Plant", yPosFeatures, config.AutoFeatures.AutoPlant, function(state)
    config.AutoFeatures.AutoPlant = state
    if state then spawn(startAutoPlant) end
end)
createToggleButton(contentFrames[1], "Auto Collect", yPosFeatures + 60, config.AutoFeatures.AutoCollect, function(state)
    config.AutoFeatures.AutoCollect = state
    if state then spawn(startAutoCollect) end
end)
createToggleButton(contentFrames[1], "Auto Teleport", yPosFeatures + 120, config.AutoFeatures.Teleport, function(state)
    config.AutoFeatures.Teleport = state
    if state then spawn(startTeleport) end
end)

-- ESP Tab GUI (Inspired by Image)
local yPosESP = 10
createToggleButton(contentFrames[2], "Highlight ESP", yPosESP, false, function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local highlight = Instance.new("Highlight", char)
                    highlight.FillColor = config.Colors.Accent
                    highlight.OutlineColor = config.Colors.Secondary
                end
            end
        end
    else
        for _, obj in pairs(game:GetService("Workspace"):GetDescendants()) do
            if obj:IsA("Highlight") then obj:Destroy() end
        end
    end
end)
createToggleButton(contentFrames[2], "Name ESP", yPosESP + 60, false, function(state)
    -- Placeholder for Name ESP (requires more complex implementation)
end)
createToggleButton(contentFrames[2], "X-Ray", yPosESP + 120, false, function(state)
    -- Placeholder for X-Ray (requires advanced rendering)
end)
createToggleButton(contentFrames[2], "Role ESP", yPosESP + 180, false, function(state)
    -- Placeholder for Role ESP (game-specific)
end)

-- Settings Tab GUI
local yPosSettings = 10
createColorPicker(contentFrames[3], "Primary Color", yPosSettings, config.Colors.Primary, function(color) end)
createColorPicker(contentFrames[3], "Secondary Color", yPosSettings + 70, config.Colors.Secondary, function(color) end)
createColorPicker(contentFrames[3], "Accent Color", yPosSettings + 140, config.Colors.Accent, function(color) end)
createToggleButton(contentFrames[3], "RGB Mode", yPosSettings + 210, config.Colors.RGBMode, function(state)
    config.Colors.RGBMode = state
    saveConfig()
end)
createSlider(contentFrames[3], "RGB Speed", yPosSettings + 270, 0.05, 0.5, config.RGBSpeed, function(value)
    config.RGBSpeed = value
    saveConfig()
end)
createSlider(contentFrames[3], "Scale", yPosSettings + 340, 1, 2, config.Effects.Scale, function(value)
    config.Effects.Scale = value
    mainFrame.Size = UDim2.new(0, 350 * value, 0, 400 * value)
    saveConfig()
end)
createSlider(contentFrames[3], "Transparency", yPosSettings + 410, 0, 0.9, config.Effects.Transparency, function(value)
    config.Effects.Transparency = value
    mainFrame.BackgroundTransparency = value
    contentFrames[3].BackgroundTransparency = value
    saveConfig()
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
