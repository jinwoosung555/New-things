-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Configuration Table
local ScriptConfig = {
    ManualSpeed = 16,        -- Default walk speed (adjust this value manually as needed)
    MaxBoostedSpeed = 32,    -- Maximum allowed speed if modified
    IsStealing = false,
}

-- Function to Manually Adjust Speed
local function setManualSpeed(newSpeed)
    if newSpeed >= 0 and newSpeed <= ScriptConfig.MaxBoostedSpeed then
        ScriptConfig.ManualSpeed = newSpeed
        humanoid.WalkSpeed = ScriptConfig.ManualSpeed
        print("Speed successfully updated to: " .. ScriptConfig.ManualSpeed)
    else
        warn("Speed out of allowed bounds!")
    end
end

-- Egg Stealing Function
local function stealEgg(eggModel)
    if ScriptConfig.IsStealing then return end
    ScriptConfig.IsStealing = true

    print("Attempting to steal the egg...")
    
    -- Simulate stealing action / animation delay
    task.wait(1) 

    if eggModel and eggModel.Parent then
        -- Reward player or add to inventory here
        print("Successfully stole the egg!")
        
        -- Remove or disable the egg from the world
        eggModel:Destroy()
    else
        warn("Egg is no longer available!")
    end

    ScriptConfig.IsStealing = false
end

-- Example Setup: Proximity Prompt Connection
local egg = Workspace:FindFirstChild("TargetEgg")
if egg then
    local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt") or Instance.new("ProximityPrompt")
    prompt.Parent = egg
    prompt.ActionText = "Steal Egg"
    prompt.ObjectText = "Golden Egg"
    
    prompt.Triggered:Connect(function(triggerPlayer)
        if triggerPlayer == player then
            stealEgg(egg)
        end
    end)
end

-- Example of changing speed manually during runtime:
-- setManualSpeed(24)
