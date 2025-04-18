-- Đường dẫn đến script chính
local rawScriptURL = "https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_core.lua"
local correctKey = "zzollyan"

-- UI Nhập key nếu chưa có
if not getgenv().key then
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "KeyInputUI"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Nhập Key để tiếp tục"
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local textbox = Instance.new("TextBox", frame)
    textbox.Size = UDim2.new(0.8, 0, 0, 30)
    textbox.Position = UDim2.new(0.1, 0, 0.4, 0)
    textbox.PlaceholderText = "Nhập key tại đây..."
    textbox.Font = Enum.Font.Gotham
    textbox.TextSize = 14
    textbox.Text = ""
    textbox.TextColor3 = Color3.new(1,1,1)
    textbox.BackgroundColor3 = Color3.fromRGB(60,60,60)

    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(0.6, 0, 0, 30)
    button.Position = UDim2.new(0.2, 0, 0.7, 0)
    button.Text = "Xác Nhận"
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    button.TextColor3 = Color3.new(1,1,1)

    button.MouseButton1Click:Connect(function()
        local userKey = textbox.Text
        if userKey == correctKey then
            getgenv().key = userKey
            gui:Destroy()
            -- Tải lại script khi key đúng
            loadstring(game:HttpGet(rawScriptURL))()
        else
            textbox.Text = ""
            textbox.PlaceholderText = "Key sai! Thử lại..."
        end
    end)
else
    if getgenv().key == correctKey then
        -- Tải lại script khi key đúng
        loadstring(game:HttpGet(rawScriptURL))()
    else
        warn("Sai key!")
    end
end

-- Tích hợp queue_on_teleport để tự động tải lại khi teleport
if queue_on_teleport then
    queue_on_teleport([[
        -- Khi teleport, tải lại script Anti AFK hoàn chỉnh
        getgenv().key = "zzollyan"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_loader.lua"))()
    ]])
end
