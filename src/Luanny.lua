--
  _       _    _          _   _ _   _   __     __  _    _ _____ 
 | |     | |  | |   /\   | \ | | \ | |  \ \   / / | |  | |_   _|
 | |     | |  | |  /  \  |  \| |  \| |   \ \_/ /  | |  | | | |  
 | |     | |  | | / /\ \ | . ` | . ` |    \   /   | |  | | | |  
 | |____ | |__| |/ ____ \| |\  | |\  |     | |    | |__| |_| |_ 
 |______| \____//_/    \_\_| \_|_| \_|     |_|     \____/|_____|
--


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = (type(gethui) == "function" and gethui()) or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui")) or Players.LocalPlayer:WaitForChild("PlayerGui")

local LuannyUi = {}
LuannyUi.__index = LuannyUi

local AllTextElements = {}
local FontUI = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FontTitle = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local successIcons, Lucide = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
end)
local Icons = (successIcons and type(Lucide) == "table") and Lucide or setmetatable({}, {__index = function() return "" end})

if CoreGui:FindFirstChild("LuannyNotifyScreen") then
    CoreGui.LuannyNotifyScreen:Destroy()
end

local NotifyScreen = Instance.new("ScreenGui")
NotifyScreen.Name = "LuannyNotifyScreen"
NotifyScreen.IgnoreGuiInset = true
NotifyScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyScreen.Parent = CoreGui

local NotifyContainer = Instance.new("Frame", NotifyScreen)
NotifyContainer.Size = UDim2.new(0, 320, 1, -40)
NotifyContainer.Position = UDim2.new(1, -20, 0, 20)
NotifyContainer.AnchorPoint = Vector2.new(1, 0)
NotifyContainer.BackgroundTransparency = 1

local ListLayout = Instance.new("UIListLayout", NotifyContainer)
ListLayout.FillDirection = Enum.FillDirection.Vertical
ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ListLayout.Padding = UDim.new(0, 10)

function LuannyUi:Notify(options)
    local titleText = options.Title or "Notification"
    local descText = options.Desc or ""
    local duration = options.Duration or 5
    local noticeColor = options.Color or Color3.fromRGB(0, 150, 255)
    local iconName = options.Icon
    local buttons = options.Buttons or {}
    local hasButtons = #buttons > 0

    local cardHeight = hasButtons and 100 or 65

    local wrapper = Instance.new("Frame", NotifyContainer)
    wrapper.Size = UDim2.new(0, 300, 0, cardHeight)
    wrapper.BackgroundTransparency = 1

    local card = Instance.new("CanvasGroup", wrapper)
    card.Size = UDim2.new(1, 0, 1, 0)
    card.Position = UDim2.new(0, 50, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    card.GroupTransparency = 1
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = Color3.fromRGB(45, 45, 50)
    stroke.Thickness = 1

    local textRightOffset = 12
    if iconName and Icons[iconName] then
        textRightOffset = 38
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.new(0, 20, 0, 20)
        ic.AnchorPoint = Vector2.new(1, 0)
        ic.Position = UDim2.new(1, -12, 0, 12)
        ic.BackgroundTransparency = 1
        ic.Image = Icons[iconName]
        ic.ImageColor3 = noticeColor
    end

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -(textRightOffset + 12), 0, 18)
    lblTitle.Position = UDim2.new(0, 12, 0, 12)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = titleText
    lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    lblTitle.FontFace = FontTitle
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -(textRightOffset + 12), 0, 30)
    lblDesc.Position = UDim2.new(0, 12, 0, 30)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = descText
    lblDesc.TextColor3 = Color3.fromRGB(170, 170, 175)
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 12
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.TextYAlignment = Enum.TextYAlignment.Top

    local progressBg = Instance.new("Frame", card)
    progressBg.Size = UDim2.new(1, 0, 0, 2)
    progressBg.Position = UDim2.new(0, 0, 1, -2)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    progressBg.BorderSizePixel = 0

    local progressBar = Instance.new("Frame", progressBg)
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = noticeColor
    progressBar.BorderSizePixel = 0

    local isClosed = false
    local function closeNotification()
        if isClosed then return end
        isClosed = true
        local closeTween = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Position = UDim2.new(0, 50, 0, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            wrapper:Destroy()
        end)
    end

    if hasButtons then
        lblDesc.Size = UDim2.new(1, -24, 0, 20)
        
        local btnContainer = Instance.new("Frame", card)
        btnContainer.Size = UDim2.new(1, -24, 0, 28)
        btnContainer.Position = UDim2.new(0, 12, 0, 58)
        btnContainer.BackgroundTransparency = 1
        
        local btnLayout = Instance.new("UIListLayout", btnContainer)
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
        btnLayout.Padding = UDim.new(0, 6)
        
        for _, btnData in ipairs(buttons) do
            local btn = Instance.new("TextButton", btnContainer)
            btn.Size = UDim2.new(1 / #buttons, -((6 * (#buttons - 1)) / #buttons), 1, 0)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            btn.Text = btnData.Title or "Button"
            btn.TextColor3 = Color3.fromRGB(240, 240, 240)
            btn.FontFace = FontUI
            btn.TextSize = 12
            btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = Color3.fromRGB(55, 55, 60)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
            end)

            btn.MouseButton1Click:Connect(function()
                if btnData.Callback then task.spawn(btnData.Callback) end
                closeNotification()
            end)
        end
    end

    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 1, 0)
    }):Play()

    task.delay(duration, function()
        closeNotification()
    end)
