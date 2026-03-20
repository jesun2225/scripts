local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LOGO_ASSET = "rbxassetid://116916851197983"
local LOGO_THUMB = "rbxthumb://type=Asset&id=116916851197983&w=420&h=420"

-- Loading Screen
local loadingGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
loadingGui.Name = "LoadingGui"
loadingGui.Enabled = false

local loadFrame = Instance.new("Frame", loadingGui)
loadFrame.Size = UDim2.new(0,390,0,140)
loadFrame.Position = UDim2.new(0.5,-195,0.5,-70)
loadFrame.BackgroundColor3 = Color3.fromRGB(12,18,30)
loadFrame.BorderSizePixel = 0
Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0,20)

local loadStroke = Instance.new("UIStroke", loadFrame)
loadStroke.Thickness = 2
loadStroke.Transparency = 0.2
loadStroke.Color = Color3.fromRGB(72, 205, 255)

local loadGradient = Instance.new("UIGradient", loadFrame)
loadGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 30, 48)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 16, 28))
})
loadGradient.Rotation = 32

local loadingBg = Instance.new("ImageLabel", loadFrame)
loadingBg.Size = UDim2.new(1,0,1,0)
loadingBg.Image = ""
loadingBg.BackgroundTransparency = 1
loadingBg.ScaleType = Enum.ScaleType.Stretch
Instance.new("UICorner", loadingBg).CornerRadius = UDim.new(0,16)

local loadLabel = Instance.new("TextLabel", loadFrame)
loadLabel.Size = UDim2.new(1,0,0,30)
loadLabel.Position = UDim2.new(0,0,0,10)
loadLabel.Text = "ChillZone"
loadLabel.TextColor3 = Color3.fromRGB(166, 230, 255)
loadLabel.Font = Enum.Font.GothamBold
loadLabel.TextSize = 22
loadLabel.BackgroundTransparency = 1

local loadSub = Instance.new("TextLabel", loadFrame)
loadSub.Size = UDim2.new(1,0,0,16)
loadSub.Position = UDim2.new(0,0,0,34)
loadSub.Text = ""
loadSub.TextColor3 = Color3.fromRGB(112, 197, 235)
loadSub.Font = Enum.Font.GothamMedium
loadSub.TextSize = 11
loadSub.BackgroundTransparency = 1

local loadBarBg = Instance.new("Frame", loadFrame)
loadBarBg.Size = UDim2.new(0.8,0,0,25)
loadBarBg.Position = UDim2.new(0.1,0,0,76)
loadBarBg.BackgroundColor3 = Color3.fromRGB(28, 46, 70)
Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(0,10)

local loadBar = Instance.new("Frame", loadBarBg)
loadBar.Size = UDim2.new(0,0,1,0)
loadBar.BackgroundColor3 = Color3.fromRGB(84, 228, 255)
Instance.new("UICorner", loadBar).CornerRadius = UDim.new(0,10)

local loadBarGradient = Instance.new("UIGradient", loadBar)
loadBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 245, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(47, 189, 255))
})
loadBarGradient.Rotation = 0

local loadShine = Instance.new("Frame", loadBar)
loadShine.Size = UDim2.new(0, 36, 1, 0)
loadShine.Position = UDim2.new(0, -42, 0, 0)
loadShine.BackgroundColor3 = Color3.fromRGB(220, 255, 255)
loadShine.BackgroundTransparency = 0.45
loadShine.BorderSizePixel = 0
Instance.new("UICorner", loadShine).CornerRadius = UDim.new(0, 10)

-- Main UI + Decorated Title (no black background)
local mainGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
mainGui.Name = "MainGui"
mainGui.Enabled = false

local mainUI = Instance.new("Frame", mainGui)
mainUI.Size = UDim2.new(0,320,0,470)
mainUI.Position = UDim2.new(1,20,0.15,0)
mainUI.BackgroundColor3 = Color3.fromRGB(14, 24, 40)
mainUI.BackgroundTransparency = 0.08
mainUI.Active = true
mainUI.Draggable = true
Instance.new("UICorner", mainUI).CornerRadius = UDim.new(0,20)

local panelStroke = Instance.new("UIStroke", mainUI)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.1
panelStroke.Color = Color3.fromRGB(62, 196, 255)

local panelGradient = Instance.new("UIGradient", mainUI)
panelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 35, 58)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 28, 46)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 19, 32))
})
panelGradient.Rotation = 45

local mainBg = Instance.new("ImageLabel", mainUI)
mainBg.Size = UDim2.new(1,0,1,0)
mainBg.Image = ""
mainBg.BackgroundTransparency = 1
mainBg.ScaleType = Enum.ScaleType.Stretch
Instance.new("UICorner", mainBg).CornerRadius = UDim.new(0,18)

-- Decorated Title (no black line/background)
local title = Instance.new("TextLabel", mainUI)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ChillZone"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(168, 235, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 30
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.ZIndex = 10

-- Neon glow
title.TextStrokeTransparency = 0.25
title.TextStrokeColor3 = Color3.fromRGB(12, 60, 110)

-- Subtle shadow
local shadow = Instance.new("TextLabel", mainUI)
shadow.Size = title.Size
shadow.Position = UDim2.new(0, 2, 0, 2)
shadow.Text = title.Text
shadow.BackgroundTransparency = 1
shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
shadow.TextTransparency = 0.45
shadow.Font = title.Font
shadow.TextSize = title.TextSize
shadow.TextStrokeTransparency = 1
shadow.ZIndex = 9

local subtitle = Instance.new("TextLabel", mainUI)
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.Text = ""
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(103, 189, 230)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 11
subtitle.ZIndex = 10

-- Icon
local iconGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
iconGui.Name = "IconGui"
iconGui.Enabled = false

local icon = Instance.new("ImageButton", iconGui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(1,-60,0.5,-25)
icon.Image = LOGO_ASSET
icon.ScaleType = Enum.ScaleType.Fit
icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
icon.ImageTransparency = 0
icon.BackgroundColor3 = Color3.fromRGB(18,34,55)
icon.BackgroundTransparency = 0.12
icon.Active = true
icon.Draggable = true
Instance.new("UICorner", icon).CornerRadius = UDim.new(0,12)
icon.ZIndex = 100

local iconGradient = Instance.new("UIGradient", icon)
iconGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 83, 124)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 46, 73))
})
iconGradient.Rotation = 55
iconGradient.Enabled = false

