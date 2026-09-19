--[[\
    Fixed CentuDox V3 Hub with Floating 'K' Minimize Button & Mobile Support
]]--

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Clean up any existing instances to avoid duplicates
if CoreGui:FindFirstChild("CentuDoxV3Gui") then
    CoreGui.CentuDoxV3Gui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentuDoxV3Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- 1. Main UI Container (Black Box Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows dragging the menu around on mobile/PC
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(140, 0, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Title Bar / Logo Container
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Text = "👑 CentuDox V3 👑"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Scrolling Frame for buttons so they don't clip out
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 450)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollingFrame

-- 2. Floating "K" Button (Minimizing System)
local FloatingK = Instance.new("TextButton")
FloatingK.Size = UDim2.new(0, 45, 0, 45)
FloatingK.Position = UDim2.new(0, 30, 0.5, -22)
FloatingK.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
FloatingK.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingK.Text = "K"
FloatingK.Font = Enum.Font.SourceSansBold
FloatingK.TextSize = 22
FloatingK.Draggable = true
FloatingK.Parent = ScreenGui

local KCorner = Instance.new("UICorner")
KCorner.CornerRadius = UDim.new(1, 0) -- Makes it a circle
KCorner.Parent = FloatingK

local KStroke = Instance.new("UIStroke")
KStroke.Color = Color3.fromRGB(255, 255, 255)
KStroke.Thickness = 1.5
KStroke.Parent = FloatingK

-- Toggle visibility function
local isOpen = true
local function ToggleUI()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end

FloatingK.MouseButton1Click:Connect(ToggleUI)

-- Keyboard toggle support (Press 'K' on keyboard)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        ToggleUI()
    end
end)

-- 3. Function to Create Functional Feature Toggles
local function CreateButton(name, initialState, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.BackgroundColor3 = initialState and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(30, 30, 30)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = name .. ": " .. (initialState and "ON" or "OFF")
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 15
    Button.Parent = ScrollingFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    local state = initialState
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(75, 0, 130) or Color3.fromRGB(30, 30, 30)
        Button.Text = name .. ": " .. (state and "ON" or "OFF")
        pcall(function()
            callback(state)
        end)
    end)
end

-- 4. Adding All Features to the Menu
CreateButton("Fast Attack", true, function(state)
    print("Fast Attack set to:", state)
end)

CreateButton("Camlock", false, function(state)
    print("Camlock set to:", state)
end)

CreateButton("Anti-Stun", true, function(state)
    print("Anti-Stun set to:", state)
end)

CreateButton("Walk On Water", true, function(state)
    print("Walk On Water set to:", state)
end)

CreateButton("Auto Race V4", false, function(state)
    print("Auto Race V4 set to:", state)
end)

CreateButton("Player ESP", true, function(state)
    print("Player ESP set to:", state)
end)

CreateButton("Player Tracers", false, function(state)
    print("Player Tracers set to:", state)
end)
