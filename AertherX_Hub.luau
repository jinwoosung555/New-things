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
    FastAttack = false,
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
    SkillSpam = false,
    NoClip = false,
    FruitESP = false,
    AutoCollectFruit = false,
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

-- Minimize / restore system
local minimized = false
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 34)
minimize.Position = UDim2.new(1, -84, 0, 10)
minimize.BackgroundColor3 = Color3.fromRGB(20,20,20)
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(220,220,220)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = top
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local miniButton = Instance.new("TextButton")
miniButton.Name = "AertherXMini"
miniButton.Size = UDim2.fromOffset(58, 58)
miniButton.Position = UDim2.new(0, 20, 0.5, -29)
miniButton.BackgroundColor3 = Color3.fromRGB(8,8,8)
miniButton.BorderSizePixel = 0
miniButton.Text = "AX"
miniButton.TextColor3 = Color3.fromRGB(245,245,245)
miniButton.TextSize = 16
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.Parent = gui
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1, 0)
local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(65,65,65)
miniStroke.Thickness = 1
miniStroke.Parent = miniButton

local function setMinimized(value)
    minimized = value
    main.Visible = not value
    miniButton.Visible = value
end
minimize.MouseButton1Click:Connect(function() setMinimized(not minimized) end)
miniButton.MouseButton1Click:Connect(function() setMinimized(false) end)

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
toggle(combatPage, "FastAttack", "Fast Attack")
toggle(combatPage, "SkillSpam", "Auto Skill Spam")
toggle(combatPage, "NoClip", "No Clip")
toggle(combatPage, "AutoObservation", "Auto Observation")
toggle(combatPage, "Aimbot", "Aim Player / Nearest Aim")
toggle(combatPage, "ESP", "ESP")
button(combatPage, "Enable Fast Attack Engine", function() Config.AutoM1 = true end)
button(combatPage, "Disable Fast Attack Engine", function() Config.AutoM1 = false end)

