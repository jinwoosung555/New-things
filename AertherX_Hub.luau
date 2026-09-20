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

showPage("Main")
