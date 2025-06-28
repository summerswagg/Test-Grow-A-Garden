-- Grow a Garden Script for Delta Executor (Nebula Masterpiece)
-- Features: Cosmic GUI, Config Save, Advanced Functions, Summer Event Support
-- Note: Use at your own risk, as scripting violates Roblox Terms of Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Config System
local config = {
    Colors = {Base = Color3.fromRGB(20, 20, 40), Nebula = Color3.fromRGB(0, 150, 255), Glow = Color3.fromRGB(255, 100, 200), ToggleOn = Color3.fromRGB(0, 200, 0), ToggleOff = Color3.fromRGB(200, 0, 0)},
    Effects = {GlowIntensity = 0.5, AnimationSpeed = 0.5},
    AutoPlant = false, AutoCollect = false, AutoSell = false, InfiniteSeeds = false,
    AutoSubmitSummer = false, AutoHarvestSummer = false
}
local function saveConfig()
    local json = HttpService:JSONEncode(config)
    writefile("GAG_Nebula_Config.json", json)
end
local function loadConfig()
    if isfile("GAG_Nebula_Config.json") then
        local json = readfile("GAG_Nebula_Config.json")
        local success, result = pcall(function() return HttpService:JSONDecode(json) end)
        if success then config = result end
    end
end
loadConfig()

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "NebulaGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BackgroundColor3 = config.Colors.Base
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 15)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Nebula), ColorSequenceKeypoint.new(1, config.Colors.Glow)}
gradient.Parent = mainFrame

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 60)
title.Text = "Nebula GAG Masterpiece"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.TextStrokeTransparency = 0.5
title.TextStrokeColor3 = config.Colors.Glow

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = config.Colors.Nebula
uiStroke.Transparency = 0.7

-- Control Buttons with Effects
local closeButton = Instance.new("TextButton", title)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
closeButton.MouseEnter:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play() end)
closeButton.MouseLeave:Connect(function() TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play() end)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

local minimizeButton = Instance.new("TextButton", title)
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -100, 0, 10)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 8)
minimizeButton.MouseEnter:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 130, 0)}):Play() end)
minimizeButton.MouseLeave:Connect(function() TweenService:Create(minimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 165, 0)}):Play() end)
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Size = UDim2.new(0, 400, 0, 60)
    for i = 1, #contentFrames do contentFrames[i].Visible = false end
end)

-- Tab System with Animation
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 60)
tabFrame.BackgroundTransparency = 1

local tabs = {
    {Name = "Main", Selected = true},
    {Name = "Summer Event", Selected = false},
    {Name = "Settings", Selected = false}
}

local function createTabButton(name, index)
    local button = Instance.new("TextButton", tabFrame)
    button.Size = UDim2.new(0.33, -4, 1, 0)
    button.Position = UDim2.new(index * 0.33, 4, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = tabs[index + 1].Selected and config.Colors.Nebula or Color3.fromRGB(40, 40, 60)
    button.Font = Enum.Font.SourceSansSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = config.Colors.Glow}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = tabs[index + 1].Selected and config.Colors.Nebula or Color3.fromRGB(40, 40, 60)}):Play() end)
    button.MouseButton1Click:Connect(function()
        for i, tab in pairs(tabs) do
            tabs[i].Selected = (i == index + 1)
            TweenService:Create(tabButtons[i], TweenInfo.new(0.3), {BackgroundColor3 = tabs[i].Selected and config.Colors.Nebula or Color3.fromRGB(40, 40, 60)}):Play()
        end
        for i = 1, #contentFrames do
            contentFrames[i].Visible = false
            if i == index + 1 then
                TweenService:Create(contentFrames[i], TweenInfo.new(0.3), {Visible = true}):Play()
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
contentFrame.Size = UDim2.new(1, -20, 0, 390)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundTransparency = 0.4
contentFrame.BackgroundColor3 = config.Colors.Base
contentFrame.Visible = false
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)
local contentGradient = Instance.new("UIGradient", contentFrame)
contentGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Nebula), ColorSequenceKeypoint.new(1, config.Colors.Base)}

local contentFrames = {}
for i, tab in pairs(tabs) do
    local frame = contentFrame:Clone()
    frame.Parent = mainFrame
    frame.Visible = tab.Selected
    contentFrames[i] = frame
end

-- Mini Frame (Collapsed State)
local miniFrame = Instance.new("Frame", gui)
miniFrame.Size = UDim2.new(0, 60, 0, 60)
miniFrame.BackgroundColor3 = config.Colors.Nebula
miniFrame.Position = UDim2.new(0.5, -30, 0.5, -30)
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 15)
local miniGradient = Instance.new("UIGradient", miniFrame)
miniGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Glow), ColorSequenceKeypoint.new(1, config.Colors.Nebula)}

