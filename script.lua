local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- 1. Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodModeGui"
screenGui.Parent = pgui
screenGui.ResetOnSpawn = false

-- 2. Create Toggle Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "God Mode: OFF"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = screenGui

local enabled = false
local connection

-- 3. Toggle Logic
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    
    if enabled then
        button.Text = "God Mode: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Start God Mode Loop
        connection = task.spawn(function()
            while enabled do
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.MaxHealth = math.huge
                        hum.Health = math.huge
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        button.Text = "God Mode: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Reset Health to Normal
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.MaxHealth = 100
            char.Humanoid.Health = 100
        end
        enabled = false
    end
end)
