local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cấu hình key
local key_required = "zzollyan"  -- Key yêu cầu
local timeout = 15
local start = tick()

-- Kiểm tra key
repeat
    task.wait(0.5)
until getgenv().key ~= nil or tick() - start > timeout

if getgenv().key ~= key_required then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key hoặc chưa nhập key.\nDùng: getgenv().key = \"zzollyan\"",
        Duration = 10
    })
    return
end

-- ** Tạo UI với nền Raiden Shogun **
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")

-- GUI GỐC
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

-- ** Tích hợp các chức năng khác **

-- Fakekey và tự động nhảy mỗi 20 giây
spawn(function()
    while true do
        -- Fake key (bấm phím J)
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.J, false, game)
        wait(0.1)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.J, false, game)
        wait(20)  -- Mỗi 20 giây
    end
end)

-- Di chuyển W/A/S/D tự động mỗi 10 giây
spawn(function()
    while true do
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:Move(Vector3.new(1, 0, 0))  -- Di chuyển về phía trước (W)
                wait(10)  -- Mỗi 10 giây di chuyển một lần
            end
        end
    end
end)

local function OptimizeGraphics()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.TextureQuality = Enum.TextureQuality.Low

    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 1e10
    game:GetService("Lighting").Brightness = 0
    game:GetService("Lighting").Ambient = Color3.new(0, 0, 0)

    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v:IsA("PostEffect") then v:Destroy() end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj:Destroy()
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Explosion") or obj:IsA("Fire") or obj:IsA("Smoke") then
            obj:Destroy()
        end
    end

    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") and sound.Playing and sound.Volume > 0.1 then
            sound.Volume = 0
        end
    end
end

pcall(OptimizeGraphics)