local miniLabel = Instance.new("TextLabel", miniFrame)
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.Text = "GAG Nebula"
miniLabel.TextColor3 = Color3.new(1, 1, 1)
miniLabel.BackgroundTransparency = 1
miniLabel.Font = Enum.Font.SourceSansBold
miniLabel.TextSize = 14
miniLabel.TextStrokeTransparency = 0.3
miniLabel.TextStrokeColor3 = config.Colors.Glow
miniLabel.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    mainFrame.Visible = true
    for i = 1, #contentFrames do
        if tabs[i].Selected then contentFrames[i].Visible = true end
    end
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 500)}):Play()
end)

-- Function to Create Toggle Button with Effects
local function createToggleButton(parent, text, yPos, default, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = default and config.Colors.ToggleOn or config.Colors.ToggleOff
    button.Text = text .. " (" .. (default and "ON" or "OFF") .. ")"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSansSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
    button.MouseEnter:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = config.Colors.Glow}):Play() end)
    button.MouseLeave:Connect(function() TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = default and config.Colors.ToggleOn or config.Colors.ToggleOff}):Play() end)
    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = text .. " (" .. (state and "ON" or "OFF") .. ")"
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = state and config.Colors.ToggleOn or config.Colors.ToggleOff}):Play()
        callback(state)
        config[text:gsub(" ", "")] = state
        saveConfig()
    end)
    return button
end

-- Function to Create Slider
local function createSlider(parent, text, yPos, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 70)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
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
    slider.BackgroundColor3 = config.Colors.Nebula
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)
    local value = default
    slider.MouseButton1Down:Connect(function(x)
        local relX = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * relX)
        label.Text = text .. ": " .. value
        callback(value)
        config[text:gsub(" ", "")] = value
        saveConfig()
        TweenService:Create(slider, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Glow}):Play()
        wait(0.1)
        TweenService:Create(slider, TweenInfo.new(0.1), {BackgroundColor3 = config.Colors.Nebula}):Play()
    end)
    return frame
end

-- Main Tab Functions
local sellPos = CFrame.new(90.08035, 0.98381, 3.02662, 6e-05, 1e-06, 1, -0.0349, 0.999, 1e-06, -0.999, -0.0349, 6e-05)

local function findRemoteDeep(eventName)
    local function searchInstance(instance)
        for _, v in pairs(instance:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():match(eventName:lower()) then
                return v
            end
        end
        return nil
    end
    return searchInstance(game)
end

local function startAutoPlant()
    local plantEvent = findRemoteDeep("PlantSeed")
    while config.AutoPlant and task.wait(0.5) do
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
    local harvestEvent = findRemoteDeep("HarvestPlant")
    while config.AutoCollect and task.wait(0.3) do
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

local function startAutoSell()
    local sellEvent = findRemoteDeep("Sell_Inventory")
    while config.AutoSell and task.wait(0.5) do
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and sellEvent then
            local orig = hrp.CFrame
            hrp.CFrame = sellPos
            task.wait(0.1)
            pcall(function() sellEvent:FireServer() end)
            task.wait(0.1)
            hrp.CFrame = orig
        end
    end
end

local function startInfiniteSeeds()
    local seedEvent = findRemoteDeep("GiveSeed")
    while config.InfiniteSeeds and task.wait(1) do
        if seedEvent then pcall(function() seedEvent:FireServer("CarrotSeed", 100) end) end
    end
end

-- Summer Event Tab Functions
local function startAutoSubmitSummer()
    local submitEvent = findRemoteDeep("SubmitSummerFruit")
    while config.AutoSubmitSummer and task.wait(1) do
        for _, fruit in pairs(workspace:GetDescendants()) do
            if fruit.Name:match("SummerFruit") and fruit:IsA("Model") then
                local root = fruit:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if submitEvent then pcall(function() submitEvent:FireServer(fruit) end) end
                end
            end
        end
    end
end

local function startAutoHarvestSummer()
    local harvestEvent = findRemoteDeep("HarvestSummerPlant")
    while config.AutoHarvestSummer and task.wait(0.5) do
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant.Name:match("SummerPlant") and plant:IsA("Model") then
                local root = plant:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if harvestEvent then pcall(function() harvestEvent:FireServer(plant) end) end
                end
            end
        end
    end
end

-- Main Tab GUI
local yPosMain = 10
createToggleButton(contentFrames[1], "Auto Plant", yPosMain, config.AutoPlant, function(state)
    config.AutoPlant = state
    if state then spawn(startAutoPlant) end
end)
createToggleButton(contentFrames[1], "Auto Collect", yPosMain + 60, config.AutoCollect, function(state)
    config.AutoCollect = state
    if state then spawn(startAutoCollect) end
end)
createToggleButton(contentFrames[1], "Auto Sell", yPosMain + 120, config.AutoSell, function(state)
    config.AutoSell = state
    if state then spawn(startAutoSell) end
end)
createToggleButton(contentFrames[1], "Infinite Seeds", yPosMain + 180, config.InfiniteSeeds, function(state)
    config.InfiniteSeeds = state
    if state then spawn(startInfiniteSeeds) end
end)
createToggleButton(contentFrames[1], "Teleport to Sell", yPosMain + 240, false, function(state)
    if state then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = sellPos end
    end
end)

-- Summer Event Tab GUI
local yPosSummer = 10
createToggleButton(contentFrames[2], "Auto Submit Summer Fruits", yPosSummer, config.AutoSubmitSummer, function(state)
    config.AutoSubmitSummer = state
    if state then spawn(startAutoSubmitSummer) end
end)
createToggleButton(contentFrames[2], "Auto Harvest Summer Plants", yPosSummer + 60, config.AutoHarvestSummer, function(state)
    config.AutoHarvestSummer = state
    if state then spawn(startAutoHarvestSummer) end
end)
createToggleButton(contentFrames[2], "Summer Boost (x2)", yPosSummer + 120, false, function(state)
    local boostEvent = findRemoteDeep("ActivateSummerBoost")
    if state and boostEvent then pcall(function() boostEvent:FireServer() end) end
end)

-- Settings Tab GUI
local yPosSettings = 10
createColorPicker(contentFrames[3], "Base Color", yPosSettings, config.Colors.Base, function(color)
    config.Colors.Base = color
    mainFrame.BackgroundColor3 = color
    contentFrames[3].BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)
    saveConfig()
end)
createColorPicker(contentFrames[3], "Nebula Color", yPosSettings + 70, config.Colors.Nebula, function(color)
    config.Colors.Nebula = color
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(1, config.Colors.Glow)}
    contentGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(1, config.Colors.Base)}
    miniGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Glow), ColorSequenceKeypoint.new(1, color)}
    uiStroke.Color = color
    saveConfig()
