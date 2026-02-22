local player = game:GetService("Players").LocalPlayer
local pgui = player:FindFirstChildOfClass("PlayerGui")

-- 기존 GUI 삭제
if pgui:FindFirstChild("InvisGui") then pgui.InvisGui:Destroy() end

local sg = Instance.new("ScreenGui", pgui)
sg.Name = "InvisGui"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0, 30, 0.4, 0)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.Text = "투명인간: OFF"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

local isInvis = false

-- 👻 투명화 핵심 함수
local function toggleInvisibility(state)
    local char = player.Character
    if not char then return end
    
    local transparencyValue = state and 1 or 0
    
    -- 몸체, 장식품, 얼굴 전부 뒤져서 투명도 조절
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = transparencyValue
        elseif v:IsA("Decal") then
            v.Transparency = transparencyValue
        end
    end
    
    -- 이름표(BillboardGui) 숨기기 시도
    if char:FindFirstChild("Head") then
        for _, gui in pairs(char.Head:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui.Enabled = not state
            end
        end
    end
end

-- 버튼 클릭 이벤트
btn.MouseButton1Click:Connect(function()
    isInvis = not isInvis
    btn.Text = isInvis and "투명인간: ON" or "투명인간: OFF"
    btn.BackgroundColor3 = isInvis and Color3.fromRGB(100, 0, 255) or Color3.fromRGB(20, 20, 20)
    
    toggleInvisibility(isInvis)
end)

-- 캐릭터가 다시 태어나도 상태 유지
player.CharacterAdded:Connect(function()
    task.wait(1)
    if isInvis then
        toggleInvisibility(true)
    end
end)

print("Invisibility Script Loaded!")