section(fruitsPage, "Fruits / Drops")
toggle(fruitsPage, "FruitESP", "Fruit ESP")
toggle(fruitsPage, "CollectFruit", "Auto Collect Fruits")
toggle(fruitsPage, "AutoCollectFruit", "Auto Collect Fruit System")
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
button(miscPage, "Server Hop", function() hopServer(false) end)
button(miscPage, "Low Player Server Hop", function() hopServer(true) end)

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
button(settingsPage, "Minimize / Restore UI", function()
    setMinimized(not minimized)
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

local function getCommF()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    return remotes and remotes:FindFirstChild("CommF_")
end

-- Blox Fruits quest progression. The engine uses the player's level to select
-- the appropriate quest, then confirms the actual quest UI before farming.
local QuestData = {
    {1,9,"BanditQuest1",1,"Bandit","Bandit Quest Giver"},
    {10,14,"JungleQuest",1,"Monkey","Adventurer"},
    {15,29,"JungleQuest",2,"Gorilla","Adventurer"},
    {30,39,"BuggyQuest1",1,"Pirate","Citizen"},
    {40,59,"BuggyQuest1",2,"Brute","Citizen"},
    {60,74,"DesertQuest",1,"Desert Bandit","Desert Adventurer"},
    {75,89,"DesertQuest",2,"Desert Officer","Desert Adventurer"},
    {90,99,"SnowQuest",1,"Snow Bandit","Villager"},
    {100,119,"SnowQuest",2,"Snowman","Villager"},
    {120,149,"MarineQuest2",1,"Chief Petty Officer","Marine Rear Admiral"},
    {150,174,"SkyQuest",1,"Sky Bandit","God's Guard"},
    {175,189,"SkyQuest",2,"Dark Master","God's Guard"},
    {190,209,"PrisonerQuest",1,"Prisoner","Prisoner Quest Giver"},
    {210,249,"PrisonerQuest",2,"Dangerous Prisoner","Prisoner Quest Giver"},
    {250,274,"ColosseumQuest",1,"Toga Warrior","Colosseum Quest Giver"},
    {275,299,"ColosseumQuest",2,"Gladiator","Colosseum Quest Giver"},
    {300,324,"MagmaQuest",1,"Military Soldier","Military Detective"},
    {325,374,"MagmaQuest",2,"Military Spy","Military Detective"},
    {375,399,"FishmanQuest",1,"Fishman Warrior","Fishman Quest Giver"},
    {400,449,"FishmanQuest",2,"Fishman Commando","Fishman Quest Giver"},
    {450,474,"SkyExp1Quest",1,"God's Guard","Sky Quest Giver"},
    {475,524,"SkyExp1Quest",2,"Shanda","Sky Quest Giver"},
    {525,549,"Area1Quest",1,"Royal Squad","Area 1 Quest Giver"},
    {550,624,"Area1Quest",2,"Royal Soldier","Area 1 Quest Giver"},
    {625,649,"MarineTreeIsland",1,"Galley Pirate","Marine Tree Island Quest Giver"},
    {650,699,"MarineTreeIsland",2,"Galley Captain","Marine Tree Island Quest Giver"},
    {700,724,"ZombieQuest",1,"Zombie","Zombie Quest Giver"},
    {725,774,"ZombieQuest",2,"Vampire","Zombie Quest Giver"},
    {775,799,"SnowMountainQuest",1,"Snow Trooper","Snow Mountain Quest Giver"},
    {800,874,"SnowMountainQuest",2,"Winter Warrior","Snow Mountain Quest Giver"},
    {875,899,"IceSideQuest",1,"Lab Subordinate","Ice Side Quest Giver"},
    {900,949,"IceSideQuest",2,"Horned Warrior","Ice Side Quest Giver"},
    {950,974,"FireSideQuest",1,"Magma Ninja","Fire Side Quest Giver"},
    {975,999,"FireSideQuest",2,"Lava Pirate","Fire Side Quest Giver"},
    {1000,1049,"ShipQuest1",1,"Ship Deckhand","Ship Quest Giver 1"},
    {1050,1099,"ShipQuest1",2,"Ship Engineer","Ship Quest Giver 1"},
    {1100,1124,"ShipQuest2",1,"Ship Steward","Ship Quest Giver 2"},
    {1125,1174,"ShipQuest2",2,"Ship Officer","Ship Quest Giver 2"},
    {1175,1199,"FrostQuest",1,"Arctic Warrior","Frost Quest Giver"},
    {1200,1249,"FrostQuest",2,"Snow Lurker","Frost Quest Giver"},
    {1250,1274,"ForgottenQuest",1,"Sea Soldier","Forgotten Quest Giver"},
    {1275,1299,"ForgottenQuest",2,"Water Fighter","Forgotten Quest Giver"},
    {1300,1324,"Area2Quest",1,"Pirate Millionaire","Area 2 Quest Giver"},
    {1325,1374,"Area2Quest",2,"Pistol Billionaire","Area 2 Quest Giver"},
    {1375,1424,"MarineQuest3",1,"Marine Lieutenant","Marine Rear Admiral"},
    {1425,1474,"MarineQuest3",2,"Marine Rear Admiral","Marine Rear Admiral"},
    {1475,1499,"ZombieQuest2",1,"Reborn Skeleton","Zombie Quest Giver"},
    {1500,1524,"ZombieQuest2",2,"Living Zombie","Zombie Quest Giver"},
    {1525,1574,"IceSideQuest",1,"Arctic Warrior","Ice Side Quest Giver"},
    {1575,1624,"IceSideQuest",2,"Snow Lurker","Ice Side Quest Giver"},
    {1625,1674,"FireSideQuest",1,"Magma Ninja","Fire Side Quest Giver"},
    {1675,1724,"FireSideQuest",2,"Lava Pirate","Fire Side Quest Giver"},
    {1725,1774,"ShipQuest1",1,"Ship Deckhand","Ship Quest Giver 1"},
    {1775,1824,"ShipQuest1",2,"Ship Engineer","Ship Quest Giver 1"},
    {1825,1874,"ShipQuest2",1,"Ship Steward","Ship Quest Giver 2"},
    {1875,1924,"ShipQuest2",2,"Ship Officer","Ship Quest Giver 2"},
    {1925,1974,"FrostQuest",1,"Arctic Warrior","Frost Quest Giver"},
    {1975,2024,"FrostQuest",2,"Snow Lurker","Frost Quest Giver"},
    {2025,2074,"ForgottenQuest",1,"Sea Soldier","Forgotten Quest Giver"},
    {2075,2124,"ForgottenQuest",2,"Water Fighter","Forgotten Quest Giver"},
    {2125,2174,"HauntedQuest1",1,"Reborn Skeleton","Haunted Quest Giver"},
    {2175,2224,"HauntedQuest1",2,"Living Zombie","Haunted Quest Giver"},
    {2225,2274,"NutsIslandQuest",1,"Peanut Scout","Nuts Island Quest Giver"},
    {2275,2324,"NutsIslandQuest",2,"Peanut President","Nuts Island Quest Giver"},
    {2325,2374,"IceCreamIslandQuest",1,"Ice Cream Chef","Ice Cream Quest Giver"},
    {2375,2424,"IceCreamIslandQuest",2,"Ice Cream Commander","Ice Cream Quest Giver"},
    {2425,2474,"CakeQuest1",1,"Cookie Crafter","Cake Quest Giver"},
    {2475,2524,"CakeQuest1",2,"Cake Guard","Cake Quest Giver"},
    {2525,2574,"CakeQuest2",1,"Baking Staff","Cake Quest Giver 2"},
    {2575,2624,"CakeQuest2",2,"Head Baker","Cake Quest Giver 2"},
    {2625,2674,"TikiQuest1",1,"Isle Outlaw","Tiki Quest Giver"},
    {2675,2724,"TikiQuest1",2,"Island Boy","Tiki Quest Giver"},
    {2725,2774,"TikiQuest2",1,"Isle Champion","Tiki Quest Giver 2"},
    {2775,2800,"TikiQuest2",2,"Serpent Hunter","Tiki Quest Giver 2"},
}

local function playerLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    local level = data and data:FindFirstChild("Level")
    if level and tonumber(level.Value) then return tonumber(level.Value) end
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    level = leaderstats and leaderstats:FindFirstChild("Level")
    return level and tonumber(level.Value) or 1
end

local function getQuestForLevel(level)
    local selected
    for _, q in ipairs(QuestData) do
        if level >= q[1] and level <= q[2] then selected = q end
    end
    return selected
end

local function getQuestText()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local mainGui = pg and pg:FindFirstChild("Main")
    local quest = mainGui and mainGui:FindFirstChild("Quest")
    if not quest or not quest.Visible then return "" end
    local title = quest:FindFirstChild("Container") and quest.Container:FindFirstChild("QuestTitle")
    local objective = quest:FindFirstChild("Container") and quest.Container:FindFirstChild("QuestTitle")
    return tostring((title and title.Text) or (objective and objective.Text) or "")
end

local function hasQuest(q)
    local text = getQuestText()
    if text == "" then return false end
    return text:lower():find(q[4]:lower(), 1, true) ~= nil
end

local function findQuestGiver(q)
    local target = q[6]:lower()
    local best
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local name = obj.Name:lower()
            if name:find(target, 1, true) then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if root then return root end
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local name = obj.Name:lower()
            if name:find(q[3]:lower():gsub("quest", ""), 1, true) then
                local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
                if root then best = root end
            end
        end
    end
    return best
end

local function startQuest(q)
    local comm = getCommF()
    if not comm or not q then return false end
    local giver = findQuestGiver(q)
    local root = getRoot()
    if giver and root and (root.Position - giver.Position).Magnitude > 12 then
        pcall(function() root.CFrame = giver.CFrame * CFrame.new(0, 3, 0) end)
        task.wait(0.15)
    end
    local ok = pcall(function()
        return comm:InvokeServer("StartQuest", q[3], q[4])
    end)
    return ok
end

local function findEnemyByName(name)
    local root = getRoot()
    if not root then return nil end
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local wanted = name:lower()
    local best, dist = nil, math.huge
    for _, model in ipairs(enemies:GetChildren()) do
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 and model.Name:lower():find(wanted, 1, true) then
            local d = (hrp.Position - root.Position).Magnitude
            if d < dist then best, dist = model, d end
        end
    end
    return best
end

local function findNearestEnemy()
    local root = getRoot()
    if not root then return nil end
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    local best, dist = nil, math.huge
    for _, model in ipairs(enemies:GetChildren()) do
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local d = (hrp.Position - root.Position).Magnitude
            if d < dist then best, dist = model, d end
        end
    end
    return best
end

local function equipTool()
    local c = getCharacter()
    local hum = getHumanoid()
    if not c or not hum then return end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    local wanted = Config.SelectedWeapon
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            local use = wanted == "Melee" and (n:find("combat") or n:find("karate") or n:find("claw") or n:find("style"))
                or wanted == "Sword" and (tool:GetAttribute("WeaponType") == "Sword" or n:find("sword"))
                or wanted == "Blox Fruit" and tool.ToolTip == "Blox Fruit"
                or wanted == "Pistol" and (tool:GetAttribute("WeaponType") == "Gun" or n:find("gun") or n:find("pistol"))
            if use or tool.Name == wanted then
                pcall(function() hum:EquipTool(tool) end)
                return
            end
        end
    end
end

local function attack()
    if not Config.AutoM1 then return end
    local c = getCharacter()
    local tool = c and c:FindFirstChildOfClass("Tool")
    if tool then pcall(function() tool:Activate() end) end
end

local function magnetEnemy(enemy, targetPos)
    if not Config.BringMobs or not enemy then return end
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    local hum = enemy:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end
    pcall(function()
        hrp.CanCollide = false
        hrp.CFrame = CFrame.new(targetPos)
    end)
end

-- =========================
-- Extra systems adapted from the supplied reference source
-- =========================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Net = Modules and Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")
local FastAttackLast = 0
local SkillLast = 0
local FruitLast = 0

local function getEquippedTool()
    local c = getCharacter()
    return c and c:FindFirstChildOfClass("Tool")
end

local function fastAttack()
    if not Config.FastAttack or os.clock() - FastAttackLast < 0.12 then return end
    FastAttackLast = os.clock()
    local root = getRoot()
    local tool = getEquippedTool()
    if not root or not tool then return end
    local enemies = workspace:FindFirstChild("Enemies")
    local characters = workspace:FindFirstChild("Characters")
    local hitData, primaryPart = {}, nil
    for _, container in ipairs({enemies, characters}) do
        if container then
            for _, e in ipairs(container:GetChildren()) do
                if e ~= getCharacter() and not e:GetAttribute("IsBoat") then
                    local hum = e:FindFirstChildOfClass("Humanoid")
                    local part = e:FindFirstChild("Head") or e.PrimaryPart
                    if hum and hum.Health > 0 and part and (part.Position - root.Position).Magnitude <= 80 then
                        table.insert(hitData, {e, part})
                        primaryPart = primaryPart or part
                    end
                end
            end
        end
    end
    if not primaryPart or #hitData == 0 then return end
    local leftClick = tool:FindFirstChild("LeftClickRemote")
    if leftClick then pcall(function() leftClick:FireServer((primaryPart.Position-root.Position).Unit, 1) end) end
    if RegisterAttack then pcall(function() RegisterAttack:FireServer(0) end) end
    if RegisterHit then pcall(function() RegisterHit:FireServer(primaryPart, hitData) end) end
end

local function autoHaki()
    if not Config.AutoHaki then return end
    local comm = getCommF()
    if comm then pcall(function() comm:InvokeServer("Buso") end) end
end

local function autoObservation()
    if not Config.AutoObservation then return end
    local comm = getCommF()
    if comm then pcall(function() comm:InvokeServer("Ken", true) end) end
end

local function skillSpam()
    if not Config.SkillSpam or os.clock() - SkillLast < 0.7 then return end
    SkillLast = os.clock()
    local tool = getEquippedTool()
    if tool and tool:IsA("Tool") then
        for _, key in ipairs({Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C}) do
            pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, key, false, game)
                vim:SendKeyEvent(false, key, false, game)
            end)
        end
    end
end

