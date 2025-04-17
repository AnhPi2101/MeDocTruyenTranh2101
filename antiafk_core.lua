local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình key
local key_required = "zzollyan"
local timeout = 15
local start = tick()

-- Kiểm tra key
repeat task.wait(0.5) until getgenv().key ~= nil or tick() - start > timeout

if getgenv().key ~= key_required then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Anti AFK Chamber",
		Text = "Sai key hoặc chưa nhập key.\nDùng: getgenv().key = \"zzollyan\"",
		Duration = 10
	})
	return
end

-- GUI GỐC
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MeDocRaidenUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- FRAME CHÍNH
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 160)
frame.Position = UDim2.new(0.03, 0, 0.05, 0)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Parent = screenGui

-- ẢNH RAIDEN SHOGUN (nền)
local image = Instance.new("ImageLabel")
image.Size = UDim2.new(1, 0, 1, 0)
image.Position = UDim2.new(0, 0, 0, 0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://99255503850752" -- <<< Thay bằng ID ảnh Raiden
image.ScaleType = Enum.ScaleType.Crop
image.Parent = frame

-- HIỆU ỨNG GRADIENT
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60)),
}
gradient.Rotation = 0
gradient.Parent = image

-- TWEEN GRADIENT LIÊN TỤC
spawn(function()
	local tweenInfo = TweenInfo.new(20, Enum.EasingStyle.Linear)
	while true do
		local goal = { Rotation = gradient.Rotation + 360 }
		local tween = TweenService:Create(gradient, tweenInfo, goal)
		tween:Play()
		tween.Completed:Wait()
	end
end)

-- TIÊU ĐỀ RICHTEXT
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = '<font color="#00AEEF">MeDoc</font><font color="#EC0B3D">TruyenTranh</font>'
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = frame

-- TRẠNG THÁI
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 50)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Đang hoạt động"
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextScaled = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Parent = frame

-- TIMER
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 25)
timerLabel.Position = UDim2.new(0, 0, 0, 85)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "00:00:00"
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextScaled = true
timerLabel.TextXAlignment = Enum.TextXAlignment.Center
timerLabel.TextColor3 = Color3.new(1, 1, 1)
timerLabel.Parent = frame

-- TÍNH GIỜ
spawn(function()
	local startTime = os.time()
	while true do
		local elapsed = os.time() - startTime
		local h = math.floor(elapsed / 3600)
		local m = math.floor((elapsed % 3600) / 60)
		local s = elapsed % 60
		timerLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
		wait(1)
	end
end)

-- KÉO THẢ UI
do
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging  = true
			dragStart = input.Position
			startPos  = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInput.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			update(input)
		end
	end)
end

--===[ Các chức năng chống AFK ]===--

local function fakeKey()
	pcall(function()
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.J, false, game)  -- Thay Space thành J
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.J, false, game) -- Thay Space thành J
	end)
end

local function jump()
	pcall(function()
		game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
	end)
end

local function moveRandomDirection()
	local directions = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
	local randomDirection = directions[math.random(1, #directions)]
	pcall(function()
		game:GetService("VirtualInputManager"):SendKeyEvent(true, randomDirection, false, game)
		game:GetService("VirtualInputManager"):SendKeyEvent(false, randomDirection, false, game)
	end)
end

--===[ Tự động chat ]===--

task.spawn(function()
	local messages = {
		"script tốt thật sự", "tôi yêu MeDocTruyenTranh",
		"Raiden đẹp thật", "mình còn đang chơi mà", "anti afk không thấm được"
	}
	while true do
		wait(300)
		local msg = messages[math.random(1, #messages)]
		pcall(function()
			game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
		end)
	end
end)

--===[ Detect AFK Chamber và auto return to lobby ]===--

local function detectAFKChamber()
	while true do
		local placeId = game.PlaceId
		-- Bạn cần thay PLACEID_AFK thành placeId thật sự của AFK Chamber
		local PLACEID_AFK = 16465572687
		local LOBBY_PLACEID = 1234567890  -- PlaceId của lobby

		if placeId == PLACEID_AFK then
			game:GetService("TeleportService"):TeleportToPlaceInstance(LOBBY_PLACEID, game.JobId)
		end
		wait(10)
	end
end

--=== Chạy Vòng Lặp Chính ===--

while true do
	wait(10)
	fakeKey()
	jump()
	moveRandomDirection()

	-- Update trạng thái UI
	statusLabel.Text = "Status: Đang hoạt động"
end
