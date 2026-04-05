-- ╔══════════════════════════════════════════════════╗
-- ║   ServerHop.lua — Tày Hub  |  v3.0              ║
-- ║   Style: Teddy Hub  |  Blox Fruits              ║
-- ║   Delta / Hydrogen / Solara                     ║
-- ╚══════════════════════════════════════════════════╝

-- ── Load UI ──────────────────────────────────────────────
local TayUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/VTDROBLOX/Animehub/refs/heads/main/TayUI.lua", true
))()

-- ── Services ─────────────────────────────────────────────
local TeleportService = game:GetService("TeleportService")
local HttpService     = game:GetService("HttpService")
local Players         = game:GetService("Players")
local LP              = Players.LocalPlayer

-- ── Config ───────────────────────────────────────────────
local BASE_URL = "http://nighthub.site/boss/"
local MAX_SRV  = 8

-- ── Fetch JobIDs từ API ───────────────────────────────────
local function fetchJobIds(endpoint)
    local url = BASE_URL .. endpoint
    local ok, raw = pcall(game.HttpGet, game, url, true)
    if not ok or not raw or raw=="" then return {} end

    local ids = {}
    local ok2, parsed = pcall(HttpService.JSONDecode, HttpService, raw)
    if ok2 and type(parsed)=="table" then
        for _, v in ipairs(parsed) do
            if type(v)=="string" then
                table.insert(ids, v)
            elseif type(v)=="table" then
                local id = v.jobId or v.id or v.JobId
                if id then table.insert(ids, id) end
            end
        end
    else
        for id in raw:gmatch("[0-9a-f]%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") do
            table.insert(ids, id)
        end
    end
    return ids
end

-- ── Hop ──────────────────────────────────────────────────
local function hop(jobId)
    if not jobId or jobId=="" then return end
    pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, jobId, LP)
end

-- ══════════════════════════════════════
-- DATA
-- ══════════════════════════════════════

-- Tab Hop: danh sách boss/event/island
local HOP_LIST = {
    { label="Hop Fullmoon",          endpoint="Fullmoon"          },
    { label="Hop Near Moon",         endpoint="NearMoon"          },
    { label="Hop Mirage Island",     endpoint="Mirage"            },
    { label="Hop Kitsune Island",    endpoint="KitsuneIsland"     },
    { label="Hop Prehistoric Island",endpoint="PrehistoricIsland" },
    { label="Hop Sword Legendary",   endpoint="SwordLegendary"    },
    { label="Hop Haki Legendary",    endpoint="HakiLegendary"     },
    { label="Hop Rip Indra",         endpoint="RipIndra"          },
    { label="Hop Darkbeard",         endpoint="Darkbeard"         },
    { label="Hop Dough King",        endpoint="DoughKing"         },
    { label="Hop Berry",             endpoint="Berry"             },
    { label="Hop Tyrant Of Skies",   endpoint="TyrantOfTheSkies"  },
    { label="Hop Cursed Captain",    endpoint="CursedCaptain"     },
    { label="Hop Soul Reaper",       endpoint="SoulReaper"        },
    { label="Hop Cake Prince",       endpoint="CakePrince"        },
    { label="Hop Elite",             endpoint="Elite"             },
    { label="Hop Castle Raid",       endpoint="CastleRaid"        },
}

-- ══════════════════════════════════════
-- BUILD WINDOW
-- ══════════════════════════════════════
local Win = TayUI:CreateWindow({
    Title   = "Tày Hub",
    Sub     = "discord.gg/tayhub",
    Width   = 680,
    Height  = 480,
    Sidebar = 150,
})

-- ══════════════════════════════════════
-- TAB: Info
-- ══════════════════════════════════════
local infoTab = Win:AddTab("Info", 1)
TayUI.AddTitle(infoTab, "Info", 0)
TayUI.AddLabel(infoTab, "🎮  Tày Hub — Server Hop v3.0", Color3.fromRGB(52,211,153), 1)
TayUI.AddLabel(infoTab, "📡  API: nighthub.site/boss/...", nil, 2)
TayUI.AddLabel(infoTab, "⚠️   Chỉ dùng trong Blox Fruits!", Color3.fromRGB(255,210,0), 3)
TayUI.AddLabel(infoTab, "✅  Delta / Hydrogen / Solara OK", nil, 4)
TayUI.AddLabel(infoTab, "👈  Chọn Hop → bấm server → HOP", nil, 5)

-- ══════════════════════════════════════
-- TAB: Hop
-- ══════════════════════════════════════
local hopTab = Win:AddTab("Hop", 2)
TayUI.AddTitle(hopTab, "Hop", 0)

for i, h in ipairs(HOP_LIST) do
    TayUI.AddRow(hopTab, h.label, i, function()
        -- Fetch rồi mở picker
        local ids = fetchJobIds(h.endpoint)
        TayUI.ShowPicker(h.label, ids, function(jobId)
            hop(jobId)
        end)
    end)
end

-- ══════════════════════════════════════
-- TAB: Id Game
-- ══════════════════════════════════════
local idTab = Win:AddTab("Id Game", 3)
TayUI.AddTitle(idTab, "Id Game", 0)
TayUI.AddSubTitle(idTab, "Place ID", 1)
TayUI.AddLabel(idTab, "Place ID: "..tostring(game.PlaceId), nil, 2)
TayUI.AddLabel(idTab, "Job ID: "..tostring(game.JobId), nil, 3)

-- ══════════════════════════════════════
-- TAB: Setting
-- ══════════════════════════════════════
local setTab = Win:AddTab("Setting", 4)
TayUI.AddTitle(setTab, "Setting", 0)

TayUI.AddSubTitle(setTab, "Thông báo", 1)
TayUI.AddToggle(setTab, "Thông báo khi hop thành công", true, 2, function(state)
    -- placeholder
end)

TayUI.AddSubTitle(setTab, "Hiệu ứng", 3)
TayUI.AddToggle(setTab, "Hiện ping dot", true, 4, function(state)
    -- placeholder
end)
TayUI.AddToggle(setTab, "Animation mở cửa sổ", true, 5, function(state)
    -- placeholder
end)

print("[TàyHub] ✓ ServerHop v3.0 loaded")
