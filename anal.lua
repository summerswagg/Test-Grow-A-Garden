-- Enhanced Cyberpunk Menu for Roblox Injector
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Проверка на инжектор
local isInjector = pcall(function() return syn or Krnl or getgenv() end)
if not isInjector then
    warn("This script requires an injector with Lua execution support!")
    return
end

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CyberpunkMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game:GetService("CoreGui")

-- Уведомление о загрузке
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 200, 0, 50)
notificationFrame.Position = UDim2.new(1, -210, 0, 10)
notificationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
notificationFrame.BackgroundTransparency = 0.3
notificationFrame.Parent = screenGui
local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 8)
notificationCorner.Parent = notificationFrame
local notificationLabel = Instance.new("TextLabel")
notificationLabel.Size = UDim2.new(1, -10, 1, -10)
notificationLabel.Position = UDim2.new(0, 5, 0, 5)
notificationLabel.BackgroundTransparency = 1
notificationLabel.Text = "Cyberpunk Menu Loaded!"
notificationLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
notificationLabel.TextSize = 16
notificationLabel.Font = Enum.Font.Code
notificationLabel.Parent = notificationFrame
-- Анимация уведомления
local function showNotification()
    notificationFrame.Position = UDim2.new(1, 0, 0, 10)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    TweenService:Create(notificationFrame, tweenInfo, {Position = UDim2.new(1, -210, 0, 10)}):Play()
    wait(3)
    TweenService:Create(notificationFrame, tweenInfo, {Position = UDim2.new(1, 0, 0, 10)}):Play()
    wait(0.5)
    notificationFrame:Destroy()
end
spawn(showNotification)

-- Основной фрейм меню
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Анимированный градиент
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- RGB-обводка
local mainStroke = Instance.new("UIStroke")
mainStroke.Thickness = 3
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Боковая панель
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

-- Панель управления
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
local tabs = {"Home", "Settings", "Config", "Scripts", "Theme"}
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
        local strokeGoal = hover and {Color = currentTheme.strokeHover} or {Color = currentTheme.strokeBase}
        local strokeTween = TweenService:Create(stroke, tweenInfo, strokeGoal)
        strokeTween:Play()
    end
end

-- Темы
local themes = {
    NeonCyan = {
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
        }),
        strokeBase = Color3.fromRGB(0, 255, 255),
        strokeHover = Color3.fromRGB(0, 100, 255),
        textColor = Color3.fromRGB(0, 255, 255)
    },
    NeonPurple = {
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 255))
        }),
        strokeBase = Color3.fromRGB(200, 0, 255),
        strokeHover = Color3.fromRGB(100, 0, 200),
        textColor = Color3.fromRGB(200, 0, 255)
    },
    NeonRed = {
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
        }),
        strokeBase = Color3.fromRGB(255, 50, 50),
        strokeHover = Color3.fromRGB(200, 0, 0),
        textColor = Color3.fromRGB(255, 50, 50)
    },
    NeonGreen = {
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 50)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 50))
        }),
        strokeBase = Color3.fromRGB(50, 255, 50),
        strokeHover = Color3.fromRGB(0, 200, 0),
        textColor = Color3.fromRGB(50, 255, 50)
    }
}
local currentTheme = themes.NeonCyan

-- Создание вкладок
for i, tabName in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1)*60)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    button.Text = tabName
    button.TextColor3 = currentTheme.textColor
    button.TextSize = 18
    button.Font = Enum.Font.Code
    button.Parent = sideBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = currentTheme.strokeBase
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
homeLabel.Text = "Cyberpunk Injector Menu v3.0"
homeLabel.TextColor3 = currentTheme.textColor
homeLabel.TextSize = 28
homeLabel.Font = Enum.Font.Code
homeLabel.Parent = tabFrames["Home"]

