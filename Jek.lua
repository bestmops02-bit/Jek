-- ============================================================
-- WOHYYHUB PREMIUM (Smooth & Fixed)
-- ============================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local State = {
    ESP = false, Boxes = false, Skeleton = false, Tracers = false, Info = false, AimBot = false,
}
local TargetName = ""
local CurrentTarget = nil

-- ============================================================
-- 1. ГЛАВНЫЙ ЭКРАН (Меню)
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WohyyhubPremium"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local shadowFrame = Instance.new("Frame")
shadowFrame.Size = UDim2.new(0, 420, 0, 280)
shadowFrame.Position = UDim2.new(0.5, -206, 0.5, -136)
shadowFrame.BackgroundColor3 = Color3.new(0, 0, 0)
shadowFrame.BackgroundTransparency = 0.5
shadowFrame.BorderSizePixel = 0
shadowFrame.Visible = false
shadowFrame.Parent = screenGui
Instance.new("UICorner", shadowFrame).CornerRadius = UDim.new(0, 14)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 280)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 2

local topGradient = Instance.new("Frame")
topGradient.Size = UDim2.new(1, 0, 0, 4)
topGradient.Position = UDim2.new(0, 0, 0, 0)
topGradient.BackgroundColor3 = Color3.new(1, 1, 1)
topGradient.BorderSizePixel = 0
topGradient.Parent = mainFrame
Instance.new("UICorner", topGradient).CornerRadius = UDim.new(0, 12)
local grad = Instance.new("UIGradient", topGradient)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 255))
})

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚔ Wohyyhub Premium"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 40)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(shadowFrame, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0)}):Play()
    task.wait(0.2)
    mainFrame.Visible = false
    shadowFrame.Visible = false
end)

-- ============================================================
-- 2. САЙДБАР И КОНТЕНТ
-- ============================================================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 50)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local function createTabButton(text, posY, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(50, 50, 70) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 32)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

local tabVisuals = createTabButton("👁 Visuals", 0, function() end)
local tabAim = createTabButton("🎯 Aim Bot", 45, function() end)

