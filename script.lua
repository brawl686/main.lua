local player = game:GetService("Players").LocalPlayer
local pgui = player:FindFirstChildOfClass("PlayerGui")
local runService = game:GetService("RunService")

-- 기존 GUI 삭제
if pgui:FindFirstChild("AntiMurderGui") then pgui.AntiMurderGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiMurderGui"
screenGui.Parent = pgui
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 130, 0, 40)
button.Position = UDim2.new(0, 30, 0.4, 0) -- 모바일 왼쪽 고정!
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.Text = "안티 머더: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

local enabled = false

-- 🗡️ 안티 머더 핵심 로직 (FE 우회)
local function RemoveHitboxes()
    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            -- 머더가 손에 들고 있는 도구(칼 등) 찾기
            for _, tool in pairs(otherPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    -- 도구 안의 '닿음 판정(TouchInterest)'을 내 클라이언트에서만 파괴!
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("TouchInterest") then
                            part:Destroy()
                        end
                    end
                end
            end
        end
    end
end

-- 버튼 클릭 시 작동
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        button.Text = "안티 머더: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- 무적이 켜져 있는 동안 0.1초마다 다른 사람들의 칼 판정을 계속 지움!
        task.spawn(function()
            while enabled do
                pcall(RemoveHitboxes)
                task.wait(0.1)
            end
        end)
    else
        button.Text = "안티 머더: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

print("FE Anti-Murder Loaded!")