end

function LuannyUi:SetFont(fontAsset)
    if typeof(fontAsset) == "string" then
        FontUI = Font.new(fontAsset, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        FontTitle = Font.new(fontAsset, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    elseif typeof(fontAsset) == "EnumItem" then
        FontUI = Font.fromEnum(fontAsset)
        FontTitle = Font.fromEnum(fontAsset)
    elseif typeof(fontAsset) == "Font" then
        FontUI = fontAsset
        FontTitle = fontAsset
    end
    for _, txt in ipairs(AllTextElements) do
        if txt and txt.Parent then
            pcall(function() txt.FontFace = FontUI end)
        end
    end
end

local Initialized = false
local ScreenGui, Overlay, Toolbar, MainContent, DockContainer, InfoContainer, ExpandBtn
local CurrentWindow = nil
local IsBarVisible = true
local IsExpanded = false
local LayoutOrderCount = 0
local WindowConfig = {}

local function RegisterText(element)
    table.insert(AllTextElements, element)
end

local function CreateLockOverlay(parent)
    local lock = Instance.new("Frame", parent)
    lock.Size = UDim2.new(1, 0, 1, 0)
    lock.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    lock.BackgroundTransparency = 1
    lock.ZIndex = 20
    lock.Visible = false
    Instance.new("UICorner", lock).CornerRadius = UDim.new(0, 8)
    return lock
end

local function UpdateToolbarWidth()
    if not Toolbar or not DockContainer or not InfoContainer then return end
    local dockWidth = DockContainer.Size.X.Offset
    local infoWidth = IsExpanded and 110 or 0
    local padding = IsExpanded and 8 or 0 
    local totalWidth = dockWidth + padding + infoWidth + 16

    if IsExpanded then InfoContainer.Visible = true end

    TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, totalWidth, 0, 45)
    }):Play()

    local tw = TweenService:Create(InfoContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, infoWidth, 1, 0)
    })
    tw:Play()
    if not IsExpanded then
        tw.Completed:Connect(function() if not IsExpanded then InfoContainer.Visible = false end end)
    end
end

local function ToggleWindow(target, windowHeight)
    local innerFrame = target:FindFirstChildOfClass("CanvasGroup")
    
    if CurrentWindow == target then
        TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        if innerFrame then
            local closeTween = TweenService:Create(innerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                GroupTransparency = 1,
                Size = UDim2.new(0, 380, 0, windowHeight - 15)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function() target.Visible = false end)
        else
            target.Visible = false
        end
        CurrentWindow = nil
    else
        if CurrentWindow then 
            local oldWindow = CurrentWindow:FindFirstChildOfClass("CanvasGroup")
            if oldWindow then oldWindow.GroupTransparency = 1 end
            CurrentWindow.Visible = false
        end
        target.Size = UDim2.new(0, 380, 0, windowHeight)
        target.Visible = true
        CurrentWindow = target
        TweenService:Create(Overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = WindowConfig.Transparent and 0.4 or 0.6}):Play()
        if innerFrame then
            innerFrame.Size = UDim2.new(0, 380, 0, windowHeight - 15)
            innerFrame.GroupTransparency = 1
            TweenService:Create(innerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
                Size = UDim2.new(0, 380, 0, windowHeight)
            }):Play()
        end
    end
end

