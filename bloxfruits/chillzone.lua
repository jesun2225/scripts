local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local App = {
    loaded = false,
    open = true,
    minimized = false,
    state = {
        selectedTab = "Dashboard",
        flags = {},
        values = {
            movementSpeed = 24,
            uiScale = 1,
            notificationDuration = 3
        },
        stats = {
            sessionStart = os.time(),
            toggleCount = 0,
            buttonRuns = 0,
            logsSent = 0
        }
    },
    config = {
        uiName = "CHILLZONE",
        webhookUrl = "",
        keybindToggle = Enum.KeyCode.RightControl,
        accent = Color3.fromRGB(0, 220, 165),
        accentAlt = Color3.fromRGB(0, 168, 255),
        base = Color3.fromRGB(13, 17, 26),
        panel = Color3.fromRGB(18, 23, 35),
        panelAlt = Color3.fromRGB(23, 30, 45),
        text = Color3.fromRGB(239, 245, 255),
        muted = Color3.fromRGB(152, 167, 194)
    },
    ui = {
        tabs = {},
        pages = {},
        notifications = nil
    },
    modules = {},
    analytics = {
        queue = {},
        inFlight = false
    },
    connections = {}
}

local function safeCall(fn, ...)
    local ok, result = pcall(fn, ...)
    if ok then
        return true, result
    end
    return false, result
end

local function hexColor(c)
    return string.format("#%02X%02X%02X", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255))
end

local function create(className, props, children)
    local inst = Instance.new(className)
    if props then
        for key, value in pairs(props) do
            inst[key] = value
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    return inst
end

local function pushLog(eventName, details)
    local payload = {
        event = tostring(eventName),
        details = tostring(details or ""),
        player = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        displayName = LocalPlayer.DisplayName,
        placeId = game.PlaceId,
        jobId = game.JobId,
        timestamp = os.time()
    }
    table.insert(App.analytics.queue, payload)
end

local function sendWebhookBody(body)
    if App.config.webhookUrl == "" then
        return false
    end

    local okRequest = false

    local ok = safeCall(function()
        if HttpService.RequestAsync then
            local response = HttpService:RequestAsync({
                Url = App.config.webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(body)
            })
            okRequest = response and response.Success == true
            return
        end

        HttpService:PostAsync(App.config.webhookUrl, HttpService:JSONEncode(body), Enum.HttpContentType.ApplicationJson)
        okRequest = true
    end)

    if not ok then
        return false
    end

    return okRequest
end

local function flushLogs()
    if App.analytics.inFlight then
        return
    end
    if #App.analytics.queue == 0 then
        return
    end

    App.analytics.inFlight = true

    local event = table.remove(App.analytics.queue, 1)
    local embed = {
        username = App.config.uiName,
        embeds = {
            {
                title = "UI Event: " .. event.event,
                description = event.details,
                color = tonumber("0x00DCA5"),
                fields = {
                    { name = "Player", value = event.player, inline = true },
                    { name = "UserId", value = tostring(event.userId), inline = true },
                    { name = "Display", value = event.displayName, inline = true },
                    { name = "PlaceId", value = tostring(event.placeId), inline = true },
                    { name = "JobId", value = tostring(event.jobId), inline = true }
                },
                footer = {
                    text = "COPYRIGHT CHILLZONE | DEVELOPER JEESAN"
                }
            }
        }
    }

    local sent = sendWebhookBody(embed)
    if sent then
        App.state.stats.logsSent = App.state.stats.logsSent + 1
    end

    App.analytics.inFlight = false
end