local content = Instance.new("Frame")
content.Size = UDim2.new(0, 270, 1, -60)
content.Position = UDim2.new(0, 140, 0, 50)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local function createToggle(parent, text, stateKey, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    btn.Text = "   " .. text
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local swBg = Instance.new("Frame")
    swBg.Size = UDim2.new(0, 40, 0, 20)
    swBg.Position = UDim2.new(1, -50, 0.5, -10)
    swBg.BackgroundColor3 = State[stateKey] and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(45, 45, 55)
    swBg.Parent = btn
    Instance.new("UICorner", swBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = State[stateKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Parent = swBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        State[stateKey] = not State[stateKey]
        TweenService:Create(swBg, TweenInfo.new(0.15), {BackgroundColor3 = State[stateKey] and Color3.fromRGB(180, 0, 255) or Color3.fromRGB(45, 45, 55)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = State[stateKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
    end)
end

local visualsGroup = Instance.new("Frame")
visualsGroup.Size = UDim2.new(1, 0, 1, 0)
visualsGroup.BackgroundTransparency = 1
visualsGroup.Parent = content

createToggle(visualsGroup, "ESP (Main)", "ESP", 0)
createToggle(visualsGroup, "3D Boxes", "Boxes", 48)
createToggle(visualsGroup, "Skeleton", "Skeleton", 96)
createToggle(visualsGroup, "Tracers", "Tracers", 144)
createToggle(visualsGroup, "Info (HP)", "Info", 192)

local aimGroup = Instance.new("Frame")
aimGroup.Size = UDim2.new(1, 0, 1, 0)
aimGroup.BackgroundTransparency = 1
aimGroup.Parent = content
aimGroup.Visible = false

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(1, -10, 0, 38)
targetBox.Position = UDim2.new(0, 0, 0, 0)
targetBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
targetBox.Text = ""
targetBox.PlaceholderText = "Введите ник цели..."
targetBox.TextColor3 = Color3.new(1, 1, 1)
targetBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
targetBox.Font = Enum.Font.Gotham
targetBox.TextSize = 13
targetBox.Parent = aimGroup
Instance.new("UICorner", targetBox).CornerRadius = UDim.new(0, 8)
local boxStroke = Instance.new("UIStroke", targetBox)
boxStroke.Color = Color3.fromRGB(80, 0, 120)
boxStroke.Thickness = 1

targetBox.FocusLost:Connect(function()
    TargetName = targetBox.Text
end)

local aimActionBtn = Instance.new("TextButton")
aimActionBtn.Size = UDim2.new(1, -10, 0, 42)
aimActionBtn.Position = UDim2.new(0, 0, 0, 55)
aimActionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
aimActionBtn.Text = "  🎯 Aim Bot"
aimActionBtn.TextColor3 = Color3.new(1, 1, 1)
aimActionBtn.Font = Enum.Font.GothamBold
aimActionBtn.TextSize = 14
aimActionBtn.Parent = aimGroup
Instance.new("UICorner", aimActionBtn).CornerRadius = UDim.new(0, 8)

-- ============================================================
-- 3. КОСМИЧЕСКАЯ КНОПКА (С плавным перетаскиванием)
-- ============================================================
local spaceBtn = Instance.new("TextButton")
spaceBtn.Name = "SpaceAimBtn"
spaceBtn.Size = UDim2.new(0, 60, 0, 60)
spaceBtn.Position = UDim2.new(1, -80, 0.8, 0) 
spaceBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
spaceBtn.Text = "🌙"
spaceBtn.TextColor3 = Color3.new(1, 1, 1)
spaceBtn.TextSize = 28
spaceBtn.Font = Enum.Font.GothamBold
spaceBtn.AutoButtonColor = false
spaceBtn.Visible = false
spaceBtn.ZIndex = 100
spaceBtn.Parent = screenGui

Instance.new("UICorner", spaceBtn).CornerRadius = UDim.new(0, 14)
local spaceGrad = Instance.new("UIGradient", spaceBtn)
spaceGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 50, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 30))
})
local spaceStroke = Instance.new("UIStroke", spaceBtn)
spaceStroke.Color = Color3.fromRGB(150, 100, 255)
spaceStroke.Thickness = 2

local lockIcon = Instance.new("TextLabel")
lockIcon.Size = UDim2.new(0, 16, 0, 16)
lockIcon.Position = UDim2.new(1, -18, 0, 2)
lockIcon.BackgroundTransparency = 1
lockIcon.Text = ""
lockIcon.TextColor3 = Color3.fromRGB(255, 200, 80)
lockIcon.TextSize = 14
lockIcon.ZIndex = 101
lockIcon.Parent = spaceBtn

-- Логика кнопки в меню
local isAimActive = false
aimActionBtn.MouseButton1Click:Connect(function()
    isAimActive = not isAimActive
    State.AimBot = isAimActive
    
    if isAimActive then
        spaceBtn.Visible = true
        spaceBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(spaceBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        aimActionBtn.Text = "  🎯 Aim Bot (ВКЛ)"
        aimActionBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    else
        TweenService:Create(spaceBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        spaceBtn.Visible = false
        aimActionBtn.Text = "  🎯 Aim Bot"
        aimActionBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
end)

-- Плавное перетаскивание
local isLocked = false
local isDragging = false
local dragInput = nil
local dragStartPos = nil
local btnStartPos = nil
local moved = false
local lastTap = 0

spaceBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        moved = false
        dragStartPos = input.Position
        btnStartPos = spaceBtn.AbsolutePosition
        
        if tick() - lastTap < 0.3 then
            isLocked = not isLocked
            lockIcon.Text = isLocked and "🔒" or ""
            spaceStroke.Color = isLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(150, 100, 255)
        end
        lastTap = tick()

        dragInput = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                if dragInput then dragInput:Disconnect() end
                
                if not moved then
                    State.AimBot = not State.AimBot
                    if State.AimBot then
                        spaceBtn.Text = "🚀"
                        spaceStroke.Color = Color3.fromRGB(0, 255, 100)
                    else
                        spaceBtn.Text = "🌙"
                        spaceStroke.Color = Color3.fromRGB(150, 100, 255)
                    end
                end
            end
        end)
    end
end)

spaceBtn.InputChanged:Connect(function(input)
    if not isDragging or isLocked then return
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        if delta.Magnitude > 3 then moved = true end
        
        spaceBtn.Position = UDim2.new(0, btnStartPos.X + delta.X, 0, btnStartPos.Y + delta.Y)
    end
end)

-- ============================================================
-- 4. ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК И FAB
-- ============================================================
local function setTabActive(activeBtn, inactiveBtn)
    activeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    activeBtn.TextColor3 = Color3.new(1, 1, 1)
    inactiveBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    inactiveBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
end

tabVisuals.MouseButton1Click:Connect(function()
    visualsGroup.Visible = true
    aimGroup.Visible = false
    setTabActive(tabVisuals, tabAim)
end)

tabAim.MouseButton1Click:Connect(function()
    visualsGroup.Visible = false
    aimGroup.Visible = true
    setTabActive(tabAim, tabVisuals)
end)

setTabActive(tabVisuals, tabAim)

local fab = Instance.new("TextButton")
fab.Size = UDim2.new(0, 55, 0, 55)
fab.Position = UDim2.new(0, 20, 0, 100)
fab.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
fab.Text = "⚔"
fab.TextColor3 = Color3.fromRGB(180, 0, 255)
fab.TextSize = 24
fab.Font = Enum.Font.GothamBold
fab.Parent = screenGui
Instance.new("UICorner", fab).CornerRadius = UDim.new(1, 0)
local fabStroke = Instance.new("UIStroke", fab)
fabStroke.Color = Color3.fromRGB(180, 0, 255)
fabStroke.Thickness = 2

fab.MouseButton1Click:Connect(function()
    local isOpening = not mainFrame.Visible
    if isOpening then
        mainFrame.Visible = true
        shadowFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        shadowFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 280)}):Play()
        TweenService:Create(shadowFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 280)}):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(shadowFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.2)
        mainFrame.Visible = false
        shadowFrame.Visible = false
    end
