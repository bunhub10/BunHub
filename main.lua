local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local noClipEnabled = false
local noClipConnection = nil

local function makePromptInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

for _, descendant in ipairs(game:GetDescendants()) do
    makePromptInstant(descendant)
end

game.DescendantAdded:Connect(makePromptInstant)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BunHubMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 410)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 35)
TitleLabel.Position = UDim2.new(0, 12, 0, 2)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "BUN HUB"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 45, 0, 45)
OpenBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
OpenBtn.TextColor3 = Color3.fromRGB(240, 240, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 11
OpenBtn.Text = "BUN"
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 22)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(90, 80, 220)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
MinimizeBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Text = "-"
MinimizeBtn.Parent = MainFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local RagdollEvent = ReplicatedStorage:WaitForChild("Library", 5) and ReplicatedStorage.Library:WaitForChild("Modules", 5) and ReplicatedStorage.Library.Modules:WaitForChild("Ragdoll", 5) and ReplicatedStorage.Library.Modules.Ragdoll:WaitForChild("Ragdoll", 5)

local function createButton(text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 176, 0, 32)
    btn.Position = UDim2.new(0, 12, 0, posY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.Text = text
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

createButton("Ragdoll Back", 40, Color3.fromRGB(190, 45, 60), function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(-7073.3930664062, 854.7236328125, 836.61865234375)) end)
    end
end)

createButton("Ragdoll Front", 80, Color3.fromRGB(210, 95, 35), function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(6803.53125, 854.7236328125, -2108.2624511719)) end)
    end
end)

createButton("Unragdoll (Up)", 120, Color3.fromRGB(40, 150, 90), function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5) end)
    end
end)

createButton("NoClip: OFF", 160, Color3.fromRGB(40, 40, 52), function(btn)
    noClipEnabled = not noClipEnabled
    
    if noClipEnabled then
        btn.Text = "NoClip: ON"
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 230)
        
        noClipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        btn.Text = "NoClip: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
        
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
    end
end)