local settingsLabel = Instance.new("TextLabel")
settingsLabel.Size = UDim2.new(1, -20, 0, 50)
settingsLabel.Position = UDim2.new(0, 10, 0, 10)
settingsLabel.BackgroundTransparency = 1
settingsLabel.Text = "Settings: Customize Experience"
settingsLabel.TextColor3 = currentTheme.textColor
settingsLabel.TextSize = 24
settingsLabel.Font = Enum.Font.Code
settingsLabel.Parent = tabFrames["Settings"]

-- Слайдер для выбора цвета обводки
local strokeColorLabel = Instance.new("TextLabel")
strokeColorLabel.Size = UDim2.new(1, -20, 0, 30)
strokeColorLabel.Position = UDim2.new(0, 10, 0, 70)
strokeColorLabel.BackgroundTransparency = 1
strokeColorLabel.Text = "Stroke Color:"
strokeColorLabel.TextColor3 = currentTheme.textColor
strokeColorLabel.TextSize = 18
strokeColorLabel.Font = Enum.Font.Code
strokeColorLabel.Parent = tabFrames["Settings"]

local strokeColorBox = Instance.new("TextBox")
strokeColorBox.Size = UDim2.new(0, 100, 0, 30)
strokeColorBox.Position = UDim2.new(0, 10, 0, 100)
strokeColorBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
strokeColorBox.TextColor3 = currentTheme.textColor
strokeColorBox.Text = "0,255,255"
strokeColorBox.TextSize = 16
strokeColorBox.Font = Enum.Font.Code
strokeColorBox.Parent = tabFrames["Settings"]
local strokeColorCorner = Instance.new("UICorner")
strokeColorCorner.CornerRadius = UDim.new(0, 8)
strokeColorCorner.Parent = strokeColorBox

strokeColorBox.FocusLost:Connect(function()
    local r, g, b = strokeColorBox.Text:match("(%d+),(%d+),(%d+)")
    if r and g and b then
        r, g, b = tonumber(r), tonumber(g), tonumber(b)
        if r and g and b and r <= 255 and g <= 255 and b <= 255 then
            currentTheme.strokeBase = Color3.fromRGB(r, g, b)
            currentTheme.strokeHover = Color3.fromRGB(math.max(r-50, 0), math.max(g-50, 0), math.max(b-50, 0))
            for _, button in pairs(tabButtons) do
                local stroke = button:FindFirstChild("UIStroke")
                if stroke then
                    stroke.Color = currentTab == button.Text and currentTheme.strokeHover or currentTheme.strokeBase
                end
            end
            mainStroke.Color = currentTheme.strokeBase
            sideStroke.Color = currentTheme.strokeBase
        end
    end
end)

local configTextBox = Instance.new("TextBox")
configTextBox.Size = UDim2.new(1, -20, 0, 200)
configTextBox.Position = UDim2.new(0, 10, 0, 10)
configTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
configTextBox.TextColor3 = currentTheme.textColor
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
scriptsLabel.TextColor3 = currentTheme.textColor
scriptsLabel.TextSize = 24
scriptsLabel.Font = Enum.Font.Code
scriptsLabel.Parent = tabFrames["Scripts"]

local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0, 150, 0, 40)
executeButton.Position = UDim2.new(0, 10, 0, 70)
executeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
executeButton.Text = "Execute Script"
executeButton.TextColor3 = currentTheme.textColor
executeButton.TextSize = 18
executeButton.Font = Enum.Font.Code
executeButton.Parent = tabFrames["Scripts"]
local executeCorner = Instance.new("UICorner")
executeCorner.CornerRadius = UDim.new(0, 8)
executeCorner.Parent = executeButton
local executeStroke = Instance.new("UIStroke")
executeStroke.Thickness = 1
executeStroke.Color = currentTheme.strokeBase
executeStroke.Parent = executeButton

executeButton.MouseButton1Click:Connect(function()
    local scriptText = configTextBox.Text
    if scriptText ~= "" and scriptText ~= "-- Enter your config here" then
        local success, err = pcall(function()
            loadstring(scriptText)()
        end)
        if not success then
            warn("Script execution failed: " .. tostring(err))
        end
    end
end)

