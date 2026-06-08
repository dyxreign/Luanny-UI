--[[
  _       _    _          _   _ _   _   __     __  _    _ _____ 
 | |     | |  | |   /\   | \ | | \ | |  \ \   / / | |  | |_   _|
 | |     | |  | |  /  \  |  \| |  \| |   \ \_/ /  | |  | | | |  
 | |     | |  | | / /\ \ | . ` | . ` |    \   /   | |  | | | |  
 | |____ | |__| |/ ____ \| |\  | |\  |     | |    | |__| |_| |_ 
 |______| \____//_/    \_\_| \_|_| \_|     |_|     \____/|_____|
                                                                
  >> LUANNY INTERFACE SUITE (v2.6 - Mobile Supported)
  >> Base + Themes + Rayfield ColorPicker + Dynamic Toolbar
--]]

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

local Themes = {
    Dark = { Bg = Color3.fromRGB(15, 15, 15), Card = Color3.fromRGB(22, 22, 25), Stroke = Color3.fromRGB(45, 45, 50), Text = Color3.fromRGB(255, 255, 255), SubText = Color3.fromRGB(170, 170, 175), Accent = Color3.fromRGB(0, 150, 255), Hover = Color3.fromRGB(35, 35, 40) },
    Light = { Bg = Color3.fromRGB(240, 240, 240), Card = Color3.fromRGB(220, 220, 225), Stroke = Color3.fromRGB(180, 180, 185), Text = Color3.fromRGB(20, 20, 20), SubText = Color3.fromRGB(100, 100, 105), Accent = Color3.fromRGB(0, 120, 200), Hover = Color3.fromRGB(200, 200, 205) },
    Amethyst = { Bg = Color3.fromRGB(20, 15, 30), Card = Color3.fromRGB(30, 25, 45), Stroke = Color3.fromRGB(60, 50, 80), Text = Color3.fromRGB(240, 230, 255), SubText = Color3.fromRGB(180, 170, 200), Accent = Color3.fromRGB(153, 50, 204), Hover = Color3.fromRGB(45, 35, 65) },
    Bloom = { Bg = Color3.fromRGB(30, 15, 20), Card = Color3.fromRGB(45, 25, 30), Stroke = Color3.fromRGB(80, 40, 50), Text = Color3.fromRGB(255, 230, 235), SubText = Color3.fromRGB(200, 170, 180), Accent = Color3.fromRGB(255, 105, 180), Hover = Color3.fromRGB(65, 35, 45) },
    ["Dark Blue"] = { Bg = Color3.fromRGB(10, 15, 25), Card = Color3.fromRGB(15, 22, 35), Stroke = Color3.fromRGB(30, 45, 70), Text = Color3.fromRGB(230, 240, 255), SubText = Color3.fromRGB(160, 180, 210), Accent = Color3.fromRGB(65, 105, 225), Hover = Color3.fromRGB(25, 35, 55) },
    Green = { Bg = Color3.fromRGB(15, 25, 15), Card = Color3.fromRGB(22, 35, 22), Stroke = Color3.fromRGB(45, 70, 45), Text = Color3.fromRGB(230, 255, 230), SubText = Color3.fromRGB(170, 210, 170), Accent = Color3.fromRGB(46, 139, 87), Hover = Color3.fromRGB(35, 55, 35) },
    Ocean = { Bg = Color3.fromRGB(10, 25, 30), Card = Color3.fromRGB(15, 35, 45), Stroke = Color3.fromRGB(30, 70, 90), Text = Color3.fromRGB(220, 245, 255), SubText = Color3.fromRGB(150, 190, 210), Accent = Color3.fromRGB(0, 191, 255), Hover = Color3.fromRGB(25, 50, 65) }
}

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
        local closeTween = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1, Position = UDim2.new(0, 50, 0, 0) }) 
        closeTween:Play() 
        closeTween.Completed:Connect(function() wrapper:Destroy() end) 
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
            
            btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 50)}):Play() end) 
            btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play() end) 
            btn.MouseButton1Click:Connect(function() if btnData.Callback then task.spawn(btnData.Callback) end closeNotification() end) 
        end 
    end 
    
    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), { GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }):Play() 
    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), { Size = UDim2.new(0, 0, 1, 0) }):Play() 
    
    task.delay(duration, function() closeNotification() end) 
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
        if txt and txt.Parent then pcall(function() txt.FontFace = FontUI end) end 
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
    local isVertical = (WindowConfig.Position == "Left" or WindowConfig.Position == "Right")
    local padding = IsExpanded and 8 or 0 
    
    if IsExpanded then InfoContainer.Visible = true end 
    
    if isVertical then
        local dockSize = DockContainer.Size.Y.Offset 
        local infoSize = IsExpanded and 40 or 0 
        local totalSize = dockSize + padding + infoSize + 16 
        
        TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 45, 0, totalSize) }):Play() 
        local tw = TweenService:Create(InfoContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, infoSize) }) 
        tw:Play() 
        
        if not IsExpanded then tw.Completed:Connect(function() if not IsExpanded then InfoContainer.Visible = false end end) end 
    else
        local dockWidth = DockContainer.Size.X.Offset 
        local infoWidth = IsExpanded and 110 or 0 
        local totalWidth = dockWidth + padding + infoWidth + 16 
        
        TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, totalWidth, 0, 45) }):Play() 
        local tw = TweenService:Create(InfoContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, infoWidth, 1, 0) }) 
        tw:Play() 
        
        if not IsExpanded then tw.Completed:Connect(function() if not IsExpanded then InfoContainer.Visible = false end end) end 
    end
end 

