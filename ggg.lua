-- Инициализация библиотеки GUI (Kavo UI с кастомными улучшениями)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Grow A Garden | Perfect GUI", "DarkTheme")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

-- Настройка кастомного стиля GUI
local function applyCustomStyle(uiElement)
    local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local colors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(255, 127, 0),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(127, 0, 255)
    }
    local i = 1
    RunService.RenderStepped:Connect(function()
        local tween = TweenService:Create(uiElement, tweenInfo, {BackgroundColor3 = colors[i]})
        tween:Play()
        i = i % #colors + 1
    end)
end

-- Анимация неоновой подсветки для кнопок
local function neonButtonEffect(button)
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end

-- Применение градиентного фона к окну
local function applyGradientBackground(ui)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 50))
    })
    gradient.Rotation = 45
    gradient.Parent = ui
    local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(gradient, tweenInfo, {Rotation = 360}):Play()
end

-- Инициализация GUI
applyGradientBackground(Window.Ui)
applyCustomStyle(Window.Title)
local SettingsTab = Window:NewTab("Настройки")
local GameplaySection = SettingsTab:NewSection("Игровые функции")
local CustomizationSection = SettingsTab:NewSection("Кастомизация GUI")

-- Игровые переменные
local autoPlant = false
local autoCollect = false
local autoSell = false
local infiniteSeeds = false
local autoBuySeeds = false
local autoBuyEggs = false
local autoBuyGear = false
local autoBuyCosmetics = false
local selectedSeed = "Carrot"
local selectedEgg = "CommonEgg"
local selectedGear = "CommonGear"
local selectedCosmetic = "CommonCosmetic"
local guiTransparency = 0.2
local rgbSpeed = 2
local selectedTheme = "DarkTheme"

-- Списки предметов с редкостями
local seedOptions = {
    ["Common"] = {"Carrot", "Strawberry", "Blueberry"},
    ["Uncommon"] = {"Rose", "Orange Tulip", "Tomato"},
    ["Rare"] = {"Cauliflower", "Raspberry", "Foxglove"},
    ["Legendary"] = {"Corn", "Paradise Petal", "Watermelon"},
    ["Mythical"] = {"Avocado", "Green Apple", "Banana"},
    ["Divine"] = {"Pepper", "Cacao", "Moon Blossom"},
    ["Prismatic"] = {"Elephant Ears", "Rosy Delight"}
}
local flatSeedOptions = {}
for _, seeds in pairs(seedOptions) do
    for _, seed in pairs(seeds) do
        table.insert(flatSeedOptions, seed)
    end
end

local eggOptions = {
    ["Common"] = {"CommonEgg"},
    ["Uncommon"] = {"UncommonEgg"},
    ["Rare"] = {"RareEgg"},
    ["Legendary"] = {"LegendaryEgg"},
    ["Mythical"] = {"MythicalEgg"},
    ["Divine"] = {"DivineEgg"},
    ["Prismatic"] = {"PrismaticEgg"}
}
local flatEggOptions = {}
for _, eggs in pairs(eggOptions) do
    for _, egg in pairs(eggs) do
        table.insert(flatEggOptions, egg)
    end
end

local gearOptions = {
    ["Common"] = {"CommonGear"},
    ["Uncommon"] = {"UncommonGear"},
    ["Rare"] = {"RareGear"},
    ["Legendary"] = {"LegendaryGear"},
    ["Mythical"] = {"MythicalGear"},
    ["Divine"] = {"DivineGear"},
    ["Prismatic"] = {"PrismaticGear"}
}
local flatGearOptions = {}
for _, gears in pairs(gearOptions) do
    for _, gear in pairs(gears) do
        table.insert(flatGearOptions, gear)
    end
end

local cosmeticOptions = {
    ["Common"] = {"CommonCosmetic"},
    ["Uncommon"] = {"UncommonCosmetic"},
    ["Rare"] = {"RareCosmetic"},
    ["Legendary"] = {"LegendaryCosmetic"},
    ["Mythical"] = {"MythicalCosmetic"},
    ["Divine"] = {"DivineCosmetic"},
    ["Prismatic"] = {"PrismaticCosmetic"}
}
local flatCosmeticOptions = {}
for _, cosmetics in pairs(cosmeticOptions) do
    for _, cosmetic in pairs(cosmetics) do
        table.insert(flatCosmeticOptions, cosmetic)
    end
