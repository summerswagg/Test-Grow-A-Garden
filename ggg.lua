-- Основной скрипт меню для Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DivineMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Основной контейнер меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Скругленные углы
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- RGB-подсветка (граница)
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 3
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Parent = mainFrame

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 0, 50)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Divine Menu"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 28
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Кнопки управления
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -45, 0, 7.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 35, 0, 35)
minimizeButton.Position = UDim2.new(1, -90, 0, 7.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = mainFrame

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(0, 35, 0, 35)
settingsButton.Position = UDim2.new(1, -135, 0, 7.5)
settingsButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
settingsButton.Text = "⚙"
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.TextSize = 20
settingsButton.Font = Enum.Font.SourceSansBold
settingsButton.Parent = mainFrame

local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(0, 8)
uiCornerClose.Parent = closeButton

local uiCornerMinimize = Instance.new("UICorner")
uiCornerMinimize.CornerRadius = UDim.new(0, 8)
uiCornerMinimize.Parent = minimizeButton

local uiCornerSettings = Instance.new("UICorner")
uiCornerSettings.CornerRadius = UDim.new(0, 8)
uiCornerSettings.Parent = settingsButton

-- Контейнер для основного контента
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -70)
contentFrame.Position = UDim2.new(0, 10, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame

-- Контейнер для кнопок
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, 0, 1, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 5
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 300)
buttonContainer.Parent = contentFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = buttonContainer

-- Боковая вкладка настроек
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(0, 200, 0, 350)
settingsFrame.Position = UDim2.new(1, 200, 0, 0)
settingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
settingsFrame.BorderSizePixel = 0
settingsFrame.Visible = false
settingsFrame.Parent = mainFrame

local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 12)
settingsCorner.Parent = settingsFrame

local settingsStroke = Instance.new("UIStroke")
settingsStroke.Thickness = 3
settingsStroke.Color = Color3.fromRGB(255, 255, 255)
settingsStroke.Parent = settingsFrame

local settingsScrollcredible

local settingsListLayout = Instance.new("UIListLayout")
settingsListLayout.Padding = UDim.new(0, 10)
settingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsListLayout.Parent = settingsFrame

-- Контейнер для уведомлений
local notificationContainer = Instance.new("Frame")
notificationContainer.Size = UDim2.new(0, 350, 1, 0)
notificationContainer.Position = UDim2.new(1, -360, 0, 0)
notificationContainer.BackgroundTransparency = 1
notificationContainer.Parent = screenGui

local notificationListLayout = Instance.new("UIListLayout")
notificationListLayout.Padding = UDim.new(0, 10)
notificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
notificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notificationListLayout.Parent = notificationContainer

-- Состояние меню
local isMenuOpen = true
local isMinimized = false
local isDragging = false
local dragStart = nil
local startPos = nil
local isSettingsOpen = false

-- Темы оформления
local themes = {
    Dark = {Background = Color3.fromRGB(25, 25, 35), Button = Color3.fromRGB(35, 35, 45), Text = Color3.fromRGB(255, 255, 255)},
    Light = {Background = Color3.fromRGB(240, 240, 240), Button = Color3.fromRGB(200, 200, 200), Text = Color3.fromRGB(0, 0, 0)},
    Neon = {Background = Color3.fromRGB(10, 10, 20), Button = Color3.fromRGB(20, 20, 30), Text = Color3.fromRGB(0, 255, 255)},
    Pastel = {Background = Color3.fromRGB(200, 220, 255), Button = Color3.fromRGB(180, 200, 240), Text = Color3.fromRGB(50, 50, 50)},
}

-- RGB-режимы
local rgbModes = {
    Rainbow = function(t) 
        local r = math.sin(t * 0.5) * 127 + 128
        local g = math.sin(t * 0.5 + 2) * 127 + 128
        local b = math.sin(t * 0.5 + 4) * 127 + 128
        return Color3.fromRGB(r, g, b)
    end,
    Pulse = function(t)
        local v = (math.sin(t * 2) + 1) / 2 * 255
        return Color3.fromRGB(v, v, v)
    end,
    Fire = function(t)
        local r = math.min(255, math.sin(t * 0.5) * 255 + 100)
        local g = math.min(255, math.sin(t * 0.5 + 2) * 100)
        local b = 0
        return Color3.fromRGB(r, g, b)
    end,
    Ocean = function(t)
        local r = 0
        local g = math.sin(t * 0.5 + 2) * 127 + 128
        local b = math.sin(t * 0.5 + 4) * 127 + 128
        return Color3.fromRGB(r, g, b)
    end,
}

local currentTheme = themes.Dark
local currentRGBMode = rgbModes.Rainbow

-- Функция для создания кнопки
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 45)
    button.BackgroundColor3 = currentTheme.Button
    button.Text = text
    button.TextColor3 = currentTheme.Text
    button.TextSize = 20
    button.Font = Enum.Font.SourceSans
    button.Parent = buttonContainer

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        callback()
        showNotification("Activated: " .. text, Color3.fromRGB(0, 255, 0))
    end)

    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = currentTheme.Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = currentTheme.Button}):Play()
    end)

    -- Обновление CanvasSize
    buttonContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end

-- Функция для создания кнопки настроек
local function createSettingsButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = currentTheme.Button
    button.Text = text
    button.TextColor3 = currentTheme.Text
    button.TextSize = 18
    button.Font = Enum.Font.SourceSans
    button.Parent = settingsFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        callback()
        showNotification("Changed: " .. text, Color3.fromRGB(0, 200, 255))
    end)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = currentTheme.Button:Lerp(Color3.fromRGB(255, 255, 255), 0.2)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = currentTheme.Button}):Play()
    end)