local function ToggleWindow(target, windowHeight) 
    local innerFrame = target:FindFirstChildOfClass("CanvasGroup") 
    
    if CurrentWindow == target then 
        TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play() 
        if innerFrame then 
            local closeTween = TweenService:Create(innerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1, Size = UDim2.new(0, 380, 0, windowHeight - 15) }) 
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
            TweenService:Create(innerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { GroupTransparency = 0, Size = UDim2.new(0, 380, 0, windowHeight) }):Play() 
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
        Position = config.Position or "Bottom",
        ShowWindow = config.ShowWindow == nil and true or config.ShowWindow 
    } 
    
    WindowConfig.ThemeData = Themes[WindowConfig.Theme] or Themes.Dark
    local theme = WindowConfig.ThemeData
    
    if CoreGui:FindFirstChild("LuannyUI") then 
        CoreGui.LuannyUI:Destroy() 
    end 
    
    local bgColor = theme.Bg
    local strokeColor = theme.Stroke
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
    
    local isVertical = (WindowConfig.Position == "Left" or WindowConfig.Position == "Right")

    -- Configuração Dinâmica da Posição do Toolbar
    local barVisPos, barHidPos, btnToggleAnchor, btnTogglePos, togIconVis, togIconHid, expandBtnAnchor, expandBtnPos
    local mainFillDir = isVertical and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal

    if WindowConfig.Position == "Top" then
        barVisPos = UDim2.new(0.5, 0, 0, 20)
        barHidPos = UDim2.new(0.5, 0, 0, -60)
        btnToggleAnchor = Vector2.new(0.5, 0)
        btnTogglePos = UDim2.new(0.5, 0, 1, 2)
        togIconVis, togIconHid = "chevron-up", "chevron-down"
        expandBtnAnchor, expandBtnPos = Vector2.new(0, 0.5), UDim2.new(1, 4, 0.5, 0)
        
    elseif WindowConfig.Position == "Left" then
        barVisPos = UDim2.new(0, 20, 0.5, 0)
        barHidPos = UDim2.new(0, -60, 0.5, 0)
        btnToggleAnchor = Vector2.new(0, 0.5)
        btnTogglePos = UDim2.new(1, 2, 0.5, 0)
        togIconVis, togIconHid = "chevron-left", "chevron-right"
        expandBtnAnchor, expandBtnPos = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 4)
        
    elseif WindowConfig.Position == "Right" then
        barVisPos = UDim2.new(1, -20, 0.5, 0)
        barHidPos = UDim2.new(1, 60, 0.5, 0)
        btnToggleAnchor = Vector2.new(1, 0.5)
        btnTogglePos = UDim2.new(0, -2, 0.5, 0)
        togIconVis, togIconHid = "chevron-right", "chevron-left"
        expandBtnAnchor, expandBtnPos = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 4)
        
    else -- "Bottom" (Padrão)
        barVisPos = UDim2.new(0.5, 0, 1, -20)
        barHidPos = UDim2.new(0.5, 0, 1, 60)
        btnToggleAnchor = Vector2.new(0.5, 1)
        btnTogglePos = UDim2.new(0.5, 0, 0, -2)
        togIconVis, togIconHid = "chevron-down", "chevron-up"
        expandBtnAnchor, expandBtnPos = Vector2.new(0, 0.5), UDim2.new(1, 4, 0.5, 0)
    end
    
    Toolbar = Instance.new("Frame", ScreenGui) 
    Toolbar.Size = isVertical and UDim2.new(0, 45, 0, 16) or UDim2.new(0, 16, 0, 45) 
    Toolbar.AnchorPoint = (WindowConfig.Position == "Top" and Vector2.new(0.5, 0)) or (WindowConfig.Position == "Left" and Vector2.new(0, 0.5)) or (WindowConfig.Position == "Right" and Vector2.new(1, 0.5)) or Vector2.new(0.5, 1)
    Toolbar.Position = WindowConfig.ShowWindow and barVisPos or barHidPos
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
    layoutMain.FillDirection = mainFillDir 
    layoutMain.HorizontalAlignment = isVertical and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left 
    layoutMain.VerticalAlignment = isVertical and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center 
    layoutMain.Padding = UDim.new(0, 8) 
    if isVertical then
        Instance.new("UIPadding", MainContent).PaddingTop = UDim.new(0, 8)
    else
        Instance.new("UIPadding", MainContent).PaddingLeft = UDim.new(0, 8) 
    end
    
    DockContainer = Instance.new("Frame", MainContent) 
    DockContainer.Size = UDim2.new(0, 0, 1, 0) 
    DockContainer.BackgroundTransparency = 1 
    DockContainer.ZIndex = 7 
    
    local dockLayout = Instance.new("UIListLayout", DockContainer) 
    dockLayout.FillDirection = mainFillDir 
    dockLayout.HorizontalAlignment = isVertical and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left 
    dockLayout.VerticalAlignment = isVertical and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center 
    dockLayout.Padding = UDim.new(0, 8) 
    dockLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        if isVertical then
            DockContainer.Size = UDim2.new(1, 0, 0, dockLayout.AbsoluteContentSize.Y)
        else
            DockContainer.Size = UDim2.new(0, dockLayout.AbsoluteContentSize.X, 1, 0) 
        end
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
    InfoLayout.HorizontalAlignment = isVertical and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Right 
    InfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center 
    InfoLayout.Padding = UDim.new(0, 2) 
    if not isVertical then Instance.new("UIPadding", InfoContainer).PaddingRight = UDim.new(0, 5) end
    
    local LblTitle = Instance.new("TextLabel", InfoContainer) 
    LblTitle.Size = UDim2.new(1, 0, 0, 16) 
    LblTitle.BackgroundTransparency = 1 
    LblTitle.Text = WindowConfig.Title 
    LblTitle.TextColor3 = theme.Text 
    LblTitle.FontFace = FontUI 
    LblTitle.TextSize = 15 
    LblTitle.TextXAlignment = isVertical and Enum.TextXAlignment.Center or Enum.TextXAlignment.Right 
    LblTitle.ZIndex = 10 
    RegisterText(LblTitle) 
    
    local LblAuthor = Instance.new("TextLabel", InfoContainer) 
    LblAuthor.Size = UDim2.new(1, 0, 0, 12) 
    LblAuthor.BackgroundTransparency = 1 
    LblAuthor.Text = WindowConfig.Author 
    LblAuthor.TextColor3 = theme.SubText 
    LblAuthor.FontFace = FontUI 
    LblAuthor.TextSize = 11 
    LblAuthor.TextXAlignment = isVertical and Enum.TextXAlignment.Center or Enum.TextXAlignment.Right 
    LblAuthor.ZIndex = 10 
    RegisterText(LblAuthor) 
    
    ExpandBtn = Instance.new("ImageButton", Toolbar) 
    ExpandBtn.Size = UDim2.new(0, 24, 0, 24) 
    ExpandBtn.AnchorPoint = expandBtnAnchor 
    ExpandBtn.Position = expandBtnPos 
    ExpandBtn.BackgroundTransparency = 1 
    ExpandBtn.Image = isVertical and Icons["chevron-down"] or Icons["chevron-right"]
    ExpandBtn.ImageColor3 = theme.Text 
    ExpandBtn.ZIndex = 6 
    ExpandBtn.MouseButton1Click:Connect(function() 
        IsExpanded = not IsExpanded 
        if isVertical then
            ExpandBtn.Image = IsExpanded and Icons["chevron-up"] or Icons["chevron-down"] 
        else
            ExpandBtn.Image = IsExpanded and Icons["chevron-left"] or Icons["chevron-right"] 
        end
        UpdateToolbarWidth() 
    end) 
    
    -- Botão Maior para Melhor Suporte Mobile
    local BtnToggleBar = Instance.new("ImageButton", Toolbar) 
    BtnToggleBar.Size = UDim2.new(0, 40, 0, 40) -- Hitbox maior!
    BtnToggleBar.AnchorPoint = btnToggleAnchor 
    BtnToggleBar.Position = btnTogglePos 
    BtnToggleBar.BackgroundTransparency = 1 
    BtnToggleBar.ImageColor3 = theme.Text 
    BtnToggleBar.ZIndex = 6 
    
    IsBarVisible = WindowConfig.ShowWindow 
    BtnToggleBar.Image = IsBarVisible and Icons[togIconVis] or Icons[togIconHid] 
    
    BtnToggleBar.MouseButton1Click:Connect(function() 
        IsBarVisible = not IsBarVisible 
        BtnToggleBar.Image = IsBarVisible and Icons[togIconVis] or Icons[togIconHid] 
        TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { 
            Position = IsBarVisible and barVisPos or barHidPos 
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
    
    local theme = WindowConfig.ThemeData
    local titleName = options.Title or "Tab" 
    local iconName = options.Icon or "layout-grid" 
    local windowHeight = options.Height or 350 
    local tabColor = options.Color or theme.Accent 
    
    local winBgColor = theme.Bg 
    local winStrokeColor = theme.Stroke 
    
    local btn = Instance.new("TextButton", DockContainer) 
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.LayoutOrder = LayoutOrderCount
    btn.ZIndex = 8 
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8) 
    
    local grad = Instance.new("UIGradient", btn) 
    grad.Rotation = 45 
    if typeof(tabColor) == "ColorSequence" then 
        grad.Color = tabColor 
    else 
        local c = typeof(tabColor) == "Color3" and tabColor or theme.Accent 
        local darker = Color3.new(c.R * 0.3, c.G * 0.3, c.B * 0.3) 
        grad.Color = ColorSequence.new(darker, c) 
    end 
    
    local ic = Instance.new("ImageLabel", btn) 
    ic.Size = UDim2.new(0, 18, 0, 18)
    ic.AnchorPoint = Vector2.new(0.5, 0.5)
    ic.Position = UDim2.new(0.5, 0, 0.5, 0)
    ic.BackgroundTransparency = 1
    ic.Image = Icons[iconName] or ""
    ic.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ic.ZIndex = 9 
    
    local maskFrame = Instance.new("Frame", ScreenGui) 
    -- Posicionando a janela baseada no Toolbar
    if WindowConfig.Position == "Top" then
        maskFrame.AnchorPoint = Vector2.new(0.5, 0) 
        maskFrame.Position = UDim2.new(0.5, 0, 0, 80)
    elseif WindowConfig.Position == "Left" then
        maskFrame.AnchorPoint = Vector2.new(0, 0.5) 
        maskFrame.Position = UDim2.new(0, 80, 0.5, 0)
    elseif WindowConfig.Position == "Right" then
        maskFrame.AnchorPoint = Vector2.new(1, 0.5) 
        maskFrame.Position = UDim2.new(1, -80, 0.5, 0)
    else -- Bottom
        maskFrame.AnchorPoint = Vector2.new(0.5, 1) 
        maskFrame.Position = UDim2.new(0.5, 0, 1, -80)
    end

    maskFrame.Size = UDim2.new(0, 380, 0, windowHeight) 
    maskFrame.BackgroundTransparency = 1 
    maskFrame.ClipsDescendants = true 
    maskFrame.Visible = false 
    maskFrame.ZIndex = 10 
    maskFrame:SetAttribute("Height", windowHeight) 
    
    local frame = Instance.new("CanvasGroup", maskFrame) 
    frame.AnchorPoint = Vector2.new(0.5, 0.5) 
    frame.Position = UDim2.new(0.5, 0, 0.5, 0) 
    frame.Size = UDim2.new(0, 380, 0, windowHeight) 
    frame.BackgroundColor3 = winBgColor 
    frame.BackgroundTransparency = WindowConfig.Transparent and 0.15 or 0 
    frame.GroupTransparency = 0 
    frame.ZIndex = 10 
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12) 
    Instance.new("UIStroke", frame).Color = winStrokeColor 
    
    local tl = Instance.new("TextLabel", frame) 
    tl.Size = UDim2.new(1, 0, 0, 45)
    tl.BackgroundTransparency = 1
    tl.Text = titleName
    tl.TextColor3 = theme.Text
    tl.FontFace = FontUI
    tl.TextSize = 22
    tl.ZIndex = 11 
    RegisterText(tl) 
    
    local container = Instance.new("ScrollingFrame", frame) 
    container.Size = UDim2.new(1, 0, 1, -50)
    container.Position = UDim2.new(0, 0, 0, 45)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 0
    container.ZIndex = 11 
    
    local layout = Instance.new("UIListLayout", container) 
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8) 
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 5) 
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() 
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) 
    end) 
    
    btn.MouseButton1Click:Connect(function() 
        ToggleWindow(maskFrame, windowHeight) 
    end) 
    
    local TabData = {Container = container, ItemCount = 0} 
    setmetatable(TabData, TabClass) 
    return TabData 