end)

-- ============================================================
-- 5. ESP И AIMBOT ЛОГИКА
-- ============================================================
local Bones = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
}
local BoxEdges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}

local function CreateLine()
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color = Color3.new(1,1,1)
    l.Visible = false
    return l
end

local function CreateText(size, center)
    local t = Drawing.new("Text")
    t.Size = size
    t.Center = center
    t.Outline = true
    t.OutlineColor = Color3.new(0,0,0)
    t.Color = Color3.new(1,1,1)
    t.Visible = false
    return t
end

local ESP_Cache = {}
local function SetupPlayer(plr)
    if plr == player then return end
    local data = { Skel = {}, Box = {}, Tracer = CreateLine(), Name = CreateText(14, true), Dist = CreateText(12, true) }
    for i = 1, #Bones do data.Skel[i] = CreateLine() end
    for i = 1, 12 do data.Box[i] = CreateLine() end
    ESP_Cache[plr] = data
end

for _, plr in ipairs(Players:GetPlayers()) do SetupPlayer(plr) end
Players.PlayerAdded:Connect(SetupPlayer)
Players.PlayerRemoving:Connect(function(plr)
    if ESP_Cache[plr] then
        for _, l in pairs(ESP_Cache[plr].Skel) do l:Remove() end
        for _, l in pairs(ESP_Cache[plr].Box) do l:Remove() end
        ESP_Cache[plr].Tracer:Remove()
        ESP_Cache[plr].Name:Remove()
        ESP_Cache[plr].Dist:Remove()
        ESP_Cache[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if mainFrame.Visible then
        local pulse = (math.sin(tick() * 3) + 1) / 2
        stroke.Color = Color3.fromRGB(180, 0, 255):Lerp(Color3.fromRGB(0, 150, 255), pulse)
    end

    if spaceBtn.Visible then
        local pulse = (math.sin(tick() * 5) + 1) / 2
        spaceStroke.Transparency = pulse * 0.5
    end

    local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end

    if State.AimBot then
        local targetHrp = nil
        if TargetName ~= "" then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Name:lower():find(TargetName:lower()) and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp then
                        targetHrp = hrp
                        CurrentTarget = plr
                        break
                    end
                end
            end
        else
            local bestDist = 500
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp then
                        local dist = (hrp.Position - myHrp.Position).Magnitude
                        if dist < bestDist then bestDist = dist; targetHrp = hrp; CurrentTarget = plr end
                    end
                end
            end
        end
        if targetHrp then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHrp.Position)
        end
    else
        CurrentTarget = nil
    end

    if not State.ESP then
        for _, data in pairs(ESP_Cache) do
            for _, l in pairs(data.Skel) do l.Visible = false end
            for _, l in pairs(data.Box) do l.Visible = false end
            data.Tracer.Visible = false
            data.Name.Visible = false
            data.Dist.Visible = false
        end
        return
    end

    for plr, data in pairs(ESP_Cache) do
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if char and hum and hum.Health > 0 and hrp and head then
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local isTarget = (plr == CurrentTarget)
            local color = isTarget and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)

            if State.Boxes and onScreen then
                local cf = hrp.CFrame
                local size = Vector3.new(3.5, 6, 3.5)
                local offsets = {
                    Vector3.new(-size.X/2, -size.Y/2, -size.Z/2), Vector3.new(size.X/2, -size.Y/2, -size.Z/2),
                    Vector3.new(size.X/2, -size.Y/2, size.Z/2), Vector3.new(-size.X/2, -size.Y/2, size.Z/2),
                    Vector3.new(-size.X/2, size.Y/2, -size.Z/2), Vector3.new(size.X/2, size.Y/2, -size.Z/2),
                    Vector3.new(size.X/2, size.Y/2, size.Z/2), Vector3.new(-size.X/2, size.Y/2, size.Z/2),
                }
                local sPoints = {}
                local allOn = true
                for i, offset in ipairs(offsets) do
                    local sp, onScr = Camera:WorldToViewportPoint((cf * CFrame.new(offset)).Position)
                    sPoints[i] = Vector2.new(sp.X, sp.Y)
                    if not onScr then allOn = false end
                end
                if allOn then
                    for i, edge in ipairs(BoxEdges) do
                        data.Box[i].From = sPoints[edge[1]]
                        data.Box[i].To = sPoints[edge[2]]
                        data.Box[i].Color = color
                        data.Box[i].Visible = true
                    end
                else
                    for _, l in pairs(data.Box) do l.Visible = false end
                end
            else
                for _, l in pairs(data.Box) do l.Visible = false end
            end

            if State.Skeleton and onScreen then
                for i, bone in ipairs(Bones) do
                    local p1 = char:FindFirstChild(bone[1])
                    local p2 = char:FindFirstChild(bone[2])
                    if p1 and p2 then
                        local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                        local s2, on2 = Camera:WorldToViewportPoint(p2.Position)
                        if on1 or on2 then
                            data.Skel[i].From = Vector2.new(s1.X, s1.Y)
                            data.Skel[i].To = Vector2.new(s2.X, s2.Y)
                            data.Skel[i].Color = color
                            data.Skel[i].Visible = true
                        else
                            data.Skel[i].Visible = false
                        end
                    end
                end
            else
                for _, l in pairs(data.Skel) do l.Visible = false end
            end

            if onScreen then
                if State.Tracers then
                    data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.Tracer.To = Vector2.new(headPos.X, headPos.Y)
                    data.Tracer.Color = color
                    data.Tracer.Visible = true
                else
                    data.Tracer.Visible = false
                end

                if State.Info then
                    local dist = math.floor((hrp.Position - myHrp.Position).Magnitude)
                    data.Name.Text = plr.Name
                    data.Name.Color = color
                    data.Name.Position = Vector2.new(headPos.X, headPos.Y - 40)
                    data.Name.Visible = true
                    
                    data.Dist.Text = string.format("HP: %d | %dm", math.floor(hum.Health), dist)
                    data.Dist.Color = color
                    data.Dist.Position = Vector2.new(headPos.X, headPos.Y - 25)
                    data.Dist.Visible = true
                else
                    data.Name.Visible = false
                    data.Dist.Visible = false
                end
            else
                data.Tracer.Visible = false
                data.Name.Visible = false
                data.Dist.Visible = false
            end
        else
            for _, l in pairs(data.Skel) do l.Visible = false end
            for _, l in pairs(data.Box) do l.Visible = false end
            data.Tracer.Visible = false
            data.Name.Visible = false
            data.Dist.Visible = false
        end
    end
end)
