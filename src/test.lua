--[[
  _       _    _          _   _ _   _   __     __  _    _ _____ 
 | |     | |  | |   /\   | \ | | \ | |  \ \   / / | |  | |_   _|
 | |     | |  | |  /  \  |  \| |  \| |   \ \_/ /  | |  | | | |  
 | |     | |  | | / /\ \ | . ` | . ` |    \   /   | |  | | | |  
 | |____ | |__| |/ ____ \| |\  | |\  |     | |    | |__| |_| |_ 
 |______| \____//_/    \_\_| \_|_| \_|     |_|     \____/|_____|
                                                              
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

if CoreGui:FindFirstChild("LuannyNotifyScreen") then CoreGui.LuannyNotifyScreen:Destroy() end
if CoreGui:FindFirstChild("LuannyUI") then CoreGui.LuannyUI:Destroy() end

local NotifyScreen = Instance.new("ScreenGui", CoreGui)
NotifyScreen.Name = "LuannyNotifyScreen"
NotifyScreen.IgnoreGuiInset = true
NotifyScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifyContainer = Instance.new("Frame", NotifyScreen)
NotifyContainer.Size = UDim2.new(0, 320, 1, -40); NotifyContainer.Position = UDim2.new(1, -20, 0, 20); NotifyContainer.AnchorPoint = Vector2.new(1, 0); NotifyContainer.BackgroundTransparency = 1
local ListLayout = Instance.new("UIListLayout", NotifyContainer)
ListLayout.FillDirection = Enum.FillDirection.Vertical; ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right; ListLayout.Padding = UDim.new(0, 10)

local WindowConfig = { ThemeData = Themes.Dark }

function LuannyUi:Notify(options)
    local theme = WindowConfig.ThemeData or Themes.Dark
    local noticeColor = options.Color or theme.Accent
    local wrapper = Instance.new("Frame", NotifyContainer)
    wrapper.Size = UDim2.new(0, 300, 0, options.Buttons and 100 or 65); wrapper.BackgroundTransparency = 1

    local card = Instance.new("CanvasGroup", wrapper)
    card.Size = UDim2.new(1, 0, 1, 0); card.Position = UDim2.new(0, 50, 0, 0); card.BackgroundColor3 = theme.Card; card.GroupTransparency = 1
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local textRightOffset = options.Icon and 38 or 12
    if options.Icon then
        local ic = Instance.new("ImageLabel", card)
        ic.Size = UDim2.new(0, 20, 0, 20); ic.AnchorPoint = Vector2.new(1, 0); ic.Position = UDim2.new(1, -12, 0, 12); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon] or ""; ic.ImageColor3 = noticeColor
    end

    local lblTitle = Instance.new("TextLabel", card)
    lblTitle.Size = UDim2.new(1, -(textRightOffset + 12), 0, 18); lblTitle.Position = UDim2.new(0, 12, 0, 12); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Notification"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontTitle; lblTitle.TextSize = 13; lblTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local lblDesc = Instance.new("TextLabel", card)
    lblDesc.Size = UDim2.new(1, -(textRightOffset + 12), 0, 30); lblDesc.Position = UDim2.new(0, 12, 0, 30); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 12; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top

    local progressBar = Instance.new("Frame", card)
    progressBar.Size = UDim2.new(1, 0, 0, 2); progressBar.Position = UDim2.new(0, 0, 1, -2); progressBar.BackgroundColor3 = noticeColor; progressBar.BorderSizePixel = 0

    local isClosed = false
    local function closeNotification()
        if isClosed then return end
        isClosed = true
        local tw = TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1, Position = UDim2.new(0, 50, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() wrapper:Destroy() end)
    end

    if options.Buttons and #options.Buttons > 0 then
        local btnContainer = Instance.new("Frame", card)
        btnContainer.Size = UDim2.new(1, -24, 0, 28); btnContainer.Position = UDim2.new(0, 12, 0, 58); btnContainer.BackgroundTransparency = 1
        local btnLayout = Instance.new("UIListLayout", btnContainer)
        btnLayout.FillDirection = Enum.FillDirection.Horizontal; btnLayout.Padding = UDim.new(0, 6)
        
        for _, btnData in ipairs(options.Buttons) do
            local btn = Instance.new("TextButton", btnContainer)
            btn.Size = UDim2.new(1 / #options.Buttons, -((6 * (#options.Buttons - 1)) / #options.Buttons), 1, 0); btn.BackgroundColor3 = theme.Hover; btn.Text = btnData.Title or "Button"; btn.TextColor3 = theme.Text; btn.FontFace = FontUI; btn.TextSize = 12; btn.AutoButtonColor = false
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            Instance.new("UIStroke", btn).Color = theme.Stroke
            btn.MouseButton1Click:Connect(function() if btnData.Callback then task.spawn(btnData.Callback) end closeNotification() end)
        end
    end

    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0)}):Play()
    TweenService:Create(progressBar, TweenInfo.new(options.Duration or 5, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    task.delay(options.Duration or 5, closeNotification)
end

function LuannyUi:SetFont(fontAsset)
    if typeof(fontAsset) == "string" then
        FontUI = Font.new(fontAsset, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        FontTitle = Font.new(fontAsset, Enum.FontWeight.Bold, Enum.FontStyle.Normal)
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

local function RegisterText(element) table.insert(AllTextElements, element) end
local function CreateLockOverlay(parent)
    local lock = Instance.new("Frame", parent)
    lock.Size = UDim2.new(1, 0, 1, 0); lock.BackgroundColor3 = Color3.fromRGB(10, 10, 12); lock.BackgroundTransparency = 1; lock.ZIndex = 20; lock.Visible = false
    Instance.new("UICorner", lock).CornerRadius = UDim.new(0, 8)
    return lock
end

local function UpdateToolbarWidth()
    if not Toolbar then return end
    local totalWidth = DockContainer.Size.X.Offset + (IsExpanded and 118 or 16)
    if IsExpanded then InfoContainer.Visible = true end
    TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, totalWidth, 0, 45)}):Play()
    local tw = TweenService:Create(InfoContainer, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, IsExpanded and 110 or 0, 1, 0)})
    tw:Play()
    if not IsExpanded then tw.Completed:Connect(function() if not IsExpanded then InfoContainer.Visible = false end end) end