function LuannyUi:CreateWindow(config)
    if Initialized then return self end
    Initialized = true

    WindowConfig = {
        Title = config.Title or "Luanny UI",
        Author = config.Author or "Snow",
        Transparent = config.Transparent or false,
        Theme = config.Theme or "Dark",
        ShowWindow = config.ShowWindow == nil and true or config.ShowWindow
    }

    if CoreGui:FindFirstChild("LuannyUI") then CoreGui.LuannyUI:Destroy() end

    local bgColor = WindowConfig.Theme == "Light" and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(15, 15, 15)
    local strokeColor = WindowConfig.Theme == "Light" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(45, 45, 45)
    local bgAlpha = WindowConfig.Transparent and 0.25 or 0

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LuannyUI"
    ScreenGui.IgnoreGuiInset = true 
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
    ScreenGui.Parent = CoreGui

    Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 1

    Toolbar = Instance.new("Frame", ScreenGui)
    Toolbar.Size = UDim2.new(0, 16, 0, 45)
    Toolbar.AnchorPoint = Vector2.new(0.5, 1)
    Toolbar.Position = WindowConfig.ShowWindow and UDim2.new(0.5, 0, 1, -20) or UDim2.new(0.5, 0, 1, 60)
    Toolbar.BackgroundColor3 = bgColor
    Toolbar.BackgroundTransparency = bgAlpha
    Toolbar.ZIndex = 5
    Toolbar.ClipsDescendants = false 
    Instance.new("UICorner", Toolbar).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Toolbar).Color = strokeColor

    MainContent = Instance.new("Frame", Toolbar)
    MainContent.Size = UDim2.new(1, 0, 1, 0)
    MainContent.BackgroundTransparency = 1
    MainContent.ClipsDescendants = true
    MainContent.ZIndex = 6
    Instance.new("UICorner", MainContent).CornerRadius = UDim.new(0, 12)
    
    local layoutMain = Instance.new("UIListLayout", MainContent)
    layoutMain.FillDirection = Enum.FillDirection.Horizontal
    layoutMain.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layoutMain.VerticalAlignment = Enum.VerticalAlignment.Center
    layoutMain.Padding = UDim.new(0, 8)
    Instance.new("UIPadding", MainContent).PaddingLeft = UDim.new(0, 8)

    DockContainer = Instance.new("Frame", MainContent)
    DockContainer.Size = UDim2.new(0, 0, 1, 0)
    DockContainer.BackgroundTransparency = 1
    DockContainer.ZIndex = 7
    local dockLayout = Instance.new("UIListLayout", DockContainer)
    dockLayout.FillDirection = Enum.FillDirection.Horizontal
    dockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    dockLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    dockLayout.Padding = UDim.new(0, 8)

    dockLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DockContainer.Size = UDim2.new(0, dockLayout.AbsoluteContentSize.X, 1, 0)
        UpdateToolbarWidth()
    end)

    InfoContainer = Instance.new("Frame", MainContent)
    InfoContainer.Size = UDim2.new(0, 0, 1, 0)
    InfoContainer.BackgroundTransparency = 1
    InfoContainer.ClipsDescendants = true
    InfoContainer.Visible = false
    InfoContainer.LayoutOrder = 2
    InfoContainer.ZIndex = 7
    local InfoLayout = Instance.new("UIListLayout", InfoContainer)
    InfoLayout.FillDirection = Enum.FillDirection.Vertical
    InfoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    InfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    InfoLayout.Padding = UDim.new(0, 2)
    Instance.new("UIPadding", InfoContainer).PaddingRight = UDim.new(0, 5)

    local LblTitle = Instance.new("TextLabel", InfoContainer)
    LblTitle.Size = UDim2.new(1, 0, 0, 16)
    LblTitle.BackgroundTransparency = 1
    LblTitle.Text = WindowConfig.Title
    LblTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LblTitle.FontFace = FontUI
    LblTitle.TextSize = 15
    LblTitle.TextXAlignment = Enum.TextXAlignment.Right
    LblTitle.ZIndex = 10
    RegisterText(LblTitle)

    local LblAuthor = Instance.new("TextLabel", InfoContainer)
    LblAuthor.Size = UDim2.new(1, 0, 0, 12)
    LblAuthor.BackgroundTransparency = 1
    LblAuthor.Text = WindowConfig.Author
    LblAuthor.TextColor3 = Color3.fromRGB(255, 255, 255)
    LblAuthor.FontFace = FontUI
    LblAuthor.TextSize = 11
    LblAuthor.TextXAlignment = Enum.TextXAlignment.Right
    LblAuthor.ZIndex = 10
    RegisterText(LblAuthor)

    ExpandBtn = Instance.new("ImageButton", Toolbar)
    ExpandBtn.Size = UDim2.new(0, 24, 0, 24)
    ExpandBtn.AnchorPoint = Vector2.new(0, 0.5)
    ExpandBtn.Position = UDim2.new(1, 6, 0.5, 0)
    ExpandBtn.BackgroundTransparency = 1
    ExpandBtn.Image = Icons["chevron-right"] or ""
    ExpandBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ExpandBtn.ZIndex = 6
    ExpandBtn.MouseButton1Click:Connect(function()
        IsExpanded = not IsExpanded
        ExpandBtn.Image = IsExpanded and Icons["chevron-left"] or Icons["chevron-right"]
        UpdateToolbarWidth()
    end)

    local BtnToggleBar = Instance.new("ImageButton", Toolbar)
    BtnToggleBar.Size = UDim2.new(0, 24, 0, 24)
    BtnToggleBar.AnchorPoint = Vector2.new(0.5, 1)
    BtnToggleBar.Position = UDim2.new(0.5, 0, 0, -6)
    BtnToggleBar.BackgroundTransparency = 1
    BtnToggleBar.Image = Icons["chevron-down"] or ""
    BtnToggleBar.ImageColor3 = Color3.fromRGB(255, 255, 255)
    BtnToggleBar.ZIndex = 6

    IsBarVisible = WindowConfig.ShowWindow
    BtnToggleBar.Image = IsBarVisible and Icons["chevron-down"] or Icons["chevron-up"]
    BtnToggleBar.MouseButton1Click:Connect(function()
        IsBarVisible = not IsBarVisible
        BtnToggleBar.Image = IsBarVisible and Icons["chevron-down"] or Icons["chevron-up"]
        TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = IsBarVisible and UDim2.new(0.5, 0, 1, -20) or UDim2.new(0.5, 0, 1, 60)
        }):Play()
        if not IsBarVisible and CurrentWindow then 
            local h = CurrentWindow:GetAttribute("Height") or 350
            ToggleWindow(CurrentWindow, h) 
        end
    end)

    return self