-- Вкладка Theme
local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -20, 0, 50)
themeLabel.Position = UDim2.new(0, 10, 0, 10)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Theme: Select Your Style"
themeLabel.TextColor3 = currentTheme.textColor
themeLabel.TextSize = 24
themeLabel.Font = Enum.Font.Code
themeLabel.Parent = tabFrames["Theme"]

for i, themeName in ipairs({"NeonCyan", "NeonPurple", "NeonRed", "NeonGreen"}) do
    local themeButton = Instance.new("TextButton")
    themeButton.Size = UDim2.new(0, 150, 0, 40)
    themeButton.Position = UDim2.new(0, 10, 0, 60 + (i-1)*50)
    themeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    themeButton.Text = themeName
    themeButton.TextColor3 = themes[themeName].textColor
    themeButton.TextSize = 16
    themeButton.Font = Enum.Font.Code
    themeButton.Parent = tabFrames["Theme"]
    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0, 8)
    themeCorner.Parent = themeButton
    local themeStroke = Instance.new("UIStroke")
    themeStroke.Thickness = 1
    themeStroke.Color = themes[themeName].strokeBase
    themeStroke.Parent = themeButton
    
    themeButton.MouseButton1Click:Connect(function()
        currentTheme = themes[themeName]
        gradient.Color = currentTheme.gradient
        mainStroke.Color = currentTheme.strokeBase
        sideStroke.Color = currentTheme.strokeBase
        for _, button in pairs(tabButtons) do
            button.TextColor3 = currentTheme.textColor
            local stroke = button:FindFirstChild("UIStroke")
            if stroke then
                stroke.Color = currentTab == button.Text and currentTheme.strokeHover or currentTheme.strokeBase
            end
        end
        homeLabel.TextColor3 = currentTheme.textColor
        settingsLabel.TextColor3 = currentTheme.textColor
        strokeColorLabel.TextColor3 = currentTheme.textColor
        strokeColorBox.TextColor3 = currentTheme.textColor
        configTextBox.TextColor3 = currentTheme.textColor
        scriptsLabel.TextColor3 = currentTheme.textColor
        executeButton.TextColor3 = currentTheme.textColor
        executeStroke.Color = currentTheme.strokeBase
    end)
end

-- Кнопки управления
local isMinimized = false
local originalSize = mainFrame.Size
local originalPos = mainFrame.Position

createControlButton("X", UDim2.new(1, -40, 0, 5), Color3.fromRGB(255, 50, 50), function()
    mainFrame.Visible = false
end)

createControlButton("-", UDim2.new(1, -80, 0, 5), Color3.fromRGB(255, 200, 50), function()
    if isMinimized then
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(mainFrame, tweenInfo, {Size = originalSize, Position = originalPos}):Play()
        isMinimized = false
    else
        originalPos = mainFrame.Position
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 600, 0, 40), Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 0, 0)}):Play()
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

-- Исправленное перемещение меню
local dragging = false
local dragStartPos, startPos
local mouse = LocalPlayer:GetMouse()

controlBar.MouseButton1Down:Connect(function()
    dragging = true
    dragStartPos = Vector2.new(mouse.X, mouse.Y)
    startPos = mainFrame.Position
end)

mouse.Move:Connect(function()
    if dragging and not isMinimized then
        local delta = Vector2.new(mouse.X, mouse.Y) - dragStartPos
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mouse.Button1Up:Connect(function()
    dragging = false
end)

-- Открытие/закрытие по клавише T
mouse.KeyDown:Connect(function(key)
    if key:lower() == "t" then
        if mainFrame.Visible then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 1, 0)}):Play()
            wait(0.5)
            mainFrame.Visible = false
        else
            mainFrame.Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 1, 0)
            mainFrame.Visible = true
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(mainFrame, tweenInfo, {Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, 0.5, -200)}):Play()
        end
    end
end)

-- Анимация RGB-градиента для тем
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

-- Инициализация
tabFrames["Home"].Visible = true
currentTab = "Home"
animateButton(tabButtons["Home"], true)