end

local function ToggleWindow(target, windowHeight)
    local innerFrame = target:FindFirstChildOfClass("CanvasGroup")
    if CurrentWindow == target then
        TweenService:Create(Overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
        if innerFrame then
            local tw = TweenService:Create(innerFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {GroupTransparency = 1, Size = UDim2.new(0, 380, 0, windowHeight - 15)})
            tw:Play()
            tw.Completed:Connect(function() target.Visible = false end)
        else
            target.Visible = false
        end
        CurrentWindow = nil
    else
        if CurrentWindow then 
            local old = CurrentWindow:FindFirstChildOfClass("CanvasGroup")
            if old then old.GroupTransparency = 1 end
            CurrentWindow.Visible = false
        end
        target.Size = UDim2.new(0, 380, 0, windowHeight)
        target.Visible = true
        CurrentWindow = target
        TweenService:Create(Overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = WindowConfig.Transparent and 0.4 or 0.6}):Play()
        if innerFrame then
            innerFrame.Size = UDim2.new(0, 380, 0, windowHeight - 15)
            innerFrame.GroupTransparency = 1
            TweenService:Create(innerFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {GroupTransparency = 0, Size = UDim2.new(0, 380, 0, windowHeight)}):Play()
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
        ShowWindow = config.ShowWindow == nil and true or config.ShowWindow,
        ThemeData = Themes[config.Theme] or Themes.Dark
    }
    local theme = WindowConfig.ThemeData

    ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "LuannyUI"
    ScreenGui.IgnoreGuiInset = true

    Overlay = Instance.new("Frame", ScreenGui)
    Overlay.Size = UDim2.new(1, 0, 1, 0); Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0); Overlay.BackgroundTransparency = 1; Overlay.ZIndex = 1

    Toolbar = Instance.new("Frame", ScreenGui)
    Toolbar.Size = UDim2.new(0, 16, 0, 45); Toolbar.AnchorPoint = Vector2.new(0.5, 1); Toolbar.Position = WindowConfig.ShowWindow and UDim2.new(0.5, 0, 1, -20) or UDim2.new(0.5, 0, 1, 60); Toolbar.BackgroundColor3 = theme.Bg; Toolbar.BackgroundTransparency = WindowConfig.Transparent and 0.25 or 0; Toolbar.ZIndex = 5; Toolbar.ClipsDescendants = false
    Instance.new("UICorner", Toolbar).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Toolbar).Color = theme.Stroke

    MainContent = Instance.new("Frame", Toolbar)
    MainContent.Size = UDim2.new(1, 0, 1, 0); MainContent.BackgroundTransparency = 1; MainContent.ClipsDescendants = true; MainContent.ZIndex = 6
    Instance.new("UICorner", MainContent).CornerRadius = UDim.new(0, 12)
    local lm = Instance.new("UIListLayout", MainContent); lm.FillDirection = Enum.FillDirection.Horizontal; lm.VerticalAlignment = Enum.VerticalAlignment.Center; lm.Padding = UDim.new(0, 8)
    Instance.new("UIPadding", MainContent).PaddingLeft = UDim.new(0, 8)

    DockContainer = Instance.new("Frame", MainContent)
    DockContainer.Size = UDim2.new(0, 0, 1, 0); DockContainer.BackgroundTransparency = 1; DockContainer.ZIndex = 7
    local dl = Instance.new("UIListLayout", DockContainer); dl.FillDirection = Enum.FillDirection.Horizontal; dl.VerticalAlignment = Enum.VerticalAlignment.Center; dl.Padding = UDim.new(0, 8)
    dl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() DockContainer.Size = UDim2.new(0, dl.AbsoluteContentSize.X, 1, 0); UpdateToolbarWidth() end)

    InfoContainer = Instance.new("Frame", MainContent)
    InfoContainer.Size = UDim2.new(0, 0, 1, 0); InfoContainer.BackgroundTransparency = 1; InfoContainer.ClipsDescendants = true; InfoContainer.Visible = false; InfoContainer.LayoutOrder = 2; InfoContainer.ZIndex = 7
    local il = Instance.new("UIListLayout", InfoContainer); il.FillDirection = Enum.FillDirection.Vertical; il.HorizontalAlignment = Enum.HorizontalAlignment.Right; il.VerticalAlignment = Enum.VerticalAlignment.Center; il.Padding = UDim.new(0, 2)
    Instance.new("UIPadding", InfoContainer).PaddingRight = UDim.new(0, 5)

    local lblT = Instance.new("TextLabel", InfoContainer); lblT.Size = UDim2.new(1, 0, 0, 16); lblT.BackgroundTransparency = 1; lblT.Text = WindowConfig.Title; lblT.TextColor3 = theme.Text; lblT.FontFace = FontUI; lblT.TextSize = 15; lblT.TextXAlignment = Enum.TextXAlignment.Right; lblT.ZIndex = 10; RegisterText(lblT)
    local lblA = Instance.new("TextLabel", InfoContainer); lblA.Size = UDim2.new(1, 0, 0, 12); lblA.BackgroundTransparency = 1; lblA.Text = WindowConfig.Author; lblA.TextColor3 = theme.SubText; lblA.FontFace = FontUI; lblA.TextSize = 11; lblA.TextXAlignment = Enum.TextXAlignment.Right; lblA.ZIndex = 10; RegisterText(lblA)

    ExpandBtn = Instance.new("ImageButton", Toolbar)
    ExpandBtn.Size = UDim2.new(0, 24, 0, 24); ExpandBtn.AnchorPoint = Vector2.new(0, 0.5); ExpandBtn.Position = UDim2.new(1, 6, 0.5, 0); ExpandBtn.BackgroundTransparency = 1; ExpandBtn.Image = Icons["chevron-right"]; ExpandBtn.ImageColor3 = theme.Text; ExpandBtn.ZIndex = 6
    ExpandBtn.MouseButton1Click:Connect(function() IsExpanded = not IsExpanded; ExpandBtn.Image = IsExpanded and Icons["chevron-left"] or Icons["chevron-right"]; UpdateToolbarWidth() end)

    local BtnToggle = Instance.new("ImageButton", Toolbar)
    BtnToggle.Size = UDim2.new(0, 24, 0, 24); BtnToggle.AnchorPoint = Vector2.new(0.5, 1); BtnToggle.Position = UDim2.new(0.5, 0, 0, -6); BtnToggle.BackgroundTransparency = 1; BtnToggle.Image = WindowConfig.ShowWindow and Icons["chevron-down"] or Icons["chevron-up"]; BtnToggle.ImageColor3 = theme.Text; BtnToggle.ZIndex = 6
    BtnToggle.MouseButton1Click:Connect(function()
        IsBarVisible = not IsBarVisible
        BtnToggle.Image = IsBarVisible and Icons["chevron-down"] or Icons["chevron-up"]
        TweenService:Create(Toolbar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = IsBarVisible and UDim2.new(0.5, 0, 1, -20) or UDim2.new(0.5, 0, 1, 60)}):Play()
        if not IsBarVisible and CurrentWindow then ToggleWindow(CurrentWindow, CurrentWindow:GetAttribute("Height") or 350) end
    end)

    return self
