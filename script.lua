local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI 생성
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Active = true
mainFrame.Draggable = true -- UI 드래그 가능하게 설정
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Fly Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Fly 버튼
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0, 40)
flyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
flyButton.Parent = mainFrame

-- 속도 입력창 (TextBox)
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.8, 0, 0, 30)
speedInput.Position = UDim2.new(0.1, 0, 0.65, 0)
speedInput.PlaceholderText = "Speed (Default: 50)"
speedInput.Text = "50"
speedInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Parent = mainFrame

-- 변수 설정
local flying = false
local speed = 50
local bv, bg

-- 비행 로직
local function startFly()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local root = char.HumanoidRootPart

	flying = true
	flyButton.Text = "Fly: ON"
	flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

	-- 물리 엔진 설정
	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
	bg.CFrame = root.CFrame
	bg.Parent = root

	char.Humanoid.PlatformStand = true

	-- 움직임 루프
	task.spawn(function()
		while flying do
			task.wait()
			-- 카메라 방향에 맞춰 이동
			bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * speed
			bg.CFrame = game.Workspace.CurrentCamera.CFrame
		end
	end)
end

local function stopFly()
	flying = false
	flyButton.Text = "Fly: OFF"
	flyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.PlatformStand = false
	end
end

-- 버튼 클릭 이벤트
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

-- 속도 변경 이벤트
speedInput.FocusLost:Connect(function()
	local newSpeed = tonumber(speedInput.Text)
	if newSpeed then
		speed = newSpeed
	else
		speedInput.Text = tostring(speed) -- 숫자가 아니면 이전 속도로 복구
	end
end)
