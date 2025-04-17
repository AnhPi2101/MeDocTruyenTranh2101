-- Anti AFK Chamber Anime Vanguard (Game-specific)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Cấu hình
local ANTI_AFK_ENABLED = true
local CHECK_INTERVAL = 60  -- Kiểm tra mỗi 60 giây
local ACTION_INTERVAL = 300 -- Hành động mỗi 5 phút
local MIN_MOVE_DISTANCE = 10 -- Di chuyển tối thiểu 10 studs

-- Biến hệ thống
local lastActionTime = tick()
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- UI đơn giản
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiAFKUI"
screenGui.Parent = game.CoreGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 0.7
statusLabel.Text = "🟢 Anti-AFK: Đang hoạt động"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = screenGui

-- Hàm di chuyển ngẫu nhiên
local function randomMove()
    if not character or not humanoid then return end
    
    -- Chọn điểm ngẫu nhiên gần vị trí hiện tại
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local currentPos = rootPart.Position
    local randomOffset = Vector3.new(
        math.random(-MIN_MOVE_DISTANCE, MIN_MOVE_DISTANCE),
        0,
        math.random(-MIN_MOVE_DISTANCE, MIN_MOVE_DISTANCE)
    )
    
    humanoid:MoveTo(currentPos + randomOffset)
    return true
end

-- Hàm tương tác UI giả lập
local function fakeUIInteraction()
    -- Giả lập nhấn phím inventory (I) hoặc menu (M)
    local keysToPress = {"I", "M", "Tab"}
    local key = keysToPress[math.random(1, #keysToPress)]
    
    -- Mô phỏng nhấn phím
    UserInputService:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    UserInputService:SendKeyEvent(false, key, false, game)
    return true
end

-- Hàm xoay camera tự nhiên
local function rotateCamera()
    local camera = workspace.CurrentCamera
    if not camera then return end
    
    local currentCFrame = camera.CFrame
    local randomAngle = math.rad(math.random(-15, 15))
    
    camera.CFrame = currentCFrame * CFrame.Angles(0, randomAngle, 0)
    task.wait(0.2)
    camera.CFrame = currentCFrame
    return true
end

-- Hệ thống chống AFK chính
local function antiAFKRoutine()
    while ANTI_AFK_ENABLED and task.wait(CHECK_INTERVAL) do
        local now = tick()
        local elapsed = now - lastActionTime
        
        if elapsed >= ACTION_INTERVAL then
            -- Chọn ngẫu nhiên 1 trong 3 hành động
            local actionSuccess = false
            local actionType = math.random(1, 3)
            
            if actionType == 1 then
                actionSuccess = randomMove()
            elseif actionType == 2 then
                actionSuccess = fakeUIInteraction()
            else
                actionSuccess = rotateCamera()
            end
            
            if actionSuccess then
                lastActionTime = tick()
                statusLabel.Text = "🟢 Anti-AFK: Đã kích hoạt "..os.date("%H:%M:%S")
                
                -- Log để debug
                print("[Anti-AFK] Đã kích hoạt hành động loại", actionType)
            end
        else
            local remaining = math.floor(ACTION_INTERVAL - elapsed)
            statusLabel.Text = string.format("🟢 Anti-AFK: Hoạt động sau %ds", remaining)
        end
    end
end

-- Tự động cập nhật khi respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

-- Bắt đầu hệ thống
antiAFKRoutine()

-- Hotkey bật/tắt (Shift + F1)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        ANTI_AFK_ENABLED = not ANTI_AFK_ENABLED
        statusLabel.Text = ANTI_AFK_ENABLED and "🟢 Anti-AFK: Đang hoạt động" or "🔴 Anti-AFK: Đã tắt"
        print("Anti-AFK:", ANTI_AFK_ENABLED and "Bật" or "Tắt")
    end
end)
