-- Minimal Grow a Garden Script for Delta Executor
-- Test: Auto Plant with Debug
-- Note: Use at your own risk, as scripting violates Roblox Terms of Service

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "GrowAGardenGUI"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.new(0.05, 0, 0, 30)
button.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
button.Text = "Toggle Auto Plant"
button.TextColor3 = Color3.new(0, 0, 0)
button.Font = Enum.Font.GothamSemibold
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

-- Variables
local autoPlant = false

-- Deep Search for RemoteEvents
local function findRemoteDeep(eventName)
    local function searchInstance(instance)
        for _, v in pairs(instance:GetDescendants()) do
            if v:IsA("RemoteEvent") and v.Name:lower():match(eventName:lower()) then
                print("Found RemoteEvent: " .. v:GetFullName())
                return v
            end
        end
        return nil
    end
    print("Searching for " .. eventName .. " in game...")
    local found = searchInstance(game)
    if not found then
        warn("No RemoteEvent found for '" .. eventName .. "'!")
    end
    return found
end

-- Auto Plant Function
local function startAutoPlant()
    local plantEvent = findRemoteDeep("PlantSeed")
    while autoPlant and task.wait(0.5) do
        for _, seed in pairs(LocalPlayer.Backpack:GetChildren()) do
            if seed:IsA("Tool") and seed.Name:match("Seed") then
                seed.Parent = LocalPlayer.Character
                if plantEvent and plantEvent:IsA("RemoteEvent") then
                    pcall(function() plantEvent:FireServer(seed.Name) end)
                    print("Attempted to plant: " .. seed.Name)
                else
                    print("PlantEvent not available or not a RemoteEvent")
                end
                task.wait(0.1)
            end
        end
    end
end

-- Button Action
button.MouseButton1Click:Connect(function()
    autoPlant = not autoPlant
    if autoPlant then
        spawn(startAutoPlant)
        print("Auto Plant toggled ON")
    else
        print("Auto Plant toggled OFF")
    end
end)

-- Initial Debug
print("Script loaded at " .. os.time())
