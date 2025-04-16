-- Anti-AFK UI + Bypass AFK Chamber
if getgenv().AntiAFKEnabled then return end
getgenv().AntiAFKEnabled = true

-- UI hiện đại giống W Azure
local imageURL = "https://i.imgur.com/3qPK8rY.jpeg" -- Hình Raiden

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AntiAFK_UI"
ScreenGui.ResetOnSpawn = false

local main = Instance.new("Frame", ScreenGui)
main.Size = UDim2.new(0, 300, 0, 100)
main.Position = UDim2.new(1, -320, 1, -120)
main.BackgroundTransparency = 0
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.ClipsDescendants = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local shadow = Instance.new("ImageLabel", main)
shadow.Image = "rbxassetid://5553946656"
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(20,20,280,280)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.ImageTransparency = 0.4
shadow.ZIndex = -1

local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = imageURL
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.2
bg.ZIndex = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -20, 0.4, 0)
title.Position = UDim2.new(0, 10, 0, 10)
title.Text = "ANTI AFK CHAMBER"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.TextStrokeTransparency = 0.7

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0.4, 0)
status.Position = UDim2.new(0, 10, 0.5, 0)
status.Text = "Đang hoạt động..."
status.Font = Enum.Font.Gotham
status.TextScaled = true
status.TextColor3 = Color3.fromRGB(200, 255, 200)
status.BackgroundTransparency = 1
status.TextStrokeTransparency = 0.8

-- Chống Roblox AFK
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

-- Bypass AFK Chamber (di chuyển camera + chuột)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    while task.wait(300) do
        if not getgenv().AntiAFKEnabled then break end
        pcall(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(1), 0)
        end)
    end
end)
