-- Kiểm tra key
local key_required = "zzollyan"
if not getgenv().key or getgenv().key ~= key_required then
    local SG = game:GetService("StarterGui")
    SG:SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key hoặc chưa nhập key.\nVui lòng dùng getgenv().key = \"zzollyan\" rồi chạy lại.",
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

-- UI Hiện Đại
local gui = Instance.new("ScreenGui")
gui.Name = "MeDocTruyenTranhUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "MeDocTruyenTranh"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

local timeElapsed = Instance.new("TextLabel")
timeElapsed.Text = "Client Time Elapsed: 0h:0m:0s"
timeElapsed.Size = UDim2.new(1, -20, 0, 20)
timeElapsed.Position = UDim2.new(0, 10, 0, 50)
timeElapsed.TextXAlignment = Enum.TextXAlignment.Left
timeElapsed.TextColor3 = Color3.new(1, 1, 1)
timeElapsed.Font = Enum.Font.Gotham
timeElapsed.TextSize = 14
timeElapsed.Parent = mainFrame

local opioButton = Instance.new("TextButton")
opioButton.Text = "[Opio]"
opioButton.Size = UDim2.new(0, 60, 0, 25)
opioButton.Position = UDim2.new(0, 10, 0, 85)
opioButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
opioButton.TextColor3 = Color3.new(1, 1, 1)
opioButton.Font = Enum.Font.Gotham
opioButton.TextSize = 14
opioButton.Parent = mainFrame

local editButton = Instance.new("TextButton")
editButton.Text = "[Edit]"
editButton.Size = UDim2.new(0, 60, 0, 25)
editButton.Position = UDim2.new(0, 80, 0, 85)
editButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
editButton.TextColor3 = Color3.new(1, 1, 1)
editButton.Font = Enum.Font.Gotham
editButton.TextSize = 14
editButton.Parent = mainFrame

local altLabel = Instance.new("TextLabel")
altLabel.Text = "[Alt]: MeDocTruyenTranh - Đọc truyện tranh tốc độ cao, hình ảnh sắc nét."
altLabel.Size = UDim2.new(1, -20, 0, 40)
altLabel.Position = UDim2.new(0, 10, 1, -50)
altLabel.TextXAlignment = Enum.TextXAlignment.Left
altLabel.TextYAlignment = Enum.TextYAlignment.Top
altLabel.TextWrapped = true
altLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
altLabel.Font = Enum.Font.Gotham
altLabel.TextSize = 12
altLabel.Parent = mainFrame

-- Trạng thái hoạt động
local status = Instance.new("TextLabel")
status.Text = "Anti AFK Chamber: Đang khởi động..."
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 110)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.new(0, 1, 0)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = mainFrame

-- Nút thu/phóng UI
local toggle = Instance.new("ImageButton", mainFrame)
toggle.Image = "rbxassetid://14230252389"
toggle.Size = UDim2.new(0, 20, 0, 20)
toggle.Position = UDim2.new(1, -25, 0, 5)
toggle.BackgroundTransparency = 1

local shown = true
toggle.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame:TweenSize(
        shown and UDim2.new(0, 300, 0, 150) or UDim2.new(0, 300, 0, 0),
        "Out",
        "Sine",
        0.3,
        true
    )
end)

-- Cập nhật thời gian
local startTime = os.time()
RunService.Heartbeat:Connect(function()
    local elapsed = os.time() - startTime
    local h = math.floor(elapsed / 3600)
    local m = math.floor((elapsed % 3600) / 60)
    local s = elapsed % 60
    timeElapsed.Text = string.format("Client Time Elapsed: %dh:%02dm:%02ds", h, m, s)
end)

-- Các hành động chống AFK
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

-- Vòng lặp chống AFK
local function antiAFKLoop()
    while ENABLED do
        task.wait(CHECK_INTERVAL)
        if tick() - lastActionTime >= ACTION_INTERVAL then
            local actions = {randomMove, fakeKey, rotateCam, simulateClick, simulateMouseMove, jump}
            local action = actions[math.random(1, #actions)]
            action()
            lastActionTime = tick()
            status.Text = "Anti AFK Chamber: Đã hành động lúc " .. os.date("%H:%M:%S")
        end
    end
end

-- Cập nhật khi rejoin
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
end)

task.spawn(antiAFKLoop)
