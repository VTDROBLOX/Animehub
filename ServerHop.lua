-- ╔══════════════════════════════════════════════════╗
-- ║   ServerHop.lua — Tày Hub  |  v2.0              ║
-- ║   Dùng TayUI.lua làm giao diện                  ║
-- ║   Blox Fruits  |  Delta / Hydrogen / Solara      ║
-- ╚══════════════════════════════════════════════════╝

-- ─── Load UI Library ─────────────────────────────────────
local TayUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/vtdroblox/tayhub/main/ServerHop/TayUI.lua", true
))()

-- ─── Services ────────────────────────────────────────────
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local Players         = game:GetService("Players")
local LP              = Players.LocalPlayer

-- ─── Config ──────────────────────────────────────────────
local BASE_URL  = "http://nighthub.site/boss/"
local MAX_SRV   = 6

-- ─── Badge colors ────────────────────────────────────────
local BADGE = {
    BOSS   = { text="BOSS",   color=Color3.fromRGB(255,90,90)   },
    EVENT  = { text="EVENT",  color=Color3.fromRGB(255,210,0)   },
    ISLAND = { text="ISLAND", color=Color3.fromRGB(79,180,247)  },
    RAID   = { text="RAID",   color=Color3.fromRGB(180,100,255) },
}

-- ─── Tab data ────────────────────────────────────────────
local TABS = {
    { icon="📋", label="Info & Errors",      endpoint=nil,                  badge=nil      },
    { icon="⚔️", label="Sword Legendary",    endpoint="SwordLegendary",     badge="BOSS"   },
    { icon="💠", label="Haki Legendary",     endpoint="HakiLegendary",      badge="BOSS"   },
    { icon="👁️", label="Rip Indra",          endpoint="RipIndra",           badge="BOSS"   },
    { icon="🧔", label="Darkbeard",          endpoint="Darkbeard",          badge="BOSS"   },
    { icon="🍩", label="Dough King",         endpoint="DoughKing",          badge="BOSS"   },
    { icon="🫐", label="Berry",              endpoint="Berry",              badge="BOSS"   },
    { icon="🦅", label="Tyrant Of Skies",    endpoint="TyrantOfTheSkies",   badge="BOSS"   },
    { icon="☠️", label="Cursed Captain",     endpoint="CursedCaptain",      badge="BOSS"   },
    { icon="💀", label="Soul Reaper",        endpoint="SoulReaper",         badge="BOSS"   },
    { icon="🌕", label="Full Moon",          endpoint="Fullmoon",           badge="EVENT"  },
    { icon="🌙", label="Near Moon",          endpoint="NearMoon",           badge="EVENT"  },
    { icon="🏝️", label="Mirage Island",      endpoint="Mirage",             badge="ISLAND" },
    { icon="🦊", label="Kitsune Island",     endpoint="KitsuneIsland",      badge="ISLAND" },
    { icon="🦕", label="Prehistoric",        endpoint="PrehistoricIsland",  badge="ISLAND" },
    { icon="🎂", label="Cake Prince",        endpoint="CakePrince",         badge="EVENT"  },
    { icon="⭐", label="Elite",              endpoint="Elite",              badge="RAID"   },
    { icon="🏰", label="Castle Raid",        endpoint="CastleRaid",         badge="RAID"   },
}

-- ─── Fetch JobIDs ────────────────────────────────────────
local function fetchJobIds(endpoint)
    local url = BASE_URL .. endpoint
    local ok, raw = pcall(game.HttpGet, game, url, true)
    if not ok or not raw or raw == "" then return {} end

    local ids = {}
    local ok2, parsed = pcall(HttpService.JSONDecode, HttpService, raw)
    if ok2 and type(parsed) == "table" then
        for _, v in ipairs(parsed) do
            if type(v) == "string" then
                table.insert(ids, v)
            elseif type(v) == "table" then
                local id = v.jobId or v.id or v.JobId
                if id then table.insert(ids, id) end
            end
        end
    else
        -- Fallback: cào GUID từ raw string
        for id in raw:gmatch(
            "[0-9a-f]%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"
        ) do
            table.insert(ids, id)
        end
    end
    return ids
end

-- ─── Hop ─────────────────────────────────────────────────
local function hop(jobId)
    if not jobId or jobId == "" then return end
    pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, jobId, LP)
end

