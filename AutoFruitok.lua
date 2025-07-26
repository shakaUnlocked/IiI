-- yea its open source, skid me noobie
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "JOIN DISCORD FOR MORE",
    SubTitle = "https://discord.gg/XTcpS7Aw",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350), 
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Teleport", Icon = "fruit" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local MainSection = Tabs.Main:AddSection("Fruit Teleport", {
    Title = "Fruit Teleport System",
    Side = "Left"
})

local SettingsSection = Tabs.Settings:AddSection("Configuration", {
    Side = "Left"
})

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local TeleportToggle = MainSection:AddToggle("TeleportToggle", {
    Title = "Tp fruit",
    Default = false,
    Callback = function(state)
        _G.TeleportToFruit = state
        if state then
            Fluent:Notify({
                Title = "Ativado",
                Content = "indo",
                Duration = 3
            })
        end
    end
})


_G.TeleportToFruit = false
_G.TeleportPriority = "Nearest Fruit"
_G.TeleportHeight = 5
_G.TeleportDelay = 0.5
_G.LastTeleport = 0

local function getAvailableFruits()
    local fruits = {}
    local success, err = pcall(function()
        local droppedTools = Workspace:WaitForChild("Playability"):WaitForChild("DroppedTools")
        
        for _, tool in ipairs(droppedTools:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                table.insert(fruits, {
                    Object = tool,
                    Position = tool.Handle.Position,
                    Distance = (tool.Handle.Position - rootPart.Position).Magnitude
                })
            end
        end
    end)
    
    if not success then
        warn("Error finding fruits: "..err)
    end
    
    return fruits
end

local function teleportToFruit(fruit)
    if not fruit or not fruit.Object:FindFirstChild("Handle") then return end
    
    local fruitPosition = fruit.Position
    local targetPosition = fruitPosition + Vector3.new(0, _G.TeleportHeight, 0)
    rootPart.CFrame = CFrame.new(targetPosition)
    
    _G.LastTeleport = tick()
end

local function selectFruit(fruits)
    if #fruits == 0 then return nil end
    
    if _G.TeleportPriority == "All Fruits" then
        table.sort(fruits, function(a, b) return a.Distance < b.Distance end)
        return fruits[1]
    elseif _G.TeleportPriority == "Random Fruit" then
        return fruits[math.random(1, #fruits)]
    elseif _G.TeleportPriority == "Best Value" then
        table.sort(fruits, function(a, b) return a.Distance < b.Distance end)
        return fruits[1]
    else 
        table.sort(fruits, function(a, b) return a.Distance < b.Distance end)
        return fruits[1]
    end
end
RunService.Heartbeat:Connect(function()
    if not _G.TeleportToFruit then return end
    if not character or not rootPart then
        character = player.Character
        if character then
            rootPart = character:WaitForChild("HumanoidRootPart")
            humanoid = character:WaitForChild("Humanoid")
        end
        return
    end
    
    if tick() - _G.LastTeleport < _G.TeleportDelay then return end
    
    local availableFruits = getAvailableFruits()
    if #availableFruits > 0 then
        local selectedFruit = selectFruit(availableFruits)
        if selectedFruit then
            teleportToFruit(selectedFruit)
        end
    end
end)
local Toggle = Tabs.Main:AddToggle("MyToggle", {
    Title = "Auto store", 
    Description = "",
    Default = true,
    Callback = function(state)
        if state then
            coroutine.wrap(function()
                while state do
                    local args = {"StoreFruit"}
                    game:GetService("ReplicatedStorage"):WaitForChild("BetweenSides"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("ToolsEvent"):FireServer(unpack(args))
                    task.wait(0)  
                end
            end)()
        end
    end 
})

Tabs.Main:AddButton({
    Title = "Hop server skidd",
    Description = "",
    Callback = function()
    local module = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()

module:Teleport(game.PlaceId)
    end
})
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
end)