end

-- Функция проверки валюты
local function getPlayerMoney()
    local money = Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Money")
    return money and tonumber(money.Value) or 0
end

-- Функция покупки с отладкой
local function purchaseItem(itemType, itemName, amount)
    local success, result = pcall(function()
        ReplicatedStorage.Remotes.PurchaseItem:FireServer({Type = itemType, Item = itemName, Amount = amount})
    end)
    if success then
        Library:Notify("Покупка: " .. itemType .. " - " .. itemName .. " (x" .. amount .. ")", 3)
    else
        Library:Notify("Ошибка покупки " .. itemType .. ": " .. tostring(result), 5)
    end
end

-- Игровые функции
GameplaySection:NewToggle("Автопосадка", "Автоматически сажает растения", function(state)
    autoPlant = state
    if state then
        spawn(function()
            while autoPlant do
                local plots = game.Workspace.Plots:GetChildren()
                for _, plot in pairs(plots) do
                    if plot:IsA("Model") and plot:FindFirstChild("Plant") == nil then
                        local success, result = pcall(function()
                            ReplicatedStorage.Remotes.PlantSeed:FireServer(plot, selectedSeed)
                        end)
                        if not success then
                            Library:Notify("Ошибка посадки: " .. tostring(result), 5)
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

GameplaySection:NewToggle("Автосбор", "Автоматически собирает урожай", function(state)
    autoCollect = state
    if state then
        spawn(function()
            while autoCollect do
                local plants = game.Workspace.Plants:GetChildren()
                for _, plant in pairs(plants) do
                    if plant:IsA("Model") and plant:FindFirstChild("Maturity") and plant.Maturity.Value >= 100 then
                        local success, result = pcall(function()
                            ReplicatedStorage.Remotes.HarvestPlant:FireServer(plant)
                        end)
                        if not success then
                            Library:Notify("Ошибка сбора: " .. tostring(result), 5)
                        end
                    end
                end
                wait(0.3)
            end
        end)
    end
end)

GameplaySection:NewToggle("Автопродажа", "Автоматически продает урожай", function(state)
    autoSell = state
    if state then
        spawn(function()
            while autoSell do
                local success, result = pcall(function()
                    ReplicatedStorage.Remotes.SellAll:FireServer()
                end)
                if not success then
                    Library:Notify("Ошибка продажи: " .. tostring(result), 5)
                end
                wait(1)
            end
        end)
    end
end)

GameplaySection:NewToggle("Бесконечные семена", "Дает бесконечные семена", function(state)
    infiniteSeeds = state
    if state then
        spawn(function()
            while infiniteSeeds do
                local seedCount = Player.PlayerGui.MainGui.SeedsFrame.Seeds.Text
                if tonumber(seedCount) < 100 then
                    if getPlayerMoney() >= 100 then
                        purchaseItem("Seed", selectedSeed, 100)
                    else
                        Library:Notify("Недостаточно денег для покупки семян!", 5)
                    end
                end
                wait(2)
            end
        end)
    end
end)

GameplaySection:NewDropdown("Выбор семян", "Выберите семена для автопокупки и посадки", flatSeedOptions, function(selected)
    selectedSeed = selected
    Library:Notify("Выбрано семя: " .. selected, 3)
end)

GameplaySection:NewToggle("Автопокупка семян", "Автоматически покупает выбранные семена", function(state)
    autoBuySeeds = state
    if state then
        spawn(function()
            while autoBuySeeds do
                if getPlayerMoney() >= 50 then
                    purchaseItem("Seed", selectedSeed, 10)
                else
                    Library:Notify("Недостаточно денег для покупки семян!", 5)
                end
                wait(5)
            end
        end)
    end
end)

GameplaySection:NewDropdown("Выбор яиц", "Выберите яйца для автопокупки", flatEggOptions, function(selected)
    selectedEgg = selected
    Library:Notify("Выбрано яйцо: " .. selected, 3)
end)

GameplaySection:NewToggle("Автопокупка яиц", "Автоматически покупает выбранные яйца", function(state)
    autoBuyEggs = state
    if state then
        spawn(function()
            while autoBuyEggs do
                if getPlayerMoney() >= 100 then
                    purchaseItem("Egg", selectedEgg, 1)
                else
                    Library:Notify("Недостаточно денег для покупки яиц!", 5)
                end
                wait(5)
            end
        end)
    end
end)

GameplaySection:NewDropdown("Выбор снаряжения", "Выберите снаряжение для автопокупки", flatGearOptions, function(selected)
    selectedGear = selected
    Library:Notify("Выбрано снаряжение: " .. selected, 3)
end)

GameplaySection:NewToggle("Автопокупка снаряжения", "Автоматически покупает выбранное снаряжение", function(state)
    autoBuyGear = state
    if state then
        spawn(function()
            while autoBuyGear do
                if getPlayerMoney() >= 200 then
                    purchaseItem("Gear", selectedGear, 1)
                else
                    Library:Notify("Недостаточно денег для покупки снаряжения!", 5)
                end
                wait(5)
            end
        end)
    end
end)

GameplaySection:NewDropdown("Выбор косметики", "Выберите косметику для автопокупки", flatCosmeticOptions, function(selected)
    selectedCosmetic = selected
    Library:Notify("Выбрана косметика: " .. selected, 3)
end)

GameplaySection:NewToggle("Автопокупка косметики", "Автоматически покупает выбранную косметику", function(state)
    autoBuyCosmetics = state
    if state then
        spawn(function()
            while autoBuyCosmetics do
                if getPlayerMoney() >= 150 then
                    purchaseItem("Cosmetic", selectedCosmetic, 1)
                else
                    Library:Notify("Недостаточно денег для покупки косметики!", 5)
                end
                wait(5)
            end
        end)
    end
end)

-- Кастомизация GUI
CustomizationSection:NewSlider("Прозрачность GUI", "Настройка прозрачности интерфейса", 1, 0, function(value)
    guiTransparency = value
    Window.Ui.BackgroundTransparency = value
    Library:Notify("Прозрачность установлена: " .. tostring(value), 3)
end)

CustomizationSection:NewSlider("Скорость RGB", "Настройка скорости RGB анимации", 10, 1, function(value)
    rgbSpeed = value
    Library:Notify("Скорость RGB: " .. tostring(value), 3)
end)

CustomizationSection:NewDropdown("Тема GUI", "Выберите тему интерфейса", {"DarkTheme", "LightTheme", "BloodTheme", "GrapeTheme", "OceanTheme"}, function(theme)
    selectedTheme = theme
    Window:ChangeTheme(theme)
    Library:Notify("Тема изменена: " .. theme, 3)
end)

CustomizationSection:NewToggle("Неоновая подсветка кнопок", "Включает неоновый эффект для кнопок", function(state)
    if state then
        for _, button in pairs(Window.Ui:GetDescendants()) do
            if button:IsA("TextButton") then
                neonButtonEffect(button)
            end
        end
    end
end)

CustomizationSection:NewToggle("Динамические тени", "Включает анимированные тени", function(state)
    if state then
        local shadow = Instance.new("UIStroke")
        shadow.Thickness = 3
        shadow.Color = Color3.fromRGB(255, 255, 255)
        shadow.Parent = Window.Ui
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        TweenService:Create(shadow, tweenInfo, {Color = Color3.fromRGB(0, 0, 255)}):Play()
    else
        local shadow = Window.Ui:FindFirstChildOfClass("UIStroke")
        if shadow then shadow:Destroy() end
    end
end)

CustomizationSection:NewButton("Свернуть/Развернуть", "Сворачивает или разворачивает GUI", function()
    local minimized = not Window.Ui.Size.X.Offset == 50
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if minimized then
        TweenService:Create(Window.Ui, tweenInfo, {Size = UDim2.new(0, 50, 0, 50)}):Play()
    else
        TweenService:Create(Window.Ui, tweenInfo, {Size = UDim2.new(0, 600, 0, 400)}):Play()
    end
end)

CustomizationSection:NewButton("Закрыть GUI", "Закрывает интерфейс", function()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(Window.Ui, tweenInfo, {BackgroundTransparency = 1}):Play()
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
Library:Notify("Grow A Garden | Perfect GUI Loaded!", 5)

-- Анти-обнаружение
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldnc = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        wait(math.random(0.01, 0.05))
    end
    return oldnc(self, ...)
end)
setreadonly(mt, true)