end

-- Функция для уведомлений
local function showNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, 60)
    notification.BackgroundColor3 = currentTheme.Background
    notification.BackgroundTransparency = 0.1
    notification.Parent = notificationContainer

    local uiCornerNotif = Instance.new("UICorner")
    uiCornerNotif.CornerRadius = UDim.new(0, 10)
    uiCornerNotif.Parent = notification

    local uiStrokeNotif = Instance.new("UIStroke")
    uiStrokeNotif.Thickness = 2
    uiStrokeNotif.Color = color
    uiStrokeNotif.Parent = notification

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -20)
    textLabel.Position = UDim2.new(0, 10, 0, 10)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = currentTheme.Text
    textLabel.TextSize = 18
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notification

    -- Анимация появления
    notification.Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset)
    notification.BackgroundTransparency = 1
    TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, notification.Position.Y.Offset), BackgroundTransparency = 0.1}):Play()

    -- Удаление через 4 секунды
    spawn(function()
        wait(4)
        TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset), BackgroundTransparency = 1}):Play()
        wait(0.5)
        notification:Destroy()
    end)
end

-- Обновление темы
local function applyTheme(theme)
    currentTheme = theme
    mainFrame.BackgroundColor3 = theme.Background
    settingsFrame.BackgroundColor3 = theme.Background
    titleLabel.TextColor3 = theme.Text
    for _, button in pairs(buttonContainer:GetChildren()) do
        if button:IsA("TextButton") then
            button.BackgroundColor3 = theme.Button
            button.TextColor3 = theme.Text
        end
    end
    for _, button in pairs(settingsFrame:GetChildren()) do
        if button:IsA("TextButton") then
            button.BackgroundColor3 = theme.Button
            button.TextColor3 = theme.Text
        end
    end
end

-- RGB-анимация для границы
local function updateRGB()
    local time = tick()
    uiStroke.Color = currentRGBMode(time)
    settingsStroke.Color = currentRGBMode(time)
end

RunService.RenderStepped:Connect(updateRGB)

-- Анимация открытия/закрытия меню
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 350)}):Play()
        showNotification("Menu Opened", Color3.fromRGB(0, 255, 0))
    else
        if isSettingsOpen then
            toggleSettings()
        end
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 400, 0, 0)}):Play()
        wait(0.5)
        mainFrame.Visible = false
        showNotification("Menu Closed", Color3.fromRGB(255, 0, 0))
    end
end

-- Анимация сворачивания
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        if isSettingsOpen then
            toggleSettings()
        end
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 400, 0, 50)}):Play()
        contentFrame.Visible = false
        showNotification("Menu Minimized", Color3.fromRGB(255, 200, 0))
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 350)}):Play()
        contentFrame.Visible = true
        showNotification("Menu Restored", Color3.fromRGB(0, 255, 0))
    end
end

-- Анимация вкладки настроек
local function toggleSettings()
    isSettingsOpen = not isSettingsOpen
    settingsFrame.Visible = isSettingsOpen
    if isSettingsOpen then
        settingsFrame.Position = UDim2.new(1, 200, 0, 0)
        TweenService:Create(settingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        showNotification("Settings Opened", Color3.fromRGB(0, 200, 255))
    else
        TweenService:Create(settingsFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Position = UDim2.new(1, 200, 0, 0)}):Play()
        wait(0.5)
        settingsFrame.Visible = false
        showNotification("Settings Closed", Color3.fromRGB(0, 200, 255))
    end
end

-- Перетаскивание меню
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and not isMinimized then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Обработка кнопок
closeButton.MouseButton1Click:Connect(toggleMenu)
minimizeButton.MouseButton1Click:Connect(toggleMinimize)
settingsButton.MouseButton1Click:Connect(toggleSettings)

-- Горячая клавиша для открытия/закрытия (K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        toggleMenu()
    end
end)

-- Создание кнопок главного меню
createButton("Teleport to Center", function()
    if player.Character then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0, 5, 0))
        showNotification("Teleported to center", Color3.fromRGB(0, 255, 0))
    end
end)

createButton("God Mode", function()
    if player.Character then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
        showNotification("God Mode enabled", Color3.fromRGB(0, 255, 0))
    end
end)

createButton("Reset Character", function()
    if player.Character then
        player:LoadCharacter()
        showNotification("Character reset", Color3.fromRGB(0, 255, 0))
    end
end)

createButton("Night Vision", function()
    local nightVision = Instance.new("ColorCorrectionEffect")
    nightVision.Brightness = 0.1
    nightVision.Contrast = 0.2
    nightVision.Saturation = 0.1
    nightVision.TintColor = Color3.fromRGB(200, 255, 200)
    nightVision.Parent = Lighting
    showNotification("Night Vision enabled", Color3.fromRGB(0, 255, 0))
end)

createButton("Clear Lighting Effects", function()
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("ColorCorrectionEffect") then
            effect:Destroy()
        end
    end
    showNotification("Lighting effects cleared", Color3.fromRGB(0, 255, 0))
end)

createButton("High Jump", function()
    if player.Character then
        player.Character.Humanoid.JumpPower = 100
        showNotification("High Jump enabled", Color3.fromRGB(0, 255, 0))
    end
end)

-- Создание кнопок настроек
for themeName, theme in pairs(themes) do
    createSettingsButton("Theme: " .. themeName, function()
        applyTheme(theme)
    end)
end

for rgbName, rgbFunc in pairs(rgbModes) do
    createSettingsButton("RGB: " .. rgbName, function()
        currentRGBMode = rgbFunc
    end)
end

-- Начальная анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 350)}):Play()
showNotification("Welcome to Divine Menu!", Color3.fromRGB(0, 200, 255))