end

local TabClass = {}
TabClass.__index = TabClass

function LuannyUi:Tab(options)
    if not Initialized then self:CreateWindow({}) end
    LayoutOrderCount = LayoutOrderCount + 1
    local theme = WindowConfig.ThemeData
    local windowHeight = options.Height or 350

    local btn = Instance.new("TextButton", DockContainer)
    btn.Size = UDim2.new(0, 32, 0, 32); btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255); btn.Text = ""; btn.LayoutOrder = LayoutOrderCount; btn.ZIndex = 8
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local c = options.Color or theme.Accent
    local grad = Instance.new("UIGradient", btn); grad.Rotation = 45; grad.Color = typeof(c) == "ColorSequence" and c or ColorSequence.new(Color3.new(c.R*0.5, c.G*0.5, c.B*0.5), c)
    
    local ic = Instance.new("ImageLabel", btn); ic.Size = UDim2.new(0, 18, 0, 18); ic.AnchorPoint = Vector2.new(0.5, 0.5); ic.Position = UDim2.new(0.5, 0, 0.5, 0); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon or "layout-grid"]; ic.ImageColor3 = Color3.fromRGB(255,255,255); ic.ZIndex = 9

    local maskFrame = Instance.new("Frame", ScreenGui)
    maskFrame.AnchorPoint = Vector2.new(0.5, 1); maskFrame.Position = UDim2.new(0.5, 0, 1, -72); maskFrame.Size = UDim2.new(0, 380, 0, windowHeight); maskFrame.BackgroundTransparency = 1; maskFrame.ClipsDescendants = true; maskFrame.Visible = false; maskFrame.ZIndex = 10; maskFrame:SetAttribute("Height", windowHeight)
    
    local frame = Instance.new("CanvasGroup", maskFrame)
    frame.AnchorPoint = Vector2.new(0.5, 1); frame.Position = UDim2.new(0.5, 0, 1, 0); frame.Size = UDim2.new(0, 380, 0, windowHeight); frame.BackgroundColor3 = theme.Bg; frame.BackgroundTransparency = WindowConfig.Transparent and 0.15 or 0; frame.ZIndex = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", frame).Color = theme.Stroke
    
    local tl = Instance.new("TextLabel", frame); tl.Size = UDim2.new(1, 0, 0, 45); tl.BackgroundTransparency = 1; tl.Text = options.Title or "Tab"; tl.TextColor3 = theme.Text; tl.FontFace = FontUI; tl.TextSize = 22; tl.ZIndex = 11; RegisterText(tl)

    local container = Instance.new("ScrollingFrame", frame)
    container.Size = UDim2.new(1, 0, 1, -50); container.Position = UDim2.new(0, 0, 0, 45); container.BackgroundTransparency = 1; container.ScrollBarThickness = 0; container.ZIndex = 11
    local layout = Instance.new("UIListLayout", container); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 8)
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 5)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) end)
    btn.MouseButton1Click:Connect(function() ToggleWindow(maskFrame, windowHeight) end)

    local TabData = {Container = container, ItemCount = 0}
    setmetatable(TabData, TabClass)
    return TabData
