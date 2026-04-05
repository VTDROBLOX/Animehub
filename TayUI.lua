-- ╔══════════════════════════════════════════╗
-- ║   TayUI.lua — Tày Hub UI Library        ║
-- ║   Style: Teddy Hub  |  v3.0             ║
-- ╚══════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

-- ══════════════════════════
-- COLORS — Teddy Hub style
-- ══════════════════════════
local C = {
    BG        = Color3.fromRGB(28, 28, 28),
    Panel     = Color3.fromRGB(22, 22, 22),
    Sidebar   = Color3.fromRGB(33, 33, 33),
    Row       = Color3.fromRGB(40, 40, 40),
    RowHover  = Color3.fromRGB(50, 50, 50),
    TabSel    = Color3.fromRGB(38, 38, 38),
    Accent    = Color3.fromRGB(90, 150, 255),
    AccentGrn = Color3.fromRGB(52, 211, 153),
    Text      = Color3.fromRGB(225, 225, 225),
    TextDim   = Color3.fromRGB(140, 140, 140),
    TextTitle = Color3.fromRGB(255, 255, 255),
    Border    = Color3.fromRGB(52, 52, 52),
    TogOn     = Color3.fromRGB(80, 200, 120),
    TogOff    = Color3.fromRGB(75, 75, 75),
    Red       = Color3.fromRGB(255, 80, 80),
    Yellow    = Color3.fromRGB(255, 210, 0),
}

-- ══════════════════════════
-- HELPERS
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

local function corner(r, p) new("UICorner", {CornerRadius=UDim.new(0,r)}, p) end
local function stroke(c, t, p) new("UIStroke", {Color=c, Thickness=t}, p) end

local function makeDrag(frame, handle)
    local drag, inp, start, spos = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag=true; start=i.Position; spos=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch then inp=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==inp and drag then
            local d = i.Position-start
            frame.Position = UDim2.new(spos.X.Scale, spos.X.Offset+d.X, spos.Y.Scale, spos.Y.Offset+d.Y)
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
    local title = opts.Title   or "Tày Hub"
    local sub   = opts.Sub     or ""
    local W     = opts.Width   or 680
    local H     = opts.Height  or 480
    local SW    = opts.Sidebar or 150

    pcall(function()
        if CoreGui:FindFirstChild("TayUI") then CoreGui.TayUI:Destroy() end
    end)

    local sg = new("ScreenGui", {
        Name="TayUI", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    -- Window
    local win = new("Frame", {
        Size=UDim2.new(0,W,0,0),
        Position=UDim2.new(0.5,-W/2,0.5,-H/2),
        BackgroundColor3=C.BG,
        BorderSizePixel=0,
        ClipsDescendants=true,
    }, sg)
    corner(8, win)
    stroke(C.Border, 1, win)

    -- Shadow
    new("ImageLabel", {
        AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1,
        Position=UDim2.new(0.5,0,0.5,6), Size=UDim2.new(1,40,1,40),
        Image="rbxassetid://6014261993", ImageColor3=Color3.new(0,0,0),
        ImageTransparency=0.5, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), ZIndex=0,
    }, win)

    -- Open anim
    TweenService:Create(win, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size=UDim2.new(0,W,0,H)}):Play()

    -- ── Titlebar ────────────────────────────────────────────
    local tbar = new("Frame", {
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=C.Panel,
        BorderSizePixel=0, ZIndex=10,
    }, win)
    new("Frame", {
        Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
        BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=10,
    }, tbar)

    makeDrag(win, tbar)

    -- Title
    new("TextLabel", {
        Size=UDim2.new(1,-120,1,0), Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text = sub~="" and (title.."  "..sub) or title,
        TextColor3=C.Text, TextSize=13, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=11,
    }, tbar)

    -- Minimize
    local minBtn = new("TextButton", {
        Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-100,0.5,-16),
        BackgroundTransparency=1,
        Text="—", TextColor3=C.TextDim, TextSize=16, Font=Enum.Font.GothamBold,
        ZIndex=11, AutoButtonColor=false,
    }, tbar)
    local minimized=false
    minBtn.MouseButton1Click:Connect(function()
        minimized=not minimized
        tw(win, 0.2, {Size=minimized and UDim2.new(0,W,0,44) or UDim2.new(0,W,0,H)})
    end)

    -- Maximize (deco)
    new("TextButton", {
        Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-66,0.5,-16),
        BackgroundTransparency=1,
        Text="⛶", TextColor3=C.TextDim, TextSize=13, Font=Enum.Font.GothamBold,
        ZIndex=11, AutoButtonColor=false,
    }, tbar)

    -- Close
    local closeBtn = new("TextButton", {
        Size=UDim2.new(0,32,0,32), Position=UDim2.new(1,-34,0.5,-16),
        BackgroundTransparency=1,
        Text="✕", TextColor3=C.TextDim, TextSize=13, Font=Enum.Font.GothamBold,
        ZIndex=11, AutoButtonColor=false,
    }, tbar)
    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3=C.Red end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3=C.TextDim end)
    closeBtn.MouseButton1Click:Connect(function()
        tw(win, 0.2, {Size=UDim2.new(0,W,0,0)})
        task.delay(0.21, function() sg:Destroy() end)
    end)

    -- ── Body ────────────────────────────────────────────────
    local body = new("Frame", {
        Position=UDim2.new(0,0,0,44), Size=UDim2.new(1,0,1,-44),
        BackgroundTransparency=1, ClipsDescendants=true,
    }, win)

    -- ── Sidebar ─────────────────────────────────────────────
    local sidebar = new("ScrollingFrame", {
        Size=UDim2.new(0,SW,1,0),
        BackgroundColor3=C.Sidebar,
        BorderSizePixel=0,
        ScrollBarThickness=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=3,
    }, body)
    new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,0)}, sidebar)
    new("Frame", {
        Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
        BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=4,
    }, sidebar)

    -- ── Content ─────────────────────────────────────────────
    local content = new("Frame", {
        Position=UDim2.new(0,SW,0,0), Size=UDim2.new(1,-SW,1,0),
        BackgroundColor3=C.BG, BorderSizePixel=0, ClipsDescendants=true,
    }, body)

    local winObj = {
        _sg=sg, _win=win, _sidebar=sidebar, _content=content,
        _tabs={}, _active=nil, _W=W, _H=H,
    }
    setmetatable(winObj, {__index=TayUI})
    return winObj
