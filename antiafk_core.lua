local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInput = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Kiểm tra key
local key_required = "zzollyan"
if getgenv().key ~= key_required then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Anti AFK Chamber",
        Text = "Sai key hoặc chưa nhập key.\nDùng: getgenv().key = \"zzollyan\"",
        Duration = 10
    })
    return
end

-- UI chính
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "MeDocRaidenUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 160)
frame.Position = UDim2.new(0.03, 0, 0.05, 0)
frame.BackgroundTransparency = 1
frame.Active = true

local image = Instance.new("ImageLabel", frame)
image.Size = UDim2.new(1, 0, 1, 0)
image.BackgroundTransparency = 1
image.Image = "rbxassetid://99255503850752"
image.ScaleType = Enum.ScaleType.Crop

local gradient = Instance.new("UIGradient", image)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
}

spawn(function()
    while true do
        local tween = TweenService:Create(gradient, TweenInfo.new(20, Enum.EasingStyle.Linear), {Rotation = gradient.Rotation + 360})
        tween:Play()
        tween.Completed:Wait()
    end
end)

local function addLabel(text, position)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Position = position
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = text
    return label
end

local title = addLabel('<font color="#00AEEF">MeDoc</font><font color="#EC0B3D">TruyenTranh</font>', UDim2.new(0, 0, 0, 5))
title.RichText = true
title.Font = Enum.Font.GothamBold
title.Size = UDim2.new(1, 0, 0, 35)

local statusLabel = addLabel("Status: Đang hoạt động", UDim2.new(0, 0, 0, 50))
local timerLabel = addLabel("00:00:00", UDim2.new(0, 0, 0, 85))

spawn(function()
    local startTime = os.time()
    while true do
        local elapsed = os.time() - startTime
        timerLabel.Text = string.format("%02d:%02d:%02d", math.floor(elapsed / 3600), math.floor((elapsed % 3600) / 60), elapsed % 60)
        wait(1)
    end
end)

-- Kéo thả UI
do
    local dragging, dragStart, startPos, dragInput
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInput.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Auto Jump mỗi 15 giây
spawn(function()
    while true do
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        wait(15)
    end
end)

-- Auto W/A/S/D mỗi 10 giây
spawn(function()
    local moveList = {Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1)}
    while true do
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(moveList[math.random(1, #moveList)])
            end
        end
        wait(10)
    end
end)

-- Fake key (J) mỗi 20s
spawn(function()
    while true do
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.J, false, game)
        wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.J, false, game)
        wait(20)
    end
end)

-- Giảm FPS (giảm CPU)
pcall(function()
    setfpscap(20)
end)

-- Tối ưu đồ hoạ không phá map
local function OptimizeGraphics()
    local Lighting = game:GetService("Lighting")
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.TextureQuality = Enum.TextureQuality.Low

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    Lighting.Ambient = Color3.new(0, 0, 0)

    for _, v in pairs(Lighting:GetChildren()) do
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
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Explosion") then
            obj:Destroy()
        end
    end

    for _, sound in pairs(workspace:GetDescendants()) do
        if sound:IsA("Sound") and sound.Volume > 0.1 then
            sound.Volume = 0
        end
    end
end

pcall(OptimizeGraphics)
