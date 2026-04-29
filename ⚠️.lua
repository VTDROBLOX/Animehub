-- [[ CONFIG ]]
_G.BringMobFarm = true
_G.FastV2 = true
_G.FarmState = true
_G.KilledCount = 0 

local p = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Net = require(RS.Modules.Net)
local RegisterHit = Net:RemoteEvent("RegisterHit")
local RegisterAttack = RS.Modules.Net["RE/RegisterAttack"]

-- [[ GUI GÓC TRÊN BÊN TRÁI - DƯỚI LOGO 12+ ]]
local function CreateGUI()
    if p.PlayerGui:FindFirstChild("FarmCounter") then p.PlayerGui.FarmCounter:Destroy() end
    local sg = Instance.new("ScreenGui", p.PlayerGui)
    sg.Name = "FarmCounter"
    
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 110, 0, 35)
    -- Tọa độ ngay dưới logo 12+
    frame.Position = UDim2.new(0.015, 0, 0.12, 0) 
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.4
    
    local label = Instance.new("TextLabel", frame)
    label.Name = "CountLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = "Killed: 0"
    label.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan Neon
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.BackgroundTransparency = 1
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 255, 255)
    stroke.Thickness = 1.5
end
CreateGUI()

local function UpdateLabel()
    if p.PlayerGui:FindFirstChild("FarmCounter") then
        p.PlayerGui.FarmCounter.Frame.CountLabel.Text = "Killed: " .. _G.KilledCount
    end
end

-- [[ LOGIC ĐẾM: CỨ HIỆN CHỮ "EXP" LÀ CỘNG 1 ]]
-- Logic này cực chuẩn, không cần quan tâm quái máu bao nhiêu
p.PlayerGui.Notifications.ChildAdded:Connect(function(child)
    -- Đợi một chút để text load hẳn rồi check
    task.wait(0.1)
    if child:IsA("TextLabel") and (string.find(child.Text, "Exp") or string.find(child.Text, "Đã nhận")) then
        _G.KilledCount = _G.KilledCount + 1
        UpdateLabel()
    end
end)

-- Tự động cầm Fruit
local function EquipFruit()
    local char = p.Character
    if char then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool.ToolTip == "Blox Fruit" then return tool end
        for _, v in pairs(p.Backpack:GetChildren()) do
            if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
                char.Humanoid:EquipTool(v)
                return v
            end
        end
    end
    return nil
end

-- Timer 20s Farm / 5s Nghỉ
task.spawn(function()
    while _G.BringMobFarm do
        _G.FarmState = true
        task.wait(20)
        _G.FarmState = false
        task.wait(5)
    end
end)

-- Logic Dịch Chuyển & Farm Gốc
task.spawn(function()
    while _G.BringMobFarm do
        task.wait(0.1)
        if _G.FarmState then
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                for _, target in pairs(workspace.Enemies:GetChildren()) do
                    if not _G.FarmState or not _G.BringMobFarm then break end
                    local hum = target:FindFirstChild("Humanoid")
                    local tRoot = target:FindFirstChild("HumanoidRootPart")
                    
                    if hum and hum.Health > 0 and tRoot then
                        local fruit = EquipFruit()
                        char:PivotTo(tRoot.CFrame * CFrame.new(0, 2, 0))
                        
                        if _G.FastV2 then
                            RegisterAttack:FireServer()
                            RegisterHit:FireServer(root, {{target, tRoot}}, nil, nil, tostring(os.clock()))
                            if fruit and fruit:FindFirstChild("LeftClickRemote") then
                                fruit.LeftClickRemote:FireServer((tRoot.Position - root.Position).Unit, 1)
                            end
                        end
                        task.wait(0.05) 
                    end
                end
            end
        end
    end
end)

-- Chống rơi
task.spawn(function()
    while _G.BringMobFarm do
        local root = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if root and not root:FindFirstChild("VelocityHold") then
            local bv = Instance.new("BodyVelocity", root)
            bv.Name = "VelocityHold"
            bv.Velocity = Vector3.zero
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        end
        task.wait(1)
    end
end)
