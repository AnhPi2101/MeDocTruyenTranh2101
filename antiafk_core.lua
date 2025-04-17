--=== MeDocTruyenTranh – Anti AFK Chamber (with dragable UI) ===--

-- Kiểm tra key
local key_required = "zzollyan"
if not getgenv().key or getgenv().key ~= key_required then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key hoặc chưa nhập key.\nDùng getgenv().key = \"zzollyan\" rồi chạy lại.",
        Duration = 8
    })
    return
end

-- Dịch vụ
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UIS            = game:GetService("UserInputService")
local VIM            = game:GetService("VirtualInputManager")

-- Người chơi & nhân vật
local player     = Players.LocalPlayer
local character  = player.Character or player.CharacterAdded:Wait()
local humanoid   = character:WaitForChild("Humanoid")

-- Thời gian
local lastActionTime  = tick()
local CHECK_INTERVAL  = 30
local ACTION_INTERVAL = 120
local ENABLED         = true

--=== UI Hiện Đại ===--
local gui = Instance.new("ScreenGui")
gui.Name   = "MeDocTruyenTranhUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size              = UDim2.new(0, 300, 0, 150)
mainFrame.Position          = UDim2.new(0.5, -150, 0.8, 0)
mainFrame.AnchorPoint       = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3  = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel   = 0
mainFrame.ClipsDescendants  = true

-- Bo góc
local UICorner = Instance.new("UICorner", mainFrame)
UICorner.CornerRadius = UDim.new(0, 6)

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Text             = "MeDocTruyenTranh"
title.Size             = UDim2.new(1, 0, 0, 30)
title.Position         = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3       = Color3.new(1,1,1)
title.Font             = Enum.Font.GothamBold
title.TextSize         = 18

-- Bộ đếm client time
local timeElapsed = Instance.new("TextLabel", mainFrame)
timeElapsed.Text            = "Client Time Elapsed: 0h:00m:00s"
timeElapsed.Size            = UDim2.new(1, -20, 0, 20)
timeElapsed.Position        = UDim2.new(0, 10, 0, 40)
timeElapsed.TextXAlignment  = Enum.TextXAlignment.Left
timeElapsed.TextColor3      = Color3.new(1,1,1)
timeElapsed.Font            = Enum.Font.Gotham
timeElapsed.TextSize        = 14

-- Nút chức năng (Opio & Edit)
local opioButton = Instance.new("TextButton", mainFrame)
opioButton.Text             = "[Opio]"
opioButton.Size             = UDim2.new(0, 60, 0, 25)
opioButton.Position         = UDim2.new(0, 10, 0, 65)
opioButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
opioButton.TextColor3       = Color3.new(1,1,1)
opioButton.Font             = Enum.Font.Gotham
opioButton.TextSize         = 14

local editButton = Instance.new("TextButton", mainFrame)
editButton.Text             = "[Edit]"
editButton.Size             = UDim2.new(0, 60, 0, 25)
editButton.Position         = UDim2.new(0, 80, 0, 65)
editButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
editButton.TextColor3       = Color3.new(1,1,1)
editButton.Font             = Enum.Font.Gotham
editButton.TextSize         = 14

-- Mô tả nhỏ
local altLabel = Instance.new("TextLabel", mainFrame)
altLabel.Text            = "[Alt]: MeDocTruyenTranh - Đọc truyện tranh online tốc độ cao."
altLabel.Size            = UDim2.new(1, -20, 0, 30)
altLabel.Position        = UDim2.new(0, 10, 1, -40)
altLabel.TextXAlignment  = Enum.TextXAlignment.Left
altLabel.TextYAlignment  = Enum.TextYAlignment.Top
altLabel.TextWrapped     = true
altLabel.TextColor3      = Color3.fromRGB(200,200,200)
altLabel.Font            = Enum.Font.Gotham
altLabel.TextSize        = 12

-- Trạng thái AFK
local status = Instance.new("TextLabel", mainFrame)
status.Text            = "Anti AFK Chamber: Khởi động..."
status.Size            = UDim2.new(1, -20, 0, 20)
status.Position        = UDim2.new(0, 10, 0, 100)
status.TextXAlignment  = Enum.TextXAlignment.Left
status.TextColor3      = Color3.new(0,1,0)
status.Font            = Enum.Font.Gotham
status.TextSize        = 14

-- Nút thu/phóng (logo)
local toggle = Instance.new("ImageButton", mainFrame)
toggle.Image             = "rbxassetid://14230252389"
toggle.Size              = UDim2.new(0,20,0,20)
toggle.Position          = UDim2.new(1,-25,0,5)
toggle.BackgroundTransparency = 1

local shown = true
toggle.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame:TweenSize(
        shown and UDim2.new(0,300,0,150) or UDim2.new(0,300,0,0),
        "Out", "Sine", 0.3, true
    )
end)

--=== Drag hỗ trợ ===--
local dragging, dragInput, mousePos, framePos = false, nil, nil, nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale, framePos.X.Offset + delta.X,
            framePos.Y.Scale, framePos.Y.Offset + delta.Y
        )
    end
end)

-- Cập nhật bộ đếm thời gian
local startTime = os.time()
RunService.Heartbeat:Connect(function()
    local elapsed = os.time() - startTime
    local h = math.floor(elapsed / 3600)
    local m = math.floor((elapsed % 3600) / 60)
    local s = elapsed % 60
    timeElapsed.Text = string.format("Client Time Elapsed: %dh:%02dm:%02ds", h, m, s)
end)

--=== 6 Hành động Chống AFK ===--
local function randomMove()
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        local off = Vector3.new(math.random(-5,5),0,math.random(-5,5))
        humanoid:MoveTo(root.Position + off)
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
    VIM:SendMouseButtonEvent(200,200,0,true,game,0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(200,200,0,false,game,0)
end

local function simulateMouseMove()
    VIM:SendMouseMoveEvent(math.random(1,500), math.random(1,500), game)
end

local function jump()
    if humanoid and humanoid:GetState()~=Enum.HumanoidStateType.Jumping then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

--=== Vòng lặp chống AFK ===--
local function antiAFKLoop()
    while ENABLED do
        task.wait(CHECK_INTERVAL)
        if tick() - lastActionTime >= ACTION_INTERVAL then
            local funcs = {randomMove, fakeKey, rotateCam, simulateClick, simulateMouseMove, jump}
            funcs[math.random(1,#funcs)]()
            lastActionTime = tick()
            status.Text = "Anti AFK Chamber: Hành động lúc "..os.date("%H:%M:%S")
        end
    end
end

-- Rejoin support
player.CharacterAdded:Connect(function(c)
    character = c
    humanoid  = c:WaitForChild("Humanoid")
end)

-- Start
task.spawn(antiAFKLoop)
