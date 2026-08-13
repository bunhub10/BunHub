local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("BunHubMenu") then
    PlayerGui.BunHubMenu:Destroy()
end

local noClipEnabled = false
local noClipConnection = nil
local infJumpEnabled = false
local fullbrightEnabled = false
local espEnabled = false
local savedCFrame = nil

-- Lock Speed Variables
local lockedSpeed = 16
local speedLockEnabled = false
local speedConnection = nil

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

-- Function Input Box Speed dengan Fitur LOCKED LOOP
local function createInputSpeed(order)
    local boxFrame = Instance.new("Frame")
    boxFrame.Size = UDim2.new(1, -8, 0, 36)
    boxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    boxFrame.LayoutOrder = order
    boxFrame.Parent = ScrollingFrame
    Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(110, 95, 230)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = boxFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 100, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(220, 220, 245)
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.Text = "Lock Speed:"
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = boxFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 80, 0, 24)
    textBox.Position = UDim2.new(1, -90, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 12
    textBox.Text = "16"
    textBox.PlaceholderText = "16 - 1000"
    textBox.ClearTextOnFocus = false
    textBox.Parent = boxFrame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

    local function applySpeedLock()
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = RunService.Stepped:Connect(function()
            if speedLockEnabled and LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.WalkSpeed ~= lockedSpeed then
                    hum.WalkSpeed = lockedSpeed
                end
            end
        end)
    end

    textBox.FocusLost:Connect(function()
        local num = tonumber(textBox.Text)
        if num and num > 16 then
            lockedSpeed = math.clamp(num, 0, 1000)
            speedLockEnabled = true
            applySpeedLock()
        else
            lockedSpeed = 16
            speedLockEnabled = false
            if speedConnection then speedConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
            end
            textBox.Text = "16"
        end
    end)
end

-- Function Low Server Hop (FIXED METHOD)
local function lowServerHop(btn)
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

    if not req then
        btn.Text = "Exec Not Supported ❌"
        task.wait(2)
        btn.Text = "Low Server Hop 📉"
        return
    end

    btn.Text = "Searching Low Server..."

    task.spawn(function()
        local targetServer = nil
        local cursor = ""
        local attempts = 0

        while attempts < 10 do
            attempts = attempts + 1
            local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            
            local success, response = pcall(function()
                return req({Url = url, Method = "GET"})
            end)

            if success and response and response.Body then
                local body = HttpService:JSONDecode(response.Body)
                if body and body.data then
                    for _, server in ipairs(body.data) do
                        if server.id ~= JobId and server.playing < server.maxPlayers and server.playing > 0 then
                            targetServer = server.id
                            break
                        end
                    end
                    if targetServer then break end
                    if body.nextPageCursor then
                        cursor = body.nextPageCursor
                    else
                        break
                    end
                end
            end
            task.wait(0.2)
        end

        if targetServer then
            btn.Text = "Teleporting... 🚀"
            TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, LocalPlayer)
        else
            btn.Text = "Server Not Found! ❌"
            task.wait(2)
            btn.Text = "Low Server Hop 📉"
        end
    end)
end

-- Sistem ESP (Highlight Head + Billboard Name)
local function applyESP(plr)
    if plr == LocalPlayer then return end

    local function setupChar(char)
        if not espEnabled then return end
        
        local head = char:WaitForChild("Head", 10)
        if not head then return end

        if char:FindFirstChild("BunHubHighlight") then char.BunHubHighlight:Destroy() end
        if head:FindFirstChild("BunHubNameESP") then head.BunHubNameESP:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.Name = "BunHubHighlight"
        highlight.Adornee = head
        highlight.FillColor = Color3.fromRGB(255, 0, 50)
        highlight.FillTransparency = 0.3
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char

        local bgui = Instance.new("BillboardGui")
        bgui.Name = "BunHubNameESP"
        bgui.Adornee = head
        bgui.Size = UDim2.new(0, 150, 0, 30)
        bgui.StudsOffset = Vector3.new(0, 2.2, 0)
        bgui.AlwaysOnTop = true
        bgui.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = plr.DisplayName .. "\n(@" .. plr.Name .. ")"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = bgui
    end

    if plr.Character then setupChar(plr.Character) end
    plr.CharacterAdded:Connect(setupChar)
end

local function toggleESP(state)
    espEnabled = state
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if state then
                applyESP(plr)
            else
                if plr.Character then
                    if plr.Character:FindFirstChild("BunHubHighlight") then plr.Character.BunHubHighlight:Destroy() end
                    if plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("BunHubNameESP") then
                        plr.Character.Head.BunHubNameESP:Destroy()
                    end
                end
            end
        end
    end
end

-- ================= DAFTAR FITUR ================= --

-- 1. Ragdoll Actions
createButton("Ragdoll Back", Color3.fromRGB(180, 50, 65), 1, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(-7073.393, 854.723, 836.618)) end) end
end)

createButton("Ragdoll Front", Color3.fromRGB(200, 90, 45), 2, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Make", 2.5, Vector3.new(6803.531, 854.723, -2108.262)) end) end
end)

createButton("Unragdoll (Up)", Color3.fromRGB(40, 140, 90), 3, function()
    if RagdollEvent then pcall(function() firesignal(RagdollEvent.OnClientEvent, "Destroy", 2.5) end) end
end)

-- 2. WalkSpeed Input Box (Locked)
createInputSpeed(4)

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

createButton("ESP Head & Name: OFF", Color3.fromRGB(35, 38, 50), 8, function(btn)
    espEnabled = not espEnabled
    btn.Text = espEnabled and "ESP Head & Name: ON" or "ESP Head & Name: OFF"
    btn.BackgroundColor3 = espEnabled and Color3.fromRGB(60, 110, 220) or Color3.fromRGB(35, 38, 50)
    toggleESP(espEnabled)
end)

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then applyESP(plr) end
end)

createButton("Get Click TP Tool", Color3.fromRGB(40, 120, 180), 9, function()
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

createButton("Low Server Hop 📉", Color3.fromRGB(110, 60, 180), 10, function(btn)
    lowServerHop(btn)
end)

createButton("Rejoin Server 🔄", Color3.fromRGB(180, 80, 40), 11, function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 4. Save Position & TP (DI PALING BAWAH)
createButton("Save Position 📌", Color3.fromRGB(50, 130, 90), 12, function(btn)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        btn.Text = "Position Saved! ✅"
        task.wait(1.5)
        btn.Text = "Save Position 📌"
    end
end)

createButton("TP to Saved Position 🚀", Color3.fromRGB(160, 60, 110), 13, function(btn)
    if savedCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame
    else
        btn.Text = "No Position Saved!"
        task.wait(1.5)
        btn.Text = "TP to Saved Position 🚀"
    end
end)