local iconStroke = Instance.new("UIStroke", icon)
iconStroke.Thickness = 2
iconStroke.Color = Color3.fromRGB(79, 215, 255)
iconStroke.Transparency = 0.15

local iconText = Instance.new("TextLabel", icon)
iconText.Size = UDim2.new(1, 0, 1, 0)
iconText.BackgroundTransparency = 1
iconText.Text = "CZ"
iconText.Font = Enum.Font.GothamBlack
iconText.TextSize = 18
iconText.TextColor3 = Color3.fromRGB(226, 247, 255)
iconText.TextStrokeTransparency = 0.4
iconText.TextStrokeColor3 = Color3.fromRGB(15, 47, 76)
iconText.ZIndex = 101
iconText.Visible = false

task.delay(2, function()
    if icon and icon.Parent and not icon.IsLoaded then
        icon.Image = LOGO_THUMB
    end
end)

-- Tabs
local tabBar = Instance.new("Frame", mainUI)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,62)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 99

local tabs = {}
local tabScrolls = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0,96,1,0)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(180, 225, 245)
    btn.BackgroundColor3 = Color3.fromRGB(32, 49, 70)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    btn.ZIndex = 100

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.4
    btnStroke.Color = Color3.fromRGB(102, 194, 240)

    local btnScale = Instance.new("UIScale", btn)
    btnScale.Scale = 1

    btn.MouseEnter:Connect(function()
        TweenService:Create(btnScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.03}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btnScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)

    table.insert(tabs, btn)
    
    local scroll = Instance.new("ScrollingFrame", mainUI)
    scroll.Size = UDim2.new(1,-10,1,-108)
    scroll.Position = UDim2.new(0,5,0,96)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.ScrollBarImageColor3 = Color3.fromRGB(89, 215, 255)
    scroll.BorderSizePixel = 0
    scroll.Visible = false
    scroll.ZIndex = 50
    table.insert(tabScrolls, scroll)
    
    btn.MouseButton1Click:Connect(function()
        for i,t in pairs(tabScrolls) do
            t.Visible = (t == scroll)
            tabs[i].BackgroundColor3 = (t == scroll) and Color3.fromRGB(56, 164, 216) or Color3.fromRGB(32, 49, 70)
        end
        currentTab = scroll
    end)
    
    task.delay(0.1, function()
        local totalWidth = #tabs * 90 - 5
        local startX = (tabBar.AbsoluteSize.X - totalWidth) / 2
        for i,tb in ipairs(tabs) do
            tb.Position = UDim2.new(0, startX + (i-1)*90, 0, 6)
        end
    end)
    
    return scroll
end

local mainTab = createTab("🎯Combat")
local combatTab = createTab("🌐Server")
local serverTab = createTab("🧑‍💻Other")

RunService.RenderStepped:Connect(function()
    for _,s in pairs(tabScrolls) do
        local totalY = 0
        for _,c in pairs(s:GetChildren()) do
            if c:IsA("GuiObject") then
                totalY = totalY + c.Size.Y.Offset + 10
            end
        end
        s.CanvasSize = UDim2.new(0,0,0,totalY + 20)
    end
end)

if #tabScrolls > 0 then
    tabScrolls[1].Visible = true
    tabs[1].BackgroundColor3 = Color3.fromRGB(56, 164, 216)
    currentTab = tabScrolls[1]
end

-- Icon Toggle
icon.MouseButton1Click:Connect(function()
    if mainUI.Visible then
        local tween = TweenService:Create(mainUI, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1,20,0.15,0)
        })
        tween:Play()
        tween.Completed:Wait()
        mainUI.Visible = false
    else
        mainUI.Visible = true
        mainUI.Position = UDim2.new(1,20,0.15,0)
        TweenService:Create(mainUI, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1,-340,0.15,0)
        }):Play()
    end
end)

