--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Основной GUI
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaExecutorMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Главный контейнер
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 46)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Visible = false

-- Закругленные углы
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = mainFrame

-- Заголовок
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 50)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundTransparency = 1
header.Text = "Delta Executor"
header.TextColor3 = Color3.fromRGB(0, 255, 136)
header.TextSize = 24
header.Font = Enum.Font.GothamBold
header.TextStrokeTransparency = 0.8
header.Parent = mainFrame

-- Поле для ввода скрипта
local scriptInput = Instance.new("TextBox")
scriptInput.Size = UDim2.new(0.9, 0, 0, 100)
scriptInput.Position = UDim2.new(0.05, 0, 0, 60)
scriptInput.BackgroundColor3 = Color3.fromRGB(42, 42, 74)
scriptInput.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptInput.TextSize = 14
scriptInput.Font = Enum.Font.Code
scriptInput.PlaceholderText = "Введите ваш Lua скрипт..."
scriptInput.Text = ""
scriptInput.MultiLine = true
scriptInput.ClearTextOnFocus = false
scriptInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = scriptInput

-- Контейнер для кнопок
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0.9, 0, 0, 100)
buttonContainer.Position = UDim2.new(0.05, 0, 0, 170)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = buttonContainer

-- Функция создания кнопки
local function createButton(name: string, callback: () -> ())
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 80, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
	button.TextColor3 = Color3.fromRGB(30, 30, 46)
	button.TextSize = 14
	button.Font = Enum.Font.GothamBold
	button.Text = name
	button.Parent = buttonContainer

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button

	-- Эффекты наведения
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(0, 204, 255),
			Size = UDim2.new(0, 85, 0, 45)
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(0, 255, 136),
			Size = UDim2.new(0, 80, 0, 40)
		}):Play()
	end)

	button.Activated:Connect(callback)
	return button
end

-- Уведомление
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 200, 0, 40)
notification.Position = UDim2.new(1, -220, 1, -60)
notification.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
notification.TextColor3 = Color3.fromRGB(30, 30, 46)
notification.TextSize = 14
notification.Font = Enum.Font.Gotham
notification.Text = ""
notification.Visible = false
notification.Parent = screenGui

local notifCorner = Instance.new("UICorner")
notifCorner.CornerRadius = UDim.new(0, 5)
notifCorner.Parent = notification

-- Функция показа уведомления
local function showNotification(message: string)
	notification.Text = message
	notification.Visible = true
	local tweenIn = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -220, 1, -60),
		BackgroundTransparency = 0
	})
	tweenIn:Play()
	tweenIn.Completed:Wait()
	task.wait(2)
	local tweenOut = TweenService:Create(notification, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -220, 1, -20),
		BackgroundTransparency = 1
	})
	tweenOut:Play()
	tweenOut.Completed:Connect(function()
		notification.Visible = false
	end)
end

-- Кнопки
createButton("Выполнить", function()
	local script = scriptInput.Text
	if script ~= "" then
		showNotification("Скрипт выполнен!")
		-- Здесь можно добавить логику для инжекта скрипта через Delta Executor
	else
		showNotification("Введите скрипт!")
	end
end)

createButton("Очистить", function()
	scriptInput.Text = ""
	showNotification("Поле очищено!")
end)

createButton("Загрузить", function()
	showNotification("Скрипт загружен!")
	-- Заглушка для загрузки скрипта
end)

createButton("Сохранить", function()
	showNotification("Скрипт сохранен!")
end)

-- Анимация появления меню
local function showMenu()
	mainFrame.Visible = true
	TweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -200, 0.5, -150),
		BackgroundTransparency = 0.05
	}):Play()
	for _, button in ipairs(buttonContainer:GetChildren()) do
		if button:IsA("TextButton") then
			button.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(button, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 80, 0, 40)
			}):Play()
			task.wait(0.1)
		end
	end
end

-- Показ меню при нажатии клавиши (например, "M")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M then
		if mainFrame.Visible then
			TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(0.5, -200, 0, -300),
				BackgroundTransparency = 1
			}):Play()
			task.wait(0.5)
			mainFrame.Visible = false
		else
			showMenu()
		end
	end
end)

-- Инициализация
showMenu()