end

function TabClass:Section(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local sec = Instance.new("Frame", self.Container); sec.Size = UDim2.new(0, 340, 0, 30); sec.BackgroundTransparency = 1; sec.LayoutOrder = self.ItemCount
    local lbl = Instance.new("TextLabel", sec); lbl.Size = UDim2.new(1, -10, 1, 0); lbl.Position = UDim2.new(0, 5, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = options.Title or "Section"; lbl.TextColor3 = theme.Text; lbl.FontFace = FontTitle; lbl.TextSize = 14; lbl.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lbl)
    local line = Instance.new("Frame", sec); line.Size = UDim2.new(1, 0, 0, 1); line.Position = UDim2.new(0, 0, 1, -1); line.BackgroundColor3 = theme.Stroke
    return { SetTitle = function(t) lbl.Text = t end, Destroy = function() sec:Destroy() end }
end

function TabClass:Button(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData

    local card = Instance.new("TextButton", self.Container)
    card.Size = UDim2.new(0, 340, 0, 55); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.Text = ""; card.AutoButtonColor = false; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", card); stroke.Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)
    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -20, 0, 18); lblTitle.Position = UDim2.new(0, 10, 0, 8); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Button"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -20, 0, 16); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.ZIndex = 13; RegisterText(lblDesc)
    local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 16, 0, 16); ic.AnchorPoint = Vector2.new(1, 0.5); ic.Position = UDim2.new(1, -10, 0.5, 0); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon or "mouse-pointer-click"]; ic.ImageColor3 = theme.Text; ic.ZIndex = 13

    card.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        local tw = TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = theme.Hover}); tw:Play()
        tw.Completed:Connect(function() TweenService:Create(card, TweenInfo.new(0.1), {BackgroundColor3 = theme.Card}):Play() end)
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
    local theme = WindowConfig.ThemeData
    local state = options.Value or false
    local isCheckbox = options.Type == "Checkbox"

    local card = Instance.new("TextButton", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.Text = ""; card.AutoButtonColor = false; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)
    local offset = options.Icon and 35 or 10
    if options.Icon then
        local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon] or ""; ic.ImageColor3 = theme.Text; ic.ZIndex = 13
    end

    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -(offset + 50), 0, 16); lblTitle.Position = UDim2.new(0, offset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Toggle"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; lblDesc.ZIndex = 13; RegisterText(lblDesc)

    local switchBg = Instance.new("Frame", card); switchBg.AnchorPoint = Vector2.new(1, 0.5); switchBg.Position = UDim2.new(1, -10, 0.5, 0); switchBg.ZIndex = 14
    local checkMark, circle

    if isCheckbox then
        switchBg.Size = UDim2.new(0, 22, 0, 22); switchBg.BackgroundColor3 = state and theme.Accent or theme.Hover
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(0, 6)
        checkMark = Instance.new("ImageLabel", switchBg); checkMark.Size = UDim2.new(0, 16, 0, 16); checkMark.AnchorPoint = Vector2.new(0.5, 0.5); checkMark.Position = UDim2.new(0.5, 0, 0.5, 0); checkMark.BackgroundTransparency = 1; checkMark.Image = Icons["check"]; checkMark.ImageTransparency = state and 0 or 1; checkMark.ZIndex = 15
    else
        switchBg.Size = UDim2.new(0, 32, 0, 18); switchBg.BackgroundColor3 = state and theme.Accent or theme.Hover
        Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
        circle = Instance.new("Frame", switchBg); circle.Size = UDim2.new(0, 14, 0, 14); circle.AnchorPoint = Vector2.new(0, 0.5); circle.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); circle.ZIndex = 15
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    end

    local function updateVisual()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and theme.Accent or theme.Hover}):Play()
        if isCheckbox then TweenService:Create(checkMark, TweenInfo.new(0.2), {ImageTransparency = state and 0 or 1}):Play()
        else TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play() end
    end

    card.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        state = not state; updateVisual()
        if options.Callback then task.spawn(options.Callback, state) end
    end)

    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end, SetValue = function(v) state = v; updateVisual() end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end, Get = function() return state end
    }
