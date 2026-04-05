-- ╔═══════════════════════════════════════════╗
-- ║   TayUI.lua — Tày Hub UI Library          ║
-- ║   Style: Teddy Hub  |  v1.0               ║
-- ╚═══════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

-- ══════════════════════════
-- COLORS
-- ══════════════════════════
local C = {
    BG        = Color3.fromRGB(13, 13, 18),
    Panel     = Color3.fromRGB(18, 18, 26),
    Sidebar   = Color3.fromRGB(15, 15, 22),
    Card      = Color3.fromRGB(24, 24, 34),
    CardHover = Color3.fromRGB(30, 30, 42),
    Accent    = Color3.fromRGB(52, 211, 153),
    AccentDim = Color3.fromRGB(18, 60, 42),
    TabSel    = Color3.fromRGB(20, 42, 32),
    Text      = Color3.fromRGB(218, 218, 230),
    TextDim   = Color3.fromRGB(100, 100, 125),
    Border    = Color3.fromRGB(35, 35, 50),
    Red       = Color3.fromRGB(255, 75, 75),
    Yellow    = Color3.fromRGB(255, 210, 0),
    Blue      = Color3.fromRGB(79, 180, 247),
    Purple    = Color3.fromRGB(180, 100, 255),
}

-- ══════════════════════════
-- INTERNAL HELPERS
-- ══════════════════════════
local function tw(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad), props):Play()
end

local function new(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(r, p)
    new("UICorner", {CornerRadius = UDim.new(0, r)}, p)
end

local function stroke(col, thick, p)
    new("UIStroke", {Color = col, Thickness = thick}, p)
end

local function makeDrag(frame, handle)
    local drag, inp, start, spos = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag  = true
            start = i.Position
            spos  = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then
            inp = i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == inp and drag then
            local d = i.Position - start
            frame.Position = UDim2.new(
                spos.X.Scale, spos.X.Offset + d.X,
                spos.Y.Scale, spos.Y.Offset + d.Y
            )
        end
    end)
end

-- ══════════════════════════
-- LIBRARY
-- ══════════════════════════
local TayUI = {}
TayUI.__index = TayUI