-- Boot → Load UI + Features (key system removed)
local function bootHub()
    loadingGui.Enabled = false
        
        local startTime = tick()
        local duration = 0.01
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local pct = math.clamp(elapsed/duration,0,1)
            loadBar.Size = UDim2.new(pct,0,1,0)
            loadSub.Text = "LOADING MODULES "..math.floor(pct*100).."%"
            loadShine.Position = UDim2.new(0, math.max((loadBar.AbsoluteSize.X - 18), -42), 0, 0)
            
            if pct >= 1 then
                conn:Disconnect()
                loadingGui.Enabled = false
                mainGui.Enabled = true
                iconGui.Enabled = true
                mainUI.Visible = true
                mainUI.Position = UDim2.new(1,20,0.15,0)
                TweenService:Create(mainUI, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1,-340,0.15,0)
                }):Play()
                
                local y = 10
                
                local function section(txt, parent)
                    local l = Instance.new("TextLabel", parent)
                    l.Size = UDim2.new(1,0,0,22)
                    l.Position = UDim2.new(0,0,0,y)
                    l.Text = txt
                    l.TextColor3 = Color3.fromRGB(126, 214, 252)
                    l.Font = Enum.Font.GothamSemibold
                    l.TextSize = 14
                    l.BackgroundTransparency = 1
                    l.ZIndex = 60
                    y = y + 30
                end

                local function styleButton(b, offColor, onColor)
                    local scale = Instance.new("UIScale", b)
                    scale.Scale = 1

                    local stroke = Instance.new("UIStroke", b)
                    stroke.Thickness = 1
                    stroke.Transparency = 0.35
                    stroke.Color = Color3.fromRGB(94, 189, 240)

                    if not b:GetAttribute("HoverBound") then
                        b:SetAttribute("HoverBound", true)
                        b.MouseEnter:Connect(function()
                            TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
                            if b.BackgroundColor3 == offColor then
                                TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = offColor:Lerp(Color3.new(1,1,1), 0.06)}):Play()
                            end
                        end)
                        b.MouseLeave:Connect(function()
                            TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
                            if b.BackgroundColor3 ~= onColor then
                                TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = offColor}):Play()
                            end
                        end)
                    end
                end
                
                local function toggle(txt, callback, parent)
                    local b = Instance.new("TextButton", parent)
                    b.Size = UDim2.new(1,-30,0,36)
                    b.Position = UDim2.new(0,15,0,y)
                    b.Text = txt..": OFF"
                    b.Font = Enum.Font.GothamMedium
                    b.TextSize = 14
                    b.TextColor3 = Color3.fromRGB(236, 246, 255)
                    b.BackgroundColor3 = Color3.fromRGB(36,55,78)
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
                    b.ZIndex = 60
                    styleButton(b, Color3.fromRGB(36,55,78), Color3.fromRGB(52,165,215))
                    local state = false
                    b.MouseButton1Click:Connect(function()
                        state = not state
                        b.Text = txt..": "..(state and "ON" or "OFF")
                        b.BackgroundColor3 = state and Color3.fromRGB(52,165,215) or Color3.fromRGB(36,55,78)
                        callback(state)
                    end)
                    y = y + 44
                    return b
                end
                
                -- AIMLOCK
                section("🎯Aimbot", mainTab)
                local CamlockState = false
                local Prediction = 0.1768521
                local enemy = nil
                toggle("Aimbot", function(v)
                    CamlockState = v
                    if CamlockState then
                        enemy = FindNearestEnemy()
                    else
                        enemy = nil
                    end
                end, mainTab)
                function FindNearestEnemy()
                    local ClosestDistance, ClosestPlayer = math.huge, nil
                    local center = Camera.ViewportSize / 2
                    for _,plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local hum = plr.Character:FindFirstChild("Humanoid")
                            if hum and hum.Health > 0 then
                                local pos, visible = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                                if visible then
                                    local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                                    if dist < ClosestDistance then
                                        ClosestDistance = dist
                                        ClosestPlayer = plr
                                    end
                                end
                            end
                        end
                    end
                    return ClosestPlayer
                end
                RunService.Heartbeat:Connect(function()
                    if CamlockState and enemy and enemy.Character then
                        local part = enemy.Character:FindFirstChild("HumanoidRootPart")
                        if part then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position + part.Velocity * Prediction)
                        end
                    end
                end)
                
                -- SPEED
                section("🏃🏻‍♂️Speed", mainTab)
                local Minus = Instance.new("TextButton", mainTab)
                local Num = Instance.new("TextBox", mainTab)
                local Plus = Instance.new("TextButton", mainTab)
                Minus.Size = UDim2.new(0,50,0,36)
                Minus.Position = UDim2.new(0,15,0,y)
                Minus.Text = "-"
                Minus.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Minus.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", Minus).CornerRadius = UDim.new(0,12)
                Num.Size = UDim2.new(0,150,0,36)
                Num.Position = UDim2.new(0,70,0,y)
                Num.BackgroundColor3 = Color3.fromRGB(28,28,45)
                Num.TextColor3 = Color3.new(1,1,1)
                Num.TextScaled = true
                Num.ClearTextOnFocus = true
                Instance.new("UICorner", Num).CornerRadius = UDim.new(0,12)
                Plus.Size = UDim2.new(0,50,0,36)
                Plus.Position = UDim2.new(0,225,0,y)
                Plus.Text = "+"
                Plus.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Plus.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", Plus).CornerRadius = UDim.new(0,12)
                y = y + 50
                local humanoid
                local number = 350
                local function update()
                    Num.Text = tostring(number)
                    if humanoid then humanoid.WalkSpeed = number end
                end
                local function onChar(c)
                    humanoid = c:WaitForChild("Humanoid")
                    humanoid.WalkSpeed = number
                    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                        if humanoid.WalkSpeed ~= number then
                            humanoid.WalkSpeed = number
                        end
                    end)
                    update()
                end
                player.CharacterAdded:Connect(onChar)
                if player.Character then onChar(player.Character) end
                Plus.MouseButton1Click:Connect(function() number += 1 update() end)
                Minus.MouseButton1Click:Connect(function() if number > 1 then number -= 1 update() end end)
                Num.FocusLost:Connect(function(enter) if enter then local v = tonumber(Num.Text) if v and v > 0 then number = v end update() end end)
                
                -- INF JUMP
                section("♾️Inf Jump", mainTab)
                local infJump = false
                toggle("Inf Jump", function(v) infJump = v end, mainTab)
                UserInputService.JumpRequest:Connect(function()
                    if infJump then
                        local char = player.Character
                        if char and char:FindFirstChild("Humanoid") then
                            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
                
                -- JUMP BOOST
                section("🦘Jump Boost", mainTab)
                local JMinus = Instance.new("TextButton", mainTab)
                local JNum = Instance.new("TextBox", mainTab)
                local JPlus = Instance.new("TextButton", mainTab)
                JMinus.Size = UDim2.new(0,50,0,36)
                JMinus.Position = UDim2.new(0,15,0,y)
                JMinus.Text = "-"
                JMinus.BackgroundColor3 = Color3.fromRGB(40,40,65)
                JMinus.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", JMinus).CornerRadius = UDim.new(0,12)
                JNum.Size = UDim2.new(0,150,0,36)
                JNum.Position = UDim2.new(0,70,0,y)
                JNum.BackgroundColor3 = Color3.fromRGB(28,28,45)
                JNum.TextColor3 = Color3.new(1,1,1)
                JNum.TextScaled = true
                JNum.ClearTextOnFocus = true
                Instance.new("UICorner", JNum).CornerRadius = UDim.new(0,12)
                JPlus.Size = UDim2.new(0,50,0,36)
                JPlus.Position = UDim2.new(0,225,0,y)
                JPlus.Text = "+"
                JPlus.BackgroundColor3 = Color3.fromRGB(40,40,65)
                JPlus.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", JPlus).CornerRadius = UDim.new(0,12)
                y = y + 50
                local Jhumanoid
                local Jnumber = 200
                local function updateJump()
                    JNum.Text = tostring(Jnumber)
                    if Jhumanoid then
                        Jhumanoid.UseJumpPower = true
                        Jhumanoid.JumpPower = Jnumber
                    end
                end
                local function onCharJump(c)
                    Jhumanoid = c:WaitForChild("Humanoid")
                    Jhumanoid.UseJumpPower = true
                    Jhumanoid.JumpPower = Jnumber
                    Jhumanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                        if Jhumanoid.JumpPower ~= Jnumber then
                            Jhumanoid.JumpPower = Jnumber
                        end
                    end)
                    updateJump()
                end
                player.CharacterAdded:Connect(onCharJump)
                if player.Character then onCharJump(player.Character) end
                JPlus.MouseButton1Click:Connect(function() Jnumber += 5 updateJump() end)
                JMinus.MouseButton1Click:Connect(function() if Jnumber > 5 then Jnumber -= 5 updateJump() end end)
                JNum.FocusLost:Connect(function(enter) if enter then local v = tonumber(JNum.Text) if v and v > 0 then Jnumber = v end updateJump() end end)
                
                -- NOCLIP
                section("🧱NOCLIP", mainTab)
                local noclip = false
                toggle("Noclip", function(v) noclip = v end, mainTab)
                RunService.Stepped:Connect(function()
                    if noclip then
                        local char = player.Character
                        if char then
                            for _,p in pairs(char:GetDescendants()) do
                                if p:IsA("BasePart") then p.CanCollide = false end
                            end
                        end
                    end
                end)
                player.CharacterAdded:Connect(function() noclip = false end)
                
                -- ESP
                section("👁️ESP", mainTab)
                local espOn = false
                local espCons = {}
                toggle("ESP", function(v)
                    espOn = v
                    if not espOn then
                        for _,c in pairs(espCons) do c:Disconnect() end
                        espCons = {}
                        for _,p in pairs(Players:GetPlayers()) do
                            if p.Character and p.Character:FindFirstChild("Head") then
                                local e = p.Character.Head:FindFirstChild("ESP")
                                if e then e:Destroy() end
                            end
                        end
                    end
                end, mainTab)
                local function addESP(plr)
                    if plr == player then return end
                    local function setup(char)
                        if not espOn then return end
                        local head = char:WaitForChild("Head",5)
                        local hum = char:WaitForChild("Humanoid",5)
                        local root = char:WaitForChild("HumanoidRootPart",5)
                        if not head or not hum or not root then return end
                        if head:FindFirstChild("ESP") then head.ESP:Destroy() end
                        local gui = Instance.new("BillboardGui", head)
                        gui.Name = "ESP"
                        gui.Size = UDim2.new(0,200,0,30)
                        gui.StudsOffset = Vector3.new(0,2,0)
                        gui.AlwaysOnTop = true
                        local txt = Instance.new("TextLabel", gui)
                        txt.Size = UDim2.new(1,0,1,0)
                        txt.BackgroundTransparency = 1
                        txt.TextSize = 12
                        txt.TextStrokeTransparency = 0
                        txt.TextColor3 = Color3.new(1,1,1)
                        txt.Font = Enum.Font.SourceSansBold
                        local con = RunService.RenderStepped:Connect(function()
                            if not espOn then return end
                            local myChar = player.Character
                            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                            if not myRoot then return end
                            local dist = math.floor((myRoot.Position - root.Position).Magnitude)
                            txt.Text = plr.Name.." | "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).." | "..dist.."m"
                        end)
                        table.insert(espCons, con)
                    end
                    if plr.Character then setup(plr.Character) end
                    plr.CharacterAdded:Connect(setup)
                end
                Players.PlayerAdded:Connect(function(p) if espOn then addESP(p) end end)
                RunService.Heartbeat:Connect(function()
                    if espOn then
                        for _,p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                                if not p.Character.Head:FindFirstChild("ESP") then
                                    addESP(p)
                                end
                            end
                        end
                    end
                end)
                
                -- SKY FLY
                section("😩RUN", mainTab)
                local flyOn = false
                local flySpeed = 500
                local vel, align, attach
                local currentChar, humanoid, root
                local function cleanupFly()
                    RunService:UnbindFromRenderStep("SkyFly")
                    if vel then vel:Destroy() vel = nil end
                    if align then align:Destroy() align = nil end
                    if attach then attach:Destroy() attach = nil end
                end
                local function setupFly(char)
                    cleanupFly()
                    currentChar = char
                    humanoid = char:WaitForChild("Humanoid")
                    root = char:WaitForChild("HumanoidRootPart")
                    humanoid.PlatformStand = false
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    attach = Instance.new("Attachment", root)
                    vel = Instance.new("LinearVelocity")
                    vel.Attachment0 = attach
                    vel.MaxForce = math.huge
                    vel.Parent = root
                    align = Instance.new("AlignOrientation")
                    align.Attachment0 = attach
                    align.MaxTorque = math.huge
                    align.Responsiveness = 60
                    align.Parent = root
                    RunService:BindToRenderStep("SkyFly", 0, function()
                        if not flyOn then return end
                        if not root or not root.Parent then return end
                        humanoid.PlatformStand = false
                        if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                        align.CFrame = workspace.CurrentCamera.CFrame
                        vel.VectorVelocity = workspace.CurrentCamera.CFrame.UpVector * flySpeed
                    end)
                end
                toggle("Sky Fly", function(v)
                    flyOn = v
                    noclip = v
                    if v then
                        if player.Character then setupFly(player.Character) end
                    else
                        cleanupFly()
                    end
                end, mainTab)
                player.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    if flyOn then setupFly(char) end
                end)
                
                -- FAST ATTACK
                section("⏩Fast Attack", mainTab)
                local fastAttack = false
                local devilFastAttack = false
                toggle("Fast Attack", function(v) fastAttack = v end, mainTab)
                toggle("Devil Fruit Fast Attack", function(v) devilFastAttack = v end, mainTab)
                local FA_RANGE = 180
                local FA_MAX = 6
                local FA_DELAY = 0
                local RS = game:GetService("ReplicatedStorage")
                local CS = game:GetService("CollectionService")
                local char, hrp
                local function updateChar()
                    char = player.Character or player.CharacterAdded:Wait()
                    hrp = char:WaitForChild("HumanoidRootPart")
                end
                updateChar()
                player.CharacterAdded:Connect(updateChar)
                local registerAttack = RS.Modules.Net["RE/RegisterAttack"]
                local registerHit = debug.getupvalue(getrenv()._G.SendHitsToServer, 1)
                local function getMobs()
                    if not hrp then return {} end
                    local mobs = {}
                    local pos = hrp.Position
                    for _, mob in ipairs(CS:GetTagged("BasicMob")) do
                        local hum = mob:FindFirstChildOfClass("Humanoid")
                        local root = mob:FindFirstChild("HumanoidRootPart")
                        if hum and root and hum.Health > 0 then
                            if (root.Position - pos).Magnitude <= FA_RANGE then
                                table.insert(mobs, {mob, root})
                                if #mobs >= FA_MAX then break end
                            end
                        end
                    end
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                            local root = plr.Character:FindFirstChild("HumanoidRootPart")
                            if hum and root and hum.Health > 0 then
                                if (root.Position - pos).Magnitude <= FA_RANGE then
                                    table.insert(mobs, {plr.Character, root})
                                    if #mobs >= FA_MAX then break end
                                end
                            end
                        end
                    end
                    return mobs
                end
                local function doFastAttack()
                    local mobs = getMobs()
                    if #mobs == 0 then return end
                    registerAttack:FireServer(0/0)
                    coroutine.resume(registerHit, mobs[1][2], { table.unpack(mobs, 2) })
                end
                task.spawn(function()
                    while task.wait(FA_DELAY) do
                        if fastAttack then pcall(doFastAttack) end
                    end
                end)

                task.spawn(function()
                    while true do
                        if devilFastAttack then
                            local args = {
                                [1] = Vector3.new(-0.9909539222717285, -0, 0.13420303165912628),
                                [2] = 1,
                                [3] = true
                            }
                            local devChar = player.Character
                            if devChar and devChar:FindFirstChild("T-Rex-T-Rex") then
                                devChar["T-Rex-T-Rex"].LeftClickRemote:FireServer(unpack(args))
                            end
                        end
                        task.wait(0.00001)
                    end
                end)
                
                -- FLY (WASD)
                section("✈️ Fly", mainTab)
                local flying = false
                local FlySpeed = 60
                local vel_fly, align_fly, attach_fly
                local function StopFly()
                    RunService:UnbindFromRenderStep("Fly")
                    if vel_fly then vel_fly:Destroy() vel_fly = nil end
                    if align_fly then align_fly:Destroy() align_fly = nil end
                    if attach_fly then attach_fly:Destroy() attach_fly = nil end
                end
                local function StartFly()
                    local char = player.Character
                    if not char then return end
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    attach_fly = Instance.new("Attachment", hrp)
                    vel_fly = Instance.new("LinearVelocity", hrp)
                    vel_fly.Attachment0 = attach_fly
                    vel_fly.MaxForce = math.huge
                    align_fly = Instance.new("AlignOrientation", hrp)
                    align_fly.Attachment0 = attach_fly
                    align_fly.MaxTorque = math.huge
                    align_fly.Responsiveness = 50
                    RunService:BindToRenderStep("Fly", 0, function()
                        if not flying then return end
                        local cam = Camera
                        align_fly.CFrame = cam.CFrame
                        local move = Vector3.zero
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= cam.CFrame.UpVector end
                        vel_fly.VectorVelocity = move.Magnitude > 0 and move.Unit * FlySpeed or Vector3.zero
                    end)
                end
                toggle("Fly", function(v)
                    flying = v
                    if v then StartFly() else StopFly() end
                end, mainTab)
                player.CharacterAdded:Connect(function() flying = false StopFly() end)
                
                -- FLY SPEED SLIDER
                section("Fly Speed", mainTab)
                local slider = Instance.new("Frame", mainTab)
                slider.Size = UDim2.new(1,-30,0,36)
                slider.Position = UDim2.new(0,15,0,y)
                slider.BackgroundColor3 = Color3.fromRGB(35,35,55)
                Instance.new("UICorner",slider).CornerRadius = UDim.new(0,12)
                local bar = Instance.new("Frame", slider)
                bar.Size = UDim2.new(FlySpeed/500,0,1,0)
                bar.BackgroundColor3 = Color3.fromRGB(0,180,220)
                Instance.new("UICorner",bar).CornerRadius = UDim.new(0,12)
                local txt = Instance.new("TextLabel", slider)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.new(1,1,1)
                txt.Font = Enum.Font.Code
                txt.TextSize = 16
                txt.Text = "Fly Speed: "..FlySpeed
                y = y + 44
                local dragging = false
                slider.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                slider.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local x = math.clamp((i.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
                        bar.Size = UDim2.new(x,0,1,0)
                        FlySpeed = math.floor(1 + x * 499)
                        txt.Text = "Fly Speed: "..FlySpeed
                    end
                end)
                
                -- HITBOX
                section("🎯Hitbox", mainTab)
                local hitboxEnabled = false
                local hitboxSize = 5
                local hitboxTransparency = 0.6
                local hitboxToggle = Instance.new("TextButton", mainTab)
                hitboxToggle.Size = UDim2.new(1,-30,0,36)
                hitboxToggle.Position = UDim2.new(0,15,0,y)
                hitboxToggle.Text = "Hitbox: OFF"
                hitboxToggle.Font = Enum.Font.Code
                hitboxToggle.TextSize = 16
                hitboxToggle.TextColor3 = Color3.new(1,1,1)
                hitboxToggle.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", hitboxToggle).CornerRadius = UDim.new(0,12)
                y = y + 44
                local sizeSliderBack = Instance.new("Frame", mainTab)
                sizeSliderBack.Size = UDim2.new(1,-30,0,36)
                sizeSliderBack.Position = UDim2.new(0,15,0,y)
                sizeSliderBack.BackgroundColor3 = Color3.fromRGB(35,35,55)
                Instance.new("UICorner", sizeSliderBack).CornerRadius = UDim.new(0,12)
                local sizeSliderFill = Instance.new("Frame", sizeSliderBack)
                sizeSliderFill.Size = UDim2.new(hitboxSize/100,0,1,0)
                sizeSliderFill.BackgroundColor3 = Color3.fromRGB(0,180,220)
                Instance.new("UICorner", sizeSliderFill).CornerRadius = UDim.new(0,12)
                local sizeSliderText = Instance.new("TextLabel", sizeSliderBack)
                sizeSliderText.Size = UDim2.new(1,0,1,0)
                sizeSliderText.BackgroundTransparency = 1
                sizeSliderText.TextColor3 = Color3.new(1,1,1)
                sizeSliderText.Font = Enum.Font.Code
                sizeSliderText.TextSize = 16
                sizeSliderText.Text = "Hitbox Size: "..hitboxSize
                y = y + 44
                local transSliderBack = Instance.new("Frame", mainTab)
                transSliderBack.Size = UDim2.new(1,-30,0,36)
                transSliderBack.Position = UDim2.new(0,15,0,y)
                transSliderBack.BackgroundColor3 = Color3.fromRGB(35,35,55)
                Instance.new("UICorner", transSliderBack).CornerRadius = UDim.new(0,12)
                local transSliderFill = Instance.new("Frame", transSliderBack)
                transSliderFill.Size = UDim2.new(1 - hitboxTransparency,0,1,0)
                transSliderFill.BackgroundColor3 = Color3.fromRGB(0,180,220)
                Instance.new("UICorner", transSliderFill).CornerRadius = UDim.new(0,12)
                local transSliderText = Instance.new("TextLabel", transSliderBack)
                transSliderText.Size = UDim2.new(1,0,1,0)
                transSliderText.BackgroundTransparency = 1
                transSliderText.TextColor3 = Color3.new(1,1,1)
                transSliderText.Font = Enum.Font.Code
                transSliderText.TextSize = 16
                transSliderText.Text = "Hitbox Transparency: "..string.format("%.2f", hitboxTransparency)
                y = y + 44
                local function applyHitbox()
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                if hitboxEnabled then
                                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                                    hrp.Transparency = hitboxTransparency
                                    hrp.Material = Enum.Material.Neon
                                    hrp.CanCollide = false
                                else
                                    hrp.Size = Vector3.new(2,2,1)
                                    hrp.Transparency = 1
                                    hrp.Material = Enum.Material.Plastic
                                    hrp.CanCollide = true
                                end
                            end
                        end
                    end
                end
                hitboxToggle.MouseButton1Click:Connect(function()
                    hitboxEnabled = not hitboxEnabled
                    hitboxToggle.Text = hitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
                    hitboxToggle.BackgroundColor3 = hitboxEnabled and Color3.fromRGB(0,180,220) or Color3.fromRGB(40,40,65)
                    applyHitbox()
                end)
                local function setupSlider(sliderBack, sliderFill, sliderText, getValue, setValue, textPrefix)
                    local draggingSlider = false
                    sliderBack.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = true
                            mainUI.Active = false
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            draggingSlider = false
                            mainUI.Active = true
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local relativeX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
                            local value = math.clamp(math.floor(relativeX * 100), 0, 100)
                            setValue(value)
                            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                            sliderText.Text = textPrefix .. (textPrefix:find("Transparency") and string.format("%.2f", value / 100) or value)
                            applyHitbox()
                        end
                    end)
                end
                setupSlider(sizeSliderBack, sizeSliderFill, sizeSliderText,
                    function() return hitboxSize end,
                    function(v) hitboxSize = math.max(v, 1) end,
                    "Hitbox Size: "
                )
                setupSlider(transSliderBack, transSliderFill, transSliderText,
                    function() return hitboxTransparency end,
                    function(v) hitboxTransparency = v / 100 end,
                    "Hitbox Transparency: "
                )
                local function setupCharacterListener(plr)
                    plr.CharacterAdded:Connect(function()
                        task.wait(1)
                        if hitboxEnabled then applyHitbox() end
                    end)
                end
                for _, plr in ipairs(Players:GetPlayers()) do setupCharacterListener(plr) end
                Players.PlayerAdded:Connect(setupCharacterListener)
                player.CharacterAdded:Connect(function() task.wait(1) if hitboxEnabled then applyHitbox() end end)
                
                -- OTHER TAB
                y = 10
                section("⚙️TOOLS", serverTab)
                local autoTP = false
                toggle("Auto TP Tool", function(v)
                    autoTP = v
                    if v then giveTPTool() end
                end, serverTab)
                function giveTPTool()
                    if not autoTP then return end
                    local char = player.Character
                    if not char then return end
                    if player.Backpack:FindFirstChild("TP Tool") or char:FindFirstChild("TP Tool") then return end
                    local tool = Instance.new("Tool")
                    tool.Name = "TP Tool"
                    tool.RequiresHandle = false
                    tool.Activated:Connect(function()
                        local mouse = player:GetMouse()
                        if mouse and mouse.Hit then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = mouse.Hit + Vector3.new(0,3,0)
                            end
                        end
                    end)
                    tool.Parent = player.Backpack
                end
                player.CharacterAdded:Connect(function()
                    if autoTP then
                        task.wait(1)
                        giveTPTool()
                    end
                end)
                section("🌊Walk On Water", serverTab)
                local waterPlane
                local walkWater = false
                local function UpdateWater()
                    if not waterPlane then
                        waterPlane = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBase-Plane")
                        if not waterPlane then return end
                    end
                    if walkWater then
                        waterPlane.Size = Vector3.new(1000, 112, 1000)
                    else
                        waterPlane.Size = Vector3.new(1000, 80, 1000)
                    end
                end
                toggle("Walk On Water", function(v)
                    walkWater = v
                    UpdateWater()
                end, serverTab)
                walkWater = true
                UpdateWater()
                
                -- BLOX FRUITS TEAM
                section("🏴‍☠️ Blox Fruits Team", serverTab)
                local marinesBtn = Instance.new("TextButton", serverTab)
                marinesBtn.Size = UDim2.new(1,-30,0,36)
                marinesBtn.Position = UDim2.new(0,15,0,y)
                marinesBtn.Text = "Join Marines"
                marinesBtn.Font = Enum.Font.Code
                marinesBtn.TextSize = 16
                marinesBtn.TextColor3 = Color3.new(1,1,1)
                marinesBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", marinesBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                marinesBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                        local CommF = Remotes:WaitForChild("CommF_")
                        CommF:InvokeServer("SetTeam", "Marines")
                    end)
                    marinesBtn.Text = "Joining Marines..."
                    task.wait(2)
                    marinesBtn.Text = "Join Marines"
                end)
                local piratesBtn = Instance.new("TextButton", serverTab)
                piratesBtn.Size = UDim2.new(1,-30,0,36)
                piratesBtn.Position = UDim2.new(0,15,0,y)
                piratesBtn.Text = "Join Pirates"
                piratesBtn.Font = Enum.Font.Code
                piratesBtn.TextSize = 16
                piratesBtn.TextColor3 = Color3.new(1,1,1)
                piratesBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", piratesBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                piratesBtn.MouseButton1Click:Connect(function()
                    pcall(function()
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local Remotes = ReplicatedStorage:WaitForChild("Remotes")
                        local CommF = Remotes:WaitForChild("CommF_")
                        CommF:InvokeServer("SetTeam", "Pirates")
                    end)
                    piratesBtn.Text = "Joining Pirates..."
                    task.wait(2)
                    piratesBtn.Text = "Join Pirates"
                end)
                
                -- TELEPORTS
                y = 10
                section("🤿Teleport safe place (Sea 2)", combatTab)
                local function teleportTo(pos)
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = CFrame.new(pos)
                    else
                        player.CharacterAdded:Connect(function(newChar)
                            task.wait(0.5)
                            local root = newChar:WaitForChild("HumanoidRootPart", 5)
                            if root then root.CFrame = CFrame.new(pos) end
                        end)
                    end
                end
                local hauntedBtn = Instance.new("TextButton", combatTab)
                hauntedBtn.Size = UDim2.new(1,-30,0,36)
                hauntedBtn.Position = UDim2.new(0,15,0,y)
                hauntedBtn.Text = "🏴 Haunted Ship"
                hauntedBtn.Font = Enum.Font.Code
                hauntedBtn.TextSize = 16
                hauntedBtn.TextColor3 = Color3.new(1,1,1)
                hauntedBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", hauntedBtn).CornerRadius = UDim.new(0,12)
                hauntedBtn.MouseButton1Click:Connect(function()
                    hauntedBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-6500, 88, -122))
                    task.delay(1.2, function() hauntedBtn.Text = "🏴 Haunted Ship" end)
                end)
                y = y + 44
                local swanBtn = Instance.new("TextButton", combatTab)
                swanBtn.Size = UDim2.new(1,-30,0,36)
                swanBtn.Position = UDim2.new(0,15,0,y)
                swanBtn.Text = "🦢 Swan's Room"
                swanBtn.Font = Enum.Font.Code
                swanBtn.TextSize = 16
                swanBtn.TextColor3 = Color3.new(1,1,1)
                swanBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", swanBtn).CornerRadius = UDim.new(0,12)
                swanBtn.MouseButton1Click:Connect(function()
                    swanBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-288, 305, 591))
                    task.delay(1.2, function() swanBtn.Text = "🦢 Swan's Room" end)
                end)
                y = y + 44
                
                section("🤿Teleport safe place (Sea 3)", combatTab)
                local hydraBtn = Instance.new("TextButton", combatTab)
                hydraBtn.Size = UDim2.new(1,-30,0,36)
                hydraBtn.Position = UDim2.new(0,15,0,y)
                hydraBtn.Text = "🐉 Hydra Town"
                hydraBtn.Font = Enum.Font.Code
                hydraBtn.TextSize = 16
                hydraBtn.TextColor3 = Color3.new(1,1,1)
                hydraBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", hydraBtn).CornerRadius = UDim.new(0,12)
                hydraBtn.MouseButton1Click:Connect(function()
                    hydraBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-5028, 316, -3207))
                    task.delay(1.2, function() hydraBtn.Text = "🐉 Hydra Town" end)
                end)
                y = y + 44
                local mansionBtn = Instance.new("TextButton", combatTab)
                mansionBtn.Size = UDim2.new(1,-30,0,36)
                mansionBtn.Position = UDim2.new(0,15,0,y)
                mansionBtn.Text = "🏰 Mansion"
                mansionBtn.Font = Enum.Font.Code
                mansionBtn.TextSize = 16
                mansionBtn.TextColor3 = Color3.new(1,1,1)
                mansionBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", mansionBtn).CornerRadius = UDim.new(0,12)
                mansionBtn.MouseButton1Click:Connect(function()
                    mansionBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-5061, 316, -3194))
                    task.delay(1.2, function() mansionBtn.Text = "🏰 Mansion" end)
                end)
                y = y + 44
                local castleBtn = Instance.new("TextButton", combatTab)
                castleBtn.Size = UDim2.new(1,-30,0,36)
                castleBtn.Position = UDim2.new(0,15,0,y)
                castleBtn.Text = "🏰 Castle On The Sea"
                castleBtn.Font = Enum.Font.Code
                castleBtn.TextSize = 16
                castleBtn.TextColor3 = Color3.new(1,1,1)
                castleBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", castleBtn).CornerRadius = UDim.new(0,12)
                castleBtn.MouseButton1Click:Connect(function()
                    castleBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-5061, 316, -3194))
                    task.delay(1.2, function() castleBtn.Text = "🏰 Castle On The Sea" end)
                end)
                y = y + 44
                local tikiBtn = Instance.new("TextButton", combatTab)
                tikiBtn.Size = UDim2.new(1,-30,0,36)
                tikiBtn.Position = UDim2.new(0,15,0,y)
                tikiBtn.Text = "🌺 Tiki Outpost"
                tikiBtn.Font = Enum.Font.Code
                tikiBtn.TextSize = 16
                tikiBtn.TextColor3 = Color3.new(1,1,1)
                tikiBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", tikiBtn).CornerRadius = UDim.new(0,12)
                tikiBtn.MouseButton1Click:Connect(function()
                    tikiBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(-5099, 316, -3178))
                    task.delay(1.2, function() tikiBtn.Text = "🌺 Tiki Outpost" end)
                end)
                y = y + 44
                local templeBtn = Instance.new("TextButton", combatTab)
                templeBtn.Size = UDim2.new(1,-30,0,36)
                templeBtn.Position = UDim2.new(0,15,0,y)
                templeBtn.Text = "⏳ Temple Of Time"
                templeBtn.Font = Enum.Font.Code
                templeBtn.TextSize = 16
                templeBtn.TextColor3 = Color3.new(1,1,1)
                templeBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", templeBtn).CornerRadius = UDim.new(0,12)
                templeBtn.MouseButton1Click:Connect(function()
                    templeBtn.Text = "Teleporting..."
                    teleportTo(Vector3.new(28284, 14896, 104))
                    task.delay(1.2, function() templeBtn.Text = "⏳ Temple Of Time" end)
                end)
                y = y + 44
                
                -- SERVER CONTROLS
                section("🌍 Server Controls", combatTab)
                local rejoinBtn = Instance.new("TextButton", combatTab)
                rejoinBtn.Size = UDim2.new(1,-30,0,36)
                rejoinBtn.Position = UDim2.new(0,15,0,y)
                rejoinBtn.Text = "Rejoin Server"
                rejoinBtn.Font = Enum.Font.Code
                rejoinBtn.TextSize = 16
                rejoinBtn.TextColor3 = Color3.new(1,1,1)
                rejoinBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", rejoinBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                rejoinBtn.MouseButton1Click:Connect(function()
                    rejoinBtn.Text = "Rejoining..."
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
                end)
                local hopBtn = Instance.new("TextButton", combatTab)
                hopBtn.Size = UDim2.new(1,-30,0,36)
                hopBtn.Position = UDim2.new(0,15,0,y)
                hopBtn.Text = "Server Hop"
                hopBtn.Font = Enum.Font.Code
                hopBtn.TextSize = 16
                hopBtn.TextColor3 = Color3.new(1,1,1)
                hopBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", hopBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                hopBtn.MouseButton1Click:Connect(function()
                    hopBtn.Text = "Searching..."
                    local servers = {}
                    local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
                    local data = HttpService:JSONDecode(req)
                    for _, server in pairs(data.data) do
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            table.insert(servers, server.id)
                        end
                    end
                    if #servers > 0 then
                        local randomServer = servers[math.random(1,#servers)]
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, player)
                    else
                        hopBtn.Text = "No Servers Found"
                        task.wait(2)
                        hopBtn.Text = "Server Hop"
                    end
                end)
                section("📥 Job ID Join", combatTab)
                local jobBox = Instance.new("TextBox", combatTab)
                jobBox.Size = UDim2.new(1,-30,0,36)
                jobBox.Position = UDim2.new(0,15,0,y)
                jobBox.PlaceholderText = "Paste JobId here..."
                jobBox.Text = ""
                jobBox.ClearTextOnFocus = false
                jobBox.TextColor3 = Color3.new(1,1,1)
                jobBox.BackgroundColor3 = Color3.fromRGB(28,28,45)
                jobBox.Font = Enum.Font.Code
                jobBox.TextSize = 16
                Instance.new("UICorner", jobBox).CornerRadius = UDim.new(0,12)
                y = y + 44
                local joinBtn = Instance.new("TextButton", combatTab)
                joinBtn.Size = UDim2.new(1,-30,0,36)
                joinBtn.Position = UDim2.new(0,15,0,y)
                joinBtn.Text = "Join JobId"
                joinBtn.Font = Enum.Font.Code
                joinBtn.TextSize = 16
                joinBtn.TextColor3 = Color3.new(1,1,1)
                joinBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                joinBtn.MouseButton1Click:Connect(function()
                    local jobId = string.gsub(jobBox.Text, "%s+", "")
                    if jobId ~= "" then
                        joinBtn.Text = "Teleporting..."
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
                    end
                end)
                local copyBtn = Instance.new("TextButton", combatTab)
                copyBtn.Size = UDim2.new(1,-30,0,36)
                copyBtn.Position = UDim2.new(0,15,0,y)
                copyBtn.Text = "Copy Current JobId"
                copyBtn.Font = Enum.Font.Code
                copyBtn.TextSize = 16
                copyBtn.TextColor3 = Color3.new(1,1,1)
                copyBtn.BackgroundColor3 = Color3.fromRGB(40,40,65)
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0,12)
                y = y + 44
                copyBtn.MouseButton1Click:Connect(function()
                    if setclipboard then
                        setclipboard(game.JobId)
                        copyBtn.Text = "Copied!"
                        task.wait(1.5)
                        copyBtn.Text = "Copy Current JobId"
                    else
                        copyBtn.Text = "Clipboard Not Supported"
                        task.wait(2)
                        copyBtn.Text = "Copy Current JobId"
                    end
                end)

                local function applyModernTheme(root)
                    for _, gui in ipairs(root:GetDescendants()) do
                        if gui:IsA("TextButton") then
                            gui.Font = Enum.Font.GothamMedium
                            gui.TextSize = 14
                            if gui.BackgroundColor3 == Color3.fromRGB(40,40,65) then
                                gui.BackgroundColor3 = Color3.fromRGB(36,55,78)
                            end
                            if not gui:FindFirstChildWhichIsA("UIStroke") then
                                local s = Instance.new("UIStroke", gui)
                                s.Thickness = 1
                                s.Transparency = 0.35
                                s.Color = Color3.fromRGB(94, 189, 240)
                            end
                            if not gui:GetAttribute("HoverBound") then
                                gui:SetAttribute("HoverBound", true)
                                local scale = gui:FindFirstChildWhichIsA("UIScale") or Instance.new("UIScale", gui)
                                scale.Scale = 1
                                gui.MouseEnter:Connect(function()
                                    TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.02}):Play()
                                end)
                                gui.MouseLeave:Connect(function()
                                    TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
                                end)
                            end
                        elseif gui:IsA("TextBox") then
                            gui.Font = Enum.Font.GothamMedium
                            gui.TextSize = 14
                            gui.BackgroundColor3 = Color3.fromRGB(26,42,62)
                            gui.TextColor3 = Color3.fromRGB(234, 245, 255)
                            if not gui:FindFirstChildWhichIsA("UIStroke") then
                                local s = Instance.new("UIStroke", gui)
                                s.Thickness = 1
                                s.Transparency = 0.45
                                s.Color = Color3.fromRGB(97, 180, 229)
                            end
                        elseif gui:IsA("TextLabel") then
                            if gui.Parent ~= mainUI then
                                gui.Font = gui.Font == Enum.Font.GothamBlack and gui.Font or Enum.Font.GothamMedium
                            end
                        elseif gui:IsA("Frame") then
                            if gui.BackgroundColor3 == Color3.fromRGB(35,35,55) then
                                gui.BackgroundColor3 = Color3.fromRGB(31,48,70)
                            elseif gui.BackgroundColor3 == Color3.fromRGB(28,28,45) then
                                gui.BackgroundColor3 = Color3.fromRGB(26,42,62)
                            end
                        end
                    end
                end

                applyModernTheme(mainUI)
                
                print("[CHILLZONE] Hub fully loaded!")
            end
        end)
end

task.defer(bootHub)
print("[CHILLZONE] UI initialized.")
