-- Load Wind UI Library
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configuration Variables
getgenv().Config = {
    SilentAim = false,
    AutoFire = false,
    HitPart = "Head"
}

-- Create Window with Minimize & Close Enabled
local Window = WindUI:CreateWindow({
    Title = "Arsenal | Combat Hub",
    Icon = "crosshair",
    Author = "User",
    Folder = "ArsenalHub",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = false,
    Acrylic = true, -- Adds modern blur effect
    Theme = "Dark",
    MinimizeButton = true, -- Enables the minimize system
    CloseButton = true,    -- Enables the close system
})

-- Create Tabs
local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "sword",
})

-- // Combat Tab Sections \\
local AimSection = CombatTab:Section({ Title = "Aim & Attack Settings" })

-- Silent Aim Toggle
AimSection:Toggle({
    Title = "Silent Aim",
    Description = "Redirects your shots to target players automatically.",
    Default = false,
    Callback = function(state)
        getgenv().Config.SilentAim = state
    end
})

-- Auto Fire Toggle
AimSection:Toggle({
    Title = "Auto Fire",
    Description = "Automatically fires your weapon when a target is in sight.",
    Default = false,
    Callback = function(state)
        getgenv().Config.AutoFire = state
    end
})

-- Hitpart Dropdown
AimSection:Dropdown({
    Title = "Target Hitpart",
    Values = {"Head", "HumanoidRootPart"},
    Default = "Head",
    Callback = function(selected)
        getgenv().Config.HitPart = selected
    end
})

-- // Utility Functions \\
local function getClosestPlayer()
    local target = nil
    local shortestDist = math.huge

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local teammate = v.Team == LocalPlayer.Team
            if not teammate then
                local part = v.Character:FindFirstChild(getgenv().Config.HitPart)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if dist < shortestDist then
                        shortestDist = dist
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- // Silent Aim & Auto Fire Loops \\
RunService.RenderStepped:Connect(function()
    if not getgenv().Config.SilentAim and not getgenv().Config.AutoFire then return end
    
    local target = getClosestPlayer()
    if target and target.Character then
        local targetPart = target.Character:FindFirstChild(getgenv().Config.HitPart)
        
        if targetPart then
            if getgenv().Config.AutoFire then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("RemoteFunction") then
                    pcall(function()
                        tool.RemoteFunction:InvokeServer("Shoot", targetPart.Position)
                    end)
                end
            end
        end
    end
end)

WindUI:Notify({
    Title = "Arsenal Hub Loaded",
    Content = "Minimize system enabled successfully!",
    Duration = 3,
})