end

-- ─── AddTab ────────────────────────────────────────────────
function TayUI:AddTab(label, order)
    local panel = new("ScrollingFrame", {
        Name="Panel_"..label,
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=C.Border,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false, ZIndex=2,
    }, self._content)
    new("UIPadding", {
        PaddingTop=UDim.new(0,16), PaddingLeft=UDim.new(0,16),
        PaddingRight=UDim.new(0,16), PaddingBottom=UDim.new(0,16),
    }, panel)
    new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,8)}, panel)

    -- Sidebar button
    local btn = new("TextButton", {
        Size=UDim2.new(1,0,0,40),
        BackgroundColor3=C.Sidebar,
        BorderSizePixel=0, Text="",
        LayoutOrder=order or (#self._tabs+1),
        AutoButtonColor=false, ZIndex=4,
    }, self._sidebar)

    -- Accent bar kiri (giống Teddy Hub)
    local bar = new("Frame", {
        Size=UDim2.new(0,3,0.55,0),
        Position=UDim2.new(0,0,0.225,0),
        BackgroundColor3=C.Accent,
        BorderSizePixel=0, Visible=false, ZIndex=5,
    }, btn)
    corner(2, bar)

    local lbl = new("TextLabel", {
        Size=UDim2.new(1,-14,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=label, TextSize=13,
        Font=Enum.Font.Gotham,
        TextColor3=C.TextDim,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=5,
    }, btn)

    local entry = {btn=btn, bar=bar, lbl=lbl, panel=panel}
    table.insert(self._tabs, entry)

    local function activate()
        for _, t in ipairs(self._tabs) do
            t.panel.Visible=false
            tw(t.btn, 0.12, {BackgroundColor3=C.Sidebar})
            t.bar.Visible=false
            t.lbl.Font=Enum.Font.Gotham
            tw(t.lbl, 0.12, {TextColor3=C.TextDim})
        end
        panel.Visible=true
        tw(btn, 0.12, {BackgroundColor3=C.TabSel})
        bar.Visible=true
        lbl.Font=Enum.Font.GothamBold
        tw(lbl, 0.12, {TextColor3=C.Text})
        self._active=panel
    end

    btn.MouseEnter:Connect(function()
        if self._active~=panel then tw(btn,0.1,{BackgroundColor3=C.RowHover}) end
    end)
    btn.MouseLeave:Connect(function()
        if self._active~=panel then tw(btn,0.1,{BackgroundColor3=C.Sidebar}) end
    end)
    btn.MouseButton1Click:Connect(activate)
    if #self._tabs==1 then activate() end

    return panel
end

-- ─── AddTitle — chữ to kiểu "Hop", "Kill" ─────────────────
function TayUI.AddTitle(panel, text, order)
    return new("TextLabel", {
        Size=UDim2.new(1,0,0,38),
        BackgroundTransparency=1,
        Text=text, TextColor3=C.TextTitle,
        TextSize=22, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        LayoutOrder=order or 0, ZIndex=3,
    }, panel)
end

-- ─── AddSubTitle — "Rip Indra", "Dough King" ──────────────
function TayUI.AddSubTitle(panel, text, order)
    return new("TextLabel", {
        Size=UDim2.new(1,0,0,28),
        BackgroundTransparency=1,
        Text=text, TextColor3=C.TextTitle,
        TextSize=15, Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        LayoutOrder=order or 1, ZIndex=3,
    }, panel)
end

-- ─── AddRow — nút có mũi tên ">" giống Teddy Hub ──────────
function TayUI.AddRow(panel, text, order, callback)
    local row = new("TextButton", {
        Size=UDim2.new(1,0,0,46),
        BackgroundColor3=C.Row,
        BorderSizePixel=0,
        Text="", LayoutOrder=order or 5,
        AutoButtonColor=false, ZIndex=2,
    }, panel)
    corner(6, row)

    new("TextLabel", {
        Size=UDim2.new(1,-36,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=text, TextSize=13,
        Font=Enum.Font.Gotham,
        TextColor3=C.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=3,
    }, row)

    new("TextLabel", {
        Size=UDim2.new(0,24,1,0),
        Position=UDim2.new(1,-28,0,0),
        BackgroundTransparency=1,
        Text=">", TextSize=16,
        Font=Enum.Font.GothamBold,
        TextColor3=C.TextDim, ZIndex=3,
    }, row)

    row.MouseEnter:Connect(function() tw(row,0.1,{BackgroundColor3=C.RowHover}) end)
    row.MouseLeave:Connect(function() tw(row,0.1,{BackgroundColor3=C.Row}) end)
    row.MouseButton1Click:Connect(function()
        if callback then task.spawn(callback) end
    end)
    return row
end

-- ─── AddToggle — toggle switch kiểu Teddy Hub ─────────────
function TayUI.AddToggle(panel, text, default, order, callback)
    local state = default or false

    local row = new("Frame", {
        Size=UDim2.new(1,0,0,46),
        BackgroundColor3=C.Row,
        BorderSizePixel=0,
        LayoutOrder=order or 5, ZIndex=2,
    }, panel)
    corner(6, row)

    new("TextLabel", {
        Size=UDim2.new(1,-70,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=text, TextSize=13,
        Font=Enum.Font.Gotham,
        TextColor3=C.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=3,
    }, row)

    local bg = new("Frame", {
        Size=UDim2.new(0,44,0,24),
        Position=UDim2.new(1,-54,0.5,-12),
        BackgroundColor3=state and C.TogOn or C.TogOff,
        BorderSizePixel=0, ZIndex=3,
    }, row)
    corner(12, bg)

    local circle = new("Frame", {
        Size=UDim2.new(0,18,0,18),
        Position=state and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9),
        BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0, ZIndex=4,
    }, bg)
    corner(9, circle)

    local clickArea = new("TextButton", {
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Text="", ZIndex=5,
    }, row)
    clickArea.MouseButton1Click:Connect(function()
        state=not state
        tw(bg, 0.15, {BackgroundColor3=state and C.TogOn or C.TogOff})
        tw(circle, 0.15, {Position=state and UDim2.new(0,23,0.5,-9) or UDim2.new(0,3,0.5,-9)})
        if callback then task.spawn(callback, state) end
    end)

    return row, function() return state end
end

-- ─── AddLabel — info row ───────────────────────────────────
function TayUI.AddLabel(panel, text, color, order)
    local row = new("Frame", {
        Size=UDim2.new(1,0,0,40),
        BackgroundColor3=C.Row,
        BorderSizePixel=0,
        LayoutOrder=order or 5, ZIndex=2,
    }, panel)
    corner(6, row)
    new("TextLabel", {
        Size=UDim2.new(1,-14,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=text, TextSize=13,
        Font=Enum.Font.Gotham,
        TextColor3=color or C.Text,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=3,
    }, row)
    return row
end

-- ─── ShowPicker — popup danh sách server ──────────────────
function TayUI.ShowPicker(label, ids, hopCallback)
    pcall(function()
        if CoreGui:FindFirstChild("TayPicker") then CoreGui.TayPicker:Destroy() end
    end)

    local sg2 = new("ScreenGui", {
        Name="TayPicker", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, CoreGui)

    -- Backdrop
    local bd = new("TextButton", {
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=0.55,
        Text="", ZIndex=30,
    }, sg2)
    bd.MouseButton1Click:Connect(function() sg2:Destroy() end)

    -- Popup
    local pop = new("Frame", {
        Size=UDim2.new(0,360,0,0),
        Position=UDim2.new(0.5,-180,0.5,-170),
        BackgroundColor3=Color3.fromRGB(28,28,28),
        BorderSizePixel=0, ZIndex=31,
    }, sg2)
    corner(8, pop)
    stroke(Color3.fromRGB(52,52,52), 1, pop)

    TweenService:Create(pop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size=UDim2.new(0,360,0,340)}):Play()

    -- Header
    local hdr = new("Frame", {
        Size=UDim2.new(1,0,0,44),
        BackgroundColor3=Color3.fromRGB(22,22,22),
        BorderSizePixel=0, ZIndex=32,
    }, pop)
    corner(8, hdr)

    new("TextLabel", {
        Size=UDim2.new(1,-44,1,0),
        Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1,
        Text=label, TextSize=14, Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(225,225,225),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=33,
    }, hdr)

    local xb = new("TextButton", {
        Size=UDim2.new(0,30,0,30),
        Position=UDim2.new(1,-36,0.5,-15),
        BackgroundTransparency=1,
        Text="✕", TextColor3=Color3.fromRGB(140,140,140),
        TextSize=13, Font=Enum.Font.GothamBold,
        ZIndex=33, AutoButtonColor=false,
    }, hdr)
    xb.MouseButton1Click:Connect(function() sg2:Destroy() end)

    -- Scroll
    local scroll = new("ScrollingFrame", {
        Size=UDim2.new(1,0,1,-44),
        Position=UDim2.new(0,0,0,44),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=Color3.fromRGB(52,52,52),
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ZIndex=32,
    }, pop)
    new("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5)}, scroll)
    new("UIPadding", {
        PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10),
        PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10),
    }, scroll)

    if #ids==0 then
        new("TextLabel", {
            Size=UDim2.new(1,0,0,40),
            BackgroundTransparency=1,
            Text="❌  Không tìm thấy server nào!",
            TextColor3=Color3.fromRGB(255,80,80),
            TextSize=12, Font=Enum.Font.Gotham,
            ZIndex=33,
        }, scroll)
        return
    end

    for i, jobId in ipairs(ids) do
        local row = new("TextButton", {
            Size=UDim2.new(1,0,0,46),
            BackgroundColor3=Color3.fromRGB(38,38,38),
            BorderSizePixel=0, Text="",
            LayoutOrder=i, AutoButtonColor=false, ZIndex=33,
        }, scroll)
        corner(6, row)

        -- Ping dot
        local dot = new("Frame", {
            Size=UDim2.new(0,8,0,8),
            Position=UDim2.new(0,10,0.5,-4),
            BackgroundColor3=Color3.fromRGB(52,211,153),
            BorderSizePixel=0, ZIndex=34,
        }, row)
        corner(4, dot)
        task.spawn(function()
            while row.Parent do
                TweenService:Create(dot,TweenInfo.new(0.9),{BackgroundTransparency=0.7}):Play()
                task.wait(0.9)
                TweenService:Create(dot,TweenInfo.new(0.9),{BackgroundTransparency=0}):Play()
                task.wait(0.9)
            end
        end)

        local nameLbl = new("TextLabel", {
            Size=UDim2.new(1,-80,0,20),
            Position=UDim2.new(0,26,0,5),
            BackgroundTransparency=1,
            Text="Server  #"..i,
            TextColor3=Color3.fromRGB(220,220,220),
            TextSize=13, Font=Enum.Font.GothamBold,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=34,
        }, row)

        new("TextLabel", {
            Size=UDim2.new(1,-80,0,14),
            Position=UDim2.new(0,26,0,24),
            BackgroundTransparency=1,
            Text=jobId:sub(1,22).."…",
            TextColor3=Color3.fromRGB(100,100,100),
            TextSize=10, Font=Enum.Font.Code,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=34,
        }, row)

        local hopBtn = new("TextButton", {
            Size=UDim2.new(0,52,0,28),
            Position=UDim2.new(1,-58,0.5,-14),
            BackgroundColor3=Color3.fromRGB(18,60,42),
            Text="HOP",
            TextColor3=Color3.fromRGB(52,211,153),
            TextSize=11, Font=Enum.Font.GothamBold,
            ZIndex=35, AutoButtonColor=false,
        }, row)
        corner(6, hopBtn)

        row.MouseEnter:Connect(function() row.BackgroundColor3=Color3.fromRGB(48,48,48) end)
        row.MouseLeave:Connect(function() row.BackgroundColor3=Color3.fromRGB(38,38,38) end)
        hopBtn.MouseEnter:Connect(function()
            hopBtn.BackgroundColor3=Color3.fromRGB(52,211,153)
            hopBtn.TextColor3=Color3.fromRGB(10,10,10)
        end)
        hopBtn.MouseLeave:Connect(function()
            hopBtn.BackgroundColor3=Color3.fromRGB(18,60,42)
            hopBtn.TextColor3=Color3.fromRGB(52,211,153)
        end)

        hopBtn.MouseButton1Click:Connect(function()
            hopBtn.Text="..."
            nameLbl.Text="🚀 Đang hop..."
            if hopCallback then task.spawn(hopCallback, jobId) end
        end)
    end
end

return TayUI
