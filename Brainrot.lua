local player = game.Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local FullAutoBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")

ScreenGui.Name = "Brainrot_Final_Fixed"
ScreenGui.Parent = pgui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999 

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

FullAutoBtn.Parent = MainFrame
FullAutoBtn.Size = UDim2.new(0.8, 0, 0.6, 0)
FullAutoBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
FullAutoBtn.Text = "AUTO: OFF"
FullAutoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
FullAutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

MinimizeBtn.Parent = ScreenGui
MinimizeBtn.Position = UDim2.new(0.5, -30, 0.35, 0)
MinimizeBtn.Size = UDim2.new(0, 60, 0, 25)
MinimizeBtn.Text = "表示/隠す"

local _G.Enabled = false
local myBaseCFrame = nil

local function getBase()
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if (v:IsA("StringValue") or v:IsA("ObjectValue")) and v.Value == player.Name then
            if v.Parent:IsA("Model") then return v.Parent:GetModelCFrame() end
        end
    end
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame
end

local function fireSell()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("sell") or n:find("claim") or n:find("deposit") or n:find("money") then
                v:FireServer()
            end
        end
    end
end

task.spawn(function()
    while true do
        if _G.Enabled then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if not myBaseCFrame then myBaseCFrame = getBase() end
                for _, item in pairs(game.Workspace:GetDescendants()) do
                    if not _G.Enabled then break end
                    if item:IsA("ClickDetector") and item.Parent and item.Parent:IsA("BasePart") then
                        root.CFrame = item.Parent.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                        fireclickdetector(item)
                        task.wait(0.05)
                        if myBaseCFrame then root.CFrame = myBaseCFrame end
                        task.wait(0.1)
                        fireSell()
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

FullAutoBtn.MouseButton1Click:Connect(function()
    _G.Enabled = not _G.Enabled
    FullAutoBtn.Text = _G.Enabled and "AUTO: ON" or "AUTO: OFF"
    FullAutoBtn.BackgroundColor3 = _G.Enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    if _G.Enabled then myBaseCFrame = getBase() end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