end

function TabClass:Input(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local isTextarea = options.Type == "Textarea"
    
    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, isTextarea and 90 or 65); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke
    
    local lockOverlay = CreateLockOverlay(card)
    local offset = options.InputIcon and 35 or 10
    if options.InputIcon then
        local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.InputIcon]; ic.ImageColor3 = theme.Text
    end
    
    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -150, 0, 16); lblTitle.Position = UDim2.new(0, offset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Input"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -150, 0, 16); lblDesc.Position = UDim2.new(0, offset, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblDesc)
    
    local boxBg = Instance.new("Frame", card)
    boxBg.Size = isTextarea and UDim2.new(1, -20, 0, 40) or UDim2.new(0, 130, 0, 32); boxBg.AnchorPoint = isTextarea and Vector2.new(0, 0) or Vector2.new(1, 0.5); boxBg.Position = isTextarea and UDim2.new(0, 10, 0, 45) or UDim2.new(1, -10, 0.5, 0); boxBg.BackgroundColor3 = theme.Bg
    Instance.new("UICorner", boxBg).CornerRadius = UDim.new(0, 6)
    local boxStroke = Instance.new("UIStroke", boxBg); boxStroke.Color = theme.Stroke
    
    local box = Instance.new("TextBox", boxBg)
    box.Size = UDim2.new(1, -16, 1, 0); box.Position = UDim2.new(0, 8, 0, 0); box.BackgroundTransparency = 1; box.Text = options.Value or ""; box.PlaceholderText = options.Placeholder or ""; box.TextColor3 = theme.Text; box.PlaceholderColor3 = theme.SubText; box.FontFace = FontUI; box.TextSize = 12; box.TextWrapped = isTextarea; box.ClearTextOnFocus = not isTextarea; box.TextXAlignment = isTextarea and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center; box.TextYAlignment = isTextarea and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center; RegisterText(box)
    
    box.Focused:Connect(function() TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = theme.Accent}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = theme.Stroke}):Play()
        if lockOverlay.Visible then return end
        if options.Callback then task.spawn(options.Callback, box.Text) end
    end)
    
    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end, SetPlaceholder = function(p) box.PlaceholderText = p end, SetValue = function(v) box.Text = v end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end,
        Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end,
        Destroy = function() card:Destroy() end, Get = function() return box.Text end
    }
end

