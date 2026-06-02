local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/VTDROBLOX/Animehub/refs/heads/main/Library_Custom.lua"))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local function AutoEquipWeapon(weaponType)
    local plr = game.Players.LocalPlayer
    if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
    
    local currentTool = plr.Character:FindFirstChildOfClass("Tool")
    if currentTool and currentTool:FindFirstChild("ToolTip") and currentTool.ToolTip == weaponType then
        return
    end

    for _, item in pairs(plr.Backpack:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("ToolTip") and item.ToolTip == weaponType then
            plr.Character.Humanoid:EquipTool(item)
            break
        end
    end
end


local u381 = {
    ['Reborn Skeleton'] = CFrame.new(-8769.58984, 142.13063, 6055.27637),
    ['Living Zombie'] = CFrame.new(-10156.4531, 138.652481, 5964.5752),
    ['Demonic Soul'] = CFrame.new(-9525.17188, 172.13063, 6152.30566),
    ['Posessed Mummy'] = CFrame.new(-9570.88281, 5.81831884, 6187.86279),
}
getgenv().SelectWeaponType = "Melee"

CheckNearestTeleporter = function(p94) return nil end
requestEntrance = function(v95) return nil end

function topos(p94)
    pcall(function()
        if game:GetService('Players').LocalPlayer and (game:GetService('Players').LocalPlayer.Character and (game:GetService('Players').LocalPlayer.Character:FindFirstChild('Humanoid') and (game:GetService('Players').LocalPlayer.Character:FindFirstChild('HumanoidRootPart') and (game:GetService('Players').LocalPlayer.Character.Humanoid.Health > 0 and game:GetService('Players').LocalPlayer.Character.HumanoidRootPart)))) then
            if not TweenSpeed then
                TweenSpeed = 350
            end

            DefualtY = p94.Y
            TargetY = p94.Y
            targetCFrameWithDefualtY = CFrame.new(p94.X, DefualtY, p94.Z)
            targetPos = p94.Position
            oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            Distance = (targetPos - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude

            if Distance <= 300 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p94
            end

            local v95 = CheckNearestTeleporter(p94)

            if v95 then
                pcall(function()
                    tween:Cancel()
                end)
                requestEntrance(v95)
            end

            b1 = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, DefualtY, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
            IngoreY = true

            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, DefualtY, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)

                local _TweenService2 = game:GetService('TweenService')
                local v97 = TweenInfo.new((targetPos - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude / TweenSpeed, Enum.EasingStyle.Linear)

                tween = _TweenService2:Create(game:GetService('Players').LocalPlayer.Character.HumanoidRootPart, v97, {CFrame = targetCFrameWithDefualtY})

                tween:Play();

                ({}).Stop = function(_)
                    tween:Cancel()
                end

                tween.Completed:Wait()

                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, TargetY, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
            else
                local _TweenService3 = game:GetService('TweenService')
                local v99 = TweenInfo.new((targetPos - game:GetService('Players').LocalPlayer.Character:WaitForChild('HumanoidRootPart').Position).Magnitude / TweenSpeed, Enum.EasingStyle.Linear)
                local v100 = {CFrame = p94}

                tween = _TweenService3:Create(game:GetService('Players').LocalPlayer.Character.HumanoidRootPart, v99, v100)

                tween:Play();

                ({}).Stop = function(_)
                    tween:Cancel()
                end

                tween.Completed:Wait()

                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X, TargetY, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
            end
            if tween then
                return tweenfunc
            else
                return tween
            end
        else
            return
        end
    end)
end

function StopTween(p101)
    pcall(function()
        if not p101 then
            getgenv().StopTween = true

            if tween then
                tween:Cancel()

                tween = nil
            end

            local _LocalPlayer5 = game:GetService('Players').LocalPlayer

            if _LocalPlayer5 then
                _LocalPlayer5 = _LocalPlayer5.Character
            end
            if _LocalPlayer5 then
                _LocalPlayer5 = _LocalPlayer5:FindFirstChild('HumanoidRootPart')
            end
            if _LocalPlayer5 then
                _LocalPlayer5.Anchored = true

                task.wait(0.1)

                _LocalPlayer5.CFrame = _LocalPlayer5.CFrame
                _LocalPlayer5.Anchored = false
            end
            if _LocalPlayer5 then
                _LocalPlayer5 = _LocalPlayer5:FindFirstChild('BodyClip')
            end
            if _LocalPlayer5 then
                _LocalPlayer5:Destroy()
            end

            getgenv().StopTween = false
            getgenv().Clip = false
        end
    end)
end

spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().AutoFarm_Bones or getgenv().TeleportIsland or (getgenv().AutoFarm or (getgenv().AutoMaterial or (getgenv().MasteryFarm or (getgenv().AutoGetMelee or (getgenv().TeleportToFruit or (getgenv().AutoNewWorld or (getgenv().AutoThirdSea or (getgenv().AutoFactory or (getgenv().AutoPirateRaid or (getgenv().AutoEliteHunter or (getgenv().AutoTouchPadHaki or (getgenv().AutoRipIndra or (getgenv().AutoSoulReaper or (getgenv().AutoDoughKing or (getgenv().AutoDarkbeard or (getgenv().DojoClaimQuest or (getgenv().DragonTalonUpgrade or (getgenv().BlazeEmberFarm or (getgenv().AutoObservationHakiV2 or (getgenv().AutoObservation or (getgenv().AutoFarmBoss or (getgenv().AutoFarmAllBoss or (getgenv().Auto_Dungeon or (getgenv().SailBoat or (getgenv().RelzFishBoat or (getgenv().RelzPirateBrigade or (getgenv().RelzPirateGrandBrigade or (getgenv().AutoTerrorshark or (getgenv().AutoSeaBest or (getgenv().AutoFrozenDimension or (getgenv().KillLevi or (getgenv().UpgradeRaceV2 or (getgenv().AutoCyborg or (getgenv().AutoGhoul or (getgenv().QuestTrain_2 or (getgenv().TeleportMigare or (getgenv().Tweentohighestpoint or (getgenv().TeleportToGear or (getgenv().AutoTrialRace or (getgenv().AutoKillPlayerAfterTrial or (getgenv().AutoRainbowHaki or (getgenv().AutoSkullGuitar or (getgenv().AutoGetCDK or (getgenv().AutoTushita or (getgenv().AutoSaber or getgenv().TeleportPlayer))))))))))))))))))))))))))))))))))))))))))))) then
                if not game:GetService('Players').LocalPlayer.Character.HumanoidRootPart:FindFirstChild('BodyClip') then
                    local _BodyVelocity = Instance.new('BodyVelocity')

                    _BodyVelocity.Name = 'BodyClip'
                    _BodyVelocity.Parent = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart
                    _BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    _BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                local _BodyClip = game:GetService('Players').LocalPlayer.Character.HumanoidRootPart:FindFirstChild('BodyClip')

                if _BodyClip then
                    _BodyClip:Destroy()
                end
            end
        end)
    end
end)

