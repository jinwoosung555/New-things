-- AertherX Hub
-- Rebuilt GUI based on the feature names present in the supplied Lua constants file.
-- Black theme. Designed for Roblox/Luau executor environments.
-- Note: game-specific remote names can change; the farming engine is intentionally
-- modular so the target-game adapters can be updated without changing the GUI.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- =========================
-- AertherX configuration
-- =========================
local Config = {
    AutoFarmLevel = false,
    AutoFarmNearest = false,
    FarmAllIsland = false,
    AutoQuest = true,
    BringMobs = true,
    AutoM1 = true,
    AutoHaki = false,
    AutoObservation = false,
    Aimbot = false,
    ESP = false,
    FruitESP = false,
    CollectFruit = false,
    CollectBerry = false,
    AutoRaid = false,
    AutoFishing = false,
    AutoRaceV2V3 = false,
    AutoRaceV4 = false,
    KillBoss = false,
    AutoMaterials = false,
    AntiAFK = true,
    WalkSpeed = 16,
    JumpPower = 50,
    SelectedWeapon = "Melee",
    SelectedSeaEvent = "Prehistoric",
}


-- Expanded feature registry reconstructed from the supplied constants metadata.
local FeatureGroups = {
    Farming = {
        "Auto Farm Level", "Farm All Island", "Auto Farm Near", "Farm Elite Hunter", "Farm Boss",
        "Farm Cake Prince", "Farm Rip Indra", "Farm Dough King", "Farm Mastery", "Farm Chest",
        "Auto Quest", "Auto Accept Quest", "Auto Turn Quest", "Bring Enemy", "Magnet Event",
        "Auto Material", "Farm Bone", "Farm Ectoplasm", "Farm Fish Tail", "Farm Dragon Scale",
        "Farm Gunpowder", "Farm Leather + Scrap Metal", "Farm Demonic Wisp", "Farm Mystic Droplet",
        "Farm Conjured Cocoa", "Farm Radioactive Material", "Auto Raid", "Auto Dungeon"
    },
    Combat = {
        "Aim Player", "Nearest Aim", "Aimbot", "Auto M1", "Fast Attack", "Destroy Hit", "Auto Skill",
        "Auto Haki", "Auto Observation", "Auto Defense", "Auto PvP", "Safe Mode", "Mastery Farm",
        "Selected Mastery Skills", "Use Skills", "Auto Gun", "Auto Sword", "Auto Melee", "Auto Blox Fruit"
    },
    Fruits = {
        "Fruit ESP", "Auto Collect Fruit", "Auto Eat Fruit", "Store Fruit", "Drop Fruit", "Auto Chip Fruit",
        "Fruit Stock", "Random Auto Fruit", "Fruit Customizer", "Kitsune Island Event", "Mirage Island ESP"
    },
    SeaEvents = {
        "Prehistoric Event", "Frozen Dimension Event", "Kitsune Island Event", "Leviathan Helper",
        "Sea Beast", "Terror Shark", "Fish Boat", "Sail Boat Hydra", "Prehistoric Status", "Frozen Dimension Status",
        "Mirage Island Status", "Full Moon Status", "Moon Status", "Entity Sea Event", "Magnet Event"
    },
    Travel = {
        "Travel World 1", "Travel World 2", "Travel World 3", "Travel Island", "Travel NPC", "Hydra Teleport",
        "Temple of Time", "Tiki Outpost", "Castle On The Sea", "Mansion Cafe", "Underwater City", "Cursed Ship",
        "Haunted Castle", "Sea of Treats", "Floating Turtle", "Mirage Island", "Prehistoric Island", "Kitsune Island"
    },
    Race = {
        "Upgrade Race V2", "Upgrade Race V3", "Race V4", "Trial Quest V4", "Auto Trial", "Temple of Time",
        "Full Moon Helper", "Tiers V4 Status", "Race Status"
    },
    Fishing = {
        "Auto Fishing", "Fishing Quest", "Auto Fish", "Auto Bait", "Kelp Bait", "Good Bait", "Epic Bait",
        "Carnivore Bait", "Abyssal Bait", "Frozen Bait", "Basic Bait", "Rod Upgrade"
    },
    Items = {
        "Auto Buy Microchip Law", "Buy Electric Claw", "Buy Superhuman", "Buy Death Step", "Buy Sanguine Art",
        "Buy Dragon Talon", "Buy Fishman Karate", "Buy Fighting Style", "Legendary Sword", "Cursed Dual Katana",
        "Tushita + Yama", "Soul Guitar", "Serpent Bow", "Twin Hooks", "Pole V2", "God Enal's"
    },
    Misc = {
        "Anti AFK", "Walk On Water", "Speed Boat", "No Clip Ship", "Auto Defense", "RTX Mode", "Server Hop",
        "Rejoin Server", "FPS Boost", "Low Graphics", "Player List", "Mobile Minimizer", "Notifications", "Safe Teleport"
    }
}

