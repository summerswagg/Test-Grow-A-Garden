local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")

-- Создание основного GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PerfectGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Основной контейнер
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Закругленные углы
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Градиентный фон
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 50)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 50))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame
local gradientTween = TweenService:Create(Gradient, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
gradientTween:Play()

-- Неоновая обводка
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Parent = MainFrame
local strokeTween = TweenService:Create(UIStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Color = Color3.fromRGB(0, 255, 255)})
strokeTween:Play()

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Perfect GUI | Roblox"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextStrokeTransparency = 0.8
Title.Parent = MainFrame
local titleTween = TweenService:Create(Title, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {TextColor3 = Color3.fromRGB(255, 0, 255)})
titleTween:Play()

-- Контейнер для настроек
local SettingsFrame = Instance.new("ScrollingFrame")
SettingsFrame.Size = UDim2.new(1, -20, 1, -70)
SettingsFrame.Position = UDim2.new(0, 10, 0, 60)
SettingsFrame.BackgroundTransparency = 1
SettingsFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
SettingsFrame.ScrollBarThickness = 5
SettingsFrame.Parent = MainFrame

-- Лейаут для настроек
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = SettingsFrame

-- Переменные кастомизации
local guiTransparency = 0.2
local rgbSpeed = 2
local particleEnabled = false
local currentTheme = "Dark"
local buttonHoverScale = 1.1
local shadowEnabled = true

-- Функция создания кастомной кнопки
local function createButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 16
    Button.Font = Enum.Font.Gotham
    Button.BorderSizePixel = 0
    Button.Parent = SettingsFrame
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Thickness = 2
    ButtonStroke.Color = Color3.fromRGB(100, 100, 255)
    ButtonStroke.Parent = Button
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(100, 100, 255), Size = UDim2.new(1, -20, 0, 40 * buttonHoverScale)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(30, 30, 60), Size = UDim2.new(1, -20, 0, 40)}):Play()
    end)
    Button.Activated:Connect(callback)
    return Button
end

-- Функция создания слайдера
local function createSlider(text, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -20, 0, 60)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = SettingsFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.Parent = SliderFrame
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 10)
    SliderBar.Position = UDim2.new(0, 0, 0, 30)
    SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    SliderBar.Parent = SliderFrame
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 5)
    SliderCorner.Parent = SliderBar
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.Parent = SliderBar
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 5)
    FillCorner.Parent = SliderFill
    local dragging = false
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barWidth = SliderBar.AbsoluteSize.X
            local relativeX = math.clamp((mouseX - barPos) / barWidth, 0, 1)
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            local value = min + (max - min) * relativeX
            callback(value)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return SliderFrame
end

-- Функция создания переключателя
local function createToggle(text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = SettingsFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.8, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(0.85, 0, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleButton
    local state = false
    ToggleButton.Activated:Connect(function()
        state = not state
        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)}):Play()
        callback(state)
    end)
    return ToggleFrame
end

-- Функция создания выпадающего списка
local function createDropdown(text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -20, 0, 40)
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Parent = SettingsFrame
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 16
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0.5, 0, 0, 30)
    DropdownButton.Position = UDim2.new(0.5, 0, 0.5, -15)
    DropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    DropdownButton.Text = options[1]
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 14
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.Parent = DropdownFrame
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownButton
    local DropdownList = Instance.new("Frame")
    DropdownList.Size = UDim2.new(0.5, 0, 0, #options * 30)
    DropdownList.Position = UDim2.new(0.5, 0, 1, 0)
    DropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    DropdownList.Visible = false
    DropdownList.Parent = DropdownFrame
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = DropdownList
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 14
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Parent = DropdownList
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(100, 100, 255)}):Play()
        end)
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(30, 30, 60)}):Play()
        end)
        OptionButton.Activated:Connect(function()
            DropdownButton.Text = option
            DropdownList.Visible = false
            callback(option)
        end)
    end
    DropdownButton.Activated:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
    return DropdownFrame
end