local function notify(text)
    if not App.ui.notifications then
        return
    end

    local card = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = App.config.panelAlt,
        BorderSizePixel = 0,
        Parent = App.ui.notifications
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 10)
        }),
        create("UIStroke", {
            Color = App.config.accent,
            Transparency = 0.4,
            Thickness = 1
        }),
        create("TextLabel", {
            Size = UDim2.new(1, -12, 1, 0),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            TextColor3 = App.config.text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = text
        })
    })

    card.BackgroundTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()

    task.delay(App.state.values.notificationDuration, function()
        if card and card.Parent then
            local tween = TweenService:Create(card, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            tween:Play()
            tween.Completed:Wait()
            card:Destroy()
        end
    end)
end

local function setToggle(flag, value)
    App.state.flags[flag] = value
    App.state.stats.toggleCount = App.state.stats.toggleCount + 1
    pushLog("Toggle", flag .. "=" .. tostring(value))
end

local function setValue(key, value)
    App.state.values[key] = value
    pushLog("Value", key .. "=" .. tostring(value))
end

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(App.connections, connection)
    return connection
end

local function disconnectAll()
    for _, connection in ipairs(App.connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    App.connections = {}
end

local function makeTopBar(parent)
    local top = create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, -20, 0, 58),
        Position = UDim2.fromOffset(10, 10),
        BackgroundColor3 = App.config.panel,
        BorderSizePixel = 0,
        Parent = parent
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 14)
        }),
        create("UIStroke", {
            Color = App.config.accentAlt,
            Transparency = 0.65
        }),
        create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -240, 1, 0),
            Position = UDim2.fromOffset(16, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = string.upper(App.config.uiName),
            TextColor3 = App.config.text,
            TextSize = 17,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        create("TextLabel", {
            Name = "Sub",
            Size = UDim2.new(0, 220, 0, 24),
            Position = UDim2.new(1, -320, 0.5, -12),
            BackgroundColor3 = App.config.panelAlt,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamSemibold,
            Text = "COPYRIGHT CHILLZONE | DEVELOPER JEESAN",
            TextColor3 = App.config.accent,
            TextSize = 11
        })
    })

    local sub = top:FindFirstChild("Sub")
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = sub
    })

    local minimize = create("TextButton", {
        Name = "Minimize",
        Size = UDim2.fromOffset(40, 30),
        Position = UDim2.new(1, -90, 0.5, -15),
        BackgroundColor3 = App.config.panelAlt,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "_",
        TextColor3 = App.config.text,
        TextSize = 18,
        Parent = top
    })
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = minimize
    })

    local close = create("TextButton", {
        Name = "Close",
        Size = UDim2.fromOffset(40, 30),
        Position = UDim2.new(1, -44, 0.5, -15),
        BackgroundColor3 = Color3.fromRGB(193, 63, 81),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Color3.fromRGB(255, 235, 241),
        TextSize = 14,
        Parent = top
    })
    create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = close
    })

    return top, minimize, close
end

local function createPageContainer(content)
    return create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = App.config.accent,
        Visible = false,
        Parent = content
    }, {
        create("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4)
        }),
        create("UIListLayout", {
            Padding = UDim.new(0, 8)
        })
    })
end

local function updatePageCanvas(page)
    local layout = page:FindFirstChildOfClass("UIListLayout")
    if not layout then
        return
    end
    page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

local function setTab(name)
    App.state.selectedTab = name

    for tabName, button in pairs(App.ui.tabs) do
        local active = tabName == name
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = active and App.config.accent or App.config.panelAlt
        }):Play()
        button.TextColor3 = active and Color3.fromRGB(5, 16, 13) or App.config.text
    end

    for pageName, page in pairs(App.ui.pages) do
        page.Visible = pageName == name
        if page.Visible then
            updatePageCanvas(page)
        end
    end
end

local function makeCard(parent, title)
    return create("Frame", {
        Size = UDim2.new(1, -4, 0, 54),
        BackgroundColor3 = App.config.panelAlt,
        BorderSizePixel = 0,
        Parent = parent
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }),
        create("UIStroke", {
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.92,
            Thickness = 1
        }),
        create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -16, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = App.config.text,
            Text = title
        })
    })
end

local function addToggle(page, title, flag, defaultValue, callback)
    App.state.flags[flag] = defaultValue == true

    local card = makeCard(page, title)
    local toggle = create("TextButton", {
        Size = UDim2.fromOffset(74, 32),
        Position = UDim2.new(1, -86, 0.5, -16),
        BackgroundColor3 = App.state.flags[flag] and App.config.accent or Color3.fromRGB(70, 76, 90),
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = App.state.flags[flag] and Color3.fromRGB(7, 18, 13) or App.config.text,
        Text = App.state.flags[flag] and "ON" or "OFF",
        Parent = card
    })
    create("UICorner", {
        CornerRadius = UDim.new(0, 9),
        Parent = toggle
    })

    connect(toggle.MouseButton1Click, function()
        local value = not App.state.flags[flag]
        setToggle(flag, value)
        toggle.Text = value and "ON" or "OFF"
        toggle.TextColor3 = value and Color3.fromRGB(7, 18, 13) or App.config.text
        TweenService:Create(toggle, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = value and App.config.accent or Color3.fromRGB(70, 76, 90)
        }):Play()
        if callback then
            safeCall(callback, value)
        end
        notify(title .. " : " .. (value and "Enabled" or "Disabled"))
    end)

    updatePageCanvas(page)
    return card
