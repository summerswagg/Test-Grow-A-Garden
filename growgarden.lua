-- Grow a Garden Script for Delta Executor (Full Version)
-- Features: Auto Plant, Auto Collect, Auto Sell, Infinite Seeds, Summer Event Support
-- Note: Use at your own risk, as scripting violates Roblox Terms of Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GrowAGardenGUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Grow A Garden Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Tab System
local tabFrame = Instance.new("Frame", mainFrame)
tabFrame.Size = UDim2.new(1, 0, 0, 30)
tabFrame.Position = UDim2.new(0, 0, 0, 40)
tabFrame.BackgroundTransparency = 1

local tabs = {
    {Name = "Main", Selected = true},
    {Name = "Summer Event", Selected = false}
}

local function createTabButton(name, index)
    local button = Instance.new("TextButton", tabFrame)
    button.Size = UDim2.new(0.5, -2, 1, 0)
    button.Position = UDim2.new(index * 0.5, 2, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
    button.MouseButton1Click:Connect(function()
        for i, tab in pairs(tabs) do
            tabs[i].Selected = (i == index + 1)
            tabButtons[i].BackgroundColor3 = tabs[i].Selected and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(50, 50, 50)
        end
        contentFrame.Visible = false
        contentFrames[index + 1].Visible = true
    end)
    return button
end

local tabButtons = {}
for i, tab in pairs(tabs) do
    tabButtons[i] = createTabButton(tab.Name, i - 1)
end

local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -20, 0, 330)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
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

-- Function to Create Toggle Button
local function createToggleButton(parent, text, yPos, default, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(0.9, 0, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    button.Text = text .. " (" .. (default and "ON" or "OFF") .. ")"
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    local state = default
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = text .. " (" .. (state and "ON" or "OFF") .. ")"
        button.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        callback(state)
    end)
    return button
end

-- Main Tab Functions
local autoPlant = false
local autoCollect = false
local autoSell = false
local infiniteSeeds = false
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
    local found = searchInstance(game)
    return found
end

local function startAutoPlant()
    local plantEvent = findRemoteDeep("PlantSeed")
    while autoPlant and task.wait(0.5) do
        for _, seed in pairs(LocalPlayer.Backpack:GetChildren()) do
            if seed:IsA("Tool") and seed.Name:match("Seed") then
                seed.Parent = LocalPlayer.Character
                if plantEvent then
                    pcall(function() plantEvent:FireServer(seed.Name) end)
                end
                task.wait(0.1)
            end
        end
    end
end

local function startAutoCollect()
    local harvestEvent = findRemoteDeep("HarvestPlant")
    while autoCollect and task.wait(0.3) do
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant.Name:match("Plant") and plant:IsA("Model") then
                local root = plant:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if harvestEvent then
                        pcall(function() harvestEvent:FireServer(plant) end)
                    end
                end
            end
        end
    end
end

local function startAutoSell()
    local sellEvent = findRemoteDeep("Sell_Inventory")
    while autoSell and task.wait(0.5) do
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
    while infiniteSeeds and task.wait(1) do
        if seedEvent then
            pcall(function() seedEvent:FireServer("CarrotSeed", 100) end)
        end
    end
end

-- Main Tab GUI
local yPos = 10
createToggleButton(contentFrames[1], "Auto Plant", yPos, false, function(state)
    autoPlant = state
    if state then spawn(startAutoPlant) end
end)
createToggleButton(contentFrames[1], "Auto Collect", yPos + 50, false, function(state)
    autoCollect = state
    if state then spawn(startAutoCollect) end
end)
createToggleButton(contentFrames[1], "Auto Sell", yPos + 100, false, function(state)
    autoSell = state
    if state then spawn(startAutoSell) end
end)
createToggleButton(contentFrames[1], "Infinite Seeds", yPos + 150, false, function(state)
    infiniteSeeds = state
    if state then spawn(startInfiniteSeeds) end
end)

-- Summer Event Tab Functions
local autoSubmitSummer = false
local autoHarvestSummer = false

local function startAutoSubmitSummer()
    local submitEvent = findRemoteDeep("SubmitSummerFruit")
    while autoSubmitSummer and task.wait(1) do
        for _, fruit in pairs(workspace:GetDescendants()) do
            if fruit.Name:match("SummerFruit") and fruit:IsA("Model") then
                local root = fruit:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if submitEvent then
                        pcall(function() submitEvent:FireServer(fruit) end)
                    end
                end
            end
        end
    end
end

local function startAutoHarvestSummer()
    local harvestEvent = findRemoteDeep("HarvestSummerPlant")
    while autoHarvestSummer and task.wait(0.5) do
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant.Name:match("SummerPlant") and plant:IsA("Model") then
                local root = plant:FindFirstChild("RootPart")
                if root and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 10 then
                    if harvestEvent then
                        pcall(function() harvestEvent:FireServer(plant) end)
                    end
                end
            end
        end
    end
end

-- Summer Event Tab GUI
local yPosSummer = 10
createToggleButton(contentFrames[2], "Auto Submit Summer Fruits", yPosSummer, false, function(state)
    autoSubmitSummer = state
    if state then spawn(startAutoSubmitSummer) end
end)
createToggleButton(contentFrames[2], "Auto Harvest Summer Plants", yPosSummer + 50, false, function(state)
    autoHarvestSummer = state
    if state then spawn(startAutoHarvestSummer) end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
