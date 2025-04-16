-- Loader script with key system
local correctKey = "zzollyan"
local keyFile = "zz_key.txt"

local function saveKey(k)
    if writefile then
        writefile(keyFile, k)
    end
end

local function readKey()
    if isfile and isfile(keyFile) then
        return readfile(keyFile)
    end
    return nil
end

local function validate(k)
    return k == correctKey
end

local function promptKey(callback)
    local gui = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.8, 0, 0.3, 0)
    box.Position = UDim2.new(0.1, 0, 0.25, 0)
    box.PlaceholderText = "Nhập key..."
    box.TextScaled = true
    box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.6, 0, 0.2, 0)
    btn.Position = UDim2.new(0.2, 0, 0.65, 0)
    btn.Text = "Xác nhận"
    btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)

    btn.MouseButton1Click:Connect(function()
        local input = box.Text
        if validate(input) then
            saveKey(input)
            gui:Destroy()
            callback(true)
        else
            box.Text = "Sai key!"
        end
    end)
end

local key = getgenv().Key or readKey()
if validate(key) then
    saveKey(key)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_core.lua"))()
else
    promptKey(function(success)
        if success then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_core.lua"))()
        end
    end)
end