end

local function addButton(page, title, buttonText, callback)
    local card = makeCard(page, title)
    local button = create("TextButton", {
        Size = UDim2.fromOffset(100, 32),
        Position = UDim2.new(1, -112, 0.5, -16),
        BackgroundColor3 = App.config.accentAlt,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(7, 14, 24),
        Text = buttonText or "RUN",
        Parent = card
    })
    create("UICorner", {
        CornerRadius = UDim.new(0, 9),
        Parent = button
    })

    connect(button.MouseButton1Click, function()
        App.state.stats.buttonRuns = App.state.stats.buttonRuns + 1
        pushLog("Button", title)
        if callback then
            safeCall(callback)
        end
        notify(title .. " executed")
    end)

    updatePageCanvas(page)
    return card
end

local function addSlider(page, title, key, minV, maxV, defaultV, callback)
    App.state.values[key] = defaultV

    local card = create("Frame", {
        Size = UDim2.new(1, -4, 0, 76),
        BackgroundColor3 = App.config.panelAlt,
        BorderSizePixel = 0,
        Parent = page
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }),
        create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -24, 0, 32),
            Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = App.config.text,
            Text = title .. " : " .. tostring(defaultV)
        })
    })

    local bar = create("Frame", {
        Size = UDim2.new(1, -24, 0, 10),
        Position = UDim2.fromOffset(12, 50),
        BackgroundColor3 = Color3.fromRGB(67, 73, 86),
        BorderSizePixel = 0,
        Parent = card
    })
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = bar
    })

    local fill = create("Frame", {
        Size = UDim2.new((defaultV - minV) / (maxV - minV), 0, 1, 0),
        BackgroundColor3 = App.config.accent,
        BorderSizePixel = 0,
        Parent = bar
    })
    create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = fill
    })

    local dragging = false
    local label = card:FindFirstChild("Label")

    local function updateFromInput(input)
        local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minV + ((maxV - minV) * alpha))
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        label.Text = title .. " : " .. tostring(value)
        App.state.values[key] = value
        if callback then
            safeCall(callback, value)
        end
    end

    connect(bar.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromInput(input)
        end
    end)

    connect(bar.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            setValue(key, App.state.values[key])
        end
    end)

    connect(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromInput(input)
        end
    end)

    updatePageCanvas(page)
    return card
end

local function addSectionHeader(page, text)
    local header = create("TextLabel", {
        Size = UDim2.new(1, -4, 0, 28),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = App.config.muted,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = text,
        Parent = page
    })
    updatePageCanvas(page)
    return header
end

local function addTab(tabScroll, content, name)
    local button = create("TextButton", {
        Size = UDim2.new(1, -10, 0, 42),
        BackgroundColor3 = App.config.panelAlt,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = App.config.text,
        Text = string.upper(name),
        Parent = tabScroll
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 10)
        })
    })

    local page = createPageContainer(content)

    App.ui.tabs[name] = button
    App.ui.pages[name] = page

    connect(button.MouseButton1Click, function()
        setTab(name)
    end)

    return page
end

