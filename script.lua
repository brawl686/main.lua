local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 있으면 삭제 (깔끔하게 시작!)
if pgui:FindFirstChild("AntiMurderPrime") then pgui.AntiMurderPrime:Destroy() end

-- 1. GUI 생성
local sg = Instance.new("ScreenGui", pgui)
sg.Name = "AntiMurderPrime"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0.05, 0, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.Text = "안티 머더: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16

local corner = Instance.new("UICorner", btn)
corner.CornerRadius = UDim.new(0, 10)

local active = false

-- 🗡️ 칼 판정 무력화 함수
local function neutralizeKnives()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= player and p.Character then
            -- 손에 든 도구 확인
            for _, tool in pairs(p.Character:GetChildren()) do
                if tool:IsA("Tool") then
                    -- 칼 관련 모든 물리 판정(TouchInterest)을 내 화면에서 삭제
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

-- 🛡️ 무적 메인 루프
runService.Heartbeat:Connect(function()
    if active then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                -- 1. 죽음 상태 차단 (서버 기만)
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                if hum.Health < 1 then hum.Health = 100 end -- 죽기 직전 강제 소생
                
                -- 2. 내 몸의 모든 부위를 '안 닿는 상태'로 (유령화)
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanTouch = false
                    end
                end
            end
            -- 3. 실시간 칼 판정 삭제
            pcall(neutralizeKnives)
        end
    end
end)

-- 버튼 작동
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = active and "안티 머더: ON" or "안티 머더: OFF"
    btn.BackgroundColor3 = active and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(30, 30, 30)
    
    -- 비활성화 시 판정 복구
    if not active and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanTouch = true end
        end
    end
end)

print("KR Murder Anti-Cheat Bypass Loaded!")