end

local TabClass = {}
TabClass.__index = TabClass

function LuannyUi:Tab(options)
    if not Initialized then self:CreateWindow({Title = "Luanny UI", Author = "Unknown"}) end
    LayoutOrderCount = LayoutOrderCount + 1

    local titleName = options.Title or "Tab"
    local iconName = options.Icon or "layout-grid"
    local windowHeight = options.Height or 350 
    local tabColor = options.Color or Color3.fromRGB(255, 255, 255)
    
    local winBgColor = WindowConfig.Theme == "Light" and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(18, 18, 18)
    local winStrokeColor = WindowConfig.Theme == "Light" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(50, 50, 50)

    local btn = Instance.new("TextButton", DockContainer)
    btn.Size = UDim2.new(0, 32, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.LayoutOrder = LayoutOrderCount; btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local grad = Instance.new("UIGradient", btn)
    grad.Rotation = 45
    
    if typeof(tabColor) == "ColorSequence" then
        grad.Color = tabColor
    else
        local c = typeof(tabColor) == "Color3" and tabColor or Color3.fromRGB(255, 255, 255)
        local darker = Color3.new(c.R * 0.3, c.G * 0.3, c.B * 0.3)
        grad.Color = ColorSequence.new(darker, c)
    end
    
    local ic = Instance.new("ImageLabel", btn)
    ic.Size = UDim2.new(0, 18, 0, 18); ic.AnchorPoint = Vector2.new(0.5, 0.5); ic.Position = UDim2.new(0.5, 0, 0.5, 0); ic.BackgroundTransparency = 1; ic.Image = Icons[iconName] or ""; ic.ImageColor3 = Color3.fromRGB(255,255,255); ic.ZIndex = 9

    local maskFrame = Instance.new("Frame", ScreenGui)
    maskFrame.AnchorPoint = Vector2.new(0.5, 1)
    maskFrame.Position = UDim2.new(0.5, 0, 1, -72)
    maskFrame.Size = UDim2.new(0, 380, 0, windowHeight)
    maskFrame.BackgroundTransparency = 1
    maskFrame.ClipsDescendants = true
    maskFrame.Visible = false
    maskFrame.ZIndex = 10
    maskFrame:SetAttribute("Height", windowHeight)
    
    local frame = Instance.new("CanvasGroup", maskFrame)
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.Position = UDim2.new(0.5, 0, 1, 0)
    frame.Size = UDim2.new(0, 380, 0, windowHeight)
    frame.BackgroundColor3 = winBgColor
    frame.BackgroundTransparency = WindowConfig.Transparent and 0.15 or 0
    frame.GroupTransparency = 0
    frame.ZIndex = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", frame).Color = winStrokeColor
    
    local tl = Instance.new("TextLabel", frame)
    tl.Size = UDim2.new(1, 0, 0, 45); tl.BackgroundTransparency = 1; tl.Text = titleName; tl.TextColor3 = Color3.fromRGB(255, 255, 255); tl.FontFace = FontUI; tl.TextSize = 22; tl.ZIndex = 11
    RegisterText(tl)

    local container = Instance.new("ScrollingFrame", frame)
    container.Size = UDim2.new(1, 0, 1, -50); container.Position = UDim2.new(0, 0, 0, 45); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0; container.ZIndex = 11
    local layout = Instance.new("UIListLayout", container)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 8)
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 5)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    btn.MouseButton1Click:Connect(function() ToggleWindow(maskFrame, windowHeight) end)

    local TabData = {Container = container, ItemCount = 0}
    setmetatable(TabData, TabClass)
    return TabData