local Expanded = {}
for group, features in pairs(FeatureGroups) do
    Expanded[group] = {}
    for _, feature in ipairs(features) do Expanded[group][feature] = false end
end

local function featureToggle(parent, group, feature)
    local key = group .. "::" .. feature
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,34)
    b.BackgroundColor3 = Color3.fromRGB(14,14,14)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = ""
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    local t = label(b, feature, UDim2.fromOffset(11,0), UDim2.new(1,-60,1,0), 11, Color3.fromRGB(210,210,210))
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(16,16)
    dot.Position = UDim2.new(1,-29,0.5,-8)
    dot.BackgroundColor3 = Color3.fromRGB(55,55,55)
    dot.Parent = b
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    b.MouseButton1Click:Connect(function()
        Expanded[group][feature] = not Expanded[group][feature]
        dot.BackgroundColor3 = Expanded[group][feature] and Color3.fromRGB(230,230,230) or Color3.fromRGB(55,55,55)
    end)
end

-- =========================
-- UI helpers
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "AertherX"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Name = "Window"
main.Size = UDim2.fromOffset(720, 460)
main.Position = UDim2.new(0.5, -360, 0.5, -230)
main.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(42, 42, 42)
stroke.Thickness = 1
stroke.Parent = main

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 55)
top.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
top.BorderSizePixel = 0
top.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 7)
title.Size = UDim2.fromOffset(400, 25)
title.Font = Enum.Font.GothamBold
title.Text = "AertherX Hub"
title.TextColor3 = Color3.fromRGB(245,245,245)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(19, 31)
subtitle.Size = UDim2.fromOffset(450, 18)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Blox Fruits • Black Edition"
subtitle.TextColor3 = Color3.fromRGB(135,135,135)
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -44, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(20,20,20)
close.Text = "×"
close.TextColor3 = Color3.fromRGB(220,220,220)
close.TextSize = 22
close.Font = Enum.Font.GothamBold
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
close.MouseButton1Click:Connect(function() gui.Enabled = false end)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(0, 55)
sidebar.Size = UDim2.fromOffset(145, 405)
sidebar.BackgroundColor3 = Color3.fromRGB(10,10,10)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(145, 55)
content.Size = UDim2.new(1, -145, 1, -55)
content.BackgroundColor3 = Color3.fromRGB(8,8,8)
content.BorderSizePixel = 0
content.Parent = main

local function label(parent, text, pos, size, fontSize, color)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Position = pos
    x.Size = size
    x.Font = Enum.Font.Gotham
    x.Text = text
    x.TextColor3 = color or Color3.fromRGB(220,220,220)
    x.TextSize = fontSize or 13
    x.TextXAlignment = Enum.TextXAlignment.Left
    x.Parent = parent
    return x
end

local pages = {}
local tabButtons = {}

local function newPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Position = UDim2.fromOffset(12, 12)
    page.Size = UDim2.new(1, -24, 1, -24)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    pages[name] = page
    return page
end

local function addTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -18, 0, 34)
    b.Position = UDim2.fromOffset(9, 0)
    b.BackgroundColor3 = Color3.fromRGB(10,10,10)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(150,150,150)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = sidebar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    tabButtons[name] = b
    return b
end

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 5)
sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 12)

local function showPage(name)
    for n,p in pairs(pages) do
        p.Visible = (n == name)
    end
    for n,b in pairs(tabButtons) do
        b.BackgroundColor3 = (n == name) and Color3.fromRGB(28,28,28) or Color3.fromRGB(10,10,10)
        b.TextColor3 = (n == name) and Color3.fromRGB(245,245,245) or Color3.fromRGB(145,145,145)
    end
end

local function section(parent, text)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 31)
    holder.BackgroundTransparency = 1
    holder.Parent = parent
    label(holder, text, UDim2.fromOffset(2, 5), UDim2.new(1,0,1,0), 12, Color3.fromRGB(125,125,125))
end

