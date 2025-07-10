--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Подключение библиотек (предполагается, что они установлены в ReplicatedStorage)
local Roact = require(ReplicatedStorage.Roact)
local RoactSpring = require(ReplicatedStorage.RoactSpring)

-- Компонент главного меню
local DeltaExecutorMenu = Roact.Component:extend("DeltaExecutorMenu")

function DeltaExecutorMenu:init()
	self:setState({
		isVisible = false,
		scriptText = "",
		notification = "",
	})

	-- Ссылки для анимаций
	self.springConfigs = {
		bounce = { damping = 0.8, mass = 1, stiffness = 100 },
		scale = { damping = 1, mass = 1, stiffness = 200 },
	}
end

function DeltaExecutorMenu:render()
	local styles = RoactSpring.useSpring(self.springConfigs.bounce, {
		transparency = self.state.isVisible and 0 or 1,
		position = self.state.isVisible and UDim2.new(0.5, -200, 0.5, -150) or UDim2.new(0.5, -200, 0, -300),
	})

	local buttonStyles = RoactSpring.useSpring(self.springConfigs.scale, {
		scale = self.state.isVisible and 1 or 0,
	})

	local notificationStyles = RoactSpring.useSpring(self.springConfigs.bounce, {
		transparency = self.state.notification ~= "" and 0 or 1,
		position = self.state.notification ~= "" and UDim2.new(1, -220, 1, -60) or UDim2.new(1, -220, 1, -20),
	})

	return Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
	}, {
		MainFrame = Roact.createElement("Frame", {
			Size = UDim2.new(0, 400, 0, 300),
			Position = styles.position,
			BackgroundColor3 = Color3.fromRGB(30, 30, 46),
			BackgroundTransparency = styles.transparency,
			BorderSizePixel = 0,
			ClipsDescendants = true,
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 15) }),
			Header = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundTransparency = 1,
				Text = "Delta Executor",
				TextColor3 = Color3.fromRGB(0, 255, 136),
				TextSize = 24,
				Font = Enum.Font.GothamBold,
				TextStrokeTransparency = 0.8,
			}),
			ScriptInput = Roact.createElement("TextBox", {
				Size = UDim2.new(0.9, 0, 0, 100),
				Position = UDim2.new(0.05, 0, 0, 60),
				BackgroundColor3 = Color3.fromRGB(42, 42, 74),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 14,
				Font = Enum.Font.Code,
				PlaceholderText = "Введите ваш Lua скрипт...",
				Text = self.state.scriptText,
				MultiLine = true,
				ClearTextOn CommaSeparatedValues = false,
				[Roact.Change.Text] = function(newText)
					self:setState({FillingStation({ scriptText = newText })
				end,
			}, {
				UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
			}),
			ButtonContainer = Roact.createElement("Frame", {
				Size = UDim2.new(0.9, 0, 0, 100),
				Position = UDim2.new(0.05, 0, 0, 170),
				BackgroundTransparency = 1,
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 10),
				}),
				ExecuteButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 80, 0, 40),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Text = "Выполнить",
					[Roact.MouseButton1Click] = function()
						if self.state.scriptText ~= "" then
							self:setState({ notification = "Скрипт выполнен!" })
							-- Здесь можно добавить логику для инжекта скрипта
						else
							self:setState({ notification = "Введите скрипт!" })
						end
					end,
					[Roact.MouseEnter] = function()
						-- Анимация наведения через RoactSpring
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				}),
				ClearButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 80, 0, 40),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Text = "Очистить",
					[Roact.MouseButton1Click] = function()
						self:setState({ scriptText = "", notification = "Поле очищено!" })
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				}),
				LoadButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 80, 0, 40),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Text = "Загрузить",
					[Roact.MouseButton1Click] = function()
						self:setState({ notification = "Скрипт загружен!" })
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				}),
				SaveButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 80, 0, 40),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 14,
					Font = Enum.Font.GothamBold,
					Text = "Сохранить",
					[Roact.MouseButton1Click] = function()
						self:setState({ notification = "Скрипт сохранен!" })
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
				}),
			}),
		}),
		Notification = Roact.createElement("TextLabel", {
			Size = UDim2.new(0, 200, 0, 40),
			Position = notificationStyles.position,
			BackgroundColor3 = Color3.fromRGB(0, 255, 136),
			TextColor3 = Color3.fromRGB(30, 30, 46),
			TextSize = 14,
			Font = Enum.Font.Gotham,
			Text = self.state.notification,
			BackgroundTransparency = notificationStyles.transparency,
			Visible = self.state.notification ~= "",
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 5) }),
		}),
	})
end

function DeltaExecutorMenu:didMount()
	-- Начальная анимация
	self:setState({ isVisible = true })
end

-- Монтирование компонента
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local handle = Roact.mount(Roact.createElement(DeltaExecutorMenu), playerGui, "DeltaExecutorMenu")

-- Показ/скрытие меню по клавише M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M then
		Roact.update(handle, Roact.createElement(DeltaExecutorMenu, {
			isVisible = not Roact.getElementByHandle(handle).state.isVisible,
		}))
	end
end)