end)
createColorPicker(contentFrames[3], "Glow Color", yPosSettings + 140, config.Colors.Glow, function(color)
    config.Colors.Glow = color
    title.TextStrokeColor3 = color
    miniLabel.TextStrokeColor3 = color
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Nebula), ColorSequenceKeypoint.new(1, color)}
    contentGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, config.Colors.Nebula), ColorSequenceKeypoint.new(1, config.Colors.Base)}
    miniGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, color), ColorSequenceKeypoint.new(1, config.Colors.Nebula)}
    saveConfig()
end)
createColorPicker(contentFrames[3], "Toggle On Color", yPosSettings + 210, config.Colors.ToggleOn, function(color)
    config.Colors.ToggleOn = color
    saveConfig()
end)
createColorPicker(contentFrames[3], "Toggle Off Color", yPosSettings + 280, config.Colors.ToggleOff, function(color)
    config.Colors.ToggleOff = color
    saveConfig()
end)
createSlider(contentFrames[3], "Glow Intensity", yPosSettings + 350, 0, 1, config.Effects.GlowIntensity, function(value)
    config.Effects.GlowIntensity = value
    uiStroke.Transparency = 1 - value
    saveConfig()
end)
createSlider(contentFrames[3], "Animation Speed", yPosSettings + 430, 0.1, 1, config.Effects.AnimationSpeed, function(value)
    config.Effects.AnimationSpeed = value
    saveConfig()
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Background Particles (Cosmic Effect)
local function createParticle(parent)
    local particle = Instance.new("ImageLabel", parent)
    particle.Size = UDim2.new(0, 10, 0, 10)
    particle.BackgroundTransparency = 1
    particle.Image = "rbxassetid://243098098" -- Star-like particle
    particle.ImageColor3 = config.Colors.Glow
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    TweenService:Create(particle, TweenInfo.new(2 * config.Effects.AnimationSpeed, Enum.EasingStyle.Linear), {Position = UDim2.new(math.random(), 0, math.random(), 0), Transparency = 1}):Play()
    delay(2 * config.Effects.AnimationSpeed, function() particle:Destroy() end)
end
RunService.RenderStepped:Connect(function()
    if math.random(1, 10) == 1 then createParticle(contentFrames[1]) end
    if math.random(1, 10) == 1 then createParticle(contentFrames[2]) end
    if math.random(1, 10) == 1 then createParticle(contentFrames[3]) end
end)