end

function TabClass:Section(options)
    self.ItemCount = self.ItemCount + 1
    local titleText = options.Title or "Section"
    
    local sectionFrame = Instance.new("Frame", self.Container)
    sectionFrame.Size = UDim2.new(0, 340, 0, 30)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.LayoutOrder = self.ItemCount
    
    local lbl = Instance.new("TextLabel", sectionFrame)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = titleText
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.FontFace = FontUI
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lbl)
    
    local line = Instance.new("Frame", sectionFrame)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.8

    return {
        SetTitle = function(t) lbl.Text = t end,
        Destroy = function() sectionFrame:Destroy() end
    }
end

function TabClass:Button(options)
    self.ItemCount = self.ItemCount + 1
    local isLight = WindowConfig.Theme == "Light"

    local card = Instance.new("TextButton", self.Container)
    card.Size = UDim2.new(0, 340, 0, 55); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.Text = ""; card.AutoButtonColor = false; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)

    local lockOverlay = CreateLockOverlay(card)

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -20, 0, 18); lblTitle.Position = UDim2.new(0, 10, 0, 8); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Button"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13
    RegisterText(lblTitle)

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -20, 0, 16); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.ZIndex = 13
    RegisterText(lblDesc)

    local ic = Instance.new("ImageLabel", card)
    ic.Size = UDim2.new(0, 16, 0, 16); ic.AnchorPoint = Vector2.new(1, 0.5); ic.Position = UDim2.new(1, -10, 0.5, 0); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon or "mouse-pointer-click"] or ""; ic.ImageColor3 = Color3.fromRGB(255, 255, 255); ic.ZIndex = 13

    card.MouseEnter:Connect(function() if not lockOverlay.Visible then TweenService:Create(stroke, TweenInfo.new(0.2), {Color = isLight and Color3.fromRGB(150, 150, 150) or Color3.fromRGB(80, 80, 85)}):Play() end end)
    card.MouseLeave:Connect(function() if not lockOverlay.Visible then TweenService:Create(stroke, TweenInfo.new(0.2), {Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)}):Play() end end)
    
    card.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        local hoverColor = isLight and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(35, 35, 40)
        local baseColor = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25)
        local tw = TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = hoverColor})
        tw:Play()
        tw.Completed:Connect(function() TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = baseColor}):Play() end)
        if options.Callback then task.spawn(options.Callback) end
    end)

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end
    }
end

function TabClass:Toggle(options)
    self.ItemCount = self.ItemCount + 1
    local state = options.Value or false
    local isLight = WindowConfig.Theme == "Light"
    local isCheckbox = options.Type == "Checkbox"

    local card = Instance.new("TextButton", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.Text = ""; card.AutoButtonColor = false; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)

    local lockOverlay = CreateLockOverlay(card)
    local textOffset = options.Icon and 35 or 10

    if options.Icon then
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon] or ""; ic.ImageColor3 = Color3.fromRGB(255, 255, 255); ic.ZIndex = 13
    end

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -(textOffset + 50), 0, 16); lblTitle.Position = UDim2.new(0, textOffset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Toggle"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13
    RegisterText(lblTitle)

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; lblDesc.ZIndex = 13
    RegisterText(lblDesc)

    local offColor = isLight and Color3.fromRGB(180, 180, 180) or Color3.fromRGB(40, 40, 45)
    local switchBg = Instance.new("Frame", card)
    switchBg.AnchorPoint = Vector2.new(1, 0.5); switchBg.Position = UDim2.new(1, -10, 0.5, 0); switchBg.ZIndex = 14

    local checkMark, circle

    if isCheckbox then
        switchBg.Size = UDim2.new(0, 22, 0, 22); switchBg.BackgroundColor3 = state and Color3.fromRGB(70, 200, 70) or offColor
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0, 6)
        checkMark = Instance.new("ImageLabel", switchBg); checkMark.Size = UDim2.new(0, 16, 0, 16); checkMark.AnchorPoint = Vector2.new(0.5, 0.5); checkMark.Position = UDim2.new(0.5, 0, 0.5, 0); checkMark.BackgroundTransparency = 1; checkMark.Image = Icons["check"] or ""; checkMark.ImageColor3 = Color3.fromRGB(255, 255, 255); checkMark.ImageTransparency = state and 0 or 1; checkMark.ZIndex = 15
    else
        switchBg.Size = UDim2.new(0, 32, 0, 18); switchBg.BackgroundColor3 = state and Color3.fromRGB(70, 200, 70) or offColor
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
        circle = Instance.new("Frame", switchBg); circle.Size = UDim2.new(0, 14, 0, 14); circle.AnchorPoint = Vector2.new(0, 0.5); circle.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.ZIndex = 15
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    end

    local function updateVisual()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(70, 200, 70) or offColor}):Play()
        if isCheckbox then
            TweenService:Create(checkMark, TweenInfo.new(0.2), {ImageTransparency = state and 0 or 1}):Play()
        else
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
        end
    end

    card.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        state = not state
        updateVisual()
        if options.Callback then task.spawn(options.Callback, state) end
    end)

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        SetValue = function(v) state = v; updateVisual() end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end,
        Get = function() return state end
    }