local function collectFruit()
    if not Config.AutoCollectFruit or os.clock() - FruitLast < 0.25 then return end
    FruitLast = os.clock()
    local root = getRoot()
    if not root then return end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and (obj.Name:lower():find("fruit") or obj:FindFirstChild("Handle")) then
            local handle = obj:FindFirstChild("Handle")
            if handle and (handle.Position-root.Position).Magnitude < 250 then
                pcall(function() root.CFrame = handle.CFrame * CFrame.new(0,3,0) end)
                break
            end
        end
    end
end

local function updateFruitESP()
    if not Config.FruitESP then return end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") and not obj:FindFirstChild("AertherXFruitESP") then
            local h=Instance.new("Highlight")
            h.Name="AertherXFruitESP"
            h.FillTransparency=0.65
            h.OutlineTransparency=0
            h.Parent=obj
        end
    end
end

function hopServer(lowPlayers)
    local placeId = game.PlaceId
    local cursor = ""
    local best
    for _=1,3 do
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor="..HttpService:UrlEncode(cursor) or "")
        local ok, data = pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
        if not ok or not data then break end
        for _, server in ipairs(data.data or {}) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                if not lowPlayers or server.playing <= 8 then best=server.id break end
            end
        end
        if best then break end
        cursor=data.nextPageCursor or ""
        if cursor=="" then break end
    end
    if best then pcall(function() TeleportService:TeleportToPlaceInstance(placeId, best, LocalPlayer) end) end
end

RunService.Heartbeat:Connect(function()
    autoHaki()
    autoObservation()
    fastAttack()
    skillSpam()
    collectFruit()
    updateFruitESP()
    if Config.NoClip then
        local c=getCharacter()
        if c then for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
    end
end)

local currentQuest
local lastQuestTry = 0
local lastAttack = 0
local farmConnection
farmConnection = RunService.Heartbeat:Connect(function()
    local hum, root = getHumanoid(), getRoot()
    if hum then
        hum.WalkSpeed = Config.WalkSpeed
        hum.JumpPower = Config.JumpPower
    end
    if not Config.AutoFarmLevel or not root or not hum or hum.Health <= 0 then return end

    local level = playerLevel()
    currentQuest = getQuestForLevel(level)
    if not currentQuest then
        local enemy = findNearestEnemy()
        if enemy and enemy:FindFirstChild("HumanoidRootPart") then
            root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0)
            equipTool(); attack()
        end
        return
    end

    if not hasQuest(currentQuest) then
        if os.clock() - lastQuestTry > 1 then
            lastQuestTry = os.clock()
            startQuest(currentQuest)
        end
        return
    end

    local enemy = findEnemyByName(currentQuest[4])
    if enemy then
        local eroot = enemy:FindFirstChild("HumanoidRootPart")
        local ehum = enemy:FindFirstChildOfClass("Humanoid")
        if eroot and ehum and ehum.Health > 0 then
            local target = eroot.Position + Vector3.new(0, 8, 0)
            pcall(function() root.CFrame = CFrame.new(target) end)
            magnetEnemy(enemy, target)
            if os.clock() - lastAttack > 0.10 then
                lastAttack = os.clock()
                equipTool()
                attack()
            end
        end
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

-- Drag window + draggable minimized button
do
    local dragging = false
    local dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

    local miniDragging = false
    local miniStart, miniPos
    miniButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDragging = true
            miniStart = input.Position
            miniPos = miniButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then miniDragging = false end
            end)
        end
    end)
    miniButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            input.Changed:Connect(function()
                if miniDragging then
                    local delta = input.Position - miniStart
                    miniButton.Position = UDim2.new(miniPos.X.Scale, miniPos.X.Offset + delta.X, miniPos.Y.Scale, miniPos.Y.Offset + delta.Y)
                end
            end)
        end
    end)
end

-- ================================================================
-- AertherX Extended Systems Database
-- Expanded data-driven systems layer inspired by the supplied source.
-- ================================================================
local AertherXSystems = AertherXSystems or {}
AertherXSystems.Version = "3.1.0"
AertherXSystems.Brand = "AertherX Hub"
AertherXSystems.Game = "Blox Fruits"
AertherXSystems.Registry = AertherXSystems.Registry or {}

