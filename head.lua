-- // Настройки
getgenv().HitboxSize = Vector3.new(15, 15, 15) -- Размер хитбокса головы
getgenv().HitboxTransparency = 0.5 -- Прозрачность
getgenv().HitboxEnabled = false -- Включено/выключено

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- // Создаем интерфейс с кнопкой
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HitboxGUI"
ScreenGui.Parent = game.CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Text = "HITBOX: OFF"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = ScreenGui

-- // Улучшенная функция изменения хитбокса
function ModifyHitbox(state)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            coroutine.wrap(function()
                -- Ждем пока персонаж загрузится
                if not player.Character then
                    player.CharacterAdded:Wait()
                    wait(1)
                end
                
                local character = player.Character
                if character then
                    local head = character:FindFirstChild("Head")
                    if head then
                        if state then
                            -- Увеличиваем хитбокс головы
                            head.Size = getgenv().HitboxSize
                            head.Transparency = getgenv().HitboxTransparency
                            head.Material = Enum.Material.Neon
                            head.Color = Color3.fromRGB(255, 0, 0)
                            head.CanCollide = false
                            head.Massless = true
                        else
                            -- Возвращаем стандартные параметры
                            head.Size = Vector3.new(2, 1, 1)
                            head.Transparency = 0
                            head.Material = Enum.Material.SmoothPlastic
                            head.Color = Color3.fromRGB(255, 255, 255)
                            head.CanCollide = true
                        end
                    end
                end
            end)()
        end
    end
end

-- // Функция для принудительного применения ко всем
function ApplyToAllPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                if getgenv().HitboxEnabled then
                    head.Size = getgenv().HitboxSize
                    head.Transparency = getgenv().HitboxTransparency
                    head.Material = Enum.Material.Neon
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.CanCollide = false
                    head.Massless = true
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                    head.Material = Enum.Material.SmoothPlastic
                    head.Color = Color3.fromRGB(255, 255, 255)
                    head.CanCollide = true
                end
            end
        end
    end
end

-- // Обработчик нажатия кнопки
ToggleButton.MouseButton1Click:Connect(function()
    getgenv().HitboxEnabled = not getgenv().HitboxEnabled
    
    if getgenv().HitboxEnabled then
        ToggleButton.Text = "HITBOX: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        ModifyHitbox(true)
        -- Дополнительное применение через 2 секунды
        delay(2, function()
            ApplyToAllPlayers()
        end)
        print("Хитбоксы ВКЛЮЧЕНЫ")
    else
        ToggleButton.Text = "HITBOX: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ModifyHitbox(false)
        print("Хитбоксы ВЫКЛЮЧЕНЫ")
    end
end)

-- // Автообновление при появлении новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(2) -- Даем время на полную загрузку персонажа
        if getgenv().HitboxEnabled then
            local head = character:FindFirstChild("Head")
            if head then
                head.Size = getgenv().HitboxSize
                head.Transparency = getgenv().HitboxTransparency
                head.Material = Enum.Material.Neon
                head.Color = Color3.fromRGB(255, 0, 0)
                head.CanCollide = false
                head.Massless = true
            end
        end
    end)
end)

-- // Применяем к уже существующим игрокам при запуске
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            wait(2)
            if getgenv().HitboxEnabled then
                local head = character:FindFirstChild("Head")
                if head then
                    head.Size = getgenv().HitboxSize
                    head.Transparency = getgenv().HitboxTransparency
                    head.Material = Enum.Material.Neon
                    head.Color = Color3.fromRGB(255, 0, 0)
                    head.CanCollide = false
                    head.Massless = true
                end
            end
        end)
    end
end

-- // Постоянное обновление каждые 3 секунды
while wait(3) do
    if getgenv().HitboxEnabled then
        ApplyToAllPlayers()
    end
end

print("Хитбокс скрипт загружен! Нажми на кнопку в верхнем левом углу.")