end

function TabClass:Input(options)
    self.ItemCount = self.ItemCount + 1
    local isLight = WindowConfig.Theme == "Light"
    local isTextarea = options.Type == "Textarea"
    
    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, isTextarea and 90 or 65); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)
    
    local lockOverlay = CreateLockOverlay(card)
    local iconOffset = options.InputIcon and 35 or 10
    
    if options.InputIcon then
        local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.InputIcon] or ""; ic.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -120, 0, 16); lblTitle.Position = UDim2.new(0, iconOffset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Input"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lblTitle)
    
    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -120, 0, 16); lblDesc.Position = UDim2.new(0, iconOffset, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lblDesc)
    
    local boxBg = Instance.new("Frame", card)
    boxBg.Size = isTextarea and UDim2.new(1, -20, 0, 40) or UDim2.new(0, 110, 0, 30); boxBg.AnchorPoint = isTextarea and Vector2.new(0, 0) or Vector2.new(1, 0.5); boxBg.Position = isTextarea and UDim2.new(0, 10, 0, 45) or UDim2.new(1, -10, 0.5, 0); boxBg.BackgroundColor3 = isLight and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(15, 15, 18)
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", boxBg).Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)
    
    local box = Instance.new("TextBox", boxBg)
    box.Size = UDim2.new(1, -10, 1, 0); box.Position = UDim2.new(0, 5, 0, 0); box.BackgroundTransparency = 1; box.Text = options.Value or "" ; box.PlaceholderText = options.Placeholder or ""; box.TextColor3 = Color3.fromRGB(255, 255, 255); box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150); box.FontFace = FontUI; box.TextSize = 12; box.TextWrapped = isTextarea; box.ClearTextOnFocus = not isTextarea; box.TextXAlignment = isTextarea and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center; box.TextYAlignment = isTextarea and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
    RegisterText(box)
    
    box.FocusLost:Connect(function()
        if lockOverlay.Visible then return end
        if options.Callback then task.spawn(options.Callback, box.Text) end
    end)
    
    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        SetPlaceholder = function(p) box.PlaceholderText = p end,
        SetValue = function(v) box.Text = v end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end,
        Get = function() return box.Text end
    }
end