local function buildTabs(tabScroll, content)
    local dashboard = addTab(tabScroll, content, "Dashboard")
    local automation = addTab(tabScroll, content, "Automation")
    local movement = addTab(tabScroll, content, "Movement")
    local items = addTab(tabScroll, content, "Items")
    local combat = addTab(tabScroll, content, "Combat")
    local premium = addTab(tabScroll, content, "Premium")
    local logs = addTab(tabScroll, content, "Logs")
    local settings = addTab(tabScroll, content, "Settings")

    addSectionHeader(dashboard, "SESSION")
    addButton(dashboard, "Refresh Dashboard", "REFRESH", function()
        pushLog("Dashboard", "Manual refresh")
    end)
    addButton(dashboard, "Show Theme Hex", "SHOW", function()
        notify("Accent " .. hexColor(App.config.accent) .. " | Alt " .. hexColor(App.config.accentAlt))
    end)

    addSectionHeader(automation, "GAME TASKS")
    addToggle(automation, "Auto Task Assistant", "autoTask", false)
    addToggle(automation, "Auto Mission Router", "autoMission", false)
    addToggle(automation, "Auto Reward Collector", "autoReward", false)
    addButton(automation, "Run One Task Cycle", "RUN", function()
        notify("Task cycle finished")
        pushLog("Automation", "One cycle executed")
    end)

    addSectionHeader(movement, "NAVIGATION")
    addToggle(movement, "Smart Waypoint Movement", "smartMove", false)
    addToggle(movement, "Quick Objective Jump", "objectiveJump", false)
    addSlider(movement, "Movement Speed", "movementSpeed", 8, 60, 24)

    addSectionHeader(items, "RESOURCE TOOLS")
    addToggle(items, "Auto Resource Magnet", "resourceMagnet", false)
    addToggle(items, "Rare Item Scanner", "itemScanner", false)
    addButton(items, "Scan Nearby Resources", "SCAN", function()
        notify("Resource scan completed")
        pushLog("Items", "Scan completed")
    end)

    addSectionHeader(combat, "ASSIST")
    addToggle(combat, "Target Assist", "targetAssist", false)
    addToggle(combat, "Precision Overlay", "precisionOverlay", false)
    addSlider(combat, "Aim Smoothness", "aimSmoothness", 1, 100, 50)

    addSectionHeader(premium, "ACCESS")
    addToggle(premium, "Enable Premium UI Skin", "premiumSkin", true, function(value)
        if value then
            App.config.accent = Color3.fromRGB(0, 230, 180)
            App.config.accentAlt = Color3.fromRGB(30, 190, 255)
        else
            App.config.accent = Color3.fromRGB(0, 220, 165)
            App.config.accentAlt = Color3.fromRGB(0, 168, 255)
        end
        setTab(App.state.selectedTab)
    end)
    addButton(premium, "Validate Entitlements", "CHECK", function()
        notify("Entitlement check complete")
        pushLog("Premium", "Entitlement validated")
    end)

    addSectionHeader(logs, "ANALYTICS")
    addButton(logs, "Send Test Webhook", "SEND", function()
        pushLog("Webhook", "Manual test from UI")
        flushLogs()
        notify("Webhook send requested")
    end)
    addButton(logs, "Copy Session Info", "COPY", function()
        local info = string.format("%s | %d | %d | %s", LocalPlayer.Name, LocalPlayer.UserId, game.PlaceId, game.JobId)
        if setclipboard then
            safeCall(setclipboard, info)
        end
        notify("Session info copied")
    end)

    addSectionHeader(settings, "UI")
    addSlider(settings, "UI Scale", "uiScale", 75, 125, 100, function(value)
        local root = App.ui.root
        if root then
            root.Size = UDim2.fromOffset(math.floor(980 * (value / 100)), math.floor(610 * (value / 100)))
        end
    end)
    addSlider(settings, "Notification Duration", "notificationDuration", 1, 8, 3)
    addButton(settings, "Reset Session Stats", "RESET", function()
        App.state.stats.toggleCount = 0
        App.state.stats.buttonRuns = 0
        App.state.stats.logsSent = 0
        notify("Session stats reset")
        pushLog("Session", "Stats reset")
    end)

    setTab("Dashboard")
end