local Window = Library:Window({
    Title = "Premium Hub",
    SubTitle = "by Tày"
})

local MainPage = Window:NewPage({
    Title = "Main",
    Desc = "",
    Icon = 127194456372995
})
local SettingPage = Window:NewPage({
    Title = "Settings",
    Desc = "",
    Icon = 127194456372995 
})
MainPage:Select({
    Title = "Chọn Vũ Khí",
    Desc = "Chọn loại vũ khí bạn dùng để farm",
    Options = {"Melee", "Sword", "Blox Fruit", "Gun"},
    Default = "Melee",
    Callback = function(value)
        getgenv().SelectWeaponType = value 
    end
})

SettingPage:Select({
    Title = "Chọn Chỉ Số",
    Desc = "Lựa chọn chỉ số bạn muốn tự động cộng điểm",
    Options = {"Melee", "Defense", "Sword", "Gun", "Devil"},
    Default = "Melee",
    Callback = function(value)
    
        getgenv().SelectStatType = value 
    end
})

SettingPage:Toggle({
    Title = "Auto start",
    Desc = "",
    Value = false,
    Callback = function(value)
        getgenv().Auto_Stats = value 
    end
})

    
local ToggleExample = MainPage:Toggle({
	Title = "fram xương",
	Desc = "",
	Value = false,
	Callback = function(value)
		getgenv().AutoFarm_Bones = value 
	end
})

task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarm_Bones then 
            pcall(function()
                local TargetMonster = nil
                for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if u381[v.Name] and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        TargetMonster = v
                        break
                    end
                end
                if getgenv().SelectWeaponType then
                    AutoEquipWeapon(getgenv().SelectWeaponType)
                end
                
                if TargetMonster then
                    local TargetCFrame = u381[TargetMonster.Name] * CFrame.new(0, 12, 0)
                    topos(TargetCFrame)
                else
                    topos(CFrame.new(-9525.17188, 182, 6152.30566))
                end

                for _, v385 in pairs(game.Workspace.Enemies:GetChildren()) do
                     if u381[v385.Name] and (v385:FindFirstChild('HumanoidRootPart') and v385:FindFirstChild('Humanoid')) then
                        v385.HumanoidRootPart.CFrame = u381[v385.Name]
                        v385.Head.CanCollide = false
                        v385.Humanoid.Sit = false
                        v385.Humanoid:ChangeState(11)
                        v385.HumanoidRootPart.CanCollide = false
                        v385.Humanoid.JumpPower = 0
                        v385.Humanoid.WalkSpeed = 0
                        local _Animator3 = v385.Humanoid:FindFirstChild('Animator')
                        if _Animator3 then _Animator3:Destroy() end
                        sethiddenproperty(game.Players.LocalPlayer, 'SimulationRadius', math.huge)
                    end
                end
            end)
        else
            StopTween()
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do 
        if getgenv().Auto_Stats then
            pcall(function()
                if getgenv().SelectStatType then                  
                    StatsSetings(getgenv().SelectStatType, 1)
                    
                end
            end)
        end
    end
 end)
    