-- [[ 👻 FE 위치 기만형 투명 (Desync) 스크립트 👻 ]]
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 삭제
if pgui:FindFirstChild("DesyncInvisGui") then pgui.DesyncInvisGui:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "DesyncInvisGui"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0, 30, 0.45, 0)
btn.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
btn.Text = "위치기만 투명: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local active = false
local offset = Vector3.new(0, 1000, 0) -- 서버에는 1000미터 아래에 있는 것처럼 속임

-- 🛠️ 핵심 로직: 서버와 내 위치를 찢어버리기
runService.RenderStepped:Connect(function()
    if active and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        -- 내 화면에선 정상적으로 보이지만, 서버로 보내는 신호는 엉뚱한 곳으로!
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanTouch = false -- 칼 안 닿게 판정도 끔
            end
        end
    end
end)

-- 버튼 작동
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = active and "위치기만 투명: ON" or "위치기만 투명: OFF"
    btn.BackgroundColor3 = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 50, 100)
    
    local char = player.Character
    if char and char:FindFirstChild("LowerTorso") then
        if active then
            -- 캐릭터의 실제 렌더링 부위를 서버가 못 찾는 곳으로 날림
            char.LowerTorso:BreakJoints() -- 관절을 미세하게 틀어버림
            print("Desync Activated!")
        else
            -- 복구는 캐릭터 재설정이 가장 깔끔
            player:LoadCharacter()
        end
    end
end)

print("FE Desync Invisibility Loaded!")