function TabClass:Dropdown(options)
    self.ItemCount = self.ItemCount + 1
    local isLight = WindowConfig.Theme == "Light"
    local optionList = options.Options or {}
    local currentValue = options.Value or (optionList[1] or "...")
    local isOpen = false

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.ClipsDescendants = true; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)

    local lockOverlay = CreateLockOverlay(card)
    local textOffset = options.Icon and 35 or 10

    if options.Icon then
        local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon] or ""; ic.ImageColor3 = Color3.fromRGB(255, 255, 255); ic.ZIndex = 13
    end

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -(textOffset + 120), 0, 16); lblTitle.Position = UDim2.new(0, textOffset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Dropdown"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13
    RegisterText(lblTitle)

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; lblDesc.ZIndex = 13
    RegisterText(lblDesc)

    local selectBtn = Instance.new("TextButton", card)
    selectBtn.Size = UDim2.new(0, 110, 0, 24); selectBtn.AnchorPoint = Vector2.new(1, 0); selectBtn.Position = UDim2.new(1, -10, 0, 6); selectBtn.BackgroundColor3 = isLight and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(35, 35, 40); selectBtn.Text = "  " .. currentValue; selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255); selectBtn.FontFace = FontUI; selectBtn.TextSize = 12; selectBtn.TextXAlignment = Enum.TextXAlignment.Left; selectBtn.ZIndex = 14
    Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)
    RegisterText(selectBtn)

    local arrow = Instance.new("ImageLabel", selectBtn)
    arrow.Size = UDim2.new(0, 14, 0, 14); arrow.AnchorPoint = Vector2.new(1, 0.5); arrow.Position = UDim2.new(1, -5, 0.5, 0); arrow.BackgroundTransparency = 1; arrow.Image = Icons["chevron-down"]; arrow.ImageColor3 = Color3.fromRGB(255, 255, 255); arrow.ZIndex = 15

    local listFrame = Instance.new("ScrollingFrame", card)
    listFrame.Size = UDim2.new(1, -20, 0, 0); listFrame.Position = UDim2.new(0, 10, 0, 60); listFrame.BackgroundTransparency = 1; listFrame.ScrollBarThickness = 2; listFrame.ZIndex = 14
    local listLayout = Instance.new("UIListLayout", listFrame)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 4)

    for i, optName in ipairs(optionList) do
        local optBtn = Instance.new("TextButton", listFrame)
        optBtn.Size = UDim2.new(1, -8, 0, 25); optBtn.BackgroundColor3 = isLight and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(30, 30, 35); optBtn.Text = "  " .. optName; optBtn.TextColor3 = Color3.fromRGB(255, 255, 255); optBtn.FontFace = FontUI; optBtn.TextSize = 13; optBtn.TextXAlignment = Enum.TextXAlignment.Left; optBtn.ZIndex = 15
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
        RegisterText(optBtn)
        
        optBtn.MouseButton1Click:Connect(function()
            if lockOverlay.Visible then return end
            currentValue = optName
            selectBtn.Text = "  " .. currentValue
            isOpen = false
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 60)}):Play()
            if options.Callback then task.spawn(options.Callback, currentValue) end
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        isOpen = not isOpen
        local targetHeight = isOpen and math.min(60 + (#optionList * 29), 160) or 60
        listFrame.Size = UDim2.new(1, -20, 0, targetHeight - 65)
        listFrame.CanvasSize = UDim2.new(0, 0, 0, #optionList * 29)
        TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, targetHeight)}):Play()
    end)

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        Destroy = function() card:Destroy() end,
        Set = function(v) currentValue = v; selectBtn.Text = "  " .. v end,
        Get = function() return currentValue end
    }
end

function TabClass:Paragraph(options)
    self.ItemCount = self.ItemCount + 1
    local isLight = WindowConfig.Theme == "Light"
    local btns = options.Buttons or {}
    local hasButtons = #btns > 0
    
    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, hasButtons and 95 or 65); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    if options.Locked then card.BackgroundTransparency = 0.6 end
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", card)
    if typeof(options.Color) == "string" then
        stroke.Color = options.Color == "Red" and Color3.fromRGB(255, 50, 50) or (isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50))
    elseif typeof(options.Color) == "Color3" then
        stroke.Color = options.Color
    else
        stroke.Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)
    end

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -20, 0, 16); lblTitle.Position = UDim2.new(0, 10, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Paragraph"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    if options.Locked then lblTitle.TextTransparency = 0.5 end
    RegisterText(lblTitle)
    
    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top
    if options.Locked then lblDesc.TextTransparency = 0.5 end
    RegisterText(lblDesc)
    
    if hasButtons then
        local btnContainer = Instance.new("Frame", card)
        btnContainer.Size = UDim2.new(1, -20, 0, 28); btnContainer.Position = UDim2.new(0, 10, 0, 60); btnContainer.BackgroundTransparency = 1
        local layout = Instance.new("UIListLayout", btnContainer); layout.FillDirection = Enum.FillDirection.Horizontal; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 6)
        
        for i, btnData in ipairs(btns) do
            local pBtn = Instance.new("TextButton", btnContainer)
            pBtn.Size = UDim2.new(1 / #btns, -6 + (6/#btns), 1, 0); pBtn.BackgroundColor3 = isLight and Color3.fromRGB(200, 200, 205) or Color3.fromRGB(35, 35, 40); pBtn.Text = btnData.Title or "Button"; pBtn.TextColor3 = Color3.fromRGB(255, 255, 255); pBtn.FontFace = FontUI; pBtn.TextSize = 12
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
            RegisterText(pBtn)
            
            if options.Locked then
                pBtn.BackgroundTransparency = 0.5; pBtn.TextTransparency = 0.5; pBtn.AutoButtonColor = false
            else
                pBtn.MouseButton1Click:Connect(function()
                    if btnData.Callback then task.spawn(btnData.Callback) end
                end)
            end
        end
    end

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        Destroy = function() card:Destroy() end
    }
