-- Enhanced Cyberpunk Menu for Roblox
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.Name = "CyberpunkMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Закругленные углы для главного фрейма
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Анимированный RGB-градиент
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- RGB-обводка для главного фрейма
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Боковая панель для вкладок
local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 120, 1, -40)
sideBar.Position = UDim2.new(0, 0, 0, 40)
sideBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
sideBar.BackgroundTransparency = 0.5
sideBar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 10)
sideCorner.Parent = sideBar

local sideStroke = Instance.new("UIStroke")
sideStroke.Thickness = 2
sideStroke.Color = Color3.fromRGB(0, 255, 255)
sideStroke.Parent = sideBar

-- Контейнер для контента
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 480, 1, -40)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Панель управления (закрытие, сворачивание, увеличение)
local controlBar = Instance.new("Frame")
controlBar.Size = UDim2.new(1, 0, 0, 40)
controlBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
controlBar.BackgroundTransparency = 0.5
controlBar.Parent = mainFrame

local controlCorner = Instance.new("UICorner")
controlCorner.CornerRadius = UDim.new(0, 10)
controlCorner.Parent = controlBar

-- Кнопки управления
local function createControlButton(name, position, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 30, 0, 30)
    button.Position = position
    button.BackgroundColor3 = color
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Code
    button.Parent = controlBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

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
        local strokeGoal = hover and {Color = Color3.fromRGB(255 0, 255)} or {Color = Color3.fromRGB(0, 255, 255)}
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
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
    
    button.MouseEnter:Connect(function()
        animateButton(button, true)
    end)
    button.MouseLeave:Connect(function()
        if currentTab ~= tabName then
            animateButton(button, false)
        end
    end)
    
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

-- Контент для вкладок
local homeLabel = Instance.new("TextLabel")
homeLabel.Size = UDim2.new(1, -20, 0, 50)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.Text = "Cyberpunk Menu v2.0"
homeLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
homeLabel.TextSize = 28
homeLabel.Font = Enum.Font.Code
homeLabel.Parent = tabFrames["Home"]

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -20, 0, 50)
settingsLabel.Position = UDim2.new(0, 10, 0, 10)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings: Customize Experience"
settingsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
settingsLabel.TextSize = 24
settingsLabel.Font = Enum.Font.Code
settingsLabel.Parent = tabFrames["Settings"]

-- Слайдер с анимацией
local slider = Instance.new("Frame")
slider.Size = UDim2.new(0, 250, 0, 20)
slider.Position = UDim2.new(0, 10, 0, 70)
slider.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
slider.Parent = tabFrames["Settings"]
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = slider

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 20, 0, 20)
sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
sliderKnob.Parent = slider
local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 5)
knobCorner.Parent = sliderKnob
local knobStroke = Instance.new("UIStroke")
knobStroke.Thickness = 2
knobStroke.Color = Color3.fromRGB(0, 255, 255)
knobStroke.Parent = sliderKnob

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
local configCorner = Instance.new("UICorner")
configCorner.CornerRadius = UDim.new(0, 8)
configCorner.Parent = configTextBox

local scriptsLabel = Instance.new("TextLabel")
scriptsLabel.Size = UDim2.new(1, -20, 0, 50)
scriptsLabel.Position = UDim2.new(0, 10, 0, 10)
scriptsLabel.BackgroundTransparency = 1
scriptsLabel.Text = "Scripts: Execute Custom Code"
scriptsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
scriptsLabel.TextSize = 24
scriptsLabel.Font = Enum.Font.Code
scriptsLabel.Parent = tabFrames["Scripts"]

-- Логика кнопок управления
local isMinimized = false
local originalSize = mainFrame.Size
local originalPos = mainFrame.Position

createControlButton("X", UDim2.new(1, -40, 0, 5), Color3.fromRGB(255, 50, 50), function()
    mainFrame.Visible = false
end)

createControlButton("-", UDim2.new(1, -80, 0, 5), Color3.fromRGB(255, 200, 50), function()
    if isMinimized then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(mainFrame, tweenInfo, {Size = originalSize}):Play()
        isMinimized = false
    else
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 600, 0, 40)}):Play()
        isMinimized = true
    end
end)

createControlButton("□", UDim2.new(1, -120, 0, 5), Color3.fromRGB(50, 255, 50), function()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    if mainFrame.Size == UDim2.new(0, 600, 0, 400) then
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 800, 0, 600)}):Play()
    else
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 600, 0, 400)}):Play()
    end
end)

-- Перемещение меню
local dragging = false
local dragStartPos, startPos
controlBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        startPos = mainFrame.Position
    end
end)

controlBar.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Открытие/закрытие по клавише T
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.T then
        if mainFrame.Visible then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -300, 1, 0)}):Play()
            mainFrame.Visible = false
        else
            mainFrame.Position = UDim2.new(0.5, -300, 1, 0)
            mainFrame.Visible = true
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(0.5, -300, 0.5, -200)}):Play()
        end
    end
end)

-- Анимация RGB-обводок
local function animateStrokes()
    while true do
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local colors = {
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 255)
        }
        for i = 1, #colors - 1 do
            local strokeTween = TweenService:Create(mainStroke, tweenInfo, {Color = colors[i+1]})
            local sideStrokeTween = TweenService:Create(sideStroke, tweenInfo, {Color = colors[i+1]})
            for _, button in pairs(tabButtons) do
                local buttonStroke = button:FindFirstChild("UIStroke")
                if buttonStroke then
                    TweenService:Create(buttonStroke, tweenInfo, {Color = colors[i+1]}):Play()
                end
            end
            strokeTween:Play()
            sideStrokeTween:Play()
            strokeTween.Completed:Wait()
        end
    end
end

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

spawn(animateStrokes)
spawn(animateGradient)

-- Инициализация
tabFrames["Home"].Visible = true
currentTab = "Home"
animateButton(tabButtons["Home"], true)