-- ─── CreateWindow ──────────────────────────────────────────
function TayUI:CreateWindow(opts)
    opts = opts or {}
    local title    = opts.Title   or "Tày Hub"
    local subtitle = opts.Sub     or "v1.0"
    local W        = opts.Width   or 620
    local H        = opts.Height  or 440
    local SW       = opts.Sidebar or 195

    -- Destroy old instance
    pcall(function()
        if CoreGui:FindFirstChild("TayUI_"..title) then
            CoreGui:FindFirstChild("TayUI_"..title):Destroy()
        end
    end)

    local sg = new("ScreenGui", {
        Name = "TayUI_"..title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    -- Window frame
    local win = new("Frame", {
        Size     = UDim2.new(0, W, 0, 0),
        Position = UDim2.new(0.5, -W/2, 0.5, -H/2),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, sg)
    corner(10, win)
    stroke(C.Border, 1, win)

    -- Shadow
    new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 8),
        Size     = UDim2.new(1, 50, 1, 50),
        Image    = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0,0,0),
        ImageTransparency = 0.45,
        ScaleType   = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49,49,450,450),
        ZIndex = 0,
    }, win)

    -- Open animation
    TweenService:Create(win,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, W, 0, H)}
    ):Play()

    -- ── Titlebar ────────────────────────────────────────────
    local titlebar = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = C.Panel,
        BorderSizePixel  = 0,
        ZIndex = 10,
    }, win)
    -- bottom border
    new("Frame", {
        Size = UDim2.new(1,0,0,1),
        Position = UDim2.new(0,0,1,-1),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex = 10,
    }, titlebar)

    makeDrag(win, titlebar)

    -- Logo
    local logo = new("Frame", {
        Size = UDim2.new(0,26,0,26),
        Position = UDim2.new(0,10,0.5,-13),
        BackgroundColor3 = C.AccentDim,
        BorderSizePixel  = 0,
        ZIndex = 11,
    }, titlebar)
    corner(6, logo)
    stroke(C.Accent, 1, logo)
    new("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = "T",
        TextColor3 = C.Accent,
        TextSize   = 15,
        Font       = Enum.Font.GothamBold,
        ZIndex     = 12,
    }, logo)

    -- Title
    new("TextLabel", {
        Size = UDim2.new(1,-130,1,0),
        Position = UDim2.new(0,44,0,0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Text,
        TextSize   = 13,
        Font       = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 11,
    }, titlebar)

    -- Subtitle
    new("TextLabel", {
        Size = UDim2.new(0,180,1,0),
        Position = UDim2.new(1,-250,0,0),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = C.TextDim,
        TextSize   = 11,
        Font       = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 11,
    }, titlebar)

    -- Close
    local closeBtn = new("TextButton", {
        Size = UDim2.new(0,26,0,26),
        Position = UDim2.new(1,-34,0.5,-13),
        BackgroundColor3 = Color3.fromRGB(45,18,18),
        Text = "✕", TextColor3 = C.Red,
        TextSize = 12, Font = Enum.Font.GothamBold,
        ZIndex = 11, AutoButtonColor = false,
    }, titlebar)
    corner(6, closeBtn)
    closeBtn.MouseButton1Click:Connect(function()
        tw(win, 0.25, {Size = UDim2.new(0,W,0,0)})
        task.delay(0.26, function() sg:Destroy() end)
    end)

    -- Minimize
    local minBtn = new("TextButton", {
        Size = UDim2.new(0,26,0,26),
        Position = UDim2.new(1,-64,0.5,-13),
        BackgroundColor3 = C.Card,
        Text = "—", TextColor3 = C.TextDim,
        TextSize = 12, Font = Enum.Font.GothamBold,
        ZIndex = 11, AutoButtonColor = false,
    }, titlebar)
    corner(6, minBtn)
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        tw(win, 0.2, {Size = minimized and UDim2.new(0,W,0,40) or UDim2.new(0,W,0,H)})
    end)

    -- ── Body ────────────────────────────────────────────────
    local body = new("Frame", {
        Position = UDim2.new(0,0,0,40),
        Size     = UDim2.new(1,0,1,-40),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, win)

    -- ── Sidebar ─────────────────────────────────────────────
    local sidebar = new("ScrollingFrame", {
        Size = UDim2.new(0,SW,1,0),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel  = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = C.AccentDim,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 3,
    }, body)
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0,0)}, sidebar)
    -- right border
    new("Frame", {
        Size = UDim2.new(0,1,1,0),
        Position = UDim2.new(1,-1,0,0),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex = 4,
    }, sidebar)

    -- ── Content ─────────────────────────────────────────────
    local content = new("Frame", {
        Position = UDim2.new(0,SW,0,0),
        Size     = UDim2.new(1,-SW,1,0),
        BackgroundColor3 = C.BG,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
    }, body)

    -- Window object
    local winObj = {
        _sg       = sg,
        _win      = win,
        _sidebar  = sidebar,
        _content  = content,
        _tabs     = {},
        _active   = nil,
        _SW       = SW,
    }
    setmetatable(winObj, {__index = TayUI})
    return winObj
end

