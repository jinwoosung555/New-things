 -- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "Arsenal | Combat Hub",
    LoadingTitle = "Arsenal Hub Interface",
    LoadingSubtitle = "by Rayfield",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ArsenalHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No key needed",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {""}
    }
})

-- Create Tab
local CombatTab = Window:CreateTab("Combat", "sword")

-- // Sections \\
local AimSection = CombatTab:CreateSection("Aim & Attack Settings")

-- Silent Aim Toggle
CombatTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        getgenv().Config.SilentAim = Value
    end,
})

-- Auto Fire Toggle
CombatTab:CreateToggle({
    Name = "Auto Fire",
    CurrentValue = false,
    Flag = "AutoFireToggle",
    Callback = function(Value)
        getgenv().Config.AutoFire = Value
    end,
})

-- Hitpart Dropdown
CombatTab:CreateDropdown({
    Name = "Target Hitpart",
    Options = {"Head", "HumanoidRootPart"},
    CurrentOption = "Head",
    Flag = "HitPartDropdown",
    Callback = function(Option)
        -- Dropdown options return as a table in Rayfield, so we extract the value
        getgenv().Config.HitPart = type(Option) == "table" and Option[1] or Option
    end,
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

-- Notify user that script has loaded
Rayfield:Notify({
    Title = "Arsenal Hub Loaded",
    Content = "Rayfield UI initialized successfully!",
    Duration = 3,
    Image = "check",
})