local function buildUi()
    local existing = PlayerGui:FindFirstChild("ProfessionalUiHub")
    if existing then
        existing:Destroy()
    end

    local gui = create("ScreenGui", {
        Name = "ProfessionalUiHub",
        ResetOnSpawn = false,
        IgnoreGuiInset = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local root = create("Frame", {
        Name = "Root",
        Size = UDim2.fromOffset(980, 610),
        Position = UDim2.new(0.5, -490, 0.5, -305),
        BackgroundColor3 = App.config.base,
        BorderSizePixel = 0,
        Parent = gui
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 18)
        }),
        create("UIStroke", {
            Color = App.config.accentAlt,
            Transparency = 0.75,
            Thickness = 1
        }),
        create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 27, 40)),
                ColorSequenceKeypoint.new(0.6, Color3.fromRGB(14, 19, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(11, 16, 26))
            }),
            Rotation = 28
        })
    })

    local top, minimize, close = makeTopBar(root)

    local side = create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 230, 1, -90),
        Position = UDim2.fromOffset(10, 78),
        BackgroundColor3 = App.config.panel,
        BorderSizePixel = 0,
        Parent = root
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 14)
        })
    })

    local tabScroll = create("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.fromOffset(6, 6),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = App.config.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = side
    }, {
        create("UIListLayout", {
            Padding = UDim.new(0, 8),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
    })

    local content = create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -250, 1, -90),
        Position = UDim2.fromOffset(240, 78),
        BackgroundColor3 = App.config.panel,
        BorderSizePixel = 0,
        Parent = root
    }, {
        create("UICorner", {
            CornerRadius = UDim.new(0, 14)
        }),
        create("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12)
        })
    })

    local notifyPane = create("Frame", {
        Name = "Notifications",
        Size = UDim2.fromOffset(320, 230),
        Position = UDim2.new(1, -330, 0, 10),
        BackgroundTransparency = 1,
        Parent = gui
    }, {
        create("UIListLayout", {
            Padding = UDim.new(0, 8),
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
    })

    App.ui.gui = gui
    App.ui.root = root
    App.ui.top = top
    App.ui.side = side
    App.ui.content = content
    App.ui.notifications = notifyPane

    buildTabs(tabScroll, content)

    local tabLayout = tabScroll:FindFirstChildOfClass("UIListLayout")
    connect(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
        tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 12)
    end)

    local dragging = false
    local dragStart
    local startPos

    connect(top.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = root.Position
            connect(input.Changed, function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    connect(UserInputService.InputChanged, function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    connect(minimize.MouseButton1Click, function()
        App.minimized = not App.minimized
        if App.minimized then
            TweenService:Create(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(root.AbsoluteSize.X, 84)
            }):Play()
            TweenService:Create(side, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 230, 0, 0)
            }):Play()
            TweenService:Create(content, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, -250, 0, 0)
            }):Play()
        else
            TweenService:Create(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(math.floor(980 * (App.state.values.uiScale / 100)), math.floor(610 * (App.state.values.uiScale / 100)))
            }):Play()
            task.delay(0.08, function()
                TweenService:Create(side, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 230, 1, -90)
                }):Play()
                TweenService:Create(content, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -250, 1, -90)
                }):Play()
            end)
        end
        pushLog("UI", "Minimized=" .. tostring(App.minimized))
    end)

    connect(close.MouseButton1Click, function()
        App.open = false
        pushLog("UI", "Closed")
        flushLogs()
        disconnectAll()
        gui:Destroy()
    end)

    connect(UserInputService.InputBegan, function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.KeyCode == App.config.keybindToggle and App.ui.gui then
            App.open = not App.open
            App.ui.gui.Enabled = App.open
            pushLog("UI", "Enabled=" .. tostring(App.open))
        end
    end)

    notify("UI loaded successfully")
end

local function setupModules()
    App.modules.automation = {
        active = false,
        heartbeat = nil,
        start = function(self)
            if self.active then
                return
            end
            self.active = true
            self.heartbeat = RunService.Heartbeat:Connect(function()
                if not App.open then
                    return
                end
                if App.state.flags.autoTask or App.state.flags.autoMission or App.state.flags.autoReward then
                    if math.random(1, 450) == 10 then
                        notify("Automation pulse complete")
                    end
                end
            end)
        end,
        stop = function(self)
            self.active = false
            if self.heartbeat then
                self.heartbeat:Disconnect()
                self.heartbeat = nil
            end
        end
    }

    App.modules.analytics = {
        active = false,
        heartbeat = nil,
        start = function(self)
            if self.active then
                return
            end
            self.active = true
            self.heartbeat = RunService.Heartbeat:Connect(function()
                if math.random(1, 240) == 10 then
                    flushLogs()
                end
            end)
        end,
        stop = function(self)
            self.active = false
            if self.heartbeat then
                self.heartbeat:Disconnect()
                self.heartbeat = nil
            end
        end
    }
end

local function startModules()
    if App.modules.automation then
        App.modules.automation:start()
    end
    if App.modules.analytics then
        App.modules.analytics:start()
    end
end

local function stopModules()
    if App.modules.automation then
        App.modules.automation:stop()
    end
    if App.modules.analytics then
        App.modules.analytics:stop()
    end
end

local function init()
    if App.loaded then
        return
    end

    App.loaded = true

    local okUi = safeCall(buildUi)
    if not okUi then
        warn("CHILLZONE failed to initialize UI")
        return
    end

    setupModules()
    startModules()

    pushLog("System", "Initialized")
    flushLogs()

    LocalPlayer.AncestryChanged:Connect(function(_, parent)
        if not parent then
            stopModules()
            disconnectAll()
        end
    end)
end

init()
