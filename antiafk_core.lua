if getgenv().AntiAFKEnabled then return end
getgenv().AntiAFKEnabled = true

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AntiAFK_UI"
ScreenGui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton", ScreenGui)
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 1, -80)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
toggleButton.Text = "Hiện UI"
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.ZIndex = 3

-- Main UI frame
local main = Instance.new("Frame", ScreenGui)
main.Size = UDim2.new(0, 300, 0, 170)
main.Position = UDim2.new(0.5, -150, 0.5, -100)
main.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true
main.Draggable = true
main.ZIndex = 2

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Thickness = 2

local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "https://i.imgur.com/pLR3yOm.jpeg" -- Hình Raiden
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.4
bg.ZIndex = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ANTI AFK CHAMBER"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.ZIndex = 2

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 0, 50)
status.Text = "Đang hoạt động..."
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.TextColor3 = Color3.fromRGB(255, 255, 0)
status.BackgroundTransparency = 1
status.ZIndex = 2

-- Settings UI
local settingsLabel = Instance.new("TextLabel", main)
settingsLabel.Size = UDim2.new(1, -20, 0, 25)
settingsLabel.Position = UDim2.new(0, 10, 0, 90)
settingsLabel.Text = "Tuỳ chỉnh:"
settingsLabel.Font = Enum.Font.GothamBold
settingsLabel.TextScaled = true
settingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsLabel.BackgroundTransparency = 1
settingsLabel.ZIndex = 2

local sizeButton = Instance.new("TextButton", main)
sizeButton.Size = UDim2.new(0.3, 0, 0, 25)
sizeButton.Position = UDim2.new(0.05, 0, 0, 120)
sizeButton.Text = "Size"
sizeButton.Font = Enum.Font.Gotham
sizeButton.TextScaled = true
sizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeButton.BackgroundColor3 = Color3.fromRGB(255, 128, 128)
sizeButton.ZIndex = 2

local colorButton = Instance.new("TextButton", main)
colorButton.Size = UDim2.new(0.3, 0, 0, 25)
colorButton.Position = UDim2.new(0.35, 10, 0, 120)
colorButton.Text = "Màu"
colorButton.Font = Enum.Font.Gotham
colorButton.TextScaled = true
colorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
colorButton.BackgroundColor3 = Color3.fromRGB(128, 255, 128)
colorButton.ZIndex = 2

local bgButton = Instance.new("TextButton", main)
bgButton.Size = UDim2.new(0.3, 0, 0, 25)
bgButton.Position = UDim2.new(0.7, 0, 0, 120)
bgButton.Text = "Nền"
bgButton.Font = Enum.Font.Gotham
bgButton.TextScaled = true
bgButton.TextColor3 = Color3.fromRGB(255, 255, 255)
bgButton.BackgroundColor3 = Color3.fromRGB(128, 128, 255)
bgButton.ZIndex = 2

-- Toggle function
toggleButton.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    toggleButton.Text = main.Visible and "Ẩn UI" or "Hiện UI"
end)

-- Size options
local sizes = {
    {300, 170},
    {350, 200},
    {400, 230}
}
local sizeIndex = 1
sizeButton.MouseButton1Click:Connect(function()
    sizeIndex = sizeIndex % #sizes + 1
    main.Size = UDim2.new(0, sizes[sizeIndex][1], 0, sizes[sizeIndex][2])
end)

-- Color options
local colors = {
    Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,0,255),
    Color3.fromRGB(255,255,0),
    Color3.fromRGB(255,128,0),
}
local colorIndex = 1
colorButton.MouseButton1Click:Connect(function()
    colorIndex = colorIndex % #colors + 1
    stroke.Color = colors[colorIndex]
end)

-- Background options
local bgs = {
    "https://i.imgur.com/pLR3yOm.jpeg", -- Raiden
    "https://i.imgur.com/3qPK8rY.jpeg",
    "https://i.imgur.com/N9qz9p2.jpeg",
}
local bgIndex = 1
bgButton.MouseButton1Click:Connect(function()
    bgIndex = bgIndex % #bgs + 1
    bg.Image = bgs[bgIndex]
end)

-- VirtualUser Anti AFK Logic
for _, v in pairs(getconnections(player.Idled)) do
    v:Disable()
end

task.spawn(function()
    local vu = game:GetService("VirtualUser")
    while getgenv().AntiAFKEnabled do
        task.wait(300)
        pcall(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(1), 0)
        end)
    end
end)