end 

function TabClass:Section(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
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
    lbl.TextColor3 = theme.Text 
    lbl.FontFace = FontUI 
    lbl.TextSize = 14 
    lbl.TextXAlignment = Enum.TextXAlignment.Left 
    RegisterText(lbl) 
    
    local line = Instance.new("Frame", sectionFrame) 
    line.Size = UDim2.new(1, 0, 0, 1) 
    line.Position = UDim2.new(0, 0, 1, -1) 
    line.BackgroundColor3 = theme.Stroke 
    line.BackgroundTransparency = 0.5 
    
    return { 
        SetTitle = function(t) lbl.Text = t end, 
        Destroy = function() sectionFrame:Destroy() end 
    } 
end 

function TabClass:Button(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
    
    local card = Instance.new("TextButton", self.Container) 
    card.Size = UDim2.new(0, 340, 0, 55)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.Text = ""
    card.AutoButtonColor = false
    card.LayoutOrder = self.ItemCount
    card.ZIndex = 12 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    
    local stroke = Instance.new("UIStroke", card) 
    stroke.Color = theme.Stroke 
    
    local lockOverlay = CreateLockOverlay(card) 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -20, 0, 18)
    lblTitle.Position = UDim2.new(0, 10, 0, 8)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Button"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.ZIndex = 13 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -20, 0, 16)
    lblDesc.Position = UDim2.new(0, 10, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.ZIndex = 13 
    RegisterText(lblDesc) 
    
    local ic = Instance.new("ImageLabel", card) 
    ic.Size = UDim2.new(0, 16, 0, 16)
    ic.AnchorPoint = Vector2.new(1, 0.5)
    ic.Position = UDim2.new(1, -10, 0.5, 0)
    ic.BackgroundTransparency = 1
    ic.Image = Icons[options.Icon or "mouse-pointer-click"] or ""
    ic.ImageColor3 = theme.Text
    ic.ZIndex = 13 
    
    card.MouseEnter:Connect(function() 
        if not lockOverlay.Visible then 
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.Hover}):Play() 
        end 
    end) 
    
    card.MouseLeave:Connect(function() 
        if not lockOverlay.Visible then 
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = theme.Stroke}):Play() 
        end 
    end) 
    
    card.MouseButton1Click:Connect(function() 
        if lockOverlay.Visible then return end 
        local tw = TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = theme.Hover}) 
        tw:Play() 
        tw.Completed:Connect(function() 
            TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = theme.Card}):Play() 
        end) 
        if options.Callback then task.spawn(options.Callback) end 
    end) 
    
    return { 
        SetTitle = function(t) lblTitle.Text = t end, 
        SetDesc = function(d) lblDesc.Text = d end, 
        Lock = function() 
            lockOverlay.Visible = true
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        end, 
        Unlock = function() 
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
            task.wait(0.2) 
            lockOverlay.Visible = false 
        end, 
        Destroy = function() card:Destroy() end 
    } 
