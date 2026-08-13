local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada (biar tidak menumpuk)
if PlayerGui:FindFirstChild("BunHubMenu") then
    PlayerGui.BunHubMenu:Destroy()
end

local noClipEnabled = false
local noClipConnection = nil

-- Instant ProximityPrompt
local function makePromptInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

for _, descendant in ipairs(game:GetDescendants()) do
    makePromptInstant(descendant)
end
game.DescendantAdded:Connect(makePromptInstant)

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BunHubMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main Frame (Window Utama)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 260)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 55, 95)
MainStroke.Thickness = 1.2
MainStroke.Parent = MainFrame

-- Top Bar / Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐰 BUN HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Tombol Minimize (-) Lebih Estetik
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -34, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 12
MinimizeBtn.Text = "—"
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(45, 45, 60)
MiniStroke.Thickness = 1
MiniStroke.Parent = MinimizeBtn

-- Line Separator
local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, -28, 0, 1)
Line.Position = UDim2.new(0, 14, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

-- Container Tombol (Pake UIListLayout biar rapi)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -28, 1, -55)
Container.Position = UDim2.new(0, 14, 0, 48)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = Container

-- Tombol Buka (Floating Widget ketika di-minimize)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 20
OpenBtn.Text = "🐰"
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 16)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(110, 95, 230)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

-- Event Buka / Tutup
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Event Ragdoll Reference
local RagdollEvent = ReplicatedStorage:WaitForChild("Library", 5) and ReplicatedStorage.Library:WaitForChild("Modules", 5) and ReplicatedStorage.Library.Modules:WaitForChild("Ragdoll", 5) and ReplicatedStorage.Library.Modules.Ragdoll:WaitForChild("Ragdoll", 5)

-- Helper Function untuk Membuat Tombol Estetik + Hover Animation
local function createButton(text, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.Text = text
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.92
    stroke.Thickness = 1
    stroke.Parent = btn

    -- Efek Hover Animation
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- Membuat Tombol Menu
createButton("Ragdoll Back", Color3.fromRGB(180, 50, 65), 1, function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(-7073.3930664062, 854.7236328125, 836.61865234375)) end)
    end
end)

createButton("Ragdoll Front", Color3.fromRGB(200, 90, 45), 2, function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(6803.53125, 854.7236328125, -2108.2624511719)) end)
    end
end)

createButton("Unragdoll (Up)", Color3.fromRGB(40, 140, 90), 3, function()
    if RagdollEvent then
        pcall(function() firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5) end)
    end
end)

createButton("NoClip: OFF", Color3.fromRGB(35, 38, 50), 4, function(btn)
    noClipEnabled = not noClipEnabled
    
    if noClipEnabled then
        btn.Text = "NoClip: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
        
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
        btn.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
        
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
    end
end)
