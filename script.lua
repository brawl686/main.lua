-- 로컬 스크립트로 실행해줘!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI 생성 부분
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local NameInput = Instance.new("TextBox")
local ToggleBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

-- GUI 설정
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "FollowGui"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true -- 드래그 가능!

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "FLY FOLLOW"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

NameInput.Parent = MainFrame
NameInput.Position = UDim2.new(0.1, 0, 0.3, 0)
NameInput.Size = UDim2.new(0.8, 0, 0, 30)
NameInput.PlaceholderText = "진짜 닉네임 입력!"
NameInput.Text = ""

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 기능 변수
local isFollowing = false
local targetPlayerName = ""

-- 토글 버튼 이벤트
ToggleBtn.MouseButton1Click:Connect(function()
	isFollowing = not isFollowing
	targetPlayerName = NameInput.Text
	
	if isFollowing then
		ToggleBtn.Text = "ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		ToggleBtn.Text = "OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

-- 따라가기 로직 (Fly 방식)
RunService.Heartbeat:Connect(function()
	if isFollowing and targetPlayerName ~= "" then
		-- DisplayName이 아닌 진짜 Name으로 찾기!
		local target = Players:FindFirstChild(targetPlayerName)
		
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local myChar = LocalPlayer.Character
			if myChar and myChar:FindFirstChild("HumanoidRoot
