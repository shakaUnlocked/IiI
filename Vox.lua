local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "aa",
    SubTitle = "shaka passou aqui",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 300),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "sword" })
}

local MainSection = Tabs.Main:AddSection("aa")

local AutoAttackToggle = MainSection:AddToggle("AutoAttackToggle", {
    Title = "Auto attack(feito em 10segundos)",
    Default = true,
    Callback = function(state)
        _G.AutoAttackEnabled = state
    end
})

_G.AutoAttackEnabled = true
local ATTACK_RANGE = 15

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local CombatEvent = ReplicatedStorage:WaitForChild("BetweenSides"):WaitForChild("Remotes"):WaitForChild("Events"):WaitForChild("CombatEvent")

local ENEMY_FOLDER = workspace:WaitForChild("Playability"):WaitForChild("Enemys"):WaitForChild("Foosha Village")

local function setUpsideDownPose(active)
    if active then

        humanoid.AutoRotate = false
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.pi, 0, 0)
    else
        humanoid.AutoRotate = true
    end
end

local function dealDamageToMob(mob)
    setUpsideDownPose(true)
    
    local combos = {1, 2, 3}
    for _, combo in ipairs(combos) do
        local args = {
            "DealDamage",
            {
                CallTime = tick(),
                Results = { mob },
                Combo = combo,
                DelayTime = 0
            }
        }
        CombatEvent:FireServer(unpack(args))
    end
    
    task.delay(0, function()
        setUpsideDownPose(false)
    end)
end

local function getNearbyEnemies()
    local nearbyEnemies = {}
    for _, mob in pairs(ENEMY_FOLDER:GetChildren()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            local distance = (mob.HumanoidRootPart.Position - rootPart.Position).Magnitude
            if distance <= ATTACK_RANGE then
                table.insert(nearbyEnemies, mob)
            end
        end
    end
    return nearbyEnemies
end

RunService.Heartbeat:Connect(function()
    if not _G.AutoAttackEnabled then return end
    if not character or not rootPart then
        character = player.Character
        if character then
            rootPart = character:WaitForChild("HumanoidRootPart")
            humanoid = character:WaitForChild("Humanoid")
        end
        return
    end
    
    local enemies = getNearbyEnemies()
    for _, mob in pairs(enemies) do
        local targetCFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(math.pi, 0, 0)
        rootPart.CFrame = targetCFrame
        dealDamageToMob(mob)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    rootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
end)