-- ─── Clear server cards trong panel ──────────────────────
local function clearCards(panel)
    for _, c in ipairs(panel:GetChildren()) do
        if c.Name:sub(1,4) == "SRV_" then c:Destroy() end
    end
end

-- ══════════════════════════════════════════
-- BUILD WINDOW
-- ══════════════════════════════════════════
local Win = TayUI:CreateWindow({
    Title    = "Script Hop Server  —  Tày Hub",
    Sub      = "Blox Fruits  |  v2.0",
    Width    = 620,
    Height   = 440,
    Sidebar  = 195,
})

-- ══════════════════════════════════════════
-- BUILD TABS
-- ══════════════════════════════════════════
for i, t in ipairs(TABS) do

    local panel = Win:AddTab(t.icon, t.label, i)

    -- Dot màu trên sidebar button theo badge
    if t.badge then
        local lastBtn = Win._sidebar:GetChildren()
        for _, c in ipairs(Win._sidebar:GetChildren()) do
            if c.Name == "SBtn_"..t.label or c.LayoutOrder == i then
                TayUI.AddSidebarDot(c, BADGE[t.badge].color)
                break
            end
        end
    end

    -- ── INFO TAB ──────────────────────────────────────────
    if t.endpoint == nil then
        TayUI.AddLabel(panel, "🎮  Tày Hub — Server Hop v2.0",       Color3.fromRGB(52,211,153), 1)
        TayUI.AddLabel(panel, "📡  API: nighthub.site/boss/...",      nil,                        2)
        TayUI.AddLabel(panel, "⚠️   Chỉ dùng trong Blox Fruits!",    Color3.fromRGB(255,210,0),  3)
        TayUI.AddLabel(panel, "✅  Delta / Hydrogen / Solara OK",     nil,                        4)
        TayUI.AddLabel(panel, "👈  Chọn tab bên trái → Load → HOP",  nil,                        5)

    -- ── BOSS / EVENT / ISLAND / RAID TAB ─────────────────
    else
        local b = BADGE[t.badge] or {text="HOP", color=Color3.fromRGB(52,211,153)}

        -- Section header
        TayUI.AddSection(panel, t.icon.."  "..t.label:upper().."  ·  "..b.text, 1)

        -- Status label
        local statusF = TayUI.AddLabel(panel, "— Chưa tải —", nil, 2)
        statusF.Visible = false
        local statusLbl = statusF:FindFirstChildWhichIsA("TextLabel")

        local function setStatus(txt, col)
            statusLbl.Text = txt
            statusLbl.TextColor3 = col or Color3.fromRGB(100,100,125)
            statusF.Visible = true
        end

        -- Load Servers button
        TayUI.AddButton(panel, {
            Text  = "Load Servers",
            Sub   = "Nhấn để tải",
            Icon  = "🔍",
            Order = 3,
            Callback = function()
                clearCards(panel)
                setStatus("🔄 Đang kết nối API...", Color3.fromRGB(100,100,125))

                local ids = fetchJobIds(t.endpoint)

                if #ids == 0 then
                    setStatus("❌ Không tìm thấy server nào!", Color3.fromRGB(255,75,75))
                    return
                end

                setStatus("✅ Tìm thấy "..#ids.." server — chọn HOP!", Color3.fromRGB(52,211,153))

                local count = math.min(#ids, MAX_SRV)
                for idx = 1, count do
                    TayUI.AddServerCard(panel, idx, ids[idx], b.text, b.color, function(jobId)
                        setStatus("🚀 Đang hop tới Server #"..idx.."...", Color3.fromRGB(255,210,0))
                        hop(jobId)
                    end)
                end
            end,
        })

        -- ReLoad + Auto Hop button
        TayUI.AddButton(panel, {
            Text  = "ReLoad JobID  →  Auto Hop",
            Sub   = "Load New Server",
            Icon  = "🔄",
            Order = 4,
            Callback = function()
                clearCards(panel)
                setStatus("🔄 Đang tải + auto hop...", Color3.fromRGB(100,100,125))

                local ids = fetchJobIds(t.endpoint)

                if #ids == 0 then
                    setStatus("❌ Không có server nào!", Color3.fromRGB(255,75,75))
                    return
                end

                setStatus("🚀 Hop tới Server #1...", Color3.fromRGB(52,211,153))
                hop(ids[1])
            end,
        })

    end -- end tab content
end -- end tabs loop

print("[TàyHub] ✓ ServerHop v2.0 loaded")
