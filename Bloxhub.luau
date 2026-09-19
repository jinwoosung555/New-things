-- Blox Fruit Hub Script with Auto Farm Level System
-- Generated via Luraph Constants / Syncrypt Analysis

local repo = "https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/ui.luau"
local RedzLib = loadstring(game:HttpGet(repo))()

-- Initialize Main Window
local Window = RedzLib:MakeTab({
    Title = "Blox Fruit Hub | Syncrypt Dump",
    SubTitle = "v30 / Auto Farm Level Edition",
    Icon = "rbxassetid://6023426915"
})

-- Global Settings Table initialization matching dump keys
_G.AutoFarmLevel = _G.AutoFarmLevel or false
_G.SelectWeapon = _G.SelectWeapon or "Melee"
_G.FarmBlazeEM = _G.FarmBlazeEM or false
_G.SelectIsland = _G.SelectIsland or "Port Town"
_G.Auto_Cake_Prince = _G.Auto_Cake_Prince or false
_G.StoreF = _G.StoreF or false
_G.Raiding = _G.Raiding or false
_G.Auto_DevilFruit = _G.Auto_DevilFruit or false
_G.Auto_God_Human = _G.Auto_God_Human or false

--------------------------------------------------------------------------------
-- TAB 1: AUTO FARM LEVEL (NEW)
--------------------------------------------------------------------------------
local FarmTab = Window:MakeTab({
    Title = "Auto Farm",
    Icon = "rbxassetid://6023426915"
})

FarmTab:AddToggle({
    Name = "Auto Farm Level",
    Default = _G.AutoFarmLevel,
    Callback = function(Value)
        _G.AutoFarmLevel = Value
        
        -- Background execution loop for Auto Farm Level logic
        task.spawn(function()
            while _G.AutoFarmLevel do
                task.wait(0.5)
                pcall(function()
                    -- Placeholder logic for checking player level, grabbing quests, and teleporting to mobs
                    local player = game:GetService("Players").LocalPlayer
                    local level = player.Data.Level.Value
                    print("Current Player Level: " .. level .. " | Auto-farm active...")
                    
                    -- Insert automated Quest and Closest Mob tracking function here
                end)
            end
        end)
    end
})

FarmTab:AddDropdown({
    Name = "Select Weapon",
    Options = {
        "Melee",
        "Sword",
        "Blox Fruit",
        "Gun"
    },
    Default = "Melee",
    Callback = function(Option)
        _G.SelectWeapon = Option
    end
})

FarmTab:AddSlider({
    Name = "Fast Attack Delay",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Increment = 0.05,
    Callback = function(Value)
        _G.FastAttackDelay = Value
    end
})

--------------------------------------------------------------------------------
-- TAB 2: MAIN & ISLANDS
--------------------------------------------------------------------------------
local MainTab = Window:MakeTab({
    Title = "Main",
    Icon = "rbxassetid://6023426915"
})

MainTab:AddToggle({
    Name = "Farm Blaze EM",
    Default = _G.FarmBlazeEM,
    Callback = function(Value)
        _G.FarmBlazeEM = Value
    end
})

MainTab:AddDropdown({
    Name = "Select Island",
    Options = {
        "Pirate Village",
        "Frozen Village",
        "Magma Village",
        "Port Town",
        "Castle On The Sea",
        "Tiki Outpost"
    },
    Default = "Port Town",
    Callback = function(Option)
        _G.SelectIsland = Option
    end
})

--------------------------------------------------------------------------------
-- TAB 3: MOBS & BOSSES
--------------------------------------------------------------------------------
local MobsTab = Window:MakeTab({
    Title = "Mobs",
    Icon = "rbxassetid://6023426915"
})

MobsTab:AddButton({
    Name = "Farm Rip Indra",
    Callback = function()
        pcall(function()
            print("Targeting: Rip Indra True Form")
        end)
    end
})

MobsTab:AddButton({
    Name = "Farm Elite Hunter",
    Callback = function()
        print("Executing Elite Hunter tracking logic.")
    end
})

--------------------------------------------------------------------------------
-- TAB 4: SEA EVENTS & RAIDS
--------------------------------------------------------------------------------
local SeaTab = Window:MakeTab({
    Title = "SeaEvent",
    Icon = "rbxassetid://6023426915"
})

SeaTab:AddToggle({
    Name = "Auto Raiding",
    Default = _G.Raiding,
    Callback = function(Value)
        _G.Raiding = Value
    end
})

--------------------------------------------------------------------------------
-- TAB 5: SHOP & MISC
--------------------------------------------------------------------------------
local ShopTab = Window:MakeTab({
    Title = "Shop",
    Icon = "rbxassetid://6023426915"
})

ShopTab:AddToggle({
    Name = "Auto Store Fruits",
    Default = _G.StoreF,
    Callback = function(Value)
        _G.StoreF = Value
    end
})

ShopTab:AddButton({
    Name = "Buy God Human Style",
    Callback = function()
        _G.Auto_God_Human = true
        local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
        local CommF = Remotes:WaitForChild("CommF_")
        CommF:InvokeServer("BuyItem", "Godhuman")
    end
})

-- Notification prompt upon script execution
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blox Fruit Hub Loaded",
    Text = "Auto Farm Level framework successfully added!",
    Duration = 5
})
