-- [[ 👻 FE REAL INVISIBLE (서버 우회형) 👻 ]]
local player = game:GetService("Players").LocalPlayer
local runService = game:GetService("RunService")
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 삭제
if pgui:FindFirstChild("RealInvisGui") then pgui.RealInvisGui:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "RealInvisGui"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0, 30, 0.45, 0)
btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80) -- 보라색 간지
btn.Text = "FE 투명: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

local active = false
local fakeChar = nil

-- 🛠️ FE 우회 투명화 핵심 함수
local function toggleInvis(state)
    local char = player.Character
    if not char or not char:FindFirstChild("LowerTorso") then return end
    
    if state then
        -- 1. 관절(Motor6D)을 조작해서 서버가 네 위치를 못 찾게 만듦
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("Motor6D") and v.Name ~= "Neck" then
                v:Destroy() -- 관절을 파괴해서 서버 판정을 없앰 (FE 우회의 핵심!)
            end
        end
        -- 2. 내 화면에서도 투명하게 처리
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
        print("FE Invisible Activated!")
    else
        -- 3. 끄면 캐릭터를 다시 불러와서 복구 (가장 확실한 방법)
        player:LoadCharacter()
    end
end

-- 버튼 클릭
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = active and "FE 투명: ON" or "FE 투명: OFF"
    btn.BackgroundColor3 = active and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 0, 80)
    btn.TextColor3 = active and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
    
    toggleInvis(active)
end)

-- 한국 머더 전용: 이름표(BillboardGui) 실시간 파괴
runService.RenderStepped:Connect(function()
    if active and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.Enabled = false
            end
        end
    end
end)

print("FE True Invisibility for KR Murder Loaded!")
