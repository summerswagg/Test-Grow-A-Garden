-- Grow a Garden Script for Delta Executor (Enhanced Version)
-- Features: Advanced GUI, Config Save, Multiple Functions, Summer Event Support
-- Note: Use at your own risk, as scripting violates Roblox Terms of Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Config System
local config = {
    Colors = {Main = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 120, 255), ToggleOn = Color3.fromRGB(0, 150, 0), ToggleOff = Color3.fromRGB(150, 0, 0)},
    AutoPlant = false, AutoCollect = false, AutoSell = false, InfiniteSeeds = false,
    AutoSubmitSummer = false, AutoHarvestSummer = false
}
local function saveConfig()
    local json = HttpService:JSONEncode(config)
    writefile("GAG_Config.json", json)
end
local function loadConfig()
    if isfile("GAG_Config.json") then
        local json = readfile("GAG_Config.json")
        local success, result = pcall(function() return HttpService:JSONDecode(json) end)
        if success then config = result end
    end
end
loadConfig()

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GrowAGardenGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = config.Colors.Main
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "GAG Divine Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = config.Colors.Accent
title.Font = Enum.Font.GothamBlack
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Control Buttons
local closeButton = Instance.new("TextButton", title)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 5)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniFrame.Visible = true
end)

local minimizeButton = Instance.new("TextButton", title)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -80, 0, 10)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 5)
minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Size = UDim2.new(0, 350, 0, 50)
    contentFrames[1].Visible = false
    contentFrames[2].Visible = false
end)

-- Tab System
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundTransparency = 1

local tabs = {
    {Name = "Main", Selected = true},
    {Name = "Summer Event", Selected = false},
    {Name = "Settings", Selected = false}
}

local function createTabButton(name, index)
    local button = Instance.new("TextButton", tabFrame)
    button.Size = UDim2.new(0.33, -2, 1, 0)
    button.Position = UDim2.new(index * 0.33, 2, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = tabs[index + 1].Selected and config.Colors.Accent or Color3.fromRGB(50, 50, 50)
    button.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
    button.MouseButton1Click:Connect(function()
        for i, tab in pairs(tabs) do
            tabs[i].Selected = (i == index + 1)
            tabButtons[i].BackgroundColor3 = tabs[i].Selected and config.Colors.Accent or Color3.fromRGB(50, 50, 50)
        end
        for i = 1, #contentFrames do
            contentFrames[i].Visible = false
        end
        contentFrames[index + 1].Visible = true
    end)
    return button
end

local tabButtons = {}
for i, tab in pairs(tabs) do
    tabButtons[i] = createTabButton(tab.Name, i - 1)
end

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 0, 360)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentFrame.Visible = false
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 5)

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
miniFrame.BackgroundColor3 = config.Colors.Accent
miniFrame.Position = UDim2.new(0.5, -25, 0.5, -25)
miniFrame.Visible = false
miniFrame.Active = true
miniFrame.Draggable = true
Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 10)

local miniLabel = Instance.new("TextLabel", miniFrame)
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.Text = "GAG Hack"
miniLabel.TextColor3 = Color3.new(1, 1, 1)
miniLabel.BackgroundTransparency = 1
miniLabel.Font = Enum.Font.GothamBold
miniLabel.TextScaled = true
miniLabel.MouseButton1Click:Connect(function()
    miniFrame.Visible = false
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 350, 0, 450)
    contentFrames[1].Visible = true
end)

-- Function to Create Toggle Button
local function createToggleButton(parent, text, yPos, default, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = default and config.Colors.ToggleOn or config.Colors.ToggleOff
    button.Text = text .. " (" .. (default and "ON" or "OFF") .. ")"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = text .. " (" .. (state and "ON" or "OFF") .. ")"
        button.BackgroundColor3 = state and config.Colors.ToggleOn or config.Colors.ToggleOff
        callback(state)
        config[text:gsub(" ", "")] = state
        saveConfig()
    end)
    return button
end

-- Function to Create Color Picker
local function createColorPicker(parent, text, yPos, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(0.9, 0, 0, 60)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham

    local colorFrame = Instance.new("Frame", frame)
    colorFrame.Size = UDim2.new(1, -10, 0, 30)
    colorFrame.Position = UDim2.new(0, 5, 0, 20)
    colorFrame.BackgroundColor3 = default
    Instance.new("UICorner", colorFrame).CornerRadius = UDim.new(0, 5)

    colorFrame.MouseButton1Click:Connect(function()
        local color = Color3.fromHSV(math.random(), 0.5, 0.9)
        colorFrame.BackgroundColor3 = color
        callback(color)
        if text == "Main Color" then config.Colors.Main = color
        elseif text == "Accent Color" then config.Colors.Accent = color
        elseif text == "Toggle On Color" then config.Colors.ToggleOn = color
        elseif text == "Toggle Off Color" then config.Colors.ToggleOff = color end
        mainFrame.BackgroundColor3 = config.Colors.Main
        title.BackgroundColor3 = config.Colors.Accent
        for _, button in pairs(tabButtons) do button.BackgroundColor3 = tabs[tonumber(button.Name)] and config.Colors.Accent or Color3.fromRGB(50, 50, 50) end
        miniFrame.BackgroundColor3 = config.Colors.Accent
        saveConfig()
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
createToggleButton(contentFrames[1], "Auto Collect", yPosMain + 50, config.AutoCollect, function(state)
    config.AutoCollect = state
    if state then spawn(startAutoCollect) end
end)
createToggleButton(contentFrames[1], "Auto Sell", yPosMain + 100, config.AutoSell, function(state)
    config.AutoSell = state
    if state then spawn(startAutoSell) end
end)
createToggleButton(contentFrames[1], "Infinite Seeds", yPosMain + 150, config.InfiniteSeeds, function(state)
    config.InfiniteSeeds = state
    if state then spawn(startInfiniteSeeds) end
end)
createToggleButton(contentFrames[1], "Teleport to Sell", yPosMain + 200, false, function(state)
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
createToggleButton(contentFrames[2], "Auto Harvest Summer Plants", yPosSummer + 50, config.AutoHarvestSummer, function(state)
    config.AutoHarvestSummer = state
    if state then spawn(startAutoHarvestSummer) end
end)
createToggleButton(contentFrames[2], "Summer Boost (x2)", yPosSummer + 100, false, function(state)
    local boostEvent = findRemoteDeep("ActivateSummerBoost")
    if state and boostEvent then pcall(function() boostEvent:FireServer() end) end
end)

-- Settings Tab GUI
local yPosSettings = 10
createColorPicker(contentFrames[3], "Main Color", yPosSettings, config.Colors.Main, function(color) end)
createColorPicker(contentFrames[3], "Accent Color", yPosSettings + 70, config.Colors.Accent, function(color) end)
createColorPicker(contentFrames[3], "Toggle On Color", yPosSettings + 140, config.Colors.ToggleOn, function(color) end)
createColorPicker(contentFrames[3], "Toggle Off Color", yPosSettings + 210, config.Colors.ToggleOff, function(color) end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