function TabClass:Slider(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    
    local step = options.Step or 1
    local minVal = options.Value.Min or 0
    local maxVal = options.Value.Max or 100
    local currentVal = options.Value.Default or minVal

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 70); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)

    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -100, 0, 16); lblTitle.Position = UDim2.new(0, 12, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Slider"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -100, 0, 16); lblDesc.Position = UDim2.new(0, 12, 0, 26); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblDesc)

    local valBox = Instance.new("TextBox", card)
    valBox.Size = UDim2.new(0, 45, 0, 22); valBox.Position = UDim2.new(1, -57, 0, 12); valBox.BackgroundColor3 = theme.Hover; valBox.TextColor3 = theme.Text; valBox.Text = tostring(currentVal); valBox.FontFace = FontUI; valBox.TextSize = 12; valBox.BorderSizePixel = 0; valBox.ClearTextOnFocus = false
    Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)

    local slideTrack = Instance.new("TextButton", card)
    slideTrack.Size = UDim2.new(1, -24, 0, 8); slideTrack.Position = UDim2.new(0, 12, 0, 50); slideTrack.BackgroundColor3 = theme.Bg; slideTrack.Text = ""; slideTrack.AutoButtonColor = false; slideTrack.BorderSizePixel = 0
    Instance.new("UICorner", slideTrack).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", slideTrack).Color = theme.Stroke

    local slideFill = Instance.new("Frame", slideTrack)
    slideFill.Size = UDim2.new(0, 0, 1, 0); slideFill.BackgroundColor3 = theme.Accent; slideFill.BorderSizePixel = 0
    Instance.new("UICorner", slideFill).CornerRadius = UDim.new(1, 0)

    local slideCircle = Instance.new("Frame", slideFill)
    slideCircle.Size = UDim2.new(0, 16, 0, 16); slideCircle.AnchorPoint = Vector2.new(0.5, 0.5); slideCircle.Position = UDim2.new(1, 0, 0.5, 0); slideCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); slideCircle.BorderSizePixel = 0
    Instance.new("UICorner", slideCircle).CornerRadius = UDim.new(1, 0)
    local circleStroke = Instance.new("UIStroke", slideCircle); circleStroke.Color = theme.Stroke

    local sliding = false
    local function updateValue(rawVal, animate)
        local clamped = math.clamp(rawVal, minVal, maxVal)
        currentVal = math.clamp(math.round((clamped - minVal) / step) * step + minVal, minVal, maxVal)
        valBox.Text = tostring(currentVal)
        local percent = (currentVal - minVal) / (maxVal - minVal)
        if animate then TweenService:Create(slideFill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play() else slideFill.Size = UDim2.new(percent, 0, 1, 0) end
        if options.Callback then task.spawn(options.Callback, currentVal) end
    end

    local function updateFromMouse()
        if lockOverlay.Visible then return end
        local mousePos = UserInputService:GetMouseLocation().X
        updateValue(minVal + (math.clamp((mousePos - slideTrack.AbsolutePosition.X) / slideTrack.AbsoluteSize.X, 0, 1) * (maxVal - minVal)), false)
    end

    slideTrack.InputBegan:Connect(function(input) if not lockOverlay.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true; updateFromMouse() end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then updateFromMouse() end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    valBox.FocusLost:Connect(function() local num = tonumber(valBox.Text); if num then updateValue(num, true) else valBox.Text = tostring(currentVal) end end)
    updateValue(currentVal, false)

    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end, SetMin = function(m) minVal = m; updateValue(currentVal, true) end, SetMax = function(m) maxVal = m; updateValue(currentVal, true) end, SetValue = function(v) updateValue(v, true) end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end, Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end, Destroy = function() card:Destroy() end, Get = function() return currentVal end
    }
end

function TabClass:Dropdown(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local optionList = options.Options or {}
    local currentValue = options.Value or (optionList[1] or "...")
    local isOpen = false

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.ClipsDescendants = true; card.LayoutOrder = self.ItemCount; card.ZIndex = 12
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)
    local offset = options.Icon and 35 or 10
    if options.Icon then
        local ic = Instance.new("ImageLabel", card); ic.Size = UDim2.new(0, 18, 0, 18); ic.Position = UDim2.new(0, 10, 0, 10); ic.BackgroundTransparency = 1; ic.Image = Icons[options.Icon] or ""; ic.ImageColor3 = theme.Text; ic.ZIndex = 13
    end

    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -(offset + 120), 0, 16); lblTitle.Position = UDim2.new(0, offset, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Dropdown"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; lblTitle.ZIndex = 13; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; lblDesc.ZIndex = 13; RegisterText(lblDesc)

    local selectBtn = Instance.new("TextButton", card)
    selectBtn.Size = UDim2.new(0, 110, 0, 24); selectBtn.AnchorPoint = Vector2.new(1, 0); selectBtn.Position = UDim2.new(1, -10, 0, 6); selectBtn.BackgroundColor3 = theme.Hover; selectBtn.Text = "  " .. currentValue; selectBtn.TextColor3 = theme.Text; selectBtn.FontFace = FontUI; selectBtn.TextSize = 12; selectBtn.TextXAlignment = Enum.TextXAlignment.Left; selectBtn.ZIndex = 14
    Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)

    local arrow = Instance.new("ImageLabel", selectBtn)
    arrow.Size = UDim2.new(0, 14, 0, 14); arrow.AnchorPoint = Vector2.new(1, 0.5); arrow.Position = UDim2.new(1, -5, 0.5, 0); arrow.BackgroundTransparency = 1; arrow.Image = Icons["chevron-down"]; arrow.ImageColor3 = theme.Text; arrow.ZIndex = 15

    local listFrame = Instance.new("ScrollingFrame", card)
    listFrame.Size = UDim2.new(1, -20, 0, 0); listFrame.Position = UDim2.new(0, 10, 0, 60); listFrame.BackgroundTransparency = 1; listFrame.ScrollBarThickness = 2; listFrame.ZIndex = 14
    local listLayout = Instance.new("UIListLayout", listFrame); listLayout.SortOrder = Enum.SortOrder.LayoutOrder; listLayout.Padding = UDim.new(0, 4)

    for _, optName in ipairs(optionList) do
        local optBtn = Instance.new("TextButton", listFrame)
        optBtn.Size = UDim2.new(1, -8, 0, 25); optBtn.BackgroundColor3 = theme.Bg; optBtn.Text = "  " .. optName; optBtn.TextColor3 = theme.Text; optBtn.FontFace = FontUI; optBtn.TextSize = 13; optBtn.TextXAlignment = Enum.TextXAlignment.Left; optBtn.ZIndex = 15
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
        optBtn.MouseButton1Click:Connect(function()
            if lockOverlay.Visible then return end
            currentValue = optName; selectBtn.Text = "  " .. currentValue; isOpen = false
            TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, 60)}):Play()
            if options.Callback then task.spawn(options.Callback, currentValue) end
        end)
    end

    selectBtn.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        isOpen = not isOpen
        local h = isOpen and math.min(60 + (#optionList * 29), 160) or 60
        listFrame.Size = UDim2.new(1, -20, 0, h - 65); listFrame.CanvasSize = UDim2.new(0, 0, 0, #optionList * 29)
        TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isOpen and 180 or 0}):Play()
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, h)}):Play()
    end)

    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end, Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end, Destroy = function() card:Destroy() end, Set = function(v) currentValue = v; selectBtn.Text = "  " .. v end, Get = function() return currentValue end
    }
