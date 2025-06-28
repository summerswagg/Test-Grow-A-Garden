-- Cyberpunk Menu for Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.Name = "CyberpunkMenu"
screenGui.ResetOnSpawn = false

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

-- Неоновый градиентный фон
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Боковая панель для вкладок
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
sideBar.BackgroundTransparency = 0.5
sideBar.Parent = mainFrame

-- Эффект свечения для боковой панели
local sideGlow = Instance.new("UIStroke")
sideGlow.Thickness = 2
sideGlow.Color = Color3.fromRGB(0, 255, 255)
sideGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sideGlow.Parent = sideBar

-- Контейнер для контента
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 500, 1, 0)
contentFrame.Position = UDim2.new(0, 100, 0, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Вкладки
local tabs = {"Home", "Settings", "Config", "Scripts"}
local tabButtons = {}
local tabFrames = {}
local currentTab = nil

-- Анимация для кнопок
local function animateButton(button, hover)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = hover and {Size = UDim2.new(1, -10, 0, 60)} or {Size = UDim2.new(1, 0, 0, 50)}
    local tween = TweenService:Create(button, tweenInfo, goal)
    tween:Play()
    
    local stroke = button:FindFirstChild("UIStroke")
    if stroke then
        local strokeGoal = hover and {Color = Color3.fromRGB(255, 0, 255)} or {Color = Color3.fromRGB(0, 255, 255)}
        local strokeTween = TweenService:Create(stroke, tweenInfo, strokeGoal)
        strokeTween:Play()
    end
end

-- Создание вкладок
for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1)*60)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    button.Text = tabName
    button.TextColor3 = Color3.fromRGB(0, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.Code
    button.Parent = sideBar
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Parent = button
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = contentFrame
    content.Name = tabName .. "Content"
    
    tabButtons[tabName] = button
    tabFrames[tabName] = content
    
    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        animateButton(button, true)
    end)
    button.MouseLeave:Connect(function()
        animateButton(button, false)
    end)
    
    -- Переключение вкладок
    button.MouseButton1Click:Connect(function()
        if currentTab ~= tabName then
            if currentTab then
                tabFrames[currentTab].Visible = false
                animateButton(tabButtons[currentTab], false)
            end
            currentTab = tabName
            tabFrames[currentTab].Visible = true
            animateButton(button, true)
        end
    end)
end

-- Контент для вкладки Home
local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, -20, 0, 50)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.Text = "Welcome to Cyberpunk Menu!"
homeLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
homeLabel.TextSize = 24
homeLabel.Font = Enum.Font.Code
homeLabel.Parent = tabFrames["Home"]

-- Контент для вкладки Settings
local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -20, 0, 50)
settingsLabel.Position = UDim2.new(0, 10, 0, 10)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings: Adjust your experience"
settingsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
settingsLabel.TextSize = 24
settingsLabel.Font = Enum.Font.Code
settingsLabel.Parent = tabFrames["Settings"]

-- Слайдер для настройки (пример)
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0, 200, 0, 20)
slider.Position = UDim2.new(0, 10, 0, 70)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
slider.Parent = tabFrames["Settings"]

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
sliderKnob.Parent = slider
local knobStroke = Instance.new("UIStroke")
knobStroke.Thickness = 2
knobStroke.Color = Color3.fromRGB(0, 255, 255)
knobStroke.Parent = sliderKnob

-- Контент для вкладки Config
local configTextBox = Instance.new("TextBox")
configTextBox.Size = UDim2.new(1, -20, 0, 200)
configTextBox.Position = UDim2.new(0, 10, 0, 10)
configTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
configTextBox.TextColor3 = Color3.fromRGB(0, 255, 255)
configTextBox.Text = "-- Enter your config here"
configTextBox.TextSize = 18
configTextBox.Font = Enum.Font.Code
configTextBox.MultiLine = true
configTextBox.Parent = tabFrames["Config"]

-- Контент для вкладки Scripts
local scriptsLabel = Instance.new("TextLabel")
scriptsLabel.Size = UDim2.new(1, -20, 0, 50)
scriptsLabel.Position = UDim2.new(0, 10, 0, 10)
scriptsLabel.BackgroundTransparency = 1
scriptsLabel.Text = "Scripts: Execute custom code"
scriptsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
scriptsLabel.TextSize = 24
scriptsLabel.Font = Enum.Font.Code
scriptsLabel.Parent = tabFrames["Scripts"]

-- Анимация появления меню
local function openMenu()
    mainFrame.Position = UDim2.new(0.5, -300, 1, 0)
    mainFrame.Visible = true
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -300, 0.5, -200)})
    tween:Play()
end

local function closeMenu()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -300, 1, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        mainFrame.Visible = false
    end)
end

-- Открытие/закрытие по клавише (например, T)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
        if mainFrame.Visible then
            closeMenu()
        else
            openMenu()
        end
    end
end)

-- Инициализация
tabFrames["Home"].Visible = true
currentTab = "Home"
animateButton(tabButtons["Home"], true)

-- Анимация градиента
local function animateGradient()
    while true do
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(gradient, tweenInfo, {Rotation = 360})
        tween:Play()
        tween.Completed:Wait()
        gradient.Rotation = 0
    end
end

spawn(animateGradient)