end 

function TabClass:Toggle(options) 
    self.ItemCount = self.ItemCount + 1 
    local state = options.Value or false 
    local theme = WindowConfig.ThemeData
    local isCheckbox = options.Type == "Checkbox" 
    
    local card = Instance.new("TextButton", self.Container) 
    card.Size = UDim2.new(0, 340, 0, 60)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.Text = ""
    card.AutoButtonColor = false
    card.LayoutOrder = self.ItemCount
    card.ZIndex = 12 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    Instance.new("UIStroke", card).Color = theme.Stroke 
    
    local lockOverlay = CreateLockOverlay(card) 
    local textOffset = options.Icon and 35 or 10 
    
    if options.Icon then 
        local ic = Instance.new("ImageLabel", card) 
        ic.Size = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 10, 0, 10)
        ic.BackgroundTransparency = 1
        ic.Image = Icons[options.Icon] or ""
        ic.ImageColor3 = theme.Text
        ic.ZIndex = 13 
    end 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -(textOffset + 50), 0, 16)
    lblTitle.Position = UDim2.new(0, textOffset, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Toggle"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.ZIndex = 13 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -20, 0, 28)
    lblDesc.Position = UDim2.new(0, 10, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.TextYAlignment = Enum.TextYAlignment.Top
    lblDesc.ZIndex = 13 
    RegisterText(lblDesc) 
    
    local switchBg = Instance.new("Frame", card) 
    switchBg.AnchorPoint = Vector2.new(1, 0.5)
    switchBg.Position = UDim2.new(1, -10, 0.5, 0)
    switchBg.ZIndex = 14 
    
    local checkMark, circle 
    if isCheckbox then 
        switchBg.Size = UDim2.new(0, 22, 0, 22)
        switchBg.BackgroundColor3 = state and theme.Accent or theme.Hover 
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0, 6) 
        checkMark = Instance.new("ImageLabel", switchBg)
        checkMark.Size = UDim2.new(0, 16, 0, 16)
        checkMark.AnchorPoint = Vector2.new(0.5, 0.5)
        checkMark.Position = UDim2.new(0.5, 0, 0.5, 0)
        checkMark.BackgroundTransparency = 1
        checkMark.Image = Icons["check"] or ""
        checkMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
        checkMark.ImageTransparency = state and 0 or 1
        checkMark.ZIndex = 15 
    else 
        switchBg.Size = UDim2.new(0, 32, 0, 18)
        switchBg.BackgroundColor3 = state and theme.Accent or theme.Hover 
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0) 
        circle = Instance.new("Frame", switchBg)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.AnchorPoint = Vector2.new(0, 0.5)
        circle.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.ZIndex = 15 
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0) 
    end 
    
    local function updateVisual() 
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and theme.Accent or theme.Hover}):Play() 
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
        Lock = function() 
            lockOverlay.Visible = true
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        end, 
        Unlock = function() 
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
            task.wait(0.2) 
            lockOverlay.Visible = false 
        end, 
        Destroy = function() card:Destroy() end, 
        Get = function() return state end 
    } 
