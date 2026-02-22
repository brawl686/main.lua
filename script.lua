local player = game:GetService("Players").LocalPlayer
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 삭제 (중복 생성 방지)
if pgui:FindFirstChild("GodModeGui") then
    pgui.GodModeGui:Destroy()
end

-- 1. Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeGui"
screenGui.Parent = pgui
screenGui.ResetOnSpawn = false

-- 2. Create Toggle Button (모바일 중앙 왼쪽 배치)
local button = Instance.new("TextButton")
button.Name = "ToggleButton"
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.05, 0, 0.4, 0) -- 화면 왼쪽 살짝 안쪽
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "GOD: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.Parent = screenGui

-- 모서리 둥글게 (간지)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

local enabled = false

-- 3. Toggle Logic
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    
    if enabled then
        button.Text = "GOD: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        
        task.spawn(function()
            while enabled do
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.MaxHealth = 999999
                        hum.Health = 999999
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        button.Text = "GOD: OFF"
        button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.MaxHealth = 100
            player.Character.Humanoid.Health = 100
        end
    end
end)

print("God Mode GUI Loaded! Check your screen.")
