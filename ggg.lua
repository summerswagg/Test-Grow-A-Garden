-- Основной скрипт меню для Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DivineMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Основной контейнер меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Скругленные углы
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

-- RGB-подсветка (граница)
local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Parent = mainFrame

-- Заголовок меню
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Divine Menu"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Кнопка сворачивания/закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -80, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Parent = mainFrame

local uiCornerClose = Instance.new("UICorner")
uiCornerClose.CornerRadius = UDim.new(0, 5)
uiCornerClose.Parent = closeButton

local uiCornerMinimize = Instance.new("UICorner")
uiCornerMinimize.CornerRadius = UDim.new(0, 5)
uiCornerMinimize.Parent = minimizeButton

-- Контейнер для кнопок
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ClipsDescendants = true
buttonContainer.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = buttonContainer

-- Контейнер для уведомлений
local notificationContainer = Instance.new("Frame")
notificationContainer.Size = UDim2.new(0, 300, 1, 0)
notificationContainer.Position = UDim2.new(1, -310, 0, 0)
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

-- Функция для создания кнопки
local function createButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.SourceSans
    button.Parent = buttonContainer

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        callback()
        showNotification("Activated: " .. text, Color3.fromRGB(0, 255, 0))
    end)

    -- Анимация при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
    end)
end

-- Функция для уведомлений
local function showNotification(text, color)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, 50)
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notification.Parent = notificationContainer

    local uiCornerNotif = Instance.new("UICorner")
    uiCornerNotif.CornerRadius = UDim.new(0, 5)
    uiCornerNotif.Parent = notification

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color
    textLabel.TextSize = 16
    textLabel.Font = Enum.Font.SourceSans
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notification

    -- Анимация появления
    notification.Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset)
    TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(0, 0, 0, notification.Position.Y.Offset)}):Play()

    -- Удаление через 3 секунды
    spawn(function()
        wait(3)
        TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(1, 0, 0, notification.Position.Y.Offset)}):Play()
        wait(0.5)
        notification:Destroy()
    end)
end

-- RGB-анимация для границы
local function updateRGB()
    local time = tick()
    local r = math.sin(time * 0.5) * 127 + 128
    local g = math.sin(time * 0.5 + 2) * 127 + 128
    local b = math.sin(time * 0.5 + 4) * 127 + 128
    uiStroke.Color = Color3.fromRGB(r, g, b)
end

RunService.RenderStepped:Connect(updateRGB)

-- Анимация открытия/закрытия меню
local function toggleMenu()
    isMenuOpen = not isMenuOpen
    if isMenuOpen then
        mainFrame.Visible = true
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 300)}):Play()
        showNotification("Menu Opened", Color3.fromRGB(0, 255, 0))
    else
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
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 400, 0, 40)}):Play()
        buttonContainer.Visible = false
        showNotification("Menu Minimized", Color3.fromRGB(255, 200, 0))
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 300)}):Play()
        buttonContainer.Visible = true
        showNotification("Menu Restored", Color3.fromRGB(0, 255, 0))
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

-- Горячая клавиша для открытия/закрытия (K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        toggleMenu()
    end
end)

-- Пример кнопок с функциями
createButton("Speed Boost", function()
    player.Character.Humanoid.WalkSpeed = 32
end)

createButton("Reset Speed", function()
    player.Character.Humanoid.WalkSpeed = 16
end)

createButton("Infinite Jump", function()
    local function onJumpRequest()
        if player.Character then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
    UserInputService.JumpRequest:Connect(onJumpRequest)
end)

-- Начальная анимация появления
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Visible = true
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 300)}):Play()