end

function TabClass:ColorPicker(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local currentColor = options.Value or Color3.fromRGB(255, 255, 255)
    local isOpen = false

    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, 60); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.ClipsDescendants = true; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", card).Color = theme.Stroke

    local lockOverlay = CreateLockOverlay(card)
    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -80, 0, 16); lblTitle.Position = UDim2.new(0, 10, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "ColorPicker"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -80, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; RegisterText(lblDesc)

    local colorBtn = Instance.new("TextButton", card)
    colorBtn.Size = UDim2.new(0, 45, 0, 24); colorBtn.AnchorPoint = Vector2.new(1, 0); colorBtn.Position = UDim2.new(1, -10, 0, 6); colorBtn.BackgroundColor3 = currentColor; colorBtn.Text = ""; colorBtn.AutoButtonColor = false
    Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", colorBtn).Color = theme.Stroke

    local expandArea = Instance.new("Frame", card)
    expandArea.Size = UDim2.new(1, -20, 0, 100); expandArea.Position = UDim2.new(0, 10, 0, 60); expandArea.BackgroundTransparency = 1

    local function createColorSlider(labelTxt, yPos, colorRGB)
        local lbl = Instance.new("TextLabel", expandArea); lbl.Size = UDim2.new(0, 15, 0, 15); lbl.Position = UDim2.new(0, 0, 0, yPos); lbl.BackgroundTransparency = 1; lbl.Text = labelTxt; lbl.TextColor3 = theme.Text; lbl.FontFace = FontTitle; lbl.TextSize = 13
        local track = Instance.new("TextButton", expandArea); track.Size = UDim2.new(1, -25, 0, 8); track.Position = UDim2.new(0, 25, 0, yPos + 4); track.BackgroundColor3 = theme.Bg; track.Text = ""; track.AutoButtonColor = false
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local fill = Instance.new("Frame", track); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = colorRGB
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
        local circle = Instance.new("Frame", fill); circle.Size = UDim2.new(0, 14, 0, 14); circle.AnchorPoint = Vector2.new(0.5, 0.5); circle.Position = UDim2.new(1, 0, 0.5, 0); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        return track, fill
    end

    local rTrack, rFill = createColorSlider("R", 0, Color3.fromRGB(255, 75, 75))
    local gTrack, gFill = createColorSlider("G", 25, Color3.fromRGB(75, 255, 75))
    local bTrack, bFill = createColorSlider("B", 50, Color3.fromRGB(75, 75, 255))
    
    local hexBox = Instance.new("TextBox", expandArea)
    hexBox.Size = UDim2.new(1, 0, 0, 24); hexBox.Position = UDim2.new(0, 0, 0, 75); hexBox.BackgroundColor3 = theme.Bg; hexBox.TextColor3 = theme.Text; hexBox.FontFace = FontUI; hexBox.TextSize = 12; hexBox.ClearTextOnFocus = false
    Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", hexBox).Color = theme.Stroke

    local function updateVisuals()
        colorBtn.BackgroundColor3 = currentColor
        rFill.Size = UDim2.new(currentColor.R, 0, 1, 0)
        gFill.Size = UDim2.new(currentColor.G, 0, 1, 0)
        bFill.Size = UDim2.new(currentColor.B, 0, 1, 0)
        hexBox.Text = string.format("#%02X%02X%02X", currentColor.R * 255, currentColor.G * 255, currentColor.B * 255)
        if options.Callback then task.spawn(options.Callback, currentColor) end
    end

    local function handleSlider(track, colorKey)
        local sliding = false
        track.InputBegan:Connect(function(input) if not lockOverlay.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
        UserInputService.InputChanged:Connect(function(input)
            if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pct = math.clamp((UserInputService:GetMouseLocation().X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                if colorKey == "R" then currentColor = Color3.new(pct, currentColor.G, currentColor.B)
                elseif colorKey == "G" then currentColor = Color3.new(currentColor.R, pct, currentColor.B)
                else currentColor = Color3.new(currentColor.R, currentColor.G, pct) end
                updateVisuals()
            end
        end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
    end

    handleSlider(rTrack, "R"); handleSlider(gTrack, "G"); handleSlider(bTrack, "B")

    hexBox.FocusLost:Connect(function()
        local r, g, b = hexBox.Text:match("#?(%x%x)(%x%x)(%x%x)")
        if r and g and b then currentColor = Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)); updateVisuals() else updateVisuals() end
    end)

    colorBtn.MouseButton1Click:Connect(function()
        if lockOverlay.Visible then return end
        isOpen = not isOpen
        TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 340, 0, isOpen and 175 or 60)}):Play()
    end)

    updateVisuals()

    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end, Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end, Destroy = function() card:Destroy() end, Set = function(v) currentColor = v; updateVisuals() end, Get = function() return currentColor end
    }
