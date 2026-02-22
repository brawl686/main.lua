local player = game:GetService("Players").LocalPlayer
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 삭제
if pgui:FindFirstChild("SuperGodGui") then pgui.SuperGodGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SuperGodGui"
screenGui.Parent = pgui
screenGui.ResetOnSpawn = false

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 45)
button.Position = UDim2.new(0, 30, 0.45, 0)
button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
button.Text = "FE 무적: OFF"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 15
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local godEnabled = false

-- 🔥 FE 무적 핵심: 서버로 가는 '닿음' 신호 차단
button.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    
    if godEnabled then
        button.Text = "FE 무적: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        button.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        -- 루프 돌면서 내 몸에 닿는 모든 '칼' 판정을 비활성화
        task.spawn(function()
            while godEnabled do
                local char = player.Character
                if char then
                    for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
                        -- 'Knife'나 'Sword'라는 이름이 들어간 모든 물체의 판정을 무시
                        if v:IsA("TouchInterest") and (v.Parent.Name:find("Knife") or v.Parent.Name:find("Sword") or v.Parent:IsA("Tool")) then
                            v:Destroy() -- 내 화면에서 판정 자체를 삭제!
                        end
                    end
                end
                task.wait(0.3) -- 너무 자주 돌면 렉 걸리니까 0.3초마다 체크
            end
        end)
        
        -- 추가로 체력도 계속 회복 (보험용)
        task.spawn(function()
            while godEnabled do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.Health = 100
                end
                task.wait(0.1)
            end
        end)
    else
        button.Text = "FE 무적: OFF"
        button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

print("Super FE GodMode Loaded!")
