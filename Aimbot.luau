--[[\
    Template: Complete CentuDox V3 Hub Configuration & Architecture
]]--

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- 1. Complete Configuration Structure matching V3 Features
local HubConfig = {
    FileName = "CentuDox-67.json",
    Combat = {
        FastAttackEnabled = true,
        FADistance = 25.0,
        CamlockEnabled = false,
        PredictionAmount = 0.125,
        AntiStun = true,
        UnbreakableSkills = false
    },
    Movement = {
        SpeedEnabled = false,
        SpeedValue = 35,
        DashEnabled = true,
        DashValue = 50,
        JumpBoost = false,
        WalkOnWater = true
    },
    Automation = {
        AutoRaceV3 = false,
        AutoRaceV4 = false,
        InfiniteEnergy = true
    },
    Visuals = {
        PlayerEsp = true,
        PlayerTracers = true,
        NPCTracers = false,
        TeamCheck = true,
        ShowPvPStatus = true
    }
}

-- 2. File Management Functions
local function SaveConfig()
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(HubConfig)
    end)
    if success and writefile then
        writefile(HubConfig.FileName, encoded)
    end
end

local function LoadConfig()
    if readfile and listfiles then
        for _, file in ipairs(listfiles("")) do
            if file == HubConfig.FileName then
                local success, decoded = pcall(function()
                    return HttpService:JSONDecode(readfile(HubConfig.FileName))
                end)
                if success and decoded then
                    HubConfig = decoded
                end
            end
        end
    end
end

LoadConfig()

-- 3. Expanded UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentuDoxV3Gui"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("ScrollingFrame")
MainFrame.Size = UDim2.new(0, 380, 0, 450)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(140, 0, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Creator function for dynamic toggles
local function CreateToggle(name, yPos, initialState, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 340, 0, 35)
    ToggleButton.Position = UDim2.new(0, 20, 0, yPos)
    ToggleButton.BackgroundColor3 = initialState and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(30, 30, 30)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = name .. ": " .. tostring(initialState)
    ToggleButton.Font = Enum.Font.Jura
    ToggleButton.TextSize = 15
    ToggleButton.Parent = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = callback()
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(30, 30, 30)
        ToggleButton.Text = name .. ": " .. tostring(newState)
        SaveConfig()
    end)
end

-- 4. Initializing All Full-Featured Elements
local currentY = 20
local spacing = 45

CreateToggle("Fast Attack", currentY, HubConfig.Combat.FastAttackEnabled, function()
    HubConfig.Combat.FastAttackEnabled = not HubConfig.Combat.FastAttackEnabled
    return HubConfig.Combat.FastAttackEnabled
end)

currentY = currentY + spacing
CreateToggle("Camlock", currentY, HubConfig.Combat.CamlockEnabled, function()
    HubConfig.Combat.CamlockEnabled = not HubConfig.Combat.CamlockEnabled
    return HubConfig.Combat.CamlockEnabled
end)

currentY = currentY + spacing
CreateToggle("Anti-Stun", currentY, HubConfig.Combat.AntiStun, function()
    HubConfig.Combat.AntiStun = not HubConfig.Combat.AntiStun
    return HubConfig.Combat.AntiStun
end)

currentY = currentY + spacing
CreateToggle("Walk On Water", currentY, HubConfig.Movement.WalkOnWater, function()
    HubConfig.Movement.WalkOnWater = not HubConfig.Movement.WalkOnWater
    return HubConfig.Movement.WalkOnWater
end)

currentY = currentY + spacing
CreateToggle("Auto Race V4", currentY, HubConfig.Automation.AutoRaceV4, function()
    HubConfig.Automation.AutoRaceV4 = not HubConfig.Automation.AutoRaceV4
    return HubConfig.Automation.AutoRaceV4
end)

currentY = currentY + spacing
CreateToggle("Player ESP", currentY, HubConfig.Visuals.PlayerEsp, function()
    HubConfig.Visuals.PlayerEsp = not HubConfig.Visuals.PlayerEsp
    return HubConfig.Visuals.PlayerEsp
end)