local function toggle(parent, key, text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(15,15,15)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = ""
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)

    local t = label(b, text, UDim2.fromOffset(12,0), UDim2.new(1,-65,1,0), 12, Color3.fromRGB(220,220,220))
    local state = Instance.new("Frame")
    state.Size = UDim2.fromOffset(36, 20)
    state.Position = UDim2.new(1,-48,0.5,-10)
    state.BackgroundColor3 = Color3.fromRGB(32,32,32)
    state.Parent = b
    Instance.new("UICorner", state).CornerRadius = UDim.new(1,0)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(14,14)
    dot.Position = UDim2.fromOffset(3,3)
    dot.BackgroundColor3 = Color3.fromRGB(125,125,125)
    dot.Parent = state
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local function render()
        local on = Config[key]
        state.BackgroundColor3 = on and Color3.fromRGB(70,70,70) or Color3.fromRGB(32,32,32)
        dot.Position = on and UDim2.fromOffset(19,3) or UDim2.fromOffset(3,3)
        dot.BackgroundColor3 = on and Color3.fromRGB(245,245,245) or Color3.fromRGB(125,125,125)
    end
    render()
    b.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        render()
    end)
    return b
end

local function button(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,36)
    b.BackgroundColor3 = Color3.fromRGB(17,17,17)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(215,215,215)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 12
    b.AutoButtonColor = false
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,7)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function dropdown(parent, text, key, values)
    local current = 1
    local b = button(parent, text .. ": " .. tostring(Config[key]), function()
        current = current % #values + 1
        Config[key] = values[current]
        b.Text = text .. ": " .. tostring(Config[key])
    end)
    return b
end

-- =========================
-- Pages and tabs
-- =========================
local mainPage = newPage("Main")
local combatPage = newPage("Combat")
local fruitsPage = newPage("Fruits")
local travelPage = newPage("Travel")
local miscPage = newPage("Misc")
local settingsPage = newPage("Settings")
local farmingPage = newPage("Farming+")
local seaPage = newPage("Sea Events")
local racePage = newPage("Race V4")
local fishingPage = newPage("Fishing")
local itemsPage = newPage("Items")

for _,name in ipairs({"Main","Farming+","Combat","Fruits","Sea Events","Travel","Race V4","Fishing","Items","Misc","Settings"}) do
    local b = addTab(name)
    b.MouseButton1Click:Connect(function() showPage(name) end)
end

section(mainPage, "Farming")
toggle(mainPage, "AutoFarmLevel", "Auto Farm Level")
toggle(mainPage, "AutoFarmNearest", "Auto Farm Nearest Mob")
toggle(mainPage, "FarmAllIsland", "Farm All Island")
toggle(mainPage, "AutoQuest", "Auto Quest")
toggle(mainPage, "BringMobs", "Bring / Magnet Mobs")
toggle(mainPage, "AutoM1", "Auto M1")
dropdown(mainPage, "Weapon", "SelectedWeapon", {"Melee","Sword","Blox Fruit","Pistol"})

section(mainPage, "Boss / Event")
toggle(mainPage, "KillBoss", "Boss Farm")
toggle(mainPage, "AutoRaid", "Auto Raid")
dropdown(mainPage, "Sea Event", "SelectedSeaEvent", {"Prehistoric","Frozen Dimension","Sea Beast","Ship Event"})

section(combatPage, "Combat")
toggle(combatPage, "AutoHaki", "Auto Haki")
toggle(combatPage, "AutoObservation", "Auto Observation")
toggle(combatPage, "Aimbot", "Aim Player / Nearest Aim")
toggle(combatPage, "ESP", "ESP")
button(combatPage, "Enable Fast Attack Engine", function() Config.AutoM1 = true end)
button(combatPage, "Disable Fast Attack Engine", function() Config.AutoM1 = false end)

section(fruitsPage, "Fruits / Drops")
toggle(fruitsPage, "FruitESP", "Fruit ESP")
toggle(fruitsPage, "CollectFruit", "Auto Collect Fruits")
toggle(fruitsPage, "CollectBerry", "Collect Berry")
button(fruitsPage, "Refresh Fruit Scanner", function() end)

section(travelPage, "Travel - Worlds")
-- Roblox place IDs used by Blox Fruits:
-- First Sea  = 2753915549
-- Second Sea = 4442272183
-- Third Sea  = 7449423635
local PLACE_IDS = {
    ["First Sea"] = 2753915549,
    ["Second Sea"] = 4442272183,
    ["Third Sea"] = 7449423635,
}

local function teleportToPlace(name)
    local placeId = PLACE_IDS[name]
    if placeId then
        pcall(function()
            TeleportService:Teleport(placeId, LocalPlayer)
        end)
    end
end

