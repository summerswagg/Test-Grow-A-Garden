-- Инициализация библиотеки GUI (Synapse X / Delta совместимая)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Delta GUI", "DarkTheme")

-- Основные переменные
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Создание главного окна
local MainTab = Window:NewTab("Основное")
local MainSection = MainTab:NewSection("Автоматизация для Grow A Garden")
local AutoBuyTab = Window:NewTab("Автопокупка")
local AutoBuySection = AutoBuyTab:NewSection("Настройки автопокупки")
local SettingsTab = Window:NewTab("Настройки")
local SettingsSection = SettingsTab:NewSection("Управление GUI")

-- Стилизация и анимация заголовка
local function RainbowText(label)
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(75, 0, 130),
        Color3.fromRGB(238, 130, 238)
    }
    local i = 1
    RunService.RenderStepped:Connect(function()
        local tween = TweenService:Create(label, tweenInfo, {TextColor3 = colors[i]})
        tween:Play()
        i = i % #colors + 1
    end)
end

-- Применение радужной анимации к заголовку
local titleLabel = Window.Title
RainbowText(titleLabel)

-- Функции для Grow A Garden
local autoPlant = false
local autoCollect = false
local autoSell = false
local infiniteSeeds = false
local autoBuySeeds = false
local autoBuyEggs = false
local autoBuyGear = false
local autoBuyCosmetics = false
local selectedSeed = "BasicSeed"
local selectedEgg = "BasicEgg"
local selectedGear = "BasicGear"
local selectedCosmetic = "BasicCosmetic"

-- Списки предметов для автопокупки
local seedOptions = {"BasicSeed", "RareSeed", "EpicSeed", "LegendarySeed"}
local eggOptions = {"BasicEgg", "GoldenEgg", "MysticEgg"}
local gearOptions = {"BasicGear", "AdvancedGear", "ProGear"}
local cosmeticOptions = {"BasicCosmetic", "CoolHat", "FancyShirt"}

-- Автопосадка
MainSection:NewToggle("Автопосадка", "Автоматически сажает растения", function(state)
    autoPlant = state
    if state then
        spawn(function()
            while autoPlant do
                local plots = game.Workspace.Plots:GetChildren()
                for _, plot in pairs(plots) do
                    if plot:IsA("Model") and plot:FindFirstChild("Plant") == nil then
                        game:GetService("ReplicatedStorage").Remotes.PlantSeed:FireServer(plot, selectedSeed)
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

-- Автосбор
MainSection:NewToggle("Автосбор", "Автоматически собирает урожай", function(state)
    autoCollect = state
    if state then
        spawn(function()
            while autoCollect do
                local plants = game.Workspace.Plants:GetChildren()
                for _, plant in pairs(plants) do
                    if plant:IsA("Model") and plant:FindFirstChild("Maturity") and plant.Maturity.Value >= 100 then
                        game:GetService("ReplicatedStorage").Remotes.HarvestPlant:FireServer(plant)
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

-- Автопродажа
MainSection:NewToggle("Автопродажа", "Автоматически продает урожай", function(state)
    autoSell = state
    if state then
        spawn(function()
            while autoSell do
                game:GetService("ReplicatedStorage").Remotes.SellAll:FireServer()
                wait(1)
            end
        end)
    end
end)

-- Бесконечные семена
MainSection:NewToggle("Бесконечные семена", "Дает бесконечные семена", function(state)
    infiniteSeeds = state
    if state then
        spawn(function()
            while infiniteSeeds do
                local seedCount = Player.PlayerGui.MainGui.SeedsFrame.Seeds.Text
                if tonumber(seedCount) < 100 then
                    game:GetService("ReplicatedStorage").Remotes.BuySeeds:FireServer(selectedSeed, 100)
                end
                wait(2)
            end
        end)
    end
end)

-- Автопокупка семян
AutoBuySection:NewDropdown("Выбор семян", "Выберите семена для автопокупки", seedOptions, function(selected)
    selectedSeed = selected
end)

AutoBuySection:NewToggle("Автопокупка семян", "Автоматически покупает выбранные семена", function(state)
    autoBuySeeds = state
    if state then
        spawn(function()
            while autoBuySeeds do
                game:GetService("ReplicatedStorage").Remotes.BuySeeds:FireServer(selectedSeed, 10)
                wait(5)
            end
        end)
    end
end)

-- Автопокупка яиц
AutoBuySection:NewDropdown("Выбор яиц", "Выберите яйца для автопокупки", eggOptions, function(selected)
    selectedEgg = selected
end)

AutoBuySection:NewToggle("Автопокупка яиц", "Автоматически покупает выбранные яйца", function(state)
    autoBuyEggs = state
    if state then
        spawn(function()
            while autoBuyEggs do
                game:GetService("ReplicatedStorage").Remotes.BuyEgg:FireServer(selectedEgg, 1)
                wait(5)
            end
        end)
    end
end)

-- Автопокупка снаряжения
AutoBuySection:NewDropdown("Выбор снаряжения", "Выберите снаряжение для автопокупки", gearOptions, function(selected)
    selectedGear = selected
end)

AutoBuySection:NewToggle("Автопокупка снаряжения", "Автоматически покупает выбранное снаряжение", function(state)
    autoBuyGear = state
    if state then
        spawn(function()
            while autoBuyGear do
                game:GetService("ReplicatedStorage").Remotes.BuyGear:FireServer(selectedGear, 1)
                wait(5)
            end
        end)
    end
end)

-- Автопокупка косметики
AutoBuySection:NewDropdown("Выбор косметики", "Выберите косметику для автопокупки", cosmeticOptions, function(selected)
    selectedCosmetic = selected
end)

AutoBuySection:NewToggle("Автопокупка косметики", "Автоматически покупает выбранную косметику", function(state)
    autoBuyCosmetics = state
    if state then
        spawn(function()
            while autoBuyCosmetics do
                game:GetService("ReplicatedStorage").Remotes.BuyCosmetic:FireServer(selectedCosmetic, 1)
                wait(5)
            end
        end)
    end
end)

-- Кнопка сворачивания/разворачивания
local minimized = false
SettingsSection:NewButton("Свернуть/Развернуть", "Сворачивает или разворачивает GUI", function()
    minimized = not minimized
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if minimized then
        TweenService:Create(Window.Ui, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
    else
        TweenService:Create(Window.Ui, tweenInfo, {Size = UDim2.new(0, 600, 0, 400)}):Play()
    end
end)

-- Кнопка закрытия
SettingsSection:NewButton("Закрыть GUI", "Закрывает интерфейс", function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(Window.Ui, tweenInfo, {Transparency = 1}):Play()
    wait(0.3)
    Window:Destroy()
end)

-- Перетаскивание окна
local dragging, dragStart, startPos
Window.Ui.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Window.Ui.Position
    end
end)

Window.Ui.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Window.Ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Уведомление при запуске
Library:Notify("Grow A Garden Script Loaded! Added AutoBuy Features!", 5)

-- Анти-обнаружение (минимизация сигнатур)
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldnc = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        wait(math.random(0.01, 0.05)) -- Случайная задержка для снижения подозрительности
    end
    return oldnc(self, ...)
end)
setreadonly(mt, true)