end 

function TabClass:Input(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
    local isTextarea = options.Type == "Textarea" 
    
    local card = Instance.new("Frame", self.Container) 
    card.Size = UDim2.new(0, 340, 0, isTextarea and 90 or 65)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.LayoutOrder = self.ItemCount 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    Instance.new("UIStroke", card).Color = theme.Stroke 
    
    local lockOverlay = CreateLockOverlay(card) 
    local iconOffset = options.InputIcon and 35 or 10 
    
    if options.InputIcon then 
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 10, 0, 10)
        ic.BackgroundTransparency = 1
        ic.Image = Icons[options.InputIcon] or ""
        ic.ImageColor3 = theme.Text 
    end 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -120, 0, 16)
    lblTitle.Position = UDim2.new(0, iconOffset, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Input"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -120, 0, 16)
    lblDesc.Position = UDim2.new(0, iconOffset, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left 
    RegisterText(lblDesc) 
    
    local boxBg = Instance.new("Frame", card) 
    boxBg.Size = isTextarea and UDim2.new(1, -20, 0, 40) or UDim2.new(0, 110, 0, 30)
    boxBg.AnchorPoint = isTextarea and Vector2.new(0, 0) or Vector2.new(1, 0.5)
    boxBg.Position = isTextarea and UDim2.new(0, 10, 0, 45) or UDim2.new(1, -10, 0.5, 0)
    boxBg.BackgroundColor3 = theme.Bg 
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6) 
    Instance.new("UIStroke", boxBg).Color = theme.Stroke 
    
    local box = Instance.new("TextBox", boxBg) 
    box.Size = UDim2.new(1, -10, 1, 0)
    box.Position = UDim2.new(0, 5, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = options.Value or "" 
    box.PlaceholderText = options.Placeholder or ""
    box.TextColor3 = theme.Text
    box.PlaceholderColor3 = theme.SubText
    box.FontFace = FontUI
    box.TextSize = 12
    box.TextWrapped = isTextarea
    box.ClearTextOnFocus = not isTextarea
    box.TextXAlignment = isTextarea and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
    box.TextYAlignment = isTextarea and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center 
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
        Lock = function() 
            lockOverlay.Visible = true
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        end, 
        Unlock = function() 
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
            task.wait(0.2) 
            lockOverlay.Visible = false 
        end, 
        Destroy = function() card:Destroy() end, 
        Get = function() return box.Text end 
    } 
end 

function TabClass:Dropdown(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
    local optionList = options.Options or {} 
    local currentValue = options.Value or (optionList[1] or "...") 
    local isOpen = false 
    
    local card = Instance.new("Frame", self.Container) 
    card.Size = UDim2.new(0, 340, 0, 60)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.ClipsDescendants = true
    card.LayoutOrder = self.ItemCount
    card.ZIndex = 12 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    Instance.new("UIStroke", card).Color = theme.Stroke 
    
    local lockOverlay = CreateLockOverlay(card) 
    local textOffset = options.Icon and 35 or 10 
    
    if options.Icon then 
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.new(0, 18, 0, 18)
        ic.Position = UDim2.new(0, 10, 0, 10)
        ic.BackgroundTransparency = 1
        ic.Image = Icons[options.Icon] or ""
        ic.ImageColor3 = theme.Text
        ic.ZIndex = 13 
    end 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -(textOffset + 120), 0, 16)
    lblTitle.Position = UDim2.new(0, textOffset, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Dropdown"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    lblTitle.ZIndex = 13 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -20, 0, 28)
    lblDesc.Position = UDim2.new(0, 10, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.TextYAlignment = Enum.TextYAlignment.Top
    lblDesc.ZIndex = 13 
    RegisterText(lblDesc) 
    
    local selectBtn = Instance.new("TextButton", card) 
    selectBtn.Size = UDim2.new(0, 110, 0, 24)
    selectBtn.AnchorPoint = Vector2.new(1, 0)
    selectBtn.Position = UDim2.new(1, -10, 0, 6)
    selectBtn.BackgroundColor3 = theme.Hover
    selectBtn.Text = " " .. currentValue
    selectBtn.TextColor3 = theme.Text
    selectBtn.FontFace = FontUI
    selectBtn.TextSize = 12
    selectBtn.TextXAlignment = Enum.TextXAlignment.Left
    selectBtn.ZIndex = 14 
    Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6) 
    RegisterText(selectBtn) 
    
    local arrow = Instance.new("ImageLabel", selectBtn) 
    arrow.Size = UDim2.new(0, 14, 0, 14)
    arrow.AnchorPoint = Vector2.new(1, 0.5)
    arrow.Position = UDim2.new(1, -5, 0.5, 0)
    arrow.BackgroundTransparency = 1
    arrow.Image = Icons["chevron-down"]
    arrow.ImageColor3 = theme.Text
    arrow.ZIndex = 15 
    
    local listFrame = Instance.new("ScrollingFrame", card) 
    listFrame.Size = UDim2.new(1, -20, 0, 0)
    listFrame.Position = UDim2.new(0, 10, 0, 60)
    listFrame.BackgroundTransparency = 1
    listFrame.ScrollBarThickness = 2
    listFrame.ZIndex = 14 
    
    local listLayout = Instance.new("UIListLayout", listFrame) 
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4) 
    
    for i, optName in ipairs(optionList) do 
        local optBtn = Instance.new("TextButton", listFrame) 
        optBtn.Size = UDim2.new(1, -8, 0, 25)
        optBtn.BackgroundColor3 = theme.Bg
        optBtn.Text = " " .. optName
        optBtn.TextColor3 = theme.Text
        optBtn.FontFace = FontUI
        optBtn.TextSize = 13
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.ZIndex = 15 
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4) 
        RegisterText(optBtn) 
        
        optBtn.MouseButton1Click:Connect(function() 
            if lockOverlay.Visible then return end 
            currentValue = optName 
            selectBtn.Text = " " .. currentValue 
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
        Set = function(v) currentValue = v; selectBtn.Text = " " .. v end, 
        Get = function() return currentValue end 
    } 
