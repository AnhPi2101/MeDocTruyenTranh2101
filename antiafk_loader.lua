-- Anti AFK Loader (tự động chạy khi teleport)
local key = "zzollyan"
getgenv().Key = key

-- Dòng auto-run khi teleport sang khu vực khác
local rejoinScript = [[
getgenv().Key = "zzollyan"
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_loader.lua"))()
]]
queue_on_teleport(rejoinScript)

-- Chạy phần chính
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhPi2101/MeDocTruyenTranh2101/main/antiafk_core.lua"))()
