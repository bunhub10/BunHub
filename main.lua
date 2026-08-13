local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("BunHubMenu") then
    PlayerGui.BunHubMenu:Destroy()
end

local noClipEnabled = false
local noClipConnection = nil
local infJumpEnabled = false
local fullbrightEnabled = false
local defaultLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function makePromptInstant(prompt)
    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end
for _, descendant in ipairs(game:GetDescendants()) do makePromptInstant(descendant) end
game.DescendantAdded:Connect(makePromptInstant)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BunHubMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Fullscreen RGB Splash Screen
local SplashOverlay = Instance.new("Frame")
SplashOverlay.Size = UDim2.new(1, 0, 1, 0)
SplashOverlay.Position = UDim2.new(0, 0, 0, 0)
SplashOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
SplashOverlay.BackgroundTransparency = 0.15
SplashOverlay.BorderSizePixel = 0
SplashOverlay.ZIndex = 999
SplashOverlay.Parent = ScreenGui

local SplashText = Instance.new("TextLabel")
SplashText.Size = UDim2.new(1, 0, 1, 0)
SplashText.Position = UDim2.new(0, 0, 0, 0)
SplashText.BackgroundTransparency = 1
SplashText.TextColor3 = Color3.fromRGB(255, 0, 0)
SplashText.Font = Enum.Font.GothamBold
SplashText.TextSize = 36
SplashText.Text = "NGESKRIP MULU 🐷"
SplashText.ZIndex = 1000
SplashText.Parent = SplashOverlay

local rgbConnection
local hue = 0
rgbConnection = RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.5) % 1
    SplashText.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
end)

task.spawn(function()
    task.wait(2)
    if rgbConnection then rgbConnection:Disconnect() end
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(SplashOverlay, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(SplashText, tweenInfo, {TextTransparency = 1}):Play()
    task.wait(0.5)
    SplashOverlay:Destroy()
end)

-- Main UI Window
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
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

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🐰 BUN HUB v2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -36, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Text = "—"
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(50, 50, 70)
MiniStroke.Thickness = 1
MiniStroke.Parent = MinimizeBtn

local Line = Instance.new("Frame")
Line.Size = UDim2.new(1, -28, 0, 1)
Line.Position = UDim2.new(0, 14, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Line.BorderSizePixel = 0
Line.Parent = MainFrame

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -16, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 8, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(90, 80, 220)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 7)
ListLayout.Parent = ScrollingFrame

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 48, 0, 48)
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

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

local RagdollEvent = ReplicatedStorage:WaitForChild("Library", 3) and ReplicatedStorage.Library:WaitForChild("Modules", 3) and ReplicatedStorage.Library.Modules:WaitForChild("Ragdoll", 3) and ReplicatedStorage.Library.Modules.Ragdoll:WaitForChild("Ragdoll", 3)

local function createButton(text, color, order, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.Position = UDim2.new(0, 4, 0, 0)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(245, 245, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.Text = text
    btn.LayoutOrder = order
    btn.AutoButtonColor = false
    btn.Parent = ScrollingFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.92
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play() end)

    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- Function Generator Slider Speed
local function createSlider(minVal, maxVal, defaultVal, order, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -8, 0, 45)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    sliderFrame.LayoutOrder = order
    sliderFrame.Parent = ScrollingFrame
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -16, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 2)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(220, 220, 245)
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.Text = "WalkSpeed: " .. tostring(defaultVal)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = sliderFrame

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -16, 0, 6)
    track.Position = UDim2.new(0, 8, 0, 28)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    track.BorderSizePixel = 0
    track.Parent = sliderFrame
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(110, 95, 230)
    fill.BorderSizePixel = 0
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        title.Text = "WalkSpeed: " .. tostring(value)
        callback(value)
    end

    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- ================= DAFTAR FITUR ================= --

-- 1. Ragdoll Actions (DI PALING ATAS)
createButton("Ragdoll Back", Color3.fromRGB(180, 50, 65), 1, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(-7073.393, 854.723, 836.618)) end) end
end)

createButton("Ragdoll Front", Color3.fromRGB(200, 90, 45), 2, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(6803.531, 854.723, -2108.262)) end) end
end)

createButton("Unragdoll (Up)", Color3.fromRGB(40, 140, 90), 3, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5) end) end
end)

-- 2. WalkSpeed Slider
createSlider(16, 200, 16, 4, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

-- 3. Movement & Utility Hacks
createButton("Inf Jump: OFF", Color3.fromRGB(35, 38, 50), 5, function(btn)
    infJumpEnabled = not infJumpEnabled
    btn.Text = infJumpEnabled and "Inf Jump: ON" or "Inf Jump: OFF"
    btn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(60, 110, 220) or Color3.fromRGB(35, 38, 50)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

createButton("NoClip: OFF", Color3.fromRGB(35, 38, 50), 6, function(btn)
    noClipEnabled = not noClipEnabled
    if noClipEnabled then
        btn.Text = "NoClip: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
        noClipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        btn.Text = "NoClip: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
        if noClipConnection then noClipConnection:Disconnect() noClipConnection = nil end
    end
end)

createButton("Fullbright: OFF", Color3.fromRGB(35, 38, 50), 7, function(btn)
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        btn.Text = "Fullbright: ON"
        btn.BackgroundColor3 = Color3.fromRGB(60, 110, 220)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        btn.Text = "Fullbright: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
        Lighting.Brightness = defaultLighting.Brightness
        Lighting.ClockTime = defaultLighting.ClockTime
        Lighting.FogEnd = defaultLighting.FogEnd
        Lighting.GlobalShadows = defaultLighting.GlobalShadows
    end
end)

createButton("Get Click TP Tool", Color3.fromRGB(40, 120, 180), 8, function()
    local tool = Instance.new("Tool")
    tool.Name = "Click TP"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

createButton("Rejoin Server", Color3.fromRGB(180, 80, 40), 9, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)