end

function TabClass:Slider(options)
    self.ItemCount = self.ItemCount + 1
    local isLight = WindowConfig.Theme == "Light"
    
    local step = options.Step or 1
    local minVal = options.Value.Min or 0
    local maxVal = options.Value.Max or 100
    local defaultVal = options.Value.Default or minVal
    local currentVal = defaultVal

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 65); card.BackgroundColor3 = isLight and Color3.fromRGB(220, 220, 225) or Color3.fromRGB(22, 22, 25); card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = isLight and Color3.fromRGB(180, 180, 185) or Color3.fromRGB(45, 45, 50)

    local lockOverlay = CreateLockOverlay(card)

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -100, 0, 16); lblTitle.Position = UDim2.new(0, 12, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Slider"; lblTitle.TextColor3 = Color3.fromRGB(255, 255, 255); lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lblTitle)

    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -100, 0, 16); lblDesc.Position = UDim2.new(0, 12, 0, 26); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = Color3.fromRGB(200, 200, 200); lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lblDesc)

    local valBox = Instance.new("TextBox", card)
    valBox.Size = UDim2.new(0, 45, 0, 22); valBox.Position = UDim2.new(1, -57, 0, 12); valBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18); valBox.TextColor3 = Color3.fromRGB(255, 255, 255); valBox.Text = tostring(defaultVal); valBox.FontFace = FontUI; valBox.TextSize = 12; valBox.BorderSizePixel = 0; valBox.ClearTextOnFocus = false
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
    RegisterText(valBox)

    local slideTrack = Instance.new("TextButton", card)
    slideTrack.Size = UDim2.new(1, -24, 0, 6); slideTrack.Position = UDim2.new(0, 12, 0, 48); slideTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 45); slideTrack.Text = ""; slideTrack.AutoButtonColor = false; slideTrack.BorderSizePixel = 0
    Instance.new("UICorner", slideTrack).CornerRadius = UDim.new(1, 0)

    local slideFill = Instance.new("Frame", slideTrack)
    slideFill.Size = UDim2.new(0, 0, 1, 0); slideFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255); slideFill.BorderSizePixel = 0
    Instance.new("UICorner", slideFill).CornerRadius = UDim.new(1, 0)

    local slideCircle = Instance.new("Frame", slideFill)
    slideCircle.Size = UDim2.new(0, 12, 0, 12); slideCircle.AnchorPoint = Vector2.new(0.5, 0.5); slideCircle.Position = UDim2.new(1, 0, 0.5, 0); slideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); slideCircle.BorderSizePixel = 0
    Instance.new("UICorner", slideCircle).CornerRadius = UDim.new(1, 0)

    local sliding = false

    local function updateValue(rawVal, animate)
        local clamped = math.clamp(rawVal, minVal, maxVal)
        local rounded = math.round((clamped - minVal) / step) * step + minVal
        currentVal = math.clamp(rounded, minVal, maxVal)
        
        valBox.Text = tostring(currentVal)
        
        local percent = (currentVal - minVal) / (maxVal - minVal)
        if animate then
            TweenService:Create(slideFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
        else
            slideFill.Size = UDim2.new(percent, 0, 1, 0)
        end
        
        if options.Callback then task.spawn(options.Callback, currentVal) end
    end

    local function updateFromMouse()
        if lockOverlay.Visible then return end
        local mousePos = UserInputService:GetMouseLocation().X
        local trackPos = slideTrack.AbsolutePosition.X
        local trackWidth = slideTrack.AbsoluteSize.X
        local percent = math.clamp((mousePos - trackPos) / trackWidth, 0, 1)
        local calculated = minVal + (percent * (maxVal - minVal))
        updateValue(calculated, false)
    end

    slideTrack.InputBegan:Connect(function(input)
        if lockOverlay.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            updateFromMouse()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    valBox.FocusLost:Connect(function()
        local inputNum = tonumber(valBox.Text)
        if inputNum then updateValue(inputNum, true) else valBox.Text = tostring(currentVal) end
    end)

    updateValue(defaultVal, false)

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        SetMin = function(min) minVal = min; updateValue(currentVal, true) end,
        SetMax = function(max) maxVal = max; updateValue(currentVal, true) end,
        SetValue = function(v) updateValue(v, true) end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end,
        Get = function() return currentVal end
    }
end

return LuannyUi