end

function TabClass:Paragraph(options)
    self.ItemCount = self.ItemCount + 1
    local theme = WindowConfig.ThemeData
    local btns = options.Buttons or {}
    
    local card = Instance.new("Frame", self.Container)
    card.Size = UDim2.new(0, 340, 0, #btns > 0 and 95 or 65); card.BackgroundColor3 = theme.Card; card.BackgroundTransparency = WindowConfig.Transparent and 0.2 or 0; card.LayoutOrder = self.ItemCount
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    
    local lockOverlay = CreateLockOverlay(card)
    if options.Locked then lockOverlay.Visible = true; lockOverlay.BackgroundTransparency = 0.5 end

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = options.Color == "Red" and Color3.fromRGB(255, 50, 50) or theme.Stroke

    local lblTitle = Instance.new("TextLabel", card); lblTitle.Size = UDim2.new(1, -20, 0, 16); lblTitle.Position = UDim2.new(0, 10, 0, 10); lblTitle.BackgroundTransparency = 1; lblTitle.Text = options.Title or "Paragraph"; lblTitle.TextColor3 = theme.Text; lblTitle.FontFace = FontUI; lblTitle.TextSize = 14; lblTitle.TextXAlignment = Enum.TextXAlignment.Left; RegisterText(lblTitle)
    local lblDesc = Instance.new("TextLabel", card); lblDesc.Size = UDim2.new(1, -20, 0, 28); lblDesc.Position = UDim2.new(0, 10, 0, 28); lblDesc.BackgroundTransparency = 1; lblDesc.Text = options.Desc or ""; lblDesc.TextColor3 = theme.SubText; lblDesc.FontFace = FontUI; lblDesc.TextSize = 11; lblDesc.TextWrapped = true; lblDesc.TextXAlignment = Enum.TextXAlignment.Left; lblDesc.TextYAlignment = Enum.TextYAlignment.Top; RegisterText(lblDesc)
    
    if #btns > 0 then
        local btnContainer = Instance.new("Frame", card)
        btnContainer.Size = UDim2.new(1, -20, 0, 28); btnContainer.Position = UDim2.new(0, 10, 0, 60); btnContainer.BackgroundTransparency = 1
        local layout = Instance.new("UIListLayout", btnContainer); layout.FillDirection = Enum.FillDirection.Horizontal; layout.Padding = UDim.new(0, 6)
        
        for _, btnData in ipairs(btns) do
            local pBtn = Instance.new("TextButton", btnContainer)
            pBtn.Size = UDim2.new(1 / #btns, -6 + (6/#btns), 1, 0); pBtn.BackgroundColor3 = theme.Hover; pBtn.Text = btnData.Title or "Button"; pBtn.TextColor3 = theme.Text; pBtn.FontFace = FontUI; pBtn.TextSize = 12
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
            pBtn.MouseButton1Click:Connect(function() if not lockOverlay.Visible and btnData.Callback then task.spawn(btnData.Callback) end end)
        end
    end

    return {
        SetTitle = function(t) lblTitle.Text = t end, SetDesc = function(d) lblDesc.Text = d end,
        Lock = function() lockOverlay.Visible = true; TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end, Unlock = function() TweenService:Create(lockOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() task.wait(0.2) lockOverlay.Visible = false end, Destroy = function() card:Destroy() end
    }
end

return LuannyUi
