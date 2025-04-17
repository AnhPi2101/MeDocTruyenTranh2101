--===[ MeDocTruyenTranh – Anti AFK Chamber Full ]===--

-- Cấu hình key
local key_required = "zzollyan"

-- Đợi tối đa 15 giây để getgenv().key được set
local timeout = 15
local start = tick()
repeat task.wait(0.5) until getgenv().key ~= nil or tick() - start > timeout

-- Nếu sai key thì không chạy
if getgenv().key ~= key_required then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key hoặc chưa nhập key.\nDùng: getgenv().key = \"zzollyan\"",
        Duration = 10
    })
    return
end

--===[ Tối ưu hóa cực mạnh giảm lag ]===--
pcall(function()
    setfpscap(15)
end)

local lighting = game:GetService("Lighting")
lighting.GlobalShadows = false
lighting.FogEnd = 1e10
lighting.Brightness = 0

for _, v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Reflectance = 0
    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    end
end

--===[ Dịch vụ & biến chính ]===--
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local lastActionTime = tick()
local ENABLED = true

--===[ Tạo UI hiện đại có thể kéo ===--
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MeDocTruyenTranhUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", mainFrame)
title.Text = "MeDocTruyenTranh"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local timeElapsed = Instance.new("TextLabel", mainFrame)
timeElapsed.Position = UDim2.new(0, 10, 0, 40)
timeElapsed.Size = UDim2.new(1, -20, 0, 20)
timeElapsed.Text = "Client Time Elapsed: 0h:00m:00s"
timeElapsed.TextColor3 = Color3.new(1,1,1)
timeElapsed.Font = Enum.Font.Gotham
timeElapsed.TextSize = 14
timeElapsed.TextXAlignment = Enum.TextXAlignment.Left

local status = Instance.new("TextLabel", mainFrame)
status.Text = "Anti AFK Chamber: Khởi động..."
status.Position = UDim2.new(0, 10, 0, 100)
status.Size = UDim2.new(1, -20, 0, 20)
status.TextColor3 = Color3.new(0,1,0)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextXAlignment = Enum.TextXAlignment.Left

local toggle = Instance.new("ImageButton", mainFrame)
toggle.Image = "rbxassetid://14230252389"
toggle.Size = UDim2.new(0, 20, 0, 20)
toggle.Position = UDim2.new(1, -25, 0, 5)
toggle.BackgroundTransparency = 1

-- Thu/phóng UI
local shown = true
toggle.MouseButton1Click:Connect(function()
    shown = not shown
    mainFrame:TweenSize(
        shown and UDim2.new(0,300,0,150) or UDim2.new(0,300,0,0),
        "Out", "Sine", 0.3, true
    )
end)

-- Kéo UI
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

-- Bộ đếm thời gian
local startTime = os.time()
RunService.Heartbeat:Connect(function()
    local elapsed = os.time() - startTime
    local h = math.floor(elapsed / 3600)
    local m = math.floor((elapsed % 3600) / 60)
    local s = elapsed % 60
    timeElapsed.Text = string.format("Client Time Elapsed: %dh:%02dm:%02ds", h, m, s)
end)

--===[ Hành động chống AFK ]===--
local function randomMove()
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        humanoid:MoveTo(root.Position + Vector3.new(math.random(-5,5),0,math.random(-5,5)))
    end
end
local function fakeKey()
    VIM:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end
local function rotateCam()
    workspace.CurrentCamera.CFrame *= CFrame.Angles(0, math.rad(math.random(-10,10)), 0)
end
local function simulateClick()
    VIM:SendMouseButtonEvent(200,200,0,true,game,0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(200,200,0,false,game,0)
end
local function simulateMouseMove()
    VIM:SendMouseMoveEvent(math.random(100,700), math.random(100,700), game)
end
local function jump()
    if humanoid and humanoid:GetState()~=Enum.HumanoidStateType.Jumping then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

--===[ Tự động chat mỗi 5 phút ]===--
task.spawn(function()
    local phrases = {
        "script tốt thật sự", "đọc truyện tranh ở MeDocTruyenTranh vui ghê",
        "không afk nha roblox", "tôi còn đang chơi mà", "tôi yêu Raiden"
    }
    while true do
        task.wait(300) -- 5 phút
        pcall(function()
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                phrases[math.random(1, #phrases)], "All"
            )
        end)
    end
end)

--===[ Vòng lặp chống AFK ]===--
local function antiAFKLoop()
    while ENABLED do
        task.wait(30)
        if tick() - lastActionTime >= 120 then
            local funcs = {randomMove, fakeKey, rotateCam, simulateClick, simulateMouseMove, jump}
            funcs[math.random(1,#funcs)]()
            lastActionTime = tick()
            status.Text = "Anti AFK: Đã hoạt động lúc " .. os.date("%H:%M:%S")
        end
    end
end

-- Auto chạy lại sau teleport
player.CharacterAdded:Connect(function(c)
    character = c
    humanoid = c:WaitForChild("Humanoid")
    task.wait(1)
    task.spawn(antiAFKLoop)
end)

task.spawn(antiAFKLoop)