-- ─── AddTab ────────────────────────────────────────────────
function TayUI:AddTab(icon, label, order)
    -- Panel
    local panel = new("ScrollingFrame", {
        Name = "Panel_"..label,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.AccentDim,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex  = 2,
    }, self._content)
    new("UIPadding", {
        PaddingTop    = UDim.new(0,12),
        PaddingLeft   = UDim.new(0,12),
        PaddingRight  = UDim.new(0,12),
        PaddingBottom = UDim.new(0,12),
    }, panel)
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0,7),
    }, panel)

    -- Sidebar button
    local btn = new("TextButton", {
        Size = UDim2.new(1,0,0,36),
        BackgroundColor3 = C.Sidebar,
        BorderSizePixel  = 0,
        Text = "",
        LayoutOrder = order or (#self._tabs + 1),
        AutoButtonColor = false,
        ZIndex = 4,
    }, self._sidebar)

    -- Accent bar
    local bar = new("Frame", {
        Size = UDim2.new(0,3,0.6,0),
        Position = UDim2.new(0,0,0.2,0),
        BackgroundColor3 = C.Accent,
        BorderSizePixel  = 0,
        Visible = false,
        ZIndex  = 5,
    }, btn)
    corner(2, bar)

    -- Icon
    new("TextLabel", {
        Size = UDim2.new(0,20,0,20),
        Position = UDim2.new(0,10,0.5,-10),
        BackgroundTransparency = 1,
        Text = icon, TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.TextDim,
        ZIndex = 5,
    }, btn)

    -- Label
    local lbl = new("TextLabel", {
        Size = UDim2.new(1,-38,1,0),
        Position = UDim2.new(0,34,0,0),
        BackgroundTransparency = 1,
        Text = label, TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextColor3 = C.TextDim,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
    }, btn)

    local tabEntry = {btn=btn, bar=bar, lbl=lbl, panel=panel}
    table.insert(self._tabs, tabEntry)

    local function activate()
        for _, t in ipairs(self._tabs) do
            t.panel.Visible = false
            tw(t.btn, 0.12, {BackgroundColor3 = C.Sidebar})
            t.bar.Visible = false
            tw(t.lbl, 0.12, {TextColor3 = C.TextDim})
        end
        panel.Visible = true
        tw(btn, 0.12, {BackgroundColor3 = C.TabSel})
        bar.Visible = true
        tw(lbl, 0.12, {TextColor3 = C.Accent})
        self._active = panel
    end

    btn.MouseEnter:Connect(function()
        if self._active ~= panel then tw(btn, 0.1, {BackgroundColor3 = C.Card}) end
    end)
    btn.MouseLeave:Connect(function()
        if self._active ~= panel then tw(btn, 0.1, {BackgroundColor3 = C.Sidebar}) end
    end)
    btn.MouseButton1Click:Connect(activate)

    -- Auto activate first tab
    if #self._tabs == 1 then activate() end

    return panel
end

-- ─── AddSection ────────────────────────────────────────────
function TayUI.AddSection(panel, text, order)
    local f = new("Frame", {
        Size = UDim2.new(1,0,0,22),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, panel)
    new("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = C.TextDim,
        TextSize   = 10,
        Font       = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, f)
    new("Frame", {
        Size = UDim2.new(1,0,0,1),
        Position = UDim2.new(0,0,1,-1),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
    }, f)
    return f
end

-- ─── AddLabel ──────────────────────────────────────────────
function TayUI.AddLabel(panel, text, color, order)
    local f = new("Frame", {
        Size = UDim2.new(1,0,0,30),
        BackgroundColor3 = C.Card,
        BorderSizePixel  = 0,
        LayoutOrder = order or 1,
    }, panel)
    corner(6, f)
    new("TextLabel", {
        Size = UDim2.new(1,-12,1,0),
        Position = UDim2.new(0,12,0,0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or C.TextDim,
        TextSize   = 12,
        Font       = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, f)
    return f
end

-- ─── AddButton ─────────────────────────────────────────────
function TayUI.AddButton(panel, opts)
    -- opts: { Text, Sub, Icon, Order, Callback }
    opts = opts or {}
    local btn = new("TextButton", {
        Size = UDim2.new(1,0,0,42),
        BackgroundColor3 = C.Card,
        BorderSizePixel  = 0,
        Text = "",
        LayoutOrder = opts.Order or 5,
        AutoButtonColor = false,
        ZIndex = 2,
    }, panel)
    corner(8, btn)
    stroke(C.Border, 1, btn)

    -- Icon circle
    if opts.Icon then
        local icoF = new("Frame", {
            Size = UDim2.new(0,26,0,26),
            Position = UDim2.new(0,8,0.5,-13),
            BackgroundColor3 = C.AccentDim,
            BorderSizePixel  = 0,
            ZIndex = 3,
        }, btn)
        corner(6, icoF)
        new("TextLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Text = opts.Icon, TextSize = 14,
            Font = Enum.Font.GothamBold,
            ZIndex = 4,
        }, icoF)
    end

    local xOff = opts.Icon and 42 or 12
    local mainLbl = new("TextLabel", {
        Size = UDim2.new(1,-xOff-80,1,0),
        Position = UDim2.new(0,xOff,0,0),
        BackgroundTransparency = 1,
        Text = opts.Text or "Button",
        TextColor3 = C.Text,
        TextSize   = 13,
        Font       = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, btn)

    if opts.Sub then
        new("TextLabel", {
            Size = UDim2.new(0,90,1,0),
            Position = UDim2.new(1,-95,0,0),
            BackgroundTransparency = 1,
            Text = opts.Sub,
            TextColor3 = C.TextDim,
            TextSize   = 10,
            Font       = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 3,
        }, btn)
    end

    btn.MouseEnter:Connect(function() tw(btn, 0.1, {BackgroundColor3 = C.CardHover}) end)
    btn.MouseLeave:Connect(function() tw(btn, 0.1, {BackgroundColor3 = C.Card}) end)

    btn.MouseButton1Click:Connect(function()
        local old = mainLbl.Text
        mainLbl.Text = "⏳  Loading..."
        mainLbl.TextColor3 = C.Yellow
        task.spawn(function()
            if opts.Callback then opts.Callback() end
            mainLbl.Text = old
            mainLbl.TextColor3 = C.Text
        end)
    end)

    return btn, mainLbl
end

-- ─── AddServerCard ─────────────────────────────────────────
function TayUI.AddServerCard(panel, idx, jobId, badgeText, badgeColor, hopCallback)
    local card = new("TextButton", {
        Name = "SRV_"..idx,
        Size = UDim2.new(1,0,0,54),
        BackgroundColor3 = C.Card,
        BorderSizePixel  = 0,
        Text = "",
        LayoutOrder = 20 + idx,
        AutoButtonColor = false,
        ZIndex = 2,
    }, panel)
    corner(8, card)
    stroke(C.Border, 1, card)

    -- Ping dot
    local dot = new("Frame", {
        Size = UDim2.new(0,8,0,8),
        Position = UDim2.new(0,12,0.5,-4),
        BackgroundColor3 = C.Accent,
        BorderSizePixel  = 0,
        ZIndex = 3,
    }, card)
    corner(4, dot)
    task.spawn(function()
        while card.Parent do
            tw(dot, 0.9, {BackgroundTransparency = 0.7})
            task.wait(0.9)
            tw(dot, 0.9, {BackgroundTransparency = 0})
            task.wait(0.9)
        end
    end)

    -- Name
    new("TextLabel", {
        Size = UDim2.new(1,-115,0,20),
        Position = UDim2.new(0,28,0,8),
        BackgroundTransparency = 1,
        Text = "Server  #"..idx,
        TextColor3 = C.Text,
        TextSize   = 13,
        Font       = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, card)

    -- JobID
    new("TextLabel", {
        Size = UDim2.new(1,-115,0,16),
        Position = UDim2.new(0,28,0,28),
        BackgroundTransparency = 1,
        Text = jobId and (jobId:sub(1,22).."…") or "???",
        TextColor3 = C.TextDim,
        TextSize   = 10,
        Font       = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    }, card)

    -- Badge
    local badgeF = new("Frame", {
        Size = UDim2.new(0,54,0,18),
        Position = UDim2.new(1,-112,0.5,-9),
        BackgroundColor3 = C.AccentDim,
        BorderSizePixel  = 0,
        ZIndex = 3,
    }, card)
    corner(4, badgeF)
    new("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Text = badgeText or "BOSS",
        TextColor3 = badgeColor or C.Accent,
        TextSize   = 9,
        Font       = Enum.Font.GothamBold,
        ZIndex = 4,
    }, badgeF)

    -- HOP button
    local hopBtn = new("TextButton", {
        Size = UDim2.new(0,46,0,28),
        Position = UDim2.new(1,-56,0.5,-14),
        BackgroundColor3 = C.AccentDim,
        Text = "HOP",
        TextColor3 = C.Accent,
        TextSize   = 11,
        Font       = Enum.Font.GothamBold,
        ZIndex = 4,
        AutoButtonColor = false,
    }, card)
    corner(6, hopBtn)
    stroke(C.Accent, 1, hopBtn)

    card.MouseEnter:Connect(function() tw(card, 0.12, {BackgroundColor3 = C.CardHover}) end)
    card.MouseLeave:Connect(function() tw(card, 0.12, {BackgroundColor3 = C.Card}) end)
    hopBtn.MouseEnter:Connect(function() tw(hopBtn, 0.1, {BackgroundColor3 = C.Accent, TextColor3 = C.BG}) end)
    hopBtn.MouseLeave:Connect(function() tw(hopBtn, 0.1, {BackgroundColor3 = C.AccentDim, TextColor3 = C.Accent}) end)

    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "..."
        task.spawn(function()
            if hopCallback then hopCallback(jobId) end
            task.wait(2)
            hopBtn.Text = "HOP"
        end)
    end)

    return card
end

-- ─── AddDot badge trên sidebar ─────────────────────────────
function TayUI.AddSidebarDot(btn, color)
    local dot = new("Frame", {
        Size = UDim2.new(0,6,0,6),
        Position = UDim2.new(1,-14,0.5,-3),
        BackgroundColor3 = color,
        BorderSizePixel  = 0,
        ZIndex = 5,
    }, btn)
    corner(3, dot)
    return dot
end

return TayUI
