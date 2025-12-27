-- [[ 日本のブレインロットを盗む - 完全放置版スクリプト ]] --

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- GUI作成
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FullAutoBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Name = "BrainrotUltimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.25, 0)
Title.Text = "日本のブレインロット V4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.BackgroundTransparency = 1

FullAutoBtn.Parent = MainFrame
FullAutoBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
FullAutoBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
FullAutoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FullAutoBtn.Text = "フルオート: OFF"
FullAutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FullAutoBtn.TextSize = 16

StatusLabel.Parent = MainFrame
StatusLabel.Position = UDim2.new(0, 0, 0.65, 0)
StatusLabel.Size = UDim2.new(1, 0, 0.3, 0)
StatusLabel.Text = "待機中..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.BackgroundTransparency = 1

MinimizeBtn.Parent = ScreenGui
MinimizeBtn.Position = UDim2.new(0.1, 0, 0.33, 0)
MinimizeBtn.Size = UDim2.new(0, 80, 0, 30)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.Text = "表示/隠す"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

--- 変数 ---
local _G.Enabled = false
local myBaseCFrame = nil

-- 基地（プロット）を特定する関数
local function findMyBase()
    -- 1. 自分の名前が書かれた看板や所有者属性を探す
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v:IsA("StringValue") or v:IsA("ObjectValue")) and v.Value == player.Name then
            if v.Parent:IsA("Model") then return v.Parent:GetModelCFrame() end
            if v.Parent:IsA("BasePart") then return v.Parent.CFrame end
        end
    end
    -- 2. 見つからない場合は現在の場所を基地とする
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame
end

-- 売却リモートを実行する関数
local function autoSell()
    for _, v in pairs(replicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("sell") or v.Name:lower():find("claim")) then
            v:FireServer()
        end
    end
end

-- メインループ
task.spawn(function()
    while true do
        if _G.Enabled then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root then
                -- 基地の場所を特定
                if not myBaseCFrame then
                    StatusLabel.Text = "基地を検索中..."
                    myBaseCFrame = findMyBase()
                    task.wait(1)
                end

                -- アイテムを検索
                for _, item in pairs(game.Workspace:GetDescendants()) do
                    if not _G.Enabled then break end
                    
                    -- ClickDetector（盗めるもの）を検知
                    if item:IsA("ClickDetector") and item.Parent and item.Parent:IsA("BasePart") then
                        -- 1. アイテムへワープ
                        StatusLabel.Text = "アイテムへ移動中..."
                        root.CFrame = item.Parent.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        
                        -- 2. 盗む実行
                        fireclickdetector(item)
                        StatusLabel.Text = "盗み完了！"
                        task.wait(0.05)
                        
                        -- 3. 即座に基地へ帰還
                        if myBaseCFrame then
                            root.CFrame = myBaseCFrame + Vector3.new(0, 3, 0)
                            StatusLabel.Text = "基地で売却中..."
                            task.wait(0.1)
                            autoSell() -- 売却ボタンのリモート実行
                        end
                        
                        task.wait(0.3) -- 次のアイテムへのインターバル
                    end
                end
            end
        else
            StatusLabel.Text = "停止中"
        end
        task.wait(1)
    end
end)

--- ボタンクリックイベント ---
FullAutoBtn.MouseButton1Click:Connect(function()
    _G.Enabled = not _G.Enabled
    if _G.Enabled then
        FullAutoBtn.Text = "フルオート: ON"
        FullAutoBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        myBaseCFrame = nil -- 再起動時に基地を再検索
    else
        FullAutoBtn.Text = "フルオート: OFF"
        FullAutoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
