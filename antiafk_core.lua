--===[ MeDocTruyenTranh - Anti AFK Chamber Script Anime Vanguard ]===--

-- Kiểm tra key
local key_required = "zzollyan"
if getgenv().key ~= key_required then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key. Vui lòng nhập key hợp lệ.",
        Duration = 10
    })
    return
end

-- Dịch vụ cần thiết
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Biến thời gian
local lastActionTime = tick()
local CHECK_INTERVAL = 30
local ACTION_INTERVAL = 120
local ENABLED = true

--===[ UI Hiện Đại ]===--
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AntiAFK_UI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 70)
frame.Position = UDim2.new(0.5, -160, 1, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.ClipsDescendants = true

-- Giao diện tùy chỉnh
local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Text = "MeDocTruyenTranh"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.Size = UDim2.new(1, -10, 0, 20)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1

local status = Instance.new("TextLabel", frame)
status.Text = "Anti AFK Chamber: Đang hoạt động"
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.new(0.7, 1, 0.7)
status.Size = UDim2.new(1, -10, 0, 20)
status.Position = UDim2.new(0, 10, 0, 35)
status.BackgroundTransparency = 1

local timeRemaining = Instance.new("TextLabel", frame)
timeRemaining.Text = "Còn 120s trước khi hành động"
timeRemaining.Font = Enum.Font.Gotham
timeRemaining.TextSize = 12
timeRemaining.TextColor3 = Color3.new(1, 1, 0)
timeRemaining.Size = UDim2.new(1, -10, 0, 20)
timeRemaining.Position = UDim2.new(0, 10, 0, 55)
timeRemaining.BackgroundTransparency = 1

-- Nút tắt mở bằng logo
local toggle = Instance.new("ImageButton", frame)
toggle.Image = "rbxassetid://14230252389" -- Bạn có thể thay bằng logo sinh động hơn
toggle.Size = UDim2.new(0, 20, 0, 20)
toggle.Position = UDim2.new(1, -25, 0, 5)
toggle.BackgroundTransparency = 1

local shown = true
toggle.MouseButton1Click:Connect(function()
    shown = not shown
    frame:TweenSize(
        shown and UDim2.new(0, 320, 0, 70) or UDim2.new(0, 320, 0, 0),
        "Out",
        "Sine",
        0.3,
        true
    )
end)

--===[ 6 Hành Động Chống AFK ]===--
local function randomMove()
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local offset = Vector3.new(math.random(-5,5), 0, math.random(-5,5))
        humanoid:MoveTo(root.Position + offset)
    end
end

local function fakeKey()
    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

local function rotateCam()
    local cam = workspace.CurrentCamera
    cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(math.random(-10,10)), 0)
end

local function simulateClick()
    VIM:SendMouseButtonEvent(200, 200, 0, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(200, 200, 0, false, game, 0)
end

local function simulateMouseMove()
    VIM:SendMouseMoveEvent(math.random(1,500), math.random(1,500), game)
end

local function jump()
    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

--===[ Luồng chính chống AFK ]===--
local function antiAFKLoop()
    while ENABLED do
        task.wait(CHECK_INTERVAL)
        if tick() - lastActionTime >= ACTION_INTERVAL then
            local actions = {randomMove, fakeKey, rotateCam, simulateClick, simulateMouseMove, jump}
            local action = actions[math.random(1, #actions)]
            action()
            lastActionTime = tick()
            status.Text = "Anti AFK Chamber: Kích hoạt lúc " .. os.date("%H:%M:%S")
        end
        
        local timeRemaining = math.floor(ACTION_INTERVAL - (tick() - lastActionTime))
        timeRemaining.Text = "Còn " .. timeRemaining .. "s trước khi hành động"
    end
end

--===[ Rejoin/Teleport support ]===--
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

task.spawn(antiAFKLoop)
