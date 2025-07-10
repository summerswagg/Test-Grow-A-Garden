local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "MainMenu"
screenGui.ResetOnSpawn = false

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.4, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.3, 0, -0.5, 0) -- Изначально вне экрана
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Добавляем уголки и тень
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(100, 100, 100)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Main Menu"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Функция создания кнопки
local function createButton(text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.15, 0)
    button.Position = UDim2.new(0.1, 0, yPos, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(150, 150, 150)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button

    -- Анимации кнопки
    local hoverTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local clickTweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(70, 70, 70),
            Size = UDim2.new(0.82, 0, 0.16, 0)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, hoverTweenInfo, {
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Size = UDim2.new(0.8, 0, 0.15, 0)
        }):Play()
    end)

    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, clickTweenInfo, {
            Size = UDim2.new(0.78, 0, 0.14, 0)
        }):Play()
    end)

    button.MouseButton1Up:Connect(function()
        TweenService:Create(button, clickTweenInfo, {
            Size = UDim2.new(0.82, 0, 0.16, 0)
        }):Play()
        callback()
    end)

    return button
end

-- Анимация появления меню
local appearTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
TweenService:Create(mainFrame, appearTweenInfo, {
    Position = UDim2.new(0.3, 0, 0.25, 0)
}):Play()

-- Создаем кнопки
local playButton = createButton("Play", 0.3, function()
    print("Play button clicked!")
    -- Здесь можно добавить логику начала игры
end)

local settingsButton = createButton("Settings", 0.5, function()
    print("Settings button clicked!")
    -- Здесь можно добавить открытие настроек
end)

local quitButton = createButton("Quit", 0.7, function()
    game:Shutdown()
end)

-- Горячая клавиша для показа/скрытия меню
local menuVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        menuVisible = not menuVisible
        local targetPos = menuVisible and UDim2.new(0.3, 0, 0.25, 0) or UDim2.new(0.3, 0, -0.5, 0)
        TweenService:Create(mainFrame, appearTweenInfo, {Position = targetPos}):Play()
    end
end)