-- Функция создания частиц
local function createParticles()
    local ParticleFrame = Instance.new("Frame")
    ParticleFrame.Size = UDim2.new(1, 0, 1, 0)
    ParticleFrame.BackgroundTransparency = 1
    ParticleFrame.Parent = MainFrame
    for i = 1, 10 do
        local Particle = Instance.new("Frame")
        Particle.Size = UDim2.new(0, 5, 0, 5)
        Particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        Particle.Parent = ParticleFrame
        local ParticleCorner = Instance.new("UICorner")
        ParticleCorner.CornerRadius = UDim.new(1, 0)
        ParticleCorner.Parent = Particle
        spawn(function()
            while particleEnabled do
                local tweenInfo = TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Sine)
                TweenService:Create(Particle, tweenInfo, {Position = UDim2.new(math.random(), 0, math.random(), 0), BackgroundColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))}):Play()
                wait(math.random(2, 5))
            end
        end)
    end
    return ParticleFrame
end

-- Настройки кастомизации
createSlider("Прозрачность GUI", 0, 1, function(value)
    guiTransparency = value
    MainFrame.BackgroundTransparency = value
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Прозрачность: " .. string.format("%.2f", value)
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createSlider("Скорость RGB", 1, 10, function(value)
    rgbSpeed = value
    titleTween:Cancel()
    strokeTween:Cancel()
    gradientTween:Cancel()
    titleTween = TweenService:Create(Title, TweenInfo.new(value, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {TextColor3 = Color3.fromRGB(255, 0, 255)})
    strokeTween = TweenService:Create(UIStroke, TweenInfo.new(value, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Color = Color3.fromRGB(0, 255, 255)})
    gradientTween = TweenService:Create(Gradient, TweenInfo.new(value * 2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
    titleTween:Play()
    strokeTween:Play()
    gradientTween:Play()
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Скорость RGB: " .. string.format("%.1f", value)
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createDropdown("Тема GUI", {"Dark", "Light", "Neon", "Pastel"}, function(theme)
    currentTheme = theme
    if theme == "Dark" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 50)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 100, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 50))
        })
    elseif theme == "Light" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        })
    elseif theme == "Neon" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
        })
    elseif theme == "Pastel" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(200, 180, 255)
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 180, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 220, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 180, 255))
        })
    end
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Тема: " .. theme
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createToggle("Частицы", function(state)
    particleEnabled = state
    if state then
        createParticles()
    else
        local particleFrame = MainFrame:FindFirstChildOfClass("Frame")
        if particleFrame then particleFrame:Destroy() end
    end
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Частицы: " .. (state and "Вкл" or "Выкл")
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createToggle("Динамические тени", function(state)
    shadowEnabled = state
    if state then
        UIStroke.Enabled = true
    else
        UIStroke.Enabled = false
    end
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Тени: " .. (state and "Вкл" or "Выкл")
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createSlider("Масштаб кнопок при наведении", 1, 1.5, function(value)
    buttonHoverScale = value
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = "Масштаб кнопок: " .. string.format("%.2f", value)
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createButton("Свернуть/Развернуть", function()
    local minimized = MainFrame.Size.X.Offset == 50
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if minimized then
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 400, 0, 300)}):Play()
        SettingsFrame.Visible = true
        Title.Visible = true
    else
        TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
        SettingsFrame.Visible = false
        Title.Visible = false
    end
    local notify = Instance.new("TextLabel")
    notify.Size = UDim2.new(0, 200, 0, 50)
    notify.Position = UDim2.new(0.5, -100, 0, 10)
    notify.BackgroundTransparency = 1
    notify.Text = minimized and "Развернуто" or "Свернуто"
    notify.TextColor3 = Color3.fromRGB(255, 255, 255)
    notify.TextSize = 14
    notify.Font = Enum.Font.Gotham
    notify.Parent = ScreenGui
    wait(2)
    notify:Destroy()
end)

createButton("Закрыть GUI", function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    for _, child in pairs(MainFrame:GetChildren()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        end
    end
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Перетаскивание окна
local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Уведомление при запуске
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 200, 0, 50)
notify.Position = UDim2.new(0.5, -100, 0, 10)
notify.BackgroundTransparency = 1
notify.Text = "Perfect GUI Loaded!"
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.TextSize = 16
notify.Font = Enum.Font.Gotham
notify.Parent = ScreenGui
wait(3)
notify:Destroy()