end 

function TabClass:Paragraph(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
    local btns = options.Buttons or {} 
    local hasButtons = #btns > 0 
    
    local card = Instance.new("Frame", self.Container) 
    card.Size = UDim2.new(0, 340, 0, hasButtons and 95 or 65)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.LayoutOrder = self.ItemCount 
    if options.Locked then card.BackgroundTransparency = 0.6 end 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    
    local stroke = Instance.new("UIStroke", card) 
    if typeof(options.Color) == "string" then 
        stroke.Color = options.Color == "Red" and Color3.fromRGB(255, 50, 50) or theme.Stroke 
    elseif typeof(options.Color) == "Color3" then 
        stroke.Color = options.Color 
    else 
        stroke.Color = theme.Stroke 
    end 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -20, 0, 16)
    lblTitle.Position = UDim2.new(0, 10, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Paragraph"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left 
    if options.Locked then lblTitle.TextTransparency = 0.5 end 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -20, 0, 28)
    lblDesc.Position = UDim2.new(0, 10, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.TextYAlignment = Enum.TextYAlignment.Top 
    if options.Locked then lblDesc.TextTransparency = 0.5 end 
    RegisterText(lblDesc) 
    
    if hasButtons then 
        local btnContainer = Instance.new("Frame", card) 
        btnContainer.Size = UDim2.new(1, -20, 0, 28)
        btnContainer.Position = UDim2.new(0, 10, 0, 60)
        btnContainer.BackgroundTransparency = 1 
        
        local layout = Instance.new("UIListLayout", btnContainer)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6) 
        
        for i, btnData in ipairs(btns) do 
            local pBtn = Instance.new("TextButton", btnContainer) 
            pBtn.Size = UDim2.new(1 / #btns, -6 + (6/#btns), 1, 0)
            pBtn.BackgroundColor3 = theme.Hover
            pBtn.Text = btnData.Title or "Button"
            pBtn.TextColor3 = theme.Text
            pBtn.FontFace = FontUI
            pBtn.TextSize = 12 
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6) 
            RegisterText(pBtn) 
            
            if options.Locked then 
                pBtn.BackgroundTransparency = 0.5
                pBtn.TextTransparency = 0.5
                pBtn.AutoButtonColor = false 
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

-- [SLIDER CORRIGIDO PARA MOBILE]
function TabClass:Slider(options) 
    self.ItemCount = self.ItemCount + 1 
    local theme = WindowConfig.ThemeData
    local step = options.Step or 1 
    local minVal = options.Value.Min or 0 
    local maxVal = options.Value.Max or 100 
    local defaultVal = options.Value.Default or minVal 
    local currentVal = defaultVal 
    
    local card = Instance.new("Frame", self.Container) 
    card.Size = UDim2.new(0, 340, 0, 65)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.LayoutOrder = self.ItemCount 
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8) 
    Instance.new("UIStroke", card).Color = theme.Stroke 
    
    local lockOverlay = CreateLockOverlay(card) 
    
    local lblTitle = Instance.new("TextLabel", card) 
    lblTitle.Size = UDim2.new(1, -100, 0, 16)
    lblTitle.Position = UDim2.new(0, 12, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Slider"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontUI
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left 
    RegisterText(lblTitle) 
    
    local lblDesc = Instance.new("TextLabel", card) 
    lblDesc.Size = UDim2.new(1, -100, 0, 16)
    lblDesc.Position = UDim2.new(0, 12, 0, 26)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left 
    RegisterText(lblDesc) 
    
    local valBox = Instance.new("TextBox", card) 
    valBox.Size = UDim2.new(0, 45, 0, 22)
    valBox.Position = UDim2.new(1, -57, 0, 12)
    valBox.BackgroundColor3 = theme.Bg
    valBox.TextColor3 = theme.Text
    valBox.Text = tostring(defaultVal)
    valBox.FontFace = FontUI
    valBox.TextSize = 12
    valBox.BorderSizePixel = 0
    valBox.ClearTextOnFocus = false 
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4) 
    RegisterText(valBox) 
    
    local slideTrack = Instance.new("TextButton", card) 
    slideTrack.Size = UDim2.new(1, -24, 0, 6)
    slideTrack.Position = UDim2.new(0, 12, 0, 48)
    slideTrack.BackgroundColor3 = theme.Hover
    slideTrack.Text = ""
    slideTrack.AutoButtonColor = false
    slideTrack.BorderSizePixel = 0 
    Instance.new("UICorner", slideTrack).CornerRadius = UDim.new(1, 0) 
    
    local slideFill = Instance.new("Frame", slideTrack) 
    slideFill.Size = UDim2.new(0, 0, 1, 0)
    slideFill.BackgroundColor3 = theme.Accent
    slideFill.BorderSizePixel = 0 
    Instance.new("UICorner", slideFill).CornerRadius = UDim.new(1, 0) 
    
    local slideCircle = Instance.new("Frame", slideFill) 
    slideCircle.Size = UDim2.new(0, 12, 0, 12)
    slideCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    slideCircle.Position = UDim2.new(1, 0, 0.5, 0)
    slideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    slideCircle.BorderSizePixel = 0 
    Instance.new("UICorner", slideCircle).CornerRadius = UDim.new(1, 0) 
    
    local sliding = false 
    local currentInput = nil
    
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
    
    local function updateFromTouch(pos) 
        if lockOverlay.Visible then return end 
        local trackPos = slideTrack.AbsolutePosition.X 
        local trackWidth = slideTrack.AbsoluteSize.X 
        local percent = math.clamp((pos.X - trackPos) / trackWidth, 0, 1) 
        local calculated = minVal + (percent * (maxVal - minVal)) 
        updateValue(calculated, false) 
    end 
    
    -- TRACKEAMENTO EXATO PARA PC E MOBILE
    slideTrack.InputBegan:Connect(function(input) 
        if lockOverlay.Visible then return end 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            sliding = true 
            currentInput = input
            updateFromTouch(input.Position) 
        end 
    end) 
    
    UserInputService.InputChanged:Connect(function(input) 
        if sliding and input == currentInput then 
            updateFromTouch(input.Position) 
        end 
    end) 
    
    UserInputService.InputEnded:Connect(function(input) 
        if input == currentInput then 
            sliding = false 
            currentInput = nil
        end 
    end) 
    
    valBox.FocusLost:Connect(function() 
        local inputNum = tonumber(valBox.Text) 
        if inputNum then 
            updateValue(inputNum, true) 
        else 
            valBox.Text = tostring(currentVal) 
        end 
    end) 
    
    updateValue(defaultVal, false) 
    
    return { 
        SetTitle = function(t) lblTitle.Text = t end, 
        SetDesc = function(d) lblDesc.Text = d end, 
        SetMin = function(min) minVal = min; updateValue(currentVal, true) end, 
        SetMax = function(max) maxVal = max; updateValue(currentVal, true) end, 
        SetValue = function(v) updateValue(v, true) end, 
        Lock = function() 
            lockOverlay.Visible = true
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        end, 
        Unlock = function() 
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
            task.wait(0.2) 
            lockOverlay.Visible = false 
        end, 
        Destroy = function() card:Destroy() end, 
        Get = function() return currentVal end 
    } 
