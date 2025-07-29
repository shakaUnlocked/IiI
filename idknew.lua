local ID = game.PlaceId
local baseURL = "https://raw.githubusercontent.com/shakaUnlocked/IiI/refs/heads/main/"
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

function GetGame()
    if ID == 15014439457 or 5170731021 then
        return ""
    elseif ID == 2753915549 or 4442272183 or 7449423635 then 
        return "bffinder.lua"
    else
        print("Game is not supported.")
        return nil
    end
end

local gameScript = GetGame()

if gameScript then
    loadstring(game:HttpGet(baseURL .. gameScript))()
end

for _, v in next, getconnections(plr.Idled) do
    v:Disable()
end

local VirtualUser = game:GetService("VirtualUser")
local status = getgenv().afk_toggle
if status == nil then
    getgenv().afk_toggle = false
end

if not plr then
    error("Failed to get LocalPlayer reference")
end

plr.Idled:Connect(function()
    if not getgenv().afk_toggle then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)
