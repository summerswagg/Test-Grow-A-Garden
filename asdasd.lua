-- Загрузка Hydra UI библиотеки
local HydraLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/weakhoes/Roblox-UI-Libs/main/Hydra%20Lib/Hydra%20Lib%20Source.lua"))()

-- Создание главного окна
local Window = HydraLib:CreateWindow({
    Name = "InjectorX",
    IntroText = "InjectorX v2.0",
    IntroIcon = "rbxassetid://8595257169",
    Theme = "Dark",
    SizeX = 600,
    SizeY = 400
})

-- Создание вкладки "Главная"
local MainTab = Window:CreateTab({
    Name = "Главная",
    Icon = "rbxassetid://3926305904"
})

-- Секция "Скрипты"
local ScriptSection = MainTab:CreateSection({
    Name = "Управление скриптами",
    Side = "Left"
})

-- Кнопка для выполнения скрипта
ScriptSection:CreateButton({
    Name = "Выполнить скрипт",
    Callback = function()
        print("Скрипт выполнен!")
        HydraLib:Notify({
            Title = "Успех",
            Text = "Скрипт успешно выполнен!",
            Duration = 3
        })
    end
})

-- Текстовое поле для ввода скрипта
ScriptSection:CreateTextbox({
    Name = "Вставить скрипт",
    Placeholder = "Введите Lua код...",
    Callback = function(value)
        print("Введен скрипт: " .. value)
    end
})

-- Переключатель для автозапуска
ScriptSection:CreateToggle({
    Name = "Автозапуск скриптов",
    Default = false,
    Callback = function(state)
        print("Автозапуск: " .. tostring(state))
    end
})

-- Секция "Настройки"
local SettingsSection = MainTab:CreateSection({
    Name = "Настройки",
    Side = "Right"
})

-- Слайдер для скорости инжектора
SettingsSection:CreateSlider({
    Name = "Скорость инжекции",
    Min = 1,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Скорость инжекции: " .. value)
    end
})

-- Выпадающее меню для выбора темы
SettingsSection:CreateDropdown({
    Name = "Тема интерфейса",
    Options = {"Dark", "Light", "Midnight", "Custom"},
    Default = "Dark",
    Callback = function(selected)
        print("Выбрана тема: " .. selected)
        HydraLib:ChangeTheme(selected)
    end
})

-- Создание вкладки "Информация"
local InfoTab = Window:CreateTab({
    Name = "Информация",
    Icon = "rbxassetid://3926305904"
})

-- Секция "О программе"
local AboutSection = InfoTab:CreateSection({
    Name = "О программе",
    Side = "Left"
})

-- Метка с информацией
AboutSection:CreateLabel({
    Text = "InjectorX v2.0\nСоздано для удобного выполнения скриптов\n© 2025"
})

-- Кнопка для проверки обновлений
AboutSection:CreateButton({
    Name = "Проверить обновления",
    Callback = function()
        HydraLib:Notify({
            Title = "Обновления",
            Text = "Вы используете последнюю версию!",
            Duration = 3
        })
    end
})

-- Водяной знак
local Watermark = HydraLib:CreateWatermark({
    Text = "InjectorX | v2.0 | FPS: 60"
})

-- Начальная анимация
HydraLib:IntroAnimation()