end 

-- [COLOR PICKER CORRIGIDO PARA MOBILE]
function TabClass:ColorPicker(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local currentColor = options.Value or Color3.fromRGB(255, 255, 255)
    local H, S, V = currentColor:ToHSV()
    local isOpen = false

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60)
    card.BackgroundColor3 = theme.Card
    card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0
    card.ClipsDescendants = true
    card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)
    
    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -80, 0, 16)
    lblTitle.Position = UDim2.new(0, 10, 0, 10)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = options.Title or "Color Picker"
    lblTitle.TextColor3 = theme.Text
    lblTitle.FontFace = FontTitle
    lblTitle.TextSize = 14
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(lblTitle)
    
    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -80, 0, 28)
    lblDesc.Position = UDim2.new(0, 10, 0, 28)
    lblDesc.BackgroundTransparency = 1
    lblDesc.Text = options.Desc or ""
    lblDesc.TextColor3 = theme.SubText
    lblDesc.FontFace = FontUI
    lblDesc.TextSize = 11
    lblDesc.TextWrapped = true
    lblDesc.TextXAlignment = Enum.TextXAlignment.Left
    lblDesc.TextYAlignment = Enum.TextYAlignment.Top
    RegisterText(lblDesc)

    local colorBtn = Instance.new("TextButton", card)
    colorBtn.Size = UDim2.new(0, 45, 0, 24)
    colorBtn.AnchorPoint = Vector2.new(1, 0)
    colorBtn.Position = UDim2.new(1, -10, 0, 6)
    colorBtn.BackgroundColor3 = currentColor
    colorBtn.Text = ""
    colorBtn.AutoButtonColor = false
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", colorBtn).Color = theme.Stroke

    local expandArea = Instance.new("Frame", card)
    expandArea.Size = UDim2.new(1, -20, 0, 120)
    expandArea.Position = UDim2.new(0, 10, 0, 60)
    expandArea.BackgroundTransparency = 1
    expandArea.Visible = false

    local svMap = Instance.new("TextButton", expandArea)
    svMap.Size = UDim2.new(0, 160, 0, 95)
    svMap.Position = UDim2.new(1, -160, 0, 0)
    svMap.AutoButtonColor = false
    svMap.Text = ""
    svMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
    Instance.new("UICorner", svMap).CornerRadius = UDim.new(0, 4)

    local svWhite = Instance.new("Frame", svMap)
    svWhite.Size = UDim2.new(1, 0, 1, 0)
    svWhite.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svWhite.BorderSizePixel = 0
    local uigWhite = Instance.new("UIGradient", svWhite)
    uigWhite.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(1,1,1))})
    uigWhite.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    Instance.new("UICorner", svWhite).CornerRadius = UDim.new(0, 4)

    local svBlack = Instance.new("Frame", svMap)
    svBlack.Size = UDim2.new(1, 0, 1, 0)
    svBlack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    svBlack.BorderSizePixel = 0
    local uigBlack = Instance.new("UIGradient", svBlack)
    uigBlack.Rotation = 90
    uigBlack.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0,0,0)), ColorSequenceKeypoint.new(1, Color3.new(0,0,0))})
    uigBlack.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
    Instance.new("UICorner", svBlack).CornerRadius = UDim.new(0, 4)

    local svMarker = Instance.new("Frame", svMap)
    svMarker.Size = UDim2.new(0, 8, 0, 8)
    svMarker.AnchorPoint = Vector2.new(0.5, 0.5)
    svMarker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    svMarker.Visible = false
    Instance.new("UICorner", svMarker).CornerRadius = UDim.new(1, 0)
    local svStroke = Instance.new("UIStroke", svMarker)
    svStroke.Color = Color3.fromRGB(0, 0, 0)

    local hueSlider = Instance.new("TextButton", expandArea)
    hueSlider.Size = UDim2.new(0, 160, 0, 15)
    hueSlider.Position = UDim2.new(1, -160, 0, 105)
    hueSlider.AutoButtonColor = false
    hueSlider.Text = ""
    Instance.new("UICorner", hueSlider).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", hueSlider).Color = theme.Stroke
    
    local hueGrad = Instance.new("UIGradient", hueSlider)
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })

    local hueMarker = Instance.new("Frame", hueSlider)
    hueMarker.Size = UDim2.new(0, 4, 1, 4)
    hueMarker.AnchorPoint = Vector2.new(0.5, 0.5)
    hueMarker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueMarker.Visible = false
    Instance.new("UICorner", hueMarker).CornerRadius = UDim.new(0, 2)
    Instance.new("UIStroke", hueMarker).Color = Color3.fromRGB(0, 0, 0)

    local inputsFrame = Instance.new("Frame", expandArea)
    inputsFrame.Size = UDim2.new(0, 140, 1, 0)
    inputsFrame.BackgroundTransparency = 1
    
    local inList = Instance.new("UIListLayout", inputsFrame)
    inList.SortOrder = Enum.SortOrder.LayoutOrder
    inList.Padding = UDim.new(0, 6)

    local function makeInput(txt, isHex)
        local frame = Instance.new("Frame", inputsFrame)
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.BackgroundColor3 = theme.Bg
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", frame).Color = theme.Stroke

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0, 25, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = txt
        label.TextColor3 = theme.SubText
        label.FontFace = FontTitle
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.new(1, isHex and -25 or -35, 1, 0)
        box.Position = UDim2.new(0, isHex and 20 or 30, 0, 0)
        box.BackgroundTransparency = 1
        box.TextColor3 = theme.Text
        box.FontFace = FontUI
        box.TextSize = 12
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        return box
    end

    local rBox = makeInput("R:")
    local gBox = makeInput("G:")
    local bBox = makeInput("B:")
    local hexBox = makeInput("#", true)

    local function updateVisuals(triggerCallback)
        currentColor = Color3.fromHSV(H, S, V)
        svMap.BackgroundColor3 = Color3.fromHSV(H, 1, 1)

        svMarker.Position = UDim2.new(S, 0, 1 - V, 0)
        hueMarker.Position = UDim2.new(1 - H, 0, 0.5, 0)

        rBox.Text = tostring(math.round(currentColor.R * 255))
        gBox.Text = tostring(math.round(currentColor.G * 255))
        bBox.Text = tostring(math.round(currentColor.B * 255))
        hexBox.Text = string.format("%02X%02X%02X", math.round(currentColor.R * 255), math.round(currentColor.G * 255), math.round(currentColor.B * 255))

        colorBtn.BackgroundColor3 = currentColor

        if triggerCallback and options.Callback then
            task.spawn(options.Callback, currentColor)
        end
    end

    -- SISTEMA EXATO PARA TOUCH/MOBILE E PC SEM DESVIOS
    local svSliding = false
    local currentSvInput = nil

    svMap.InputBegan:Connect(function(input)
        if lockOverlay.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            svSliding = true
            currentSvInput = input
            S = math.clamp((input.Position.X - svMap.AbsolutePosition.X) / svMap.AbsoluteSize.X, 0, 1)
            V = 1 - math.clamp((input.Position.Y - svMap.AbsolutePosition.Y) / svMap.AbsoluteSize.Y, 0, 1)
            updateVisuals(true)
        end
    end)

    local hueSliding = false
    local currentHueInput = nil

    hueSlider.InputBegan:Connect(function(input)
        if lockOverlay.Visible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hueSliding = true
            currentHueInput = input
            H = 1 - math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
            updateVisuals(true)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if svSliding and input == currentSvInput then
            S = math.clamp((input.Position.X - svMap.AbsolutePosition.X) / svMap.AbsoluteSize.X, 0, 1)
            V = 1 - math.clamp((input.Position.Y - svMap.AbsolutePosition.Y) / svMap.AbsoluteSize.Y, 0, 1)
            updateVisuals(true)
        elseif hueSliding and input == currentHueInput then
            H = 1 - math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
            updateVisuals(true)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input == currentSvInput then
            svSliding = false
            currentSvInput = nil
        elseif input == currentHueInput then
            hueSliding = false
            currentHueInput = nil
        end
    end)

    local function rgbChanged()
        local r = tonumber(rBox.Text) or math.round(currentColor.R * 255)
        local g = tonumber(gBox.Text) or math.round(currentColor.G * 255)
        local b = tonumber(bBox.Text) or math.round(currentColor.B * 255)
        currentColor = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255))
        H, S, V = currentColor:ToHSV()
        updateVisuals(true)
    end
    rBox.FocusLost:Connect(rgbChanged)
    gBox.FocusLost:Connect(rgbChanged)
    bBox.FocusLost:Connect(rgbChanged)

    hexBox.FocusLost:Connect(function()
        local hex = hexBox.Text:gsub("#", "")
        local r, g, b = hex:match("(%x%x)(%x%x)(%x%x)")
        if r and g and b then
            currentColor = Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
            H, S, V = currentColor:ToHSV()
            updateVisuals(true)
        else
            updateVisuals(false)
        end
    end)

    colorBtn.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        isOpen = not isOpen
        
        if isOpen then
            expandArea.Visible = true
            svMarker.Visible = true
            hueMarker.Visible = true
        else
            svMarker.Visible = false
            hueMarker.Visible = false
        end

        local tw = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 340, 0, isOpen and 190 or 60)
        })
        tw:Play()
        
        if not isOpen then
            tw.Completed:Connect(function()
                if not isOpen then expandArea.Visible = false end
            end)
        end
    end)

    updateVisuals(false)

    return {
        SetTitle = function(t) lblTitle.Text = t end,
        SetDesc = function(d) lblDesc.Text = d end,
        Lock = function() 
            lockOverlay.Visible = true
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() 
        end,
        Unlock = function() 
            TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() 
            task.wait(0.2) 
            lockOverlay.Visible = false 
        end,
        Destroy = function() card:Destroy() end,
        Set = function(v) currentColor = v; H, S, V = currentColor:ToHSV(); updateVisuals() end,
        Get = function() return currentColor end
    }
end

return LuannyUi
