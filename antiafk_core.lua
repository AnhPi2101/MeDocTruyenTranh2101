-- Anti-AFK PRO | Hiện đại + Âm thanh + Tùy chỉnh size
-- Made by ChatGPT | Swift Exploit Compatible

-- Services
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

-- Anti-AFK State
local isAFKEnabled = true
local runAFKLoop = true

-- Sounds
local onSound = Instance.new("Sound", game.SoundService)
onSound.SoundId = "rbxassetid://12221967" -- bật: ting
onSound.Volume = 1

local offSound = Instance.new("Sound", game.SoundService)
offSound.SoundId = "rbxassetid://138087017" -- tắt: click
offSound.Volume = 1

-- UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AntiAFK_UIPro"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 120)
frame.Position = UDim2.new(0.75, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
frame.ClipsDescendants = true

-- Modern style
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.85, 0, 0.2, 0)
frame.Size = UDim2.new(0, 250, 0, 130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0
frame.ZIndex = 2
frame.Parent = gui
frame.ClipsDescendants = true

-- Rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.5
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.ZIndex = 1
shadow.Parent = frame

-- Background Image
local animeImage = Instance.new("ImageLabel")
animeImage.Size = UDim2.new(1, 0, 1, 0)
animeImage.Position = UDim2.new(0, 0, 0, 0)
animeImage.BackgroundTransparency = 1
animeImage.Image = "rbxassetid://15684703902"
animeImage.ImageTransparency = 0.85
animeImage.ZIndex = 0
animeImage.Parent = frame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0.4, 0)
statusLabel.Position = UDim2.new(0, 10, 0.05, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Anti-AFK: ON"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextScaled = true
statusLabel.ZIndex = 3
statusLabel.Parent = frame

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.6, 0, 0.25, 0)
toggleButton.Position = UDim2.new(0.2, 0, 0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.Text = "Tắt Anti-AFK"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.ZIndex = 3
toggleButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleButton

-- Size Slider
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Text = "Kích thước UI"
sliderLabel.Size = UDim2.new(0.6, 0, 0.15, 0)
sliderLabel.Position = UDim2.new(0.2, 0, 0.8, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.TextScaled = true
sliderLabel.ZIndex = 3
sliderLabel.Parent = frame

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(0.4, 0, 0.1, 0)
slider.Position = UDim2.new(0.55, 0, 0.8, 0)
slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
slider.Text = "+"
slider.Font = Enum.Font.Gotham
slider.TextColor3 = Color3.new(1, 1, 1)
slider.TextScaled = true
slider.ZIndex = 3
slider.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = slider

-- Slider Functionality
slider.MouseButton1Click:Connect(function()
    local size = frame.Size.X.Offset
    local newSize = size >= 400 and 250 or size + 50
    frame:TweenSize(UDim2.new(0, newSize, 0, newSize * 0.52), "Out", "Sine", 0.3, true)
end)

-- Toggle Anti-AFK
toggleButton.MouseButton1Click:Connect(function()
    isAFKEnabled = not isAFKEnabled
    if isAFKEnabled then
        onSound:Play()
        statusLabel.Text = "Anti-AFK: ON"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        toggleButton.Text = "Tắt Anti-AFK"
    else
        offSound:Play()
        statusLabel.Text = "Anti-AFK: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        toggleButton.Text = "Bật Anti-AFK"
    end
end)

-- Viền đổi màu cầu vồng
task.spawn(function()
    while frame do
        for i = 0, 1, 0.02 do
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromHSV(i, 1, 1)
            wait(0.02)
        end
    end
end)

-- Anti-AFK Core
player.Idled:Connect(function()
    if isAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(0.5)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Nhẹ nhàng dịch chuyển
task.spawn(function()
    while runAFKLoop do
        wait(120)
        if isAFKEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local original = hrp.CFrame
            hrp.CFrame = original + Vector3.new(0.1, 0, 0)
            wait(0.1)
            hrp.CFrame = original
        end
    end
end)
