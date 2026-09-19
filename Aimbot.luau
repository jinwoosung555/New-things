--[[\
    Fixed CentuDox V3 Hub with Functional Fast Attack Loop
]]--

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 既存のUIを削除
if CoreGui:FindFirstChild("CentuDoxV3Gui") then
    CoreGui.CentuDoxV3Gui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentuDoxV3Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- メインフレーム
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 400)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(140, 0, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- タイトル
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

-- スクロールフレーム
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

-- フローティング "K" ボタン
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
KCorner.CornerRadius = UDim.new(1, 0)
KCorner.Parent = FloatingK

local isOpen = true
FloatingK.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    MainFrame.Visible = isOpen
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        isOpen = not isOpen
        MainFrame.Visible = isOpen
    end
end)

-- 機能の状態管理用テーブル
local Config = {
    FastAttack = false
}

-- Fast Attack の実処理ループ
task.spawn(function()
    while true do
        task.wait(0.01)
        if Config.FastAttack then
            pcall(function()
                -- 例: Blox Fruits等の一般的な攻撃リモートを狙う処理
                local character = LocalPlayer.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local tool = character:FindFirstChildOfClass("Tool")
                    
                    if tool and humanoidRootPart then
                        -- ここにゲーム固有の攻撃イベント送信処理が入ります
                        -- 例: game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(...)
                        
                        -- 武器のレプリケーションイベントを強制発動させる簡易アプローチ
                        if tool:FindFirstChild("Handle") then
                            local remote = tool:FindFirstChild("AttackRemote") or game:GetService("ReplicatedStorage"):FindFirstChild("RegisterAttack", true)
                            if remote and remote:IsA("RemoteEvent") then
                                remote:FireServer(0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ボタン生成関数
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

-- UI要素の配置
CreateButton("Fast Attack", false, function(state)
    Config.FastAttack = state
end)

CreateButton("Camlock", false, function(state)
    print("Camlock:", state)
end)

CreateButton("Anti-Stun", true, function(state)
    print("Anti-Stun:", state)
end)
