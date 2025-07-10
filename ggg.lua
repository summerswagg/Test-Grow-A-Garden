--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Подключение библиотек (предполагается, что Roact и RoactSpring установлены в ReplicatedStorage)
local Roact = require(ReplicatedStorage.Roact)
local RoactSpring = require(ReplicatedStorage.RoactSpring)

-- Компонент главного меню
local MainMenu = Roact.Component:extend("MainMenu")

function MainMenu:init()
	self:setState({
		isVisible = false,
		notification = "",
	})

	-- Конфигурации для анимаций
	self.springConfigs = {
		bounce = { damping = 0.7, mass = 1, stiffness = 120 }, -- Пружинящий эффект
		scale = { damping = 1, mass = 1, stiffness = 200 }, -- Масштабирование кнопок
	}
end

function MainMenu:render()
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
			UIGradient = Roact.createElement("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 46)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 80)),
				}),
				Rotation = 45,
			}),
			Header = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 60),
				BackgroundTransparency = 1,
				Text = "Главное Меню",
				TextColor3 = Color3.fromRGB(0, 255, 136),
				TextSize = 28,
				Font = Enum.Font.GothamBlack,
				TextStrokeTransparency = 0.7,
				TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
			}),
			ButtonContainer = Roact.createElement("Frame", {
				Size = UDim2.new(0.9, 0, 0, 200),
				Position = UDim2.new(0.05, 0, 0, 80),
				BackgroundTransparency = 1,
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 15),
				}),
				PlayButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 200, 0, 50),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 18,
					Font = Enum.Font.GothamBold,
					Text = "Играть",
					Scale = buttonStyles.scale,
					[Roact.Event.MouseButton1Click] = function()
						self:setState({ notification = "Игра началась!" })
						-- Логика для старта игры
					end,
					[Roact.Event.MouseEnter] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(0, 204, 255) })
					end,
					[Roact.Event.MouseLeave] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(0, 255, 136) })
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
					UIGradient = Roact.createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 136)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 204, 255)),
						}),
					}),
				}),
				SettingsButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 200, 0, 50),
					BackgroundColor3 = Color3.fromRGB(0, 255, 136),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 18,
					Font = Enum.Font.GothamBold,
					Text = "Настройки",
					Scale = buttonStyles.scale,
					[Roact.Event.MouseButton1Click] = function()
						self:setState({ notification = "Открыты настройки!" })
						-- Логика для настроек
					end,
					[Roact.Event.MouseEnter] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(0, 204, 255) })
					end,
					[Roact.Event.MouseLeave] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(0, 255, 136) })
					},
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
					UIGradient = Roact.createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 136)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 204, 255)),
						}),
					}),
				}),
				ExitButton = Roact.createElement("TextButton", {
					Size = UDim2.new(0, 200, 0, 50),
					BackgroundColor3 = Color3.fromRGB(255, 77, 77),
					TextColor3 = Color3.fromRGB(30, 30, 46),
					TextSize = 18,
					Font = Enum.Font.GothamBold,
					Text = "Выход",
					Scale = buttonStyles.scale,
					[Roact.Event.MouseButton1Click] = function()
						self:setState({ notification = "Выход из игры!" })
						-- Логика для выхода
						game:Shutdown()
					end,
					[Roact.Event.MouseEnter] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(255, 128, 128) })
					end,
					[Roact.Event.MouseLeave] = function(rbx)
						RoactSpring.tween(rbx, { BackgroundColor3 = Color3.fromRGB(255, 77, 77) })
					end,
				}, {
					UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 10) }),
					UIGradient = Roact.createElement("UIGradient", {
						Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 77, 77)),
							ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 128, 128)),
						}),
					}),
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
			[Roact.Event.AncestryChanged] = function()
				if self.state.notification ~= "" then
					task.wait(2)
					self:setState({ notification = "" })
				end
			end,
		}, {
			UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 5) }),
		}),
	})
end

function MainMenu:didMount()
	-- Начальная анимация
	self:setState({ isVisible = true })
end

-- Монтирование компонента
local player = Players.LocalPlayer
local playerGui = player.PlayerGui
local handle = Roact.mount(Roact.createElement(MainMenu), playerGui, "MainMenu")

-- Показ/скрытие меню по клавише M
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.M then
		local currentState = Roact.getElementByHandle(handle).state.isVisible
		Roact.update(handle, Roact.createElement(MainMenu, {
			isVisible = not currentState,
		}))
	end
end)