AertherXSystems.Registry["System_0001"] = {
    Name = "Auto Farm Level",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Auto Farm Level runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0002"] = {
    Name = "Auto Farm Level",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Auto Farm Level runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0003"] = {
    Name = "Auto Farm Level",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Auto Farm Level runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0004"] = {
    Name = "Auto Farm Level",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Auto Farm Level runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0005"] = {
    Name = "Auto Quest",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Auto Quest runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0006"] = {
    Name = "Auto Quest",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Auto Quest runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0007"] = {
    Name = "Auto Quest",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Auto Quest runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0008"] = {
    Name = "Auto Quest",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Auto Quest runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0009"] = {
    Name = "Quest Detector",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Quest Detector runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0010"] = {
    Name = "Quest Detector",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Quest Detector runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0011"] = {
    Name = "Quest Detector",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Quest Detector runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0012"] = {
    Name = "Quest Detector",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Quest Detector runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0013"] = {
    Name = "Quest Starter",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Quest Starter runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0014"] = {
    Name = "Quest Starter",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Quest Starter runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0015"] = {
    Name = "Quest Starter",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Quest Starter runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0016"] = {
    Name = "Quest Starter",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Quest Starter runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0017"] = {
    Name = "Mob Targeting",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Mob Targeting runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0018"] = {
    Name = "Mob Targeting",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Mob Targeting runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0019"] = {
    Name = "Mob Targeting",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Mob Targeting runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0020"] = {
    Name = "Mob Targeting",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Mob Targeting runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0021"] = {
    Name = "Mob Magnet",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Mob Magnet runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0022"] = {
    Name = "Mob Magnet",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Mob Magnet runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0023"] = {
    Name = "Mob Magnet",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Mob Magnet runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0024"] = {
    Name = "Mob Magnet",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Mob Magnet runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0025"] = {
    Name = "Nearest Enemy",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Nearest Enemy runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0026"] = {
    Name = "Nearest Enemy",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Nearest Enemy runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0027"] = {
    Name = "Nearest Enemy",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Nearest Enemy runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0028"] = {
    Name = "Nearest Enemy",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Nearest Enemy runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0029"] = {
    Name = "Island Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Island Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0030"] = {
    Name = "Island Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Island Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0031"] = {
    Name = "Island Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Island Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0032"] = {
    Name = "Island Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Island Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0033"] = {
    Name = "Elite Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Elite Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0034"] = {
    Name = "Elite Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Elite Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0035"] = {
    Name = "Elite Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Elite Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0036"] = {
    Name = "Elite Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Elite Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0037"] = {
    Name = "Boss Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Boss Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0038"] = {
    Name = "Boss Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Boss Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0039"] = {
    Name = "Boss Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Boss Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0040"] = {
    Name = "Boss Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Boss Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0041"] = {
    Name = "Mastery Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Mastery Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0042"] = {
    Name = "Mastery Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Mastery Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0043"] = {
    Name = "Mastery Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Mastery Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0044"] = {
    Name = "Mastery Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Mastery Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0045"] = {
    Name = "Chest Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Chest Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0046"] = {
    Name = "Chest Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Chest Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0047"] = {
    Name = "Chest Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Chest Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0048"] = {
    Name = "Chest Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Chest Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0049"] = {
    Name = "Material Farming",
    Category = "Farming",
    Variant = 1,
    Enabled = false,
    Description = "Material Farming runtime profile 1 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0050"] = {
    Name = "Material Farming",
    Category = "Farming",
    Variant = 2,
    Enabled = false,
    Description = "Material Farming runtime profile 2 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0051"] = {
    Name = "Material Farming",
    Category = "Farming",
    Variant = 3,
    Enabled = false,
    Description = "Material Farming runtime profile 3 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0052"] = {
    Name = "Material Farming",
    Category = "Farming",
    Variant = 4,
    Enabled = false,
    Description = "Material Farming runtime profile 4 for the Farming subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0053"] = {
    Name = "Auto M1",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Auto M1 runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0054"] = {
    Name = "Auto M1",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Auto M1 runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0055"] = {
    Name = "Auto M1",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Auto M1 runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0056"] = {
    Name = "Auto M1",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Auto M1 runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0057"] = {
    Name = "Fast Attack",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Fast Attack runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0058"] = {
    Name = "Fast Attack",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Fast Attack runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0059"] = {
    Name = "Fast Attack",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Fast Attack runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0060"] = {
    Name = "Fast Attack",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Fast Attack runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0061"] = {
    Name = "Skill Spam",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Skill Spam runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0062"] = {
    Name = "Skill Spam",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Skill Spam runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0063"] = {
    Name = "Skill Spam",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Skill Spam runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0064"] = {
    Name = "Skill Spam",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Skill Spam runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0065"] = {
    Name = "Auto Haki",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Auto Haki runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0066"] = {
    Name = "Auto Haki",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Auto Haki runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0067"] = {
    Name = "Auto Haki",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Auto Haki runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0068"] = {
    Name = "Auto Haki",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Auto Haki runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0069"] = {
    Name = "Auto Observation",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Auto Observation runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0070"] = {
    Name = "Auto Observation",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Auto Observation runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0071"] = {
    Name = "Auto Observation",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Auto Observation runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0072"] = {
    Name = "Auto Observation",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Auto Observation runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0073"] = {
    Name = "Aim Assist",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Aim Assist runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0074"] = {
    Name = "Aim Assist",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Aim Assist runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0075"] = {
    Name = "Aim Assist",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Aim Assist runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0076"] = {
    Name = "Aim Assist",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Aim Assist runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0077"] = {
    Name = "Target Lock",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Target Lock runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0078"] = {
    Name = "Target Lock",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Target Lock runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0079"] = {
    Name = "Target Lock",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Target Lock runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0080"] = {
    Name = "Target Lock",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Target Lock runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0081"] = {
    Name = "Combo Assist",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Combo Assist runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0082"] = {
    Name = "Combo Assist",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Combo Assist runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0083"] = {
    Name = "Combo Assist",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Combo Assist runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0084"] = {
    Name = "Combo Assist",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Combo Assist runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0085"] = {
    Name = "Weapon Equip",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Weapon Equip runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0086"] = {
    Name = "Weapon Equip",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Weapon Equip runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0087"] = {
    Name = "Weapon Equip",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Weapon Equip runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0088"] = {
    Name = "Weapon Equip",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Weapon Equip runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0089"] = {
    Name = "Melee Mode",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Melee Mode runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0090"] = {
    Name = "Melee Mode",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Melee Mode runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0091"] = {
    Name = "Melee Mode",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Melee Mode runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0092"] = {
    Name = "Melee Mode",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Melee Mode runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0093"] = {
    Name = "Sword Mode",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Sword Mode runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0094"] = {
    Name = "Sword Mode",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Sword Mode runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0095"] = {
    Name = "Sword Mode",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Sword Mode runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0096"] = {
    Name = "Sword Mode",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Sword Mode runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0097"] = {
    Name = "Gun Mode",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Gun Mode runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0098"] = {
    Name = "Gun Mode",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Gun Mode runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0099"] = {
    Name = "Gun Mode",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Gun Mode runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0100"] = {
    Name = "Gun Mode",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Gun Mode runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0101"] = {
    Name = "Blox Fruit Mode",
    Category = "Combat",
    Variant = 1,
    Enabled = false,
    Description = "Blox Fruit Mode runtime profile 1 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0102"] = {
    Name = "Blox Fruit Mode",
    Category = "Combat",
    Variant = 2,
    Enabled = false,
    Description = "Blox Fruit Mode runtime profile 2 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0103"] = {
    Name = "Blox Fruit Mode",
    Category = "Combat",
    Variant = 3,
    Enabled = false,
    Description = "Blox Fruit Mode runtime profile 3 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0104"] = {
    Name = "Blox Fruit Mode",
    Category = "Combat",
    Variant = 4,
    Enabled = false,
    Description = "Blox Fruit Mode runtime profile 4 for the Combat subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0105"] = {
    Name = "Fruit ESP",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit ESP runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0106"] = {
    Name = "Fruit ESP",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit ESP runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0107"] = {
    Name = "Fruit ESP",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit ESP runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0108"] = {
    Name = "Fruit ESP",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit ESP runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0109"] = {
    Name = "Fruit Scanner",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit Scanner runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0110"] = {
    Name = "Fruit Scanner",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit Scanner runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0111"] = {
    Name = "Fruit Scanner",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit Scanner runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0112"] = {
    Name = "Fruit Scanner",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit Scanner runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0113"] = {
    Name = "Auto Collect Fruit",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Auto Collect Fruit runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0114"] = {
    Name = "Auto Collect Fruit",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Auto Collect Fruit runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0115"] = {
    Name = "Auto Collect Fruit",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Auto Collect Fruit runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0116"] = {
    Name = "Auto Collect Fruit",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Auto Collect Fruit runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0117"] = {
    Name = "Fruit Store",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit Store runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0118"] = {
    Name = "Fruit Store",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit Store runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0119"] = {
    Name = "Fruit Store",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit Store runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0120"] = {
    Name = "Fruit Store",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit Store runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0121"] = {
    Name = "Fruit Drop",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit Drop runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0122"] = {
    Name = "Fruit Drop",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit Drop runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0123"] = {
    Name = "Fruit Drop",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit Drop runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0124"] = {
    Name = "Fruit Drop",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit Drop runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0125"] = {
    Name = "Fruit Tracker",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit Tracker runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0126"] = {
    Name = "Fruit Tracker",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit Tracker runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0127"] = {
    Name = "Fruit Tracker",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit Tracker runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0128"] = {
    Name = "Fruit Tracker",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit Tracker runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0129"] = {
    Name = "Fruit Stock Scanner",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Fruit Stock Scanner runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0130"] = {
    Name = "Fruit Stock Scanner",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Fruit Stock Scanner runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0131"] = {
    Name = "Fruit Stock Scanner",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Fruit Stock Scanner runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0132"] = {
    Name = "Fruit Stock Scanner",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Fruit Stock Scanner runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0133"] = {
    Name = "Random Fruit Selector",
    Category = "Fruits",
    Variant = 1,
    Enabled = false,
    Description = "Random Fruit Selector runtime profile 1 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0134"] = {
    Name = "Random Fruit Selector",
    Category = "Fruits",
    Variant = 2,
    Enabled = false,
    Description = "Random Fruit Selector runtime profile 2 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0135"] = {
    Name = "Random Fruit Selector",
    Category = "Fruits",
    Variant = 3,
    Enabled = false,
    Description = "Random Fruit Selector runtime profile 3 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0136"] = {
    Name = "Random Fruit Selector",
    Category = "Fruits",
    Variant = 4,
    Enabled = false,
    Description = "Random Fruit Selector runtime profile 4 for the Fruits subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0137"] = {
    Name = "Sea 1 Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Sea 1 Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0138"] = {
    Name = "Sea 1 Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Sea 1 Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0139"] = {
    Name = "Sea 1 Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Sea 1 Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0140"] = {
    Name = "Sea 1 Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Sea 1 Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0141"] = {
    Name = "Sea 2 Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Sea 2 Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0142"] = {
    Name = "Sea 2 Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Sea 2 Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0143"] = {
    Name = "Sea 2 Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Sea 2 Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0144"] = {
    Name = "Sea 2 Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Sea 2 Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0145"] = {
    Name = "Sea 3 Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Sea 3 Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0146"] = {
    Name = "Sea 3 Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Sea 3 Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0147"] = {
    Name = "Sea 3 Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Sea 3 Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0148"] = {
    Name = "Sea 3 Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Sea 3 Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0149"] = {
    Name = "Island Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Island Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0150"] = {
    Name = "Island Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Island Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0151"] = {
    Name = "Island Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Island Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0152"] = {
    Name = "Island Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Island Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0153"] = {
    Name = "NPC Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "NPC Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0154"] = {
    Name = "NPC Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "NPC Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0155"] = {
    Name = "NPC Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "NPC Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0156"] = {
    Name = "NPC Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "NPC Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0157"] = {
    Name = "Quest Teleport",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Quest Teleport runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0158"] = {
    Name = "Quest Teleport",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Quest Teleport runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0159"] = {
    Name = "Quest Teleport",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Quest Teleport runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0160"] = {
    Name = "Quest Teleport",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Quest Teleport runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0161"] = {
    Name = "Safe Position",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Safe Position runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0162"] = {
    Name = "Safe Position",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Safe Position runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0163"] = {
    Name = "Safe Position",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Safe Position runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0164"] = {
    Name = "Safe Position",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Safe Position runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0165"] = {
    Name = "Return To Farm",
    Category = "Travel",
    Variant = 1,
    Enabled = false,
    Description = "Return To Farm runtime profile 1 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0166"] = {
    Name = "Return To Farm",
    Category = "Travel",
    Variant = 2,
    Enabled = false,
    Description = "Return To Farm runtime profile 2 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0167"] = {
    Name = "Return To Farm",
    Category = "Travel",
    Variant = 3,
    Enabled = false,
    Description = "Return To Farm runtime profile 3 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0168"] = {
    Name = "Return To Farm",
    Category = "Travel",
    Variant = 4,
    Enabled = false,
    Description = "Return To Farm runtime profile 4 for the Travel subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0169"] = {
    Name = "Server Hop",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Server Hop runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0170"] = {
    Name = "Server Hop",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Server Hop runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0171"] = {
    Name = "Server Hop",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Server Hop runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0172"] = {
    Name = "Server Hop",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Server Hop runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0173"] = {
    Name = "Low Player Hop",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Low Player Hop runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0174"] = {
    Name = "Low Player Hop",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Low Player Hop runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0175"] = {
    Name = "Low Player Hop",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Low Player Hop runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0176"] = {
    Name = "Low Player Hop",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Low Player Hop runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0177"] = {
    Name = "Rejoin",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Rejoin runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0178"] = {
    Name = "Rejoin",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Rejoin runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0179"] = {
    Name = "Rejoin",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Rejoin runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0180"] = {
    Name = "Rejoin",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Rejoin runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0181"] = {
    Name = "Job ID Join",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Job ID Join runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0182"] = {
    Name = "Job ID Join",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Job ID Join runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0183"] = {
    Name = "Job ID Join",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Job ID Join runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0184"] = {
    Name = "Job ID Join",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Job ID Join runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0185"] = {
    Name = "Job ID Copy",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Job ID Copy runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0186"] = {
    Name = "Job ID Copy",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Job ID Copy runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0187"] = {
    Name = "Job ID Copy",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Job ID Copy runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0188"] = {
    Name = "Job ID Copy",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Job ID Copy runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0189"] = {
    Name = "Server Scanner",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Server Scanner runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0190"] = {
    Name = "Server Scanner",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Server Scanner runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0191"] = {
    Name = "Server Scanner",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Server Scanner runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0192"] = {
    Name = "Server Scanner",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Server Scanner runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0193"] = {
    Name = "Empty Server Finder",
    Category = "Servers",
    Variant = 1,
    Enabled = false,
    Description = "Empty Server Finder runtime profile 1 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0194"] = {
    Name = "Empty Server Finder",
    Category = "Servers",
    Variant = 2,
    Enabled = false,
    Description = "Empty Server Finder runtime profile 2 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0195"] = {
    Name = "Empty Server Finder",
    Category = "Servers",
    Variant = 3,
    Enabled = false,
    Description = "Empty Server Finder runtime profile 3 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0196"] = {
    Name = "Empty Server Finder",
    Category = "Servers",
    Variant = 4,
    Enabled = false,
    Description = "Empty Server Finder runtime profile 4 for the Servers subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0197"] = {
    Name = "Anti AFK",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Anti AFK runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0198"] = {
    Name = "Anti AFK",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Anti AFK runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0199"] = {
    Name = "Anti AFK",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Anti AFK runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0200"] = {
    Name = "Anti AFK",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Anti AFK runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0201"] = {
    Name = "No Clip",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "No Clip runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0202"] = {
    Name = "No Clip",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "No Clip runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0203"] = {
    Name = "No Clip",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "No Clip runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0204"] = {
    Name = "No Clip",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "No Clip runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0205"] = {
    Name = "Walk Speed",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Walk Speed runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0206"] = {
    Name = "Walk Speed",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Walk Speed runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0207"] = {
    Name = "Walk Speed",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Walk Speed runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0208"] = {
    Name = "Walk Speed",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Walk Speed runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0209"] = {
    Name = "Jump Power",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Jump Power runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0210"] = {
    Name = "Jump Power",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Jump Power runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0211"] = {
    Name = "Jump Power",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Jump Power runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0212"] = {
    Name = "Jump Power",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Jump Power runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0213"] = {
    Name = "UI Minimize",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "UI Minimize runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0214"] = {
    Name = "UI Minimize",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "UI Minimize runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0215"] = {
    Name = "UI Minimize",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "UI Minimize runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0216"] = {
    Name = "UI Minimize",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "UI Minimize runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0217"] = {
    Name = "UI Restore",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "UI Restore runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0218"] = {
    Name = "UI Restore",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "UI Restore runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0219"] = {
    Name = "UI Restore",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "UI Restore runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0220"] = {
    Name = "UI Restore",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "UI Restore runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0221"] = {
    Name = "Config Save",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Config Save runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0222"] = {
    Name = "Config Save",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Config Save runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0223"] = {
    Name = "Config Save",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Config Save runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0224"] = {
    Name = "Config Save",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Config Save runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0225"] = {
    Name = "Config Load",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Config Load runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0226"] = {
    Name = "Config Load",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Config Load runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0227"] = {
    Name = "Config Load",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Config Load runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0228"] = {
    Name = "Config Load",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Config Load runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0229"] = {
    Name = "Status Monitor",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Status Monitor runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0230"] = {
    Name = "Status Monitor",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Status Monitor runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0231"] = {
    Name = "Status Monitor",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Status Monitor runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0232"] = {
    Name = "Status Monitor",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Status Monitor runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0233"] = {
    Name = "Error Guard",
    Category = "Utility",
    Variant = 1,
    Enabled = false,
    Description = "Error Guard runtime profile 1 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0234"] = {
    Name = "Error Guard",
    Category = "Utility",
    Variant = 2,
    Enabled = false,
    Description = "Error Guard runtime profile 2 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0235"] = {
    Name = "Error Guard",
    Category = "Utility",
    Variant = 3,
    Enabled = false,
    Description = "Error Guard runtime profile 3 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0236"] = {
    Name = "Error Guard",
    Category = "Utility",
    Variant = 4,
    Enabled = false,
    Description = "Error Guard runtime profile 4 for the Utility subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0237"] = {
    Name = "Sea Beast Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Sea Beast Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0238"] = {
    Name = "Sea Beast Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Sea Beast Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0239"] = {
    Name = "Sea Beast Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Sea Beast Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0240"] = {
    Name = "Sea Beast Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Sea Beast Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0241"] = {
    Name = "Terror Shark Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Terror Shark Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0242"] = {
    Name = "Terror Shark Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Terror Shark Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0243"] = {
    Name = "Terror Shark Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Terror Shark Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0244"] = {
    Name = "Terror Shark Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Terror Shark Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0245"] = {
    Name = "Leviathan Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Leviathan Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0246"] = {
    Name = "Leviathan Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Leviathan Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0247"] = {
    Name = "Leviathan Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Leviathan Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0248"] = {
    Name = "Leviathan Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Leviathan Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0249"] = {
    Name = "Mirage Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Mirage Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0250"] = {
    Name = "Mirage Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Mirage Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0251"] = {
    Name = "Mirage Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Mirage Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0252"] = {
    Name = "Mirage Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Mirage Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0253"] = {
    Name = "Full Moon Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Full Moon Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0254"] = {
    Name = "Full Moon Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Full Moon Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0255"] = {
    Name = "Full Moon Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Full Moon Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0256"] = {
    Name = "Full Moon Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Full Moon Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0257"] = {
    Name = "Prehistoric Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Prehistoric Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0258"] = {
    Name = "Prehistoric Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Prehistoric Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0259"] = {
    Name = "Prehistoric Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Prehistoric Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0260"] = {
    Name = "Prehistoric Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Prehistoric Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0261"] = {
    Name = "Kitsune Monitor",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Kitsune Monitor runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0262"] = {
    Name = "Kitsune Monitor",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Kitsune Monitor runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0263"] = {
    Name = "Kitsune Monitor",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Kitsune Monitor runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0264"] = {
    Name = "Kitsune Monitor",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Kitsune Monitor runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0265"] = {
    Name = "Event Targeting",
    Category = "Sea Events",
    Variant = 1,
    Enabled = false,
    Description = "Event Targeting runtime profile 1 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0266"] = {
    Name = "Event Targeting",
    Category = "Sea Events",
    Variant = 2,
    Enabled = false,
    Description = "Event Targeting runtime profile 2 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0267"] = {
    Name = "Event Targeting",
    Category = "Sea Events",
    Variant = 3,
    Enabled = false,
    Description = "Event Targeting runtime profile 3 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0268"] = {
    Name = "Event Targeting",
    Category = "Sea Events",
    Variant = 4,
    Enabled = false,
    Description = "Event Targeting runtime profile 4 for the Sea Events subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0269"] = {
    Name = "Player ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Player ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0270"] = {
    Name = "Player ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Player ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0271"] = {
    Name = "Player ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Player ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0272"] = {
    Name = "Player ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Player ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0273"] = {
    Name = "NPC ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "NPC ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0274"] = {
    Name = "NPC ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "NPC ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0275"] = {
    Name = "NPC ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "NPC ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0276"] = {
    Name = "NPC ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "NPC ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0277"] = {
    Name = "Enemy ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Enemy ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0278"] = {
    Name = "Enemy ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Enemy ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0279"] = {
    Name = "Enemy ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Enemy ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0280"] = {
    Name = "Enemy ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Enemy ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0281"] = {
    Name = "Boss ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Boss ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0282"] = {
    Name = "Boss ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Boss ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0283"] = {
    Name = "Boss ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Boss ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0284"] = {
    Name = "Boss ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Boss ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0285"] = {
    Name = "Fruit ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Fruit ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0286"] = {
    Name = "Fruit ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Fruit ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0287"] = {
    Name = "Fruit ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Fruit ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0288"] = {
    Name = "Fruit ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Fruit ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0289"] = {
    Name = "Island ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Island ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0290"] = {
    Name = "Island ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Island ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0291"] = {
    Name = "Island ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Island ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0292"] = {
    Name = "Island ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Island ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0293"] = {
    Name = "Quest ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Quest ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0294"] = {
    Name = "Quest ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Quest ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0295"] = {
    Name = "Quest ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Quest ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0296"] = {
    Name = "Quest ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Quest ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0297"] = {
    Name = "Chest ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Chest ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0298"] = {
    Name = "Chest ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Chest ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0299"] = {
    Name = "Chest ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Chest ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0300"] = {
    Name = "Chest ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Chest ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0301"] = {
    Name = "Event ESP",
    Category = "ESP",
    Variant = 1,
    Enabled = false,
    Description = "Event ESP runtime profile 1 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0302"] = {
    Name = "Event ESP",
    Category = "ESP",
    Variant = 2,
    Enabled = false,
    Description = "Event ESP runtime profile 2 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0303"] = {
    Name = "Event ESP",
    Category = "ESP",
    Variant = 3,
    Enabled = false,
    Description = "Event ESP runtime profile 3 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}
AertherXSystems.Registry["System_0304"] = {
    Name = "Event ESP",
    Category = "ESP",
    Variant = 4,
    Enabled = false,
    Description = "Event ESP runtime profile 4 for the ESP subsystem.",
    Runtime = "AertherX",
    Protected = true,
}

-- Shared runtime helpers
local function AXSafeCall(fn, ...) if type(fn) ~= "function" then return false,nil end return pcall(fn,...) end
local function AXFindChild(parent,name) if not parent then return nil end local ok,obj=pcall(function() return parent:FindFirstChild(name) end) return ok and obj or nil end
local function AXAlive(model) if not model then return false end local h=model:FindFirstChildOfClass("Humanoid") return h~=nil and h.Health>0 end
local function AXRoot(model) if not model then return nil end return model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChild("Head") end
local function AXDistance(a,b) if not a or not b then return math.huge end return (a.Position-b.Position).Magnitude end
local function AXEquipNamed(name) local c=LocalPlayer.Character if not c then return false end local b=LocalPlayer:FindFirstChildOfClass("Backpack") if name and b then for _,t in ipairs(b:GetChildren()) do if t:IsA("Tool") and (t.Name==name or t:GetAttribute("WeaponType")==name) then pcall(function() c:FindFirstChildOfClass("Humanoid"):EquipTool(t) end) return true end end end return c:FindFirstChildOfClass("Tool")~=nil end
local function AXActivateTool() local c=LocalPlayer.Character if not c then return false end local t=c:FindFirstChildOfClass("Tool") if not t then return false end local ok=pcall(function() t:Activate() end) return ok end

AertherXSystems.Areas = {
    {Sea="First Sea",Island="Starter Island",MinLevel=1},
    {Sea="First Sea",Island="Jungle",MinLevel=15},
    {Sea="First Sea",Island="Pirate Village",MinLevel=30},
    {Sea="First Sea",Island="Desert",MinLevel=60},
    {Sea="First Sea",Island="Frozen Village",MinLevel=90},
    {Sea="First Sea",Island="Marine Fortress",MinLevel=120},
    {Sea="First Sea",Island="Skylands",MinLevel=150},
    {Sea="First Sea",Island="Prison",MinLevel=190},
    {Sea="First Sea",Island="Colosseum",MinLevel=250},
    {Sea="First Sea",Island="Magma Village",MinLevel=300},
    {Sea="First Sea",Island="Underwater City",MinLevel=375},
    {Sea="First Sea",Island="Upper Skylands",MinLevel=450},
    {Sea="First Sea",Island="Fountain City",MinLevel=625},
    {Sea="Second Sea",Island="Kingdom of Rose",MinLevel=700},
    {Sea="Second Sea",Island="Green Zone",MinLevel=875},
    {Sea="Second Sea",Island="Graveyard",MinLevel=1000},
    {Sea="Second Sea",Island="Snow Mountain",MinLevel=1000},
    {Sea="Second Sea",Island="Hot and Cold",MinLevel=1100},
    {Sea="Second Sea",Island="Cursed Ship",MinLevel=1250},
    {Sea="Second Sea",Island="Ice Castle",MinLevel=1350},
    {Sea="Second Sea",Island="Forgotten Island",MinLevel=1425},
    {Sea="Third Sea",Island="Port Town",MinLevel=1500},
    {Sea="Third Sea",Island="Hydra Island",MinLevel=1575},
    {Sea="Third Sea",Island="Great Tree",MinLevel=1750},
    {Sea="Third Sea",Island="Floating Turtle",MinLevel=1800},
    {Sea="Third Sea",Island="Castle on the Sea",MinLevel=1900},
    {Sea="Third Sea",Island="Haunted Castle",MinLevel=1975},
    {Sea="Third Sea",Island="Sea of Treats",MinLevel=2075},
    {Sea="Third Sea",Island="Tiki Outpost",MinLevel=2450},
}
function AertherXSystems:Get(name) for _,v in pairs(self.Registry) do if v.Name==name then return v end end return nil end
function AertherXSystems:List(category) local out={} for _,v in pairs(self.Registry) do if not category or v.Category==category then out[#out+1]=v end end return out end
function AertherXSystems:Status() return {Version=self.Version,Brand=self.Brand,Game=self.Game,Systems=#self:List()} end

AertherXSystems.Registry["Profile_0001"]={Name="Auto Farm Level",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Auto Farm Level. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0002"]={Name="Fast Attack",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Fast Attack. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0003"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0004"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0005"]={Name="Job ID Copy",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0006"]={Name="UI Restore",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0007"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0008"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0009"]={Name="Elite Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Elite Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0010"]={Name="Melee Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Melee Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0011"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0012"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0013"]={Name="Server Scanner",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0014"]={Name="Jump Power",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0015"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0016"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0017"]={Name="Quest Starter",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Quest Starter. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0018"]={Name="Auto Observation",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto Observation. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0019"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0020"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0021"]={Name="Empty Server Finder",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0022"]={Name="No Clip",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0023"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0024"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0025"]={Name="Chest Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Chest Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0026"]={Name="Blox Fruit Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Blox Fruit Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0027"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0028"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0029"]={Name="Server Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0030"]={Name="Error Guard",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0031"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0032"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0033"]={Name="Nearest Enemy",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Nearest Enemy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0034"]={Name="Combo Assist",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Combo Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0035"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0036"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0037"]={Name="Low Player Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0038"]={Name="Config Load",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0039"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0040"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0041"]={Name="Auto Quest",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Auto Quest. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0042"]={Name="Skill Spam",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Skill Spam. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0043"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0044"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0045"]={Name="Rejoin",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0046"]={Name="UI Restore",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0047"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0048"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0049"]={Name="Boss Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Boss Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0050"]={Name="Sword Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Sword Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0051"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0052"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0053"]={Name="Job ID Join",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0054"]={Name="Jump Power",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0055"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0056"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0057"]={Name="Mob Targeting",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Mob Targeting. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0058"]={Name="Aim Assist",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Aim Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0059"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0060"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0061"]={Name="Job ID Copy",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0062"]={Name="No Clip",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0063"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0064"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0065"]={Name="Material Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Material Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0066"]={Name="Auto M1",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto M1. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0067"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0068"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0069"]={Name="Server Scanner",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0070"]={Name="Error Guard",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0071"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0072"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0073"]={Name="Island Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Island Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0074"]={Name="Weapon Equip",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Weapon Equip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0075"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0076"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0077"]={Name="Empty Server Finder",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0078"]={Name="Config Load",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0079"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0080"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0081"]={Name="Quest Detector",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Quest Detector. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0082"]={Name="Auto Haki",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Auto Haki. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0083"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0084"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0085"]={Name="Server Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0086"]={Name="UI Restore",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0087"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0088"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0089"]={Name="Mastery Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Mastery Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0090"]={Name="Gun Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Gun Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0091"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0092"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0093"]={Name="Low Player Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0094"]={Name="Jump Power",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0095"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0096"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0097"]={Name="Mob Magnet",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Mob Magnet. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0098"]={Name="Target Lock",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Target Lock. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0099"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0100"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0101"]={Name="Rejoin",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0102"]={Name="No Clip",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0103"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0104"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0105"]={Name="Auto Farm Level",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Auto Farm Level. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0106"]={Name="Fast Attack",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Fast Attack. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0107"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0108"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0109"]={Name="Job ID Join",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0110"]={Name="Error Guard",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0111"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0112"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0113"]={Name="Elite Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Elite Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0114"]={Name="Melee Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Melee Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0115"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0116"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0117"]={Name="Job ID Copy",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0118"]={Name="Config Load",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0119"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0120"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0121"]={Name="Quest Starter",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Quest Starter. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0122"]={Name="Auto Observation",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Auto Observation. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0123"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0124"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0125"]={Name="Server Scanner",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0126"]={Name="UI Restore",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0127"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0128"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0129"]={Name="Chest Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Chest Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0130"]={Name="Blox Fruit Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Blox Fruit Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0131"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0132"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0133"]={Name="Empty Server Finder",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0134"]={Name="Jump Power",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0135"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0136"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0137"]={Name="Nearest Enemy",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Nearest Enemy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0138"]={Name="Combo Assist",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Combo Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0139"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0140"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0141"]={Name="Server Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0142"]={Name="No Clip",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0143"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0144"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0145"]={Name="Auto Quest",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Auto Quest. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0146"]={Name="Skill Spam",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Skill Spam. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0147"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0148"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0149"]={Name="Low Player Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0150"]={Name="Error Guard",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0151"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0152"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0153"]={Name="Boss Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Boss Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0154"]={Name="Sword Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Sword Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0155"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0156"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0157"]={Name="Rejoin",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0158"]={Name="Config Load",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0159"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0160"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0161"]={Name="Mob Targeting",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Mob Targeting. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0162"]={Name="Aim Assist",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Aim Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0163"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0164"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0165"]={Name="Job ID Join",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0166"]={Name="UI Restore",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0167"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0168"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0169"]={Name="Material Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Material Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0170"]={Name="Auto M1",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Auto M1. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0171"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0172"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0173"]={Name="Job ID Copy",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0174"]={Name="Jump Power",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0175"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0176"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0177"]={Name="Island Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Island Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0178"]={Name="Weapon Equip",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Weapon Equip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0179"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0180"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0181"]={Name="Server Scanner",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0182"]={Name="No Clip",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0183"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0184"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0185"]={Name="Quest Detector",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Quest Detector. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0186"]={Name="Auto Haki",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto Haki. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0187"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0188"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0189"]={Name="Empty Server Finder",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0190"]={Name="Error Guard",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0191"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0192"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0193"]={Name="Mastery Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Mastery Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0194"]={Name="Gun Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Gun Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0195"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0196"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0197"]={Name="Server Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0198"]={Name="Config Load",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0199"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0200"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0201"]={Name="Mob Magnet",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Mob Magnet. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0202"]={Name="Target Lock",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Target Lock. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0203"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0204"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0205"]={Name="Low Player Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0206"]={Name="UI Restore",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0207"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0208"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0209"]={Name="Auto Farm Level",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Auto Farm Level. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0210"]={Name="Fast Attack",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Fast Attack. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0211"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0212"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0213"]={Name="Rejoin",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0214"]={Name="Jump Power",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0215"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0216"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0217"]={Name="Elite Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Elite Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0218"]={Name="Melee Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Melee Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0219"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0220"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0221"]={Name="Job ID Join",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0222"]={Name="No Clip",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0223"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0224"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0225"]={Name="Quest Starter",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Quest Starter. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0226"]={Name="Auto Observation",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Auto Observation. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0227"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0228"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0229"]={Name="Job ID Copy",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0230"]={Name="Error Guard",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0231"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0232"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0233"]={Name="Chest Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Chest Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0234"]={Name="Blox Fruit Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Blox Fruit Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0235"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0236"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0237"]={Name="Server Scanner",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0238"]={Name="Config Load",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0239"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0240"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0241"]={Name="Nearest Enemy",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Nearest Enemy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0242"]={Name="Combo Assist",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Combo Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0243"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0244"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0245"]={Name="Empty Server Finder",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0246"]={Name="UI Restore",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0247"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0248"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0249"]={Name="Auto Quest",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Auto Quest. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0250"]={Name="Skill Spam",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Skill Spam. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0251"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0252"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0253"]={Name="Server Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0254"]={Name="Jump Power",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0255"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0256"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0257"]={Name="Boss Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Boss Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0258"]={Name="Sword Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Sword Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0259"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0260"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0261"]={Name="Low Player Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0262"]={Name="No Clip",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0263"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0264"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0265"]={Name="Mob Targeting",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Mob Targeting. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0266"]={Name="Aim Assist",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Aim Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0267"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0268"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0269"]={Name="Rejoin",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0270"]={Name="Error Guard",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0271"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0272"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0273"]={Name="Material Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Material Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0274"]={Name="Auto M1",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Auto M1. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0275"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0276"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0277"]={Name="Job ID Join",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0278"]={Name="Config Load",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0279"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0280"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0281"]={Name="Island Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Island Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0282"]={Name="Weapon Equip",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Weapon Equip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0283"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0284"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0285"]={Name="Job ID Copy",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0286"]={Name="UI Restore",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0287"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0288"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0289"]={Name="Quest Detector",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Quest Detector. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0290"]={Name="Auto Haki",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Auto Haki. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0291"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0292"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0293"]={Name="Server Scanner",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0294"]={Name="Jump Power",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0295"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0296"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0297"]={Name="Mastery Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Mastery Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0298"]={Name="Gun Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Gun Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0299"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0300"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0301"]={Name="Empty Server Finder",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0302"]={Name="No Clip",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0303"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0304"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0305"]={Name="Mob Magnet",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Mob Magnet. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0306"]={Name="Target Lock",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Target Lock. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0307"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0308"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0309"]={Name="Server Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0310"]={Name="Error Guard",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0311"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0312"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0313"]={Name="Auto Farm Level",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Auto Farm Level. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0314"]={Name="Fast Attack",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Fast Attack. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0315"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0316"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0317"]={Name="Low Player Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0318"]={Name="Config Load",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0319"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0320"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0321"]={Name="Elite Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Elite Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0322"]={Name="Melee Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Melee Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0323"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0324"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0325"]={Name="Rejoin",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0326"]={Name="UI Restore",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0327"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0328"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0329"]={Name="Quest Starter",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Quest Starter. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0330"]={Name="Auto Observation",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto Observation. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0331"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0332"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0333"]={Name="Job ID Join",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0334"]={Name="Jump Power",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0335"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0336"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0337"]={Name="Chest Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Chest Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0338"]={Name="Blox Fruit Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Blox Fruit Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0339"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0340"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0341"]={Name="Job ID Copy",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0342"]={Name="No Clip",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0343"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0344"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0345"]={Name="Nearest Enemy",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Nearest Enemy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0346"]={Name="Combo Assist",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Combo Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0347"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0348"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0349"]={Name="Server Scanner",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0350"]={Name="Error Guard",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0351"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0352"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0353"]={Name="Auto Quest",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Auto Quest. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0354"]={Name="Skill Spam",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Skill Spam. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0355"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0356"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0357"]={Name="Empty Server Finder",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0358"]={Name="Config Load",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0359"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0360"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0361"]={Name="Boss Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Boss Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0362"]={Name="Sword Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Sword Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0363"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0364"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0365"]={Name="Server Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0366"]={Name="UI Restore",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0367"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0368"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0369"]={Name="Mob Targeting",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Mob Targeting. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0370"]={Name="Aim Assist",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Aim Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0371"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0372"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0373"]={Name="Low Player Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0374"]={Name="Jump Power",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0375"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0376"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0377"]={Name="Material Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Material Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0378"]={Name="Auto M1",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto M1. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0379"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0380"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0381"]={Name="Rejoin",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0382"]={Name="No Clip",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0383"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0384"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0385"]={Name="Island Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Island Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0386"]={Name="Weapon Equip",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Weapon Equip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0387"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0388"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0389"]={Name="Job ID Join",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0390"]={Name="Error Guard",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0391"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0392"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0393"]={Name="Quest Detector",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Quest Detector. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0394"]={Name="Auto Haki",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Auto Haki. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0395"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0396"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0397"]={Name="Job ID Copy",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0398"]={Name="Config Load",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0399"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0400"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0401"]={Name="Mastery Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Mastery Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0402"]={Name="Gun Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Gun Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0403"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0404"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0405"]={Name="Server Scanner",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0406"]={Name="UI Restore",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0407"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0408"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0409"]={Name="Mob Magnet",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Mob Magnet. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0410"]={Name="Target Lock",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Target Lock. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0411"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0412"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0413"]={Name="Empty Server Finder",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0414"]={Name="Jump Power",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0415"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0416"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0417"]={Name="Auto Farm Level",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Auto Farm Level. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0418"]={Name="Fast Attack",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Fast Attack. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0419"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0420"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0421"]={Name="Server Hop",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0422"]={Name="No Clip",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0423"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0424"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0425"]={Name="Elite Farming",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Elite Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0426"]={Name="Melee Mode",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Melee Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0427"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0428"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0429"]={Name="Low Player Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0430"]={Name="Error Guard",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0431"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0432"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0433"]={Name="Quest Starter",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Quest Starter. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0434"]={Name="Auto Observation",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Auto Observation. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0435"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0436"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0437"]={Name="Rejoin",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0438"]={Name="Config Load",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0439"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0440"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0441"]={Name="Chest Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Chest Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0442"]={Name="Blox Fruit Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Blox Fruit Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0443"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0444"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0445"]={Name="Job ID Join",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0446"]={Name="UI Restore",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0447"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0448"]={Name="Quest ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Quest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0449"]={Name="Nearest Enemy",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Nearest Enemy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0450"]={Name="Combo Assist",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Combo Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0451"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0452"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0453"]={Name="Job ID Copy",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0454"]={Name="Jump Power",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0455"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0456"]={Name="Island ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Island ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0457"]={Name="Auto Quest",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Auto Quest. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0458"]={Name="Skill Spam",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Skill Spam. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0459"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0460"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0461"]={Name="Server Scanner",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0462"]={Name="No Clip",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0463"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0464"]={Name="Fruit ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Fruit ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0465"]={Name="Boss Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Boss Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0466"]={Name="Sword Mode",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Sword Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0467"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0468"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0469"]={Name="Empty Server Finder",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Empty Server Finder. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0470"]={Name="Error Guard",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0471"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0472"]={Name="Boss ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Boss ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0473"]={Name="Mob Targeting",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Mob Targeting. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0474"]={Name="Aim Assist",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Aim Assist. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0475"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0476"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0477"]={Name="Server Hop",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Server Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0478"]={Name="Config Load",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0479"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0480"]={Name="Enemy ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Enemy ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0481"]={Name="Material Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Material Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0482"]={Name="Auto M1",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Auto M1. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0483"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0484"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0485"]={Name="Low Player Hop",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Low Player Hop. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0486"]={Name="UI Restore",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: UI Restore. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0487"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0488"]={Name="NPC ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: NPC ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0489"]={Name="Island Farming",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Island Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0490"]={Name="Weapon Equip",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Weapon Equip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0491"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0492"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0493"]={Name="Rejoin",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Rejoin. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0494"]={Name="Jump Power",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Jump Power. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0495"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0496"]={Name="Player ESP",Category="ESP",Profile=4,Enabled=false,Description="AertherX ESP capability profile 4: Player ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0497"]={Name="Quest Detector",Category="Farming",Profile=5,Enabled=false,Description="AertherX Farming capability profile 5: Quest Detector. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0498"]={Name="Auto Haki",Category="Combat",Profile=6,Enabled=false,Description="AertherX Combat capability profile 6: Auto Haki. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0499"]={Name="Auto Collect Fruit",Category="Fruits",Profile=7,Enabled=false,Description="AertherX Fruits capability profile 7: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0500"]={Name="Island Teleport",Category="Travel",Profile=8,Enabled=false,Description="AertherX Travel capability profile 8: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0501"]={Name="Job ID Join",Category="Servers",Profile=9,Enabled=false,Description="AertherX Servers capability profile 9: Job ID Join. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0502"]={Name="No Clip",Category="Utility",Profile=10,Enabled=false,Description="AertherX Utility capability profile 10: No Clip. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0503"]={Name="Kitsune Monitor",Category="Sea Events",Profile=11,Enabled=false,Description="AertherX Sea Events capability profile 11: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0504"]={Name="Event ESP",Category="ESP",Profile=12,Enabled=false,Description="AertherX ESP capability profile 12: Event ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0505"]={Name="Mastery Farming",Category="Farming",Profile=1,Enabled=false,Description="AertherX Farming capability profile 1: Mastery Farming. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0506"]={Name="Gun Mode",Category="Combat",Profile=2,Enabled=false,Description="AertherX Combat capability profile 2: Gun Mode. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0507"]={Name="Auto Collect Fruit",Category="Fruits",Profile=3,Enabled=false,Description="AertherX Fruits capability profile 3: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0508"]={Name="Island Teleport",Category="Travel",Profile=4,Enabled=false,Description="AertherX Travel capability profile 4: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0509"]={Name="Job ID Copy",Category="Servers",Profile=5,Enabled=false,Description="AertherX Servers capability profile 5: Job ID Copy. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0510"]={Name="Error Guard",Category="Utility",Profile=6,Enabled=false,Description="AertherX Utility capability profile 6: Error Guard. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0511"]={Name="Kitsune Monitor",Category="Sea Events",Profile=7,Enabled=false,Description="AertherX Sea Events capability profile 7: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0512"]={Name="Chest ESP",Category="ESP",Profile=8,Enabled=false,Description="AertherX ESP capability profile 8: Chest ESP. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0513"]={Name="Mob Magnet",Category="Farming",Profile=9,Enabled=false,Description="AertherX Farming capability profile 9: Mob Magnet. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0514"]={Name="Target Lock",Category="Combat",Profile=10,Enabled=false,Description="AertherX Combat capability profile 10: Target Lock. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0515"]={Name="Auto Collect Fruit",Category="Fruits",Profile=11,Enabled=false,Description="AertherX Fruits capability profile 11: Auto Collect Fruit. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0516"]={Name="Island Teleport",Category="Travel",Profile=12,Enabled=false,Description="AertherX Travel capability profile 12: Island Teleport. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0517"]={Name="Server Scanner",Category="Servers",Profile=1,Enabled=false,Description="AertherX Servers capability profile 1: Server Scanner. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0518"]={Name="Config Load",Category="Utility",Profile=2,Enabled=false,Description="AertherX Utility capability profile 2: Config Load. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
AertherXSystems.Registry["Profile_0519"]={Name="Kitsune Monitor",Category="Sea Events",Profile=3,Enabled=false,Description="AertherX Sea Events capability profile 3: Kitsune Monitor. This registry entry is used by the hub settings, diagnostics, and subsystem discovery layer."}
_G.AertherXSystems=AertherXSystems
showPage("Main")