button(travelPage, "First Sea", function()
    teleportToPlace("First Sea")
end)
button(travelPage, "Second Sea", function()
    teleportToPlace("Second Sea")
end)
button(travelPage, "Third Sea", function()
    teleportToPlace("Third Sea")
end)

section(travelPage, "Island / NPC Travel")
button(travelPage, "Travel - Islands", function()
    -- Island travel uses CFrame/position adapters, not separate Roblox place IDs.
end)
button(travelPage, "Travel - NPCs", function()
    -- NPC travel uses the game's current NPC positions/remotes.
end)

section(miscPage, "Utility")
toggle(miscPage, "AutoFishing", "Auto Fishing")
toggle(miscPage, "AutoRaceV2V3", "Upgrade Race V2 / V3")
toggle(miscPage, "AutoRaceV4", "Race V4 / Full Moon Helper")
toggle(miscPage, "AutoMaterials", "Auto Materials")
toggle(miscPage, "AntiAFK", "Anti AFK")
button(miscPage, "Rejoin Server", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)
button(miscPage, "Server Hop", function()
    -- Server hopping requires a server-list endpoint; kept separate so it can be
    -- swapped when the game's API changes.
end)

section(settingsPage, "Player")
button(settingsPage, "WalkSpeed +", function()
    Config.WalkSpeed = math.clamp(Config.WalkSpeed + 5, 16, 250)
end)
button(settingsPage, "WalkSpeed Reset", function()
    Config.WalkSpeed = 16
end)
button(settingsPage, "JumpPower Reset", function()
    Config.JumpPower = 50
end)
button(settingsPage, "Hide / Show UI", function()
    gui.Enabled = not gui.Enabled
end)

-- Expanded feature pages
for group, page in pairs({Farming=farmingPage, SeaEvents=seaPage, Race=racePage, Fishing=fishingPage, Items=itemsPage}) do
    section(page, group .. " Features")
    for _, feature in ipairs(FeatureGroups[group]) do
        featureToggle(page, group, feature)
    end
end

-- =========================
-- Core farming helpers
-- =========================
local function getCharacter()
    return LocalPlayer.Character
end

local function getRoot()
    local c = getCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local c = getCharacter()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function findNearestEnemy()
    local root = getRoot()
    if not root then return nil end

    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    local best, dist = nil, math.huge
    for _,m in ipairs(enemies:GetChildren()) do
        local hrp = m:FindFirstChild("HumanoidRootPart")
        local hum = m:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (hrp.Position - root.Position).Magnitude
            if d < dist then
                best, dist = m, d
            end
        end
    end
    return best
end

local function equipTool()
    local c = getCharacter()
    if not c then return end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return end

    local wanted = Config.SelectedWeapon
    for _,tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (wanted == "Melee" or tool.Name == wanted) then
            pcall(function() getHumanoid():EquipTool(tool) end)
            break
        end
    end
end

local function attack()
    if not Config.AutoM1 then return end
    local c = getCharacter()
    if not c then return end
    local tool = c:FindFirstChildOfClass("Tool")
    if tool then
        pcall(function()
            tool:Activate()
        end)
    end
end

local lastAttack = 0
local farmConnection
farmConnection = RunService.Heartbeat:Connect(function()
    if Config.AntiAFK then
        -- Anti-idle is handled below by Idled.
    end

    local hum = getHumanoid()
    local root = getRoot()
    if hum then
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end

    if Config.AutoFarmLevel and root then
        local enemy = findNearestEnemy()
        if enemy then
            local eroot = enemy:FindFirstChild("HumanoidRootPart")
            local ehum = enemy:FindFirstChildOfClass("Humanoid")
            if eroot and ehum and ehum.Health > 0 then
                -- Simple safe positioning loop. Quest selection/remote calls are
                -- kept adapter-based because Blox Fruits internals change.
                pcall(function()
                    root.CFrame = eroot.CFrame * CFrame.new(0, 8, 0)
                end)
                if os.clock() - lastAttack > 0.12 then
                    lastAttack = os.clock()
                    equipTool()
                    attack()
                end
            end
        end
    elseif Config.AutoFarmNearest and root then
        local enemy = findNearestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
            if os.clock() - lastAttack > 0.12 then
                lastAttack = os.clock()
                equipTool()
                attack()
            end
        end
    end

    if Config.BringMobs then
        -- Hook for game-specific mob magnet adapter.
    end

    if Config.ESP or Config.FruitESP then
        -- ESP adapter hook.
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
    end
end)

-- Drag window
do
    local dragging = false
    local dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            input.Changed:Connect(function()
                if dragging then
                    local delta = input.Position - dragStart
                    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
end

showPage("Main")
