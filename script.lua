-- ========================================
-- ===== PLANT HUB v3.0 ULTIMATE (ПОЛНАЯ ВЕРСИЯ) =====
-- ========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local MaterialService = game:GetService("MaterialService")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ========================================
-- ===== ЗАГРУЗКА WINDUI =====
-- ========================================

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
if not WindUI then
    game.StarterGui:SetCore("SendNotification", {Title="Error", Text="WindUI not loaded!", Duration=5})
    return
end

WindUI:SetTheme("Violet")
WindUI.TransparencyValue = 0.1

-- ========================================
-- ===== ПЛАШКА "РЕЛИЗ" =====
-- ========================================

local function createReleaseBadge()
    local badge = Instance.new("TextLabel")
    badge.Name = "ReleaseBadge"
    badge.Size = UDim2.new(0, 65, 0, 20)
    badge.Position = UDim2.new(0, 160, 0, 12)
    badge.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    badge.BackgroundTransparency = 0.15
    badge.TextColor3 = Color3.fromRGB(255, 255, 255)
    badge.Text = "Релиз"
    badge.TextSize = 11
    badge.Font = Enum.Font.GothamBold
    badge.BorderSizePixel = 0
    badge.TextStrokeColor3 = Color3.fromRGB(138, 43, 226)
    badge.TextStrokeTransparency = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = badge
    return badge
end

-- ========================================
-- ===== СОЗДАНИЕ ОКНА =====
-- ========================================

local Window = WindUI:CreateWindow({
    Title = "PlanetHub",
    Author = "MMV and MM2",
    Icon = "crown",
    Folder = "PlanetHubSettings",
    Size = UDim2.fromOffset(720, 600),
    Resizable = true,
    Transparent = true,
    Theme = "Violet",
    SideBarWidth = 190,
    HideSearchBar = false
})

local badge = createReleaseBadge()
badge.Parent = Window.UIElements.Main

-- ========================================
-- ===== УВЕДОМЛЕНИЯ WINDUI =====
-- ========================================

local function notify(title, content, duration)
    pcall(function()
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = duration or 3,
        })
    end)
end

-- ========================================
-- ===== НАСТРОЙКИ =====
-- ========================================

local Settings = {
    MurderESP = false,
    SheriffESP = false,
    InnocentESP = false,
    ChamsEnabled = false,
    ChamsColor = "Purple",
    TracersEnabled = false,
    JumpCircles = false,
    Trails = false,
    RGBHumanoid = false,
    XRayEnabled = false,
    BloomEnabled = false,
    ColorCorrectionEnabled = false,
    VignetteEnabled = false,
    CustomSkyId = "",
    FlyEnabled = false,
    BHopEnabled = false,
    BHopSpeed = 30,
    SpinBotEnabled = false,
    SpinBotSpeed = 9999,
    AntiFlingEnabled = false,
    FovAimbotEnabled = false,
    FovRadius = 120,
    AutoFarmEnabled = false,
    AutoFarmSpeed = 20,
    AutoFarmCoinLimit = 40,
    AutoFarmCoinDelay = 0.15,
    AutoRespawn = true,
    AntiAFKEnabled = false,
    ShootButtonEnabled = false,
    GrabGunEnabled = false,
    SheriffAutoShootEnabled = false,
    WallHopEnabled = false,
    TexturePackEnabled = false,
    ChinaHatEnabled = false,
    ChinaHatStyle = "Classic",
    ChinaHatTransparency = 0.3,
    ChinaHatRainbow = false,
    ChinaHatRainbowSpeed = 5,
    ChinaHatColor = Color3.fromRGB(0, 255, 255),
    ChinaHatRadius = 2.4,
    ChinaHatHeight = 1.6,
    ChinaHatReflectance = 0,
    ChinaHatSides = 25,
    AuraEnabled = false,
    AuraColor = Color3.fromRGB(133, 220, 255),
    JerkEnabled = false,
    OrbizEnabled = false,
}

-- ========================================
-- ===== КЭШ =====
-- ========================================

local Cache = {
    Highlights = {},
    ChamsPartsList = {},
    PostEffects = {},
    JumpTracking = {wasJumping = false},
    RGBConnection = nil,
    AutoFarmConn = nil,
    CurrentTween = nil,
    XRayParts = {},
    Tracers = {},
    TrailAttachments = {},
    FovCircle = nil,
    FovConnection = nil,
    FlyCore = nil,
    FlyKeys = {a=false,d=false,w=false,s=false},
    FlySpeed = 10,
    FlyRunning = false,
    FlyE1 = nil,
    FlyE2 = nil,
    mainConn = nil,
    GrabGunRunning = false,
    WallHopConnection = nil,
    SheriffAutoShootConnection = nil,
    ChinaHatParts = {},
    ChinaHatConnection = nil,
    ChinaHatDrawings = {},
    TextureState = {},
    TextureVariantsBuilt = false,
    AuraParticles = {},
    AuraCache = {},
    JerkConnection = nil,
    BHopConn = nil,
    BHopBV = nil,
    BHopActive = false,
    SpinConn = nil,
    OrbizFolder = nil,
    OrbizParticles = {},
    OrbizConnection = nil,
}

local COLORS = {
    Murder = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 100, 255),
    Innocent = Color3.fromRGB(138, 43, 226),
    Purple = Color3.fromRGB(138, 43, 226),
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 50, 50),
    Blue = Color3.fromRGB(0, 100, 255),
    Green = Color3.fromRGB(0, 255, 0),
}

local CHAMS_COLORS = {
    Purple = Color3.fromRGB(138, 43, 226),
    Blue = Color3.fromRGB(0, 100, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
}

-- ========================================
-- ===== ХЕЛПЕРЫ =====
-- ========================================

local function safeDisconnect(conn)
    if conn and typeof(conn) == "RBXScriptConnection" then
        pcall(function() conn:Disconnect() end)
    end
end

local function checkKnife(player)
    if not player or not player.Character then return false end
    for _, item in ipairs(player.Character:GetDescendants()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("knife") or n:find("blade") then return true end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("knife") or n:find("blade") then return true end
            end
        end
    end
    return false
end

local function checkGun(player)
    if not player or not player.Character then return false end
    for _, item in ipairs(player.Character:GetDescendants()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("gun") or n:find("pistol") or n:find("revolver") then return true end
        end
    end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("gun") or n:find("pistol") or n:find("revolver") then return true end
            end
        end
    end
    return false
end

local function getRole(player)
    if checkKnife(player) then return "Убийца" end
    if checkGun(player) then return "Шериф" end
    return "Невинный"
end

local function getRoleColor(player)
    local r = getRole(player)
    if r == "Убийца" then return COLORS.Murder end
    if r == "Шериф" then return COLORS.Sheriff end
    return COLORS.Purple
end

local function equipGun()
    if not LocalPlayer.Character then return false end
    for _, item in ipairs(LocalPlayer.Character:GetDescendants()) do
        if item:IsA("Tool") then
            local n = item.Name:lower()
            if n:find("gun") or n:find("pistol") or n:find("revolver") then
                pcall(function() LocalPlayer.Character.Humanoid:EquipTool(item) end)
                return true
            end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("gun") or n:find("pistol") or n:find("revolver") then
                    pcall(function() LocalPlayer.Character.Humanoid:EquipTool(item) end)
                    return true
                end
            end
        end
    end
    return false
end

local function getGroundY(origin)
    local rayOrigin = origin
    local rayDirection = Vector3.new(0, -50, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local char = LocalPlayer.Character
    if char then
        raycastParams.FilterDescendantsInstances = {char}
    end
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then
        return result.Position.Y
    end
    return origin.Y - 3
end

local function isPlayerVisible(player)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
    local result = Workspace:Raycast(myHRP.Position, hrp.Position - myHRP.Position, raycastParams)
    return not result
end

-- ========================================
-- ===== НЕОН-ТРЕЙС ОТ ВЫСТРЕЛА =====
-- ========================================

local function createGunBeam(startPos, endPos, color, duration)
    duration = duration or 0.2
    color = color or Color3.fromRGB(180, 50, 255)

    local distance = (startPos - endPos).Magnitude
    if distance < 1 then return end

    local beam = Instance.new("Part")
    beam.Name = "GunBeam"
    beam.Size = Vector3.new(0.15, 0.15, distance)
    beam.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -distance / 2)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = color
    beam.Transparency = 0.1
    beam.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = 10
    light.Range = 15
    light.Parent = beam

    task.spawn(function()
        for i = 1, 10 do
            task.wait(duration / 10)
            beam.Transparency = beam.Transparency + 0.09
            beam.Size = Vector3.new(beam.Size.X * 0.95, beam.Size.Y * 0.95, beam.Size.Z)
        end
        beam:Destroy()
    end)

    return beam
end

-- ========================================
-- ===== АУРА =====
-- ========================================

local AURA_IDS = {
    angel = "97658130917593",
    starlight = "134645216613107",
    heavenly = "139300897520961",
    ribbon = "132069507632161",
    sakura = "81755778619404",
    wind = "80694081850877",
    flow = "119913533725648",
    star = "73754563740680"
}

local AURA_ORDER = {"angel", "starlight", "heavenly", "ribbon", "sakura", "wind", "flow", "star"}
local AuraSelected = {}

for _, name in ipairs(AURA_ORDER) do
    AuraSelected[name] = false
end

local function clearAura()
    for _, p in ipairs(Cache.AuraParticles) do
        pcall(function() p:Destroy() end)
    end
    Cache.AuraParticles = {}
end

local function loadAura(name)
    if Cache.AuraCache[name] then return Cache.AuraCache[name] end
    local id = AURA_IDS[name]
    if not id then return nil end
    local success, result = pcall(game.GetObjects, game, "rbxassetid://"..id)
    if success and result and result[1] then
        Cache.AuraCache[name] = result[1]
        return result[1]
    end
    return nil
end

local function colorAura(model, color)
    local seq = ColorSequence.new(color)
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("PointLight") then
            descendant.Color = color
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Color = seq
        end
    end
end

local function applyAura()
    clearAura()
    if not Settings.AuraEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    
    local real_char = char
    if char.Parent ~= workspace then
        real_char = nil
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name == LocalPlayer.Name then
                if not (obj:GetAttribute("1") or obj == _G.VIEWPORT_CLONE) then
                    local hrp = obj:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp:IsA("BasePart") then
                        real_char = obj
                        break
                    end
                end
            end
        end
    end
    if not real_char then return end
    
    for _, name in ipairs(AURA_ORDER) do
        if AuraSelected[name] then
            local aura_model = loadAura(name)
            if aura_model then
                colorAura(aura_model, Settings.AuraColor)
                local cloned = aura_model:Clone()
                for _, part in ipairs(cloned:GetChildren()) do
                    local target = real_char:FindFirstChild(part.Name)
                    if target and target:IsA("BasePart") then
                        for _, child in ipairs(part:GetChildren()) do
                            child.Parent = target
                            table.insert(Cache.AuraParticles, child)
                        end
                    end
                end
                cloned:Destroy()
            end
        end
    end
end

local function toggleAura(value)
    Settings.AuraEnabled = value
    if value then applyAura() else clearAura() end
end

-- ========================================
-- ===== JERK =====
-- ========================================

local function toggleJerk(value)
    Settings.JerkEnabled = value
    
    if value then
        if Cache.JerkConnection then
            Cache.JerkConnection:Disconnect()
            Cache.JerkConnection = nil
        end
        
        Cache.JerkConnection = RunService.Heartbeat:Connect(function()
            if not LocalPlayer.Character then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local randomVec = Vector3.new(
                math.random(-50, 50),
                math.random(-30, 30),
                math.random(-50, 50)
            )
            hrp.AssemblyLinearVelocity = randomVec
        end)
        notify("Jerk", "Включен", 2)
    else
        if Cache.JerkConnection then
            Cache.JerkConnection:Disconnect()
            Cache.JerkConnection = nil
        end
        notify("Jerk", "Выключен", 2)
    end
end

-- ========================================
-- ===== FLY =====
-- ========================================

local function stopFly()
    if Cache.FlyRunning then
        Cache.FlyRunning = false
        if Cache.FlyE1 then
            Cache.FlyE1:Disconnect()
            Cache.FlyE1 = nil
        end
        if Cache.FlyE2 then
            Cache.FlyE2:Disconnect()
            Cache.FlyE2 = nil
        end
        if Cache.FlyCore and Cache.FlyCore.Parent then
            Cache.FlyCore:Destroy()
            Cache.FlyCore = nil
        end
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        Cache.FlyKeys = {a=false,d=false,w=false,s=false}
        Cache.FlySpeed = 10
    end
end

local function startFly()
    if Cache.FlyRunning then return end
    if not LocalPlayer.Character then return end
    
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return end
    
    if workspace:FindFirstChild("Core") then
        workspace.Core:Destroy()
    end
    if Cache.FlyCore and Cache.FlyCore.Parent then
        Cache.FlyCore:Destroy()
        Cache.FlyCore = nil
    end
    
    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)
    Core.Anchored = true
    Core.CanCollide = false
    Core.Transparency = 1
    Core.Parent = workspace
    
    task.spawn(function()
        repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("LowerTorso")
        if Core and Core.Parent then
            local Weld = Instance.new("Weld", Core)
            Weld.Part0 = Core
            Weld.Part1 = LocalPlayer.Character.LowerTorso
            Weld.C0 = CFrame.new(0, 0, 0)
        end
    end)
    
    task.wait(0.1)
    local torso = workspace:FindFirstChild("Core")
    if not torso then
        notify("Fly", "Core не создан", 2)
        return
    end
    
    Cache.FlyCore = torso
    Cache.FlyRunning = true
    Cache.FlyKeys = {a=false,d=false,w=false,s=false}
    Cache.FlySpeed = 10
    
    local pos = Instance.new("BodyPosition", torso)
    local gyro = Instance.new("BodyGyro", torso)
    pos.Name = "EPIXPOS"
    pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
    pos.position = torso.Position
    gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.cframe = torso.CFrame
    
    local flyThread = task.spawn(function()
        while Cache.FlyRunning and torso and torso.Parent do
            task.wait()
            if not LocalPlayer.Character then break end
            
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            
            local new = gyro.cframe - gyro.cframe.p + pos.position
            
            if not Cache.FlyKeys.w and not Cache.FlyKeys.s and not Cache.FlyKeys.a and not Cache.FlyKeys.d then
                Cache.FlySpeed = 5
            end
            
            if Cache.FlyKeys.w then
                new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * Cache.FlySpeed
            end
            if Cache.FlyKeys.s then
                new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * Cache.FlySpeed
            end
            if Cache.FlyKeys.d then
                new = new * CFrame.new(Cache.FlySpeed,0,0)
            end
            if Cache.FlyKeys.a then
                new = new * CFrame.new(-Cache.FlySpeed,0,0)
            end
            
            if Cache.FlySpeed > 10 then Cache.FlySpeed = 5 end
            
            pos.position = new.p
            
            if Cache.FlyKeys.w then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad(Cache.FlySpeed*0),0,0)
            elseif Cache.FlyKeys.s then
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(math.rad(Cache.FlySpeed*0),0,0)
            else
                gyro.cframe = workspace.CurrentCamera.CoordinateFrame
            end
        end
        
        if gyro then gyro:Destroy() end
        if pos then pos:Destroy() end
        if Cache.FlyCore and Cache.FlyCore.Parent then
            Cache.FlyCore:Destroy()
            Cache.FlyCore = nil
        end
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
        Cache.FlyRunning = false
    end)
    
    Cache.FlyE1 = mouse.KeyDown:Connect(function(key)
        if not Cache.FlyRunning then return end
        if key == "w" then Cache.FlyKeys.w = true
        elseif key == "s" then Cache.FlyKeys.s = true
        elseif key == "a" then Cache.FlyKeys.a = true
        elseif key == "d" then Cache.FlyKeys.d = true
        elseif key == "x" then
            if Cache.FlyRunning then
                stopFly()
            else
                startFly()
            end
        end
    end)
    
    Cache.FlyE2 = mouse.KeyUp:Connect(function(key)
        if key == "w" then Cache.FlyKeys.w = false
        elseif key == "s" then Cache.FlyKeys.s = false
        elseif key == "a" then Cache.FlyKeys.a = false
        elseif key == "d" then Cache.FlyKeys.d = false
        end
    end)
    
    notify("Fly", "Включен (WASD - движение, X - выкл)", 2)
end

local function toggleFly(value)
    Settings.FlyEnabled = value
    if value then startFly() else stopFly() end
end

-- ========================================
-- ===== BANIHOP =====
-- ========================================

local function stopBHop()
    Cache.BHopActive = false
    if Cache.BHopConn then
        Cache.BHopConn:Disconnect()
        Cache.BHopConn = nil
    end
    if Cache.BHopBV then
        pcall(function() Cache.BHopBV:Destroy() end)
        Cache.BHopBV = nil
    end
end

local function startBHop()
    if not LocalPlayer.Character then return end
    if Cache.BHopActive then stopBHop() end

    local char = LocalPlayer.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    Cache.BHopActive = true

    if Cache.BHopBV then
        pcall(function() Cache.BHopBV:Destroy() end)
        Cache.BHopBV = nil
    end
    
    Cache.BHopBV = Instance.new("BodyVelocity")
    Cache.BHopBV.Name = "BHopBV"
    Cache.BHopBV.MaxForce = Vector3.new(1e5, 0, 1e5)
    Cache.BHopBV.Velocity = Vector3.new(0, 0, 0)
    Cache.BHopBV.Parent = hrp

    local lastJump = 0
    local COOLDOWN = 0.15

    if Cache.BHopConn then
        Cache.BHopConn:Disconnect()
        Cache.BHopConn = nil
    end
    
    Cache.BHopConn = RunService.Stepped:Connect(function()
        if not Cache.BHopActive then 
            stopBHop() 
            return 
        end

        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not Cache.BHopBV or not Cache.BHopBV.Parent then
            Cache.BHopBV = Instance.new("BodyVelocity")
            Cache.BHopBV.Name = "BHopBV"
            Cache.BHopBV.MaxForce = Vector3.new(1e5, 0, 1e5)
            Cache.BHopBV.Velocity = Vector3.new(0, 0, 0)
            Cache.BHopBV.Parent = hrp
        end

        local moveDir = hum.MoveDirection
        local isMoving = moveDir.Magnitude > 0.1
        local state = hum:GetState()
        local onGround = (
            state == Enum.HumanoidStateType.Running or
            state == Enum.HumanoidStateType.Landed or
            state == Enum.HumanoidStateType.RunningNoPhysics
        )

        if isMoving then
            local horizontal = Vector3.new(moveDir.X, 0, moveDir.Z)
            if horizontal.Magnitude > 0.01 then
                Cache.BHopBV.Velocity = horizontal.Unit * Settings.BHopSpeed
            end
            if onGround and tick() - lastJump > COOLDOWN then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                lastJump = tick()
            end
        else
            Cache.BHopBV.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    notify("BHop", "Включен", 2)
end

local function toggleBHop(value)
    Settings.BHopEnabled = value
    if value then startBHop() else stopBHop() end
end

-- ========================================
-- ===== СПИН БОТ =====
-- ========================================

local SpinBot = {Enabled = false, Speed = 9999}

local function setupSpinBot()
    if Cache.SpinConn then
        Cache.SpinConn:Disconnect()
        Cache.SpinConn = nil
    end
    
    if not SpinBot.Enabled then return end
    
    Cache.SpinConn = RunService.Heartbeat:Connect(function(dt)
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SpinBot.Speed * dt), 0)
        end
    end)
end

local function toggleSpinBot(value)
    SpinBot.Enabled = value
    setupSpinBot()
    notify("Spin Bot", value and "Включен" or "Выключен", 2)
end

-- ========================================
-- ===== ОРБИЗЫ / СНЕГ =====
-- ========================================

local function createOrbiz()
    if Cache.OrbizFolder then
        Cache.OrbizFolder:Destroy()
        Cache.OrbizFolder = nil
    end
    if Cache.OrbizConnection then
        Cache.OrbizConnection:Disconnect()
        Cache.OrbizConnection = nil
    end
    Cache.OrbizParticles = {}
    
    if not Settings.OrbizEnabled then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local folder = Instance.new("Folder")
    folder.Name = "Orbiz3D"
    folder.Parent = workspace
    Cache.OrbizFolder = folder

    local COUNT = 800
    for i = 1, COUNT do
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(0.2 + math.random() * 0.3, 0.2 + math.random() * 0.3, 0.2 + math.random() * 0.3)
        part.BrickColor = BrickColor.new("Bright violet")
        part.Material = Enum.Material.Neon
        part.Transparency = 0.2 + math.random() * 0.5
        part.Anchored = true
        part.CanCollide = false
        part.Parent = folder
        
        local range = 80
        part.Position = root.Position + Vector3.new(
            (math.random() - 0.5) * range * 2,
            math.random() * 50 + 20,
            (math.random() - 0.5) * range * 2
        )
        
        table.insert(Cache.OrbizParticles, {
            part = part,
            speed = 0.2 + math.random() * 0.8,
            driftX = (math.random() - 0.5) * 0.5,
            driftZ = (math.random() - 0.5) * 0.5,
            startY = part.Position.Y
        })
    end

    Cache.OrbizConnection = RunService.Heartbeat:Connect(function()
        if not Settings.OrbizEnabled then return end
        local rootPos = root and root.Position or Vector3.new(0, 0, 0)
        local range = 80
        
        for _, data in pairs(Cache.OrbizParticles) do
            local part = data.part
            if not part or not part.Parent then continue end
            local pos = part.Position
            
            pos = pos - Vector3.new(0, data.speed * 0.08, 0)
            pos = pos + Vector3.new(data.driftX * 0.03, 0, data.driftZ * 0.03)
            
            if pos.Y < rootPos.Y - 10 then
                pos = Vector3.new(
                    rootPos.X + (math.random() - 0.5) * range * 2,
                    rootPos.Y + 30 + math.random() * 40,
                    rootPos.Z + (math.random() - 0.5) * range * 2
                )
                part.Transparency = 0.2 + math.random() * 0.5
                part.Size = Vector3.new(0.2 + math.random() * 0.4, 0.2 + math.random() * 0.4, 0.2 + math.random() * 0.4)
            end
            
            part.Position = pos
        end
    end)
end

local function toggleOrbiz(value)
    Settings.OrbizEnabled = value
    createOrbiz()
    notify("Орбизы", value and "Включены" or "Выключены", 2)
end

-- ========================================
-- ===== GRAB GUN =====
-- ========================================

local function findWeapon()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local name = obj.Name:lower()
            if name:find("gun") or name:find("pistol") or name:find("weapon") or 
               name:find("rifle") or name:find("shotgun") or name:find("gundrop") or 
               name:find("droppedgun") then
                return obj
            end
        end
    end
    return nil
end

local function grabGunAction()
    if Cache.GrabGunRunning then return end
    Cache.GrabGunRunning = true

    if not LocalPlayer.Character then
        notify("Grab Gun", "Персонаж не найден", 2)
        Cache.GrabGunRunning = false
        return
    end

    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        notify("Grab Gun", "HRP не найден", 2)
        Cache.GrabGunRunning = false
        return
    end

    local originalCFrame = hrp.CFrame

    local weapon = findWeapon()
    if not weapon then
        notify("Grab Gun", "Оружие не найдено", 2)
        Cache.GrabGunRunning = false
        return
    end

    local handle = weapon:FindFirstChild("Handle")
    if not handle then
        notify("Grab Gun", "Нет Handle", 2)
        Cache.GrabGunRunning = false
        return
    end

    hrp.CFrame = handle.CFrame * CFrame.new(0, 2, 2)
    task.wait(0.1)
    hrp.CFrame = originalCFrame

    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not tool then
            humanoid:EquipTool(weapon)
            notify("Grab Gun", "Подобрано: " .. weapon.Name, 2)
        end
    end

    Cache.GrabGunRunning = false
end

local function toggleGrabGun()
    Settings.GrabGunEnabled = not Settings.GrabGunEnabled
    if Settings.GrabGunEnabled then
        grabGunAction()
        Settings.GrabGunEnabled = false
    end
end

-- ========================================
-- ===== SHERIFF AUTO SHOOT =====
-- ========================================

local function sheriffAutoShootLoop()
    while Settings.SheriffAutoShootEnabled do
        task.wait(0.05)
        if not LocalPlayer.Character then continue end
        if not checkGun(LocalPlayer) then continue end
        local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then continue end
        local target = nil
        local targetDist = math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            if checkKnife(player) and isPlayerVisible(player) then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (myHRP.Position - hrp.Position).Magnitude
                    if dist < targetDist and dist <= 100 then
                        targetDist = dist
                        target = player
                    end
                end
            end
        end
        if target then
            local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                local targetPos = tHRP.Position
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
                local beamStart = Camera.CFrame.Position
                createGunBeam(beamStart, targetPos, Color3.fromRGB(180, 50, 255), 0.2)
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.MouseButton1, false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.MouseButton1, false, game)
                end)
                task.wait(0.3)
            end
        end
    end
end

local function toggleSheriffAutoShoot(value)
    Settings.SheriffAutoShootEnabled = value
    safeDisconnect(Cache.SheriffAutoShootConnection)
    Cache.SheriffAutoShootConnection = nil
    if value then
        Cache.SheriffAutoShootConnection = task.spawn(sheriffAutoShootLoop)
        notify("Sheriff AutoShoot", "Включен", 2)
    else
        notify("Sheriff AutoShoot", "Выключен", 2)
    end
end

-- ========================================
-- ===== WALL HOP =====
-- ========================================

local function setupWallHop()
    safeDisconnect(Cache.WallHopConnection)
    Cache.WallHopConnection = nil
    if not Settings.WallHopEnabled then return end
    Cache.WallHopConnection = RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character then return end
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function toggleWallHop(value)
    Settings.WallHopEnabled = value
    if value then
        setupWallHop()
        notify("Wall Hop", "Включен (зажми Space)", 2)
    else
        safeDisconnect(Cache.WallHopConnection)
        Cache.WallHopConnection = nil
        notify("Wall Hop", "Выключен", 2)
    end
end

-- ========================================
-- ===== CHAMS =====
-- ========================================

local function cacheCharacterParts(player)
    if not player or not player.Character then return end
    local list = {}
    for _, part in ipairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            list[part] = {
                ogMaterial = part.Material,
                ogColor = part.Color,
                ogTransparency = part.Transparency,
                ogCastShadow = part.CastShadow,
            }
        end
    end
    Cache.ChamsPartsList[player.UserId] = list
end

local function getChamsColor()
    local colorMap = {
        Purple = Color3.fromRGB(138, 43, 226),
        Blue = Color3.fromRGB(0, 100, 255),
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
    }
    return colorMap[Settings.ChamsColor] or Color3.fromRGB(138, 43, 226)
end

local function applyChams(player)
    if not player or not player.Character then return end
    local char = player.Character
    local oldHL = char:FindFirstChild("PH_Chams")
    if oldHL then pcall(function() oldHL:Destroy() end) end
    
    if not Cache.ChamsPartsList[player.UserId] then
        cacheCharacterParts(player)
    end
    
    local chamsColor = getChamsColor()
    
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            if not Cache.ChamsPartsList[player.UserId] then
                Cache.ChamsPartsList[player.UserId] = {}
            end
            if not Cache.ChamsPartsList[player.UserId][part] then
                Cache.ChamsPartsList[player.UserId][part] = {
                    ogMaterial = part.Material,
                    ogColor = part.Color,
                    ogTransparency = part.Transparency,
                    ogCastShadow = part.CastShadow,
                }
            end
            part.Material = Enum.Material.ForceField
            part.Color = chamsColor
            part.Transparency = 0.0
            part.CastShadow = false
        end
    end
end

local function removeChams(player)
    if not player or not player.Character then return end
    local char = player.Character
    local hl = char:FindFirstChild("PH_Chams")
    if hl then pcall(function() hl:Destroy() end) end
    
    local list = Cache.ChamsPartsList[player.UserId]
    if not list then return end
    
    for part, data in pairs(list) do
        if part and part.Parent then
            pcall(function()
                part.Material = data.ogMaterial
                part.Color = data.ogColor
                part.Transparency = data.ogTransparency
                part.CastShadow = data.ogCastShadow
            end)
        end
    end
    Cache.ChamsPartsList[player.UserId] = nil
end

local function clearAllChams()
    for userId, _ in pairs(Cache.ChamsPartsList) do
        local p = Players:GetPlayerByUserId(userId)
        if p then removeChams(p) end
    end
    Cache.ChamsPartsList = {}
end

local function updateChamsForAll()
    if Settings.ChamsEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            cacheCharacterParts(p)
            applyChams(p)
        end
    else
        clearAllChams()
    end
end

-- ========================================
-- ===== ESP =====
-- ========================================

local function createOrUpdateHighlight(player, color)
    if not player or not player.Character then return end
    local char = player.Character
    local hl = char:FindFirstChild("PH_ESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "PH_ESP"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Enabled = true
    Cache.Highlights[player.UserId] = hl
end

local function removeHighlight(player)
    if not player or not player.Character then return end
    local hl = player.Character:FindFirstChild("PH_ESP")
    if hl then pcall(function() hl:Destroy() end) end
    Cache.Highlights[player.UserId] = nil
end

local function clearAllHighlights()
    for _, hl in pairs(Cache.Highlights) do
        if hl then pcall(function() hl:Destroy() end) end
    end
    Cache.Highlights = {}
end

-- ========================================
-- ===== ТРАССЕРЫ =====
-- ========================================

local function createTracer(player)
    if not player or player == LocalPlayer then return end
    if Cache.Tracers[player.UserId] then return end
    
    local line = Drawing.new("Line")
    line.Thickness = 2
    line.Transparency = 0.8
    line.Visible = false
    line.Color = getRoleColor(player)
    
    Cache.Tracers[player.UserId] = line
end

local function updateTracers()
    if not Settings.TracersEnabled then
        for _, line in pairs(Cache.Tracers) do
            line.Visible = false
        end
        return
    end
    
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
    
    for userId, line in pairs(Cache.Tracers) do
        local player = Players:GetPlayerByUserId(userId)
        
        if not player or not player.Character then
            line.Visible = false
            continue
        end
        
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            line.Visible = false
            continue
        end
        
        local sp, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        
        if not onScreen then
            line.Visible = false
            continue
        end
        
        line.From = center
        line.To = Vector2.new(sp.X, sp.Y)
        line.Visible = true
        line.Color = getRoleColor(player)
    end
end

local function clearAllTracers()
    for userId, line in pairs(Cache.Tracers) do
        pcall(function() line:Remove() end)
    end
    Cache.Tracers = {}
end

-- ========================================
-- ===== TRAILS =====
-- ========================================

local function createLocalPlayerTrail()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if Cache.TrailAttachments.trail and Cache.TrailAttachments.trail.Parent then return end

    local att1 = Instance.new("Attachment"); att1.Position = Vector3.new(-1,0,0); att1.Parent = hrp
    local att2 = Instance.new("Attachment"); att2.Position = Vector3.new( 1,0,0); att2.Parent = hrp

    local trail = Instance.new("Trail")
    trail.Attachment0 = att1
    trail.Attachment1 = att2
    trail.Lifetime = 0.8
    trail.MinLength = 0
    trail.FaceCamera = true
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Color = ColorSequence.new(COLORS.Purple)
    trail.Parent = hrp
    Cache.TrailAttachments = {trail=trail, att1=att1, att2=att2}
end

local function removeLocalPlayerTrail()
    if Cache.TrailAttachments.trail then pcall(function() Cache.TrailAttachments.trail:Destroy() end) end
    if Cache.TrailAttachments.att1 then pcall(function() Cache.TrailAttachments.att1:Destroy() end) end
    if Cache.TrailAttachments.att2 then pcall(function() Cache.TrailAttachments.att2:Destroy() end) end
    Cache.TrailAttachments = {}
end

-- ========================================
-- ===== ЭФФЕКТЫ =====
-- ========================================

local function setupBloom(en)
    Lighting.Brightness = en and 1.5 or 1
end

local function setupColorCorrection(en)
    Lighting.Ambient = en and COLORS.Purple or Color3.fromRGB(0,0,0)
    Lighting.OutdoorAmbient = en and COLORS.Purple or Color3.fromRGB(0,0,0)
end

local function setupVignette(en)
    if en then
        if Cache.PostEffects.vignette then return end
        local sg = Instance.new("ScreenGui")
        sg.Name = "VignetteEffect"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1,0,1,0)
        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
        f.BackgroundTransparency = 0.5
        f.BorderSizePixel = 0
        f.Parent = sg
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
        Cache.PostEffects.vignette = sg
    else
        if Cache.PostEffects.vignette then
            pcall(function() Cache.PostEffects.vignette:Destroy() end)
            Cache.PostEffects.vignette = nil
        end
    end
end

-- ========================================
-- ===== НЕБО (SKYBOX) =====
-- ========================================

local SKYBOX_ASSETS = {
    ["Black Storm"] = {
        Bk = "rbxassetid://15502511288", Dn = "rbxassetid://15502508460",
        Ft = "rbxassetid://15502510289", Lf = "rbxassetid://15502507918",
        Rt = "rbxassetid://15502509398", Up = "rbxassetid://15502511911"
    },
    ["HD"] = {
        Bk = "http://www.roblox.com/asset/?id=16553658937", Dn = "http://www.roblox.com/asset/?id=16553660713",
        Ft = "http://www.roblox.com/asset/?id=16553662144", Lf = "http://www.roblox.com/asset/?id=16553664042",
        Rt = "http://www.roblox.com/asset/?id=16553665766", Up = "http://www.roblox.com/asset/?id=16553667750"
    },
    ["Snow"] = {
        Bk = "http://www.roblox.com/asset/?id=155657655", Dn = "http://www.roblox.com/asset/?id=155674246",
        Ft = "http://www.roblox.com/asset/?id=155657609", Lf = "http://www.roblox.com/asset/?id=155657671",
        Rt = "http://www.roblox.com/asset/?id=155657619", Up = "http://www.roblox.com/asset/?id=155674931"
    },
    ["Blue Space"] = {
        Bk = "rbxassetid://15536110634", Dn = "rbxassetid://15536112543",
        Ft = "rbxassetid://15536116141", Lf = "rbxassetid://15536114370",
        Rt = "rbxassetid://15536118762", Up = "rbxassetid://15536117282"
    },
    ["Realistic"] = {
        Bk = "rbxassetid://653719502", Dn = "rbxassetid://653718790",
        Ft = "rbxassetid://653719067", Lf = "rbxassetid://653719190",
        Rt = "rbxassetid://653718931", Up = "rbxassetid://653719321"
    },
    ["Stormy"] = {
        Bk = "http://www.roblox.com/asset/?id=18703245834", Dn = "http://www.roblox.com/asset/?id=18703243349",
        Ft = "http://www.roblox.com/asset/?id=18703240532", Lf = "http://www.roblox.com/asset/?id=18703237556",
        Rt = "http://www.roblox.com/asset/?id=18703235430", Up = "http://www.roblox.com/asset/?id=18703232671"
    },
    ["Pink"] = {
        Bk = "rbxassetid://12216109205", Dn = "rbxassetid://12216109875",
        Ft = "rbxassetid://12216109489", Lf = "rbxassetid://12216110170",
        Rt = "rbxassetid://12216110471", Up = "rbxassetid://12216108877"
    },
    ["Sunset"] = {
        Bk = "rbxassetid://600830446", Dn = "rbxassetid://600831635",
        Ft = "rbxassetid://600832720", Lf = "rbxassetid://600886090",
        Rt = "rbxassetid://600833862", Up = "rbxassetid://600835177"
    },
    ["Space"] = {
        Bk = "http://www.roblox.com/asset/?id=166509999", Dn = "http://www.roblox.com/asset/?id=166510057",
        Ft = "http://www.roblox.com/asset/?id=166510116", Lf = "http://www.roblox.com/asset/?id=166510092",
        Rt = "http://www.roblox.com/asset/?id=166510131", Up = "http://www.roblox.com/asset/?id=166510114"
    },
    ["Roblox Default"] = {
        Bk = "rbxasset://textures/sky/sky512_bk.tex", Dn = "rbxasset://textures/sky/sky512_dn.tex",
        Ft = "rbxasset://textures/sky/sky512_ft.tex", Lf = "rbxasset://textures/sky/sky512_lf.tex",
        Rt = "rbxasset://textures/sky/sky512_rt.tex", Up = "rbxasset://textures/sky/sky512_up.tex"
    },
    ["Red Night"] = {
        Bk = "http://www.roblox.com/asset/?id=401664839", Dn = "http://www.roblox.com/asset/?id=401664862",
        Ft = "http://www.roblox.com/asset/?id=401664960", Lf = "http://www.roblox.com/asset/?id=401664881",
        Rt = "http://www.roblox.com/asset/?id=401664901", Up = "http://www.roblox.com/asset/?id=401664936"
    },
    ["Pink Skies"] = {
        Bk = "http://www.roblox.com/asset/?id=151165214", Dn = "http://www.roblox.com/asset/?id=151165197",
        Ft = "http://www.roblox.com/asset/?id=151165224", Lf = "http://www.roblox.com/asset/?id=151165191",
        Rt = "http://www.roblox.com/asset/?id=151165206", Up = "http://www.roblox.com/asset/?id=151165227"
    },
    ["Purple Sunset"] = {
        Bk = "rbxassetid://264908339", Dn = "rbxassetid://264907909",
        Ft = "rbxassetid://264909420", Lf = "rbxassetid://264909758",
        Rt = "rbxassetid://264908886", Up = "rbxassetid://264907379"
    },
    ["Blue Night"] = {
        Bk = "http://www.roblox.com/asset/?id=12064107", Dn = "http://www.roblox.com/asset/?id=12064152",
        Ft = "http://www.roblox.com/asset/?id=12064121", Lf = "http://www.roblox.com/asset/?id=12063984",
        Rt = "http://www.roblox.com/asset/?id=12064115", Up = "http://www.roblox.com/asset/?id=12064131"
    },
    ["Summer"] = {
        Bk = "rbxassetid://16648590964", Dn = "rbxassetid://16648617436",
        Ft = "rbxassetid://16648595424", Lf = "rbxassetid://16648566370",
        Rt = "rbxassetid://16648577071", Up = "rbxassetid://16648598180"
    },
    ["Galaxy"] = {
        Bk = "rbxassetid://15983968922", Dn = "rbxassetid://15983966825",
        Ft = "rbxassetid://15983965025", Lf = "rbxassetid://15983967420",
        Rt = "rbxassetid://15983966246", Up = "rbxassetid://15983964246"
    },
    ["Minecraft"] = {
        Bk = "rbxassetid://8735166756", Dn = "http://www.roblox.com/asset/?id=8735166707",
        Ft = "http://www.roblox.com/asset/?id=8735231668", Lf = "http://www.roblox.com/asset/?id=8735166755",
        Rt = "http://www.roblox.com/asset/?id=8735166751", Up = "http://www.roblox.com/asset/?id=8735166729"
    },
}

local DefaultSky = Lighting:FindFirstChildOfClass("Sky")
local DefaultSkySettings = {}
if DefaultSky then
    DefaultSkySettings.SkyboxBk = DefaultSky.SkyboxBk
    DefaultSkySettings.SkyboxDn = DefaultSky.SkyboxDn
    DefaultSkySettings.SkyboxFt = DefaultSky.SkyboxFt
    DefaultSkySettings.SkyboxLf = DefaultSky.SkyboxLf
    DefaultSkySettings.SkyboxRt = DefaultSky.SkyboxRt
    DefaultSkySettings.SkyboxUp = DefaultSky.SkyboxUp
end

local function setupSky(skyName)
    local sb = SKYBOX_ASSETS[skyName]
    if not sb then
        local skyId = tostring(skyName):gsub("%s+",""):gsub("rbxassetid://","")
        if skyId:match("^%d+$") then
            local url = "rbxassetid://" .. skyId
            for _, obj in ipairs(Lighting:GetChildren()) do
                if obj:IsA("Sky") then obj:Destroy() end
            end
            local sky = Instance.new("Sky")
            sky.SkyboxBk = url
            sky.SkyboxDn = url
            sky.SkyboxFt = url
            sky.SkyboxLf = url
            sky.SkyboxRt = url
            sky.SkyboxUp = url
            sky.Parent = Lighting
            notify("Небо", "Загружено: " .. skyId, 2)
        else
            notify("Небо", "Неизвестный скибокс", 2)
        end
        return
    end
    
    local assets = {sb.Bk, sb.Dn, sb.Ft, sb.Lf, sb.Rt, sb.Up}
    task.spawn(function()
        ContentProvider:PreloadAsync(assets)
    end)
    
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then 
        sky = Instance.new("Sky")
        sky.Name = "Sky" 
        sky.Parent = Lighting
    end
    
    sky.SkyboxBk = sb.Bk
    sky.SkyboxDn = sb.Dn
    sky.SkyboxFt = sb.Ft
    sky.SkyboxLf = sb.Lf
    sky.SkyboxRt = sb.Rt
    sky.SkyboxUp = sb.Up
    
    notify("Небо", "Загружено: " .. skyName, 2)
end

local function removeSky()
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then obj:Destroy() end
    end
    notify("Небо", "Удалено", 2)
end

-- ========================================
-- ===== TEXTURE PACK =====
-- ========================================

local TEXTURE_VARIANTS = {
    Brick = { BaseMaterial = Enum.Material.Brick, Texture = 'rbxassetid://10777285622' },
    Concrete = { BaseMaterial = Enum.Material.Concrete, Texture = 'rbxassetid://15622710576' },
    CorrodedMetal = { BaseMaterial = Enum.Material.CorrodedMetal, Texture = 'rbxassetid://78612695839404' },
    Grass = { BaseMaterial = Enum.Material.Grass, Texture = 'rbxassetid://9267183930' },
    Metal = { BaseMaterial = Enum.Material.Metal, Texture = 'rbxassetid://121650613091353' },
    Sand = { BaseMaterial = Enum.Material.Sand, Texture = 'rbxassetid://12624140843' },
    Slate = { BaseMaterial = Enum.Material.Slate, Texture = 'rbxassetid://8676746437' },
    Wood = { BaseMaterial = Enum.Material.Wood, Texture = 'rbxassetid://3258599312' },
    WoodPlanks = { BaseMaterial = Enum.Material.WoodPlanks, Texture = 'rbxassetid://8676581022' },
}

local TEXTURE_VARIANT_BY_MATERIAL = {
    [Enum.Material.Brick] = 'Brick',
    [Enum.Material.Concrete] = 'Concrete',
    [Enum.Material.CorrodedMetal] = 'CorrodedMetal',
    [Enum.Material.Grass] = 'Grass',
    [Enum.Material.Metal] = 'Metal',
    [Enum.Material.Sand] = 'Sand',
    [Enum.Material.Slate] = 'Slate',
    [Enum.Material.Wood] = 'Wood',
    [Enum.Material.WoodPlanks] = 'WoodPlanks',
}

local TEXTURE_TERRAIN_COLORS = {
    [Enum.Material.Grass] = Color3.fromRGB(106, 170, 64),
    [Enum.Material.Ground] = Color3.fromRGB(134, 96, 67),
    [Enum.Material.Mud] = Color3.fromRGB(102, 76, 51),
    [Enum.Material.Sand] = Color3.fromRGB(219, 211, 160),
    [Enum.Material.Rock] = Color3.fromRGB(122, 122, 122),
    [Enum.Material.Slate] = Color3.fromRGB(90, 90, 90),
    [Enum.Material.Snow] = Color3.fromRGB(245, 245, 245),
    [Enum.Material.Water] = Color3.fromRGB(63, 118, 228),
}

local function ensureTextureVariants()
    if Cache.TextureVariantsBuilt then return end
    for name, data in pairs(TEXTURE_VARIANTS) do
        local variant = MaterialService:FindFirstChild(name)
        if not variant then
            variant = Instance.new('MaterialVariant')
            variant.Name = name
            variant.Parent = MaterialService
        end
        pcall(function()
            variant.BaseMaterial = data.BaseMaterial
            variant.ColorMap = data.Texture
            variant.MetalnessMap = data.Texture
            variant.NormalMap = data.Texture
            variant.RoughnessMap = data.Texture
            variant.MaterialPattern = Enum.MaterialPattern.Regular
            variant.StudsPerTile = 5
        end)
    end
    Cache.TextureVariantsBuilt = true
end

local function rememberTexturePart(part)
    if not Cache.TextureState[part] then
        Cache.TextureState[part] = {
            Color = part.Color,
            Material = part.Material,
            MaterialVariant = part.MaterialVariant,
        }
    end
    return Cache.TextureState[part]
end

local function shouldSkipTexturePart(part)
    if not part:IsDescendantOf(workspace) then return true end
    if part.Name == 'LarpticWeather' or part.Name == 'Part' then return true end
    local parent = part.Parent
    if parent and (parent:IsA('Tool') or parent:IsA('Accessory')) then return true end
    local model = part:FindFirstAncestorOfClass('Model')
    if model and game.Players:GetPlayerFromCharacter(model) then return true end
    return false
end

local function applyTexturePack()
    if not Settings.TexturePackEnabled then return end
    ensureTextureVariants()
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA('BasePart') and not shouldSkipTexturePart(obj) then
            rememberTexturePart(obj)
            local variantName = TEXTURE_VARIANT_BY_MATERIAL[obj.Material]
            if variantName then
                pcall(function() obj.MaterialVariant = variantName end)
            end
        end
    end
    
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    if Terrain then
        for mat, col in pairs(TEXTURE_TERRAIN_COLORS) do
            pcall(function() Terrain:SetMaterialColor(mat, col) end)
        end
    end
end

local function clearTexturePack()
    for part, state in pairs(Cache.TextureState) do
        if part and part.Parent and state then
            pcall(function()
                part.Color = state.Color
                part.Material = state.Material
                part.MaterialVariant = state.MaterialVariant or ''
            end)
        end
    end
    Cache.TextureState = {}
    
    for name, _ in pairs(TEXTURE_VARIANTS) do
        local variant = MaterialService:FindFirstChild(name)
        if variant and variant:IsA('MaterialVariant') then
            pcall(function() variant:Destroy() end)
        end
    end
    Cache.TextureVariantsBuilt = false
end

local function toggleTexturePack(value)
    Settings.TexturePackEnabled = value
    if value then
        applyTexturePack()
        notify("Texture Pack", "Включен", 2)
    else
        clearTexturePack()
        notify("Texture Pack", "Выключен", 2)
    end
end

-- ========================================
-- ===== CHINA HAT =====
-- ========================================

local tau = math.pi * 2

local function createChinaHatDrawings()
    for i = 1, #Cache.ChinaHatDrawings do
        pcall(function()
            Cache.ChinaHatDrawings[i][1]:Remove()
            Cache.ChinaHatDrawings[i][2]:Remove()
        end)
    end
    Cache.ChinaHatDrawings = {}
    
    for i = 1, Settings.ChinaHatSides do
        Cache.ChinaHatDrawings[i] = {Drawing.new('Line'), Drawing.new('Triangle')}
        Cache.ChinaHatDrawings[i][1].ZIndex = 2
        Cache.ChinaHatDrawings[i][1].Thickness = 2
        Cache.ChinaHatDrawings[i][2].ZIndex = 1
        Cache.ChinaHatDrawings[i][2].Filled = true
    end
end

local function hatRemoveClassic()
    if Cache.ChinaHatParts[LocalPlayer.Character] then 
        pcall(function() Cache.ChinaHatParts[LocalPlayer.Character]:Destroy() end)
        Cache.ChinaHatParts[LocalPlayer.Character] = nil 
    end
end

local function hatAddClassic(char)
    task.wait(0.1)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    hatRemoveClassic()

    local hat = Instance.new("Part")
    hat.Name = "ChineseHat"
    hat.Transparency = Settings.ChinaHatTransparency
    hat.Color = Settings.ChinaHatColor
    hat.Material = Enum.Material.Neon
    hat.CanCollide = false
    hat.Reflectance = Settings.ChinaHatReflectance

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(Settings.ChinaHatRadius, Settings.ChinaHatHeight, Settings.ChinaHatRadius)
    mesh.Parent = hat

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = hat
    weld.Parent = hat

    hat.CFrame = head.CFrame * CFrame.new(0, 1.1, 0)
    hat.Parent = char
    Cache.ChinaHatParts[char] = hat
end

local function hatUpdateClassic()
    for char, hat in pairs(Cache.ChinaHatParts) do
        if hat and hat.Parent and char == LocalPlayer.Character then
            hat.Transparency = Settings.ChinaHatTransparency
            hat.Reflectance = Settings.ChinaHatReflectance
            
            if Settings.ChinaHatRainbow then
                hat.Color = Color3.fromHSV(tick() % Settings.ChinaHatRainbowSpeed / Settings.ChinaHatRainbowSpeed, 1, 1)
            else
                hat.Color = Settings.ChinaHatColor
            end
            
            local mesh = hat:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(Settings.ChinaHatRadius, Settings.ChinaHatHeight, Settings.ChinaHatRadius)
            end
        end
    end
end

local function hatUpdateDrawing()
    local pass = Settings.ChinaHatEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head') ~= nil and (Camera.CFrame.p - Camera.Focus.p).magnitude > 1 and LocalPlayer.Character.Humanoid.Health > 0
    
    for i = 1, #Cache.ChinaHatDrawings do
        local line, triangle = Cache.ChinaHatDrawings[i][1], Cache.ChinaHatDrawings[i][2]
        if pass then
            local color
            if Settings.ChinaHatRainbow then
                color = Color3.fromHSV((tick() % Settings.ChinaHatRainbowSpeed / Settings.ChinaHatRainbowSpeed - (i / #Cache.ChinaHatDrawings)) % 1, 0.5, 1)
            else
                color = Settings.ChinaHatColor
            end
            
            local pos = LocalPlayer.Character.Head.Position + Vector3.new(0, 0.75, 0)
            local topWorld = pos + Vector3.new(0, 0.75, 0)

            local last, next = (i / Settings.ChinaHatSides) * tau, ((i + 1) / Settings.ChinaHatSides) * tau
            local lastWorld = pos + (Vector3.new(math.cos(last), 0, math.sin(last)) * Settings.ChinaHatRadius)
            local nextWorld = pos + (Vector3.new(math.cos(next), 0, math.sin(next)) * Settings.ChinaHatRadius)
            local lastScreen = Camera:WorldToViewportPoint(lastWorld)
            local nextScreen = Camera:WorldToViewportPoint(nextWorld)
            local topScreen = Camera:WorldToViewportPoint(topWorld)

            line.From = Vector2.new(lastScreen.X, lastScreen.Y)
            line.To = Vector2.new(nextScreen.X, nextScreen.Y)
            line.Color = color
            line.Transparency = 1 - Settings.ChinaHatTransparency
            line.Visible = true

            triangle.PointA = Vector2.new(topScreen.X, topScreen.Y)
            triangle.PointB = line.From
            triangle.PointC = line.To
            triangle.Color = color
            triangle.Transparency = 0.35
            triangle.Visible = true
        else
            line.Visible = false
            triangle.Visible = false
        end
    end
end

local function toggleChinaHat(value)
    Settings.ChinaHatEnabled = value
    
    if value then
        createChinaHatDrawings()
        if Settings.ChinaHatStyle == "Classic" and LocalPlayer.Character then
            hatAddClassic(LocalPlayer.Character)
        end
        
        if Cache.ChinaHatConnection then safeDisconnect(Cache.ChinaHatConnection) end
        Cache.ChinaHatConnection = RunService.Heartbeat:Connect(function()
            if Settings.ChinaHatStyle == "Classic" then
                hatUpdateClassic()
            end
        end)
        notify("China Hat", "Включен (" .. Settings.ChinaHatStyle .. ")", 2)
    else
        hatRemoveClassic()
        for i = 1, #Cache.ChinaHatDrawings do
            pcall(function()
                Cache.ChinaHatDrawings[i][1].Visible = false
                Cache.ChinaHatDrawings[i][2].Visible = false
            end)
        end
        if Cache.ChinaHatConnection then 
            safeDisconnect(Cache.ChinaHatConnection)
            Cache.ChinaHatConnection = nil 
        end
        notify("China Hat", "Выключен", 2)
    end
end

local function hatChangeStyle(value)
    local wasEnabled = Settings.ChinaHatEnabled
    Settings.ChinaHatStyle = value
    if wasEnabled then
        toggleChinaHat(false)
        task.wait(0.1)
        toggleChinaHat(true)
    end
    notify("China Hat", "Стиль: " .. value, 2)
end

-- ========================================
-- ===== RGB ПЕРСОНАЖ =====
-- ========================================

local function setupRGBHumanoid()
    safeDisconnect(Cache.RGBConnection); Cache.RGBConnection = nil
    if not Settings.RGBHumanoid then
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Plastic
                    part.Color = Color3.fromRGB(255,255,255)
                    part.Transparency = 0
                end
            end
        end
        return
    end
    Cache.RGBConnection = RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character then return end
        local color = Color3.fromHSV(tick() % 1, 1, 1)
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Material = Enum.Material.ForceField
                part.Color = color
                part.Transparency = 0.3
            end
        end
    end)
end

-- ========================================
-- ===== XRAY =====
-- ========================================

local function setupXRay()
    if Settings.XRayEnabled then
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsA("Terrain") then
                Cache.XRayParts[part] = part.LocalTransparencyModifier
                part.LocalTransparencyModifier = 0.6
            end
        end
    else
        for part, val in pairs(Cache.XRayParts) do
            if part and part.Parent then
                pcall(function() part.LocalTransparencyModifier = val end)
            end
        end
        Cache.XRayParts = {}
    end
end

-- ========================================
-- ===== КРУГИ ПРЫЖКА =====
-- ========================================

local function createJumpCircle(originPos)
    local groundY = getGroundY(originPos)
    local ringPos = Vector3.new(originPos.X, groundY + 0.08, originPos.Z)

    local ring = Instance.new("Part")
    ring.Shape = Enum.PartType.Cylinder
    ring.Size = Vector3.new(0.08, 0.5, 0.5)
    ring.Material = Enum.Material.Neon
    ring.Color = COLORS.Purple
    ring.Transparency = 0
    ring.Anchored = true
    ring.CanCollide = false
    ring.CastShadow = false
    ring.CFrame = CFrame.new(ringPos) * CFrame.Angles(0, 0, math.rad(90))
    ring.Parent = Workspace

    local light = Instance.new("PointLight")
    light.Brightness = 4
    light.Color = COLORS.Purple
    light.Range = 20
    light.Parent = ring

    local t0 = tick()
    local duration = 0.7
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not ring or not ring.Parent then safeDisconnect(conn) return end
        local p = (tick() - t0) / duration
        if p >= 1 then
            pcall(function() ring:Destroy() end)
            safeDisconnect(conn)
            return
        end
        local diameter = 0.5 + p * 6
        ring.Size = Vector3.new(0.08, diameter, diameter)
        ring.Transparency = p
        ring.CFrame = CFrame.new(ringPos) * CFrame.Angles(0, 0, math.rad(90))
        light.Brightness = 4 * (1 - p)
    end)
end

local function updateJumpCircles()
    if not Settings.JumpCircles or not LocalPlayer.Character then return end
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    local isJumping = hum:GetState() == Enum.HumanoidStateType.Jumping
    if isJumping and not Cache.JumpTracking.wasJumping then
        createJumpCircle(hrp.Position)
    end
    Cache.JumpTracking.wasJumping = isJumping
end

-- ========================================
-- ===== FOV АИМБОТ =====
-- ========================================

local function getClosestMurderInFov()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local bestP = nil
    local bestDist = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if not checkKnife(player) then continue end
        if not player.Character then continue end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local sp, onScreen = Camera:WorldToScreenPoint(hrp.Position)
        if not onScreen or sp.Z < 0 then continue end

        local d = (center - Vector2.new(sp.X, sp.Y)).Magnitude
        if d <= Settings.FovRadius and d < bestDist then
            bestDist = d
            bestP = player
        end
    end
    return bestP
end

local function createFovCircle()
    if Cache.FovCircle then pcall(function() Cache.FovCircle:Remove() end) end
    local c = Drawing.new("Circle")
    c.Radius = Settings.FovRadius
    c.Color = COLORS.White
    c.Thickness = 1.5
    c.Transparency = 0.7
    c.Filled = false
    c.Visible = false
    c.NumSides = 64
    Cache.FovCircle = c
end

local function setupFovAimbot()
    safeDisconnect(Cache.FovConnection)
    Cache.FovConnection = nil
    if Cache.FovCircle then Cache.FovCircle.Visible = false end
    if not Settings.FovAimbotEnabled then return end
    if not Cache.FovCircle then createFovCircle() end

    local circle = Cache.FovCircle

    Cache.FovConnection = RunService.RenderStepped:Connect(function()
        if not Settings.FovAimbotEnabled then
            circle.Visible = false
            return
        end

        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        circle.Position = center
        circle.Radius = Settings.FovRadius
        circle.Visible = true

        local target = getClosestMurderInFov()

        if target then
            circle.Color = COLORS.Red
            circle.Thickness = 2.0

            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local camPos = Camera.CFrame.Position
                local newCF = CFrame.lookAt(camPos, hrp.Position, Camera.CFrame.UpVector)
                Camera.CFrame = newCF
            end
        else
            circle.Color = COLORS.White
            circle.Thickness = 1.5
        end
    end)
end

-- ========================================
-- ===== ТЕЛЕПОРТ К УБИЙЦЕ / ШЕРИФУ =====
-- ========================================

local function teleportToRole(role)
    if not LocalPlayer.Character then return end
    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    
    local target = nil
    local targetDist = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hasRole = (role == "Убийца" and checkKnife(player)) or (role == "Шериф" and checkGun(player))
            if hasRole then
                local dist = (myHRP.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < targetDist then
                    targetDist = dist
                    target = player
                end
            end
        end
    end
    
    if not target then
        notify("Телепорт", role .. " не найден", 2)
        return
    end
    
    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if tHRP then
        myHRP.CFrame = tHRP.CFrame * CFrame.new(0, 3, 2)
        notify("Телепорт", "Телепорт к " .. role, 2)
    end
end

-- ========================================
-- ===== ЗАЩИТА ОТ АФК =====
-- ========================================

local afkConn = nil

local function setupAntiAFK()
    safeDisconnect(afkConn); afkConn = nil
    if not Settings.AntiAFKEnabled then return end
    local last = 0
    afkConn = RunService.Heartbeat:Connect(function()
        if not LocalPlayer.Character then return end
        local now = tick()
        if now - last > 60 then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Jump = true; last = now end
        end
    end)
end

-- ========================================
-- ===== АВТО ФАРМ =====
-- ========================================

local function getCurrentCoins()
    local ok, res = pcall(function()
        return LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins.Text
    end)
    return ok and (tonumber(res) or 0) or 0
end

local function getValidCoins()
    local coins = {}
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return coins end
    for _, map in pairs(Workspace:GetChildren()) do
        local container = map:FindFirstChild("CoinContainer")
        if container then
            for _, coin in pairs(container:GetChildren()) do
                if coin.Name == "Coin_Server" and coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    table.insert(coins, {part=coin, distance=(hrp.Position-coin.Position).Magnitude})
                end
            end
        end
    end
    table.sort(coins, function(a,b) return a.distance < b.distance end)
    return coins
end

local function tweenToCoin(coin)
    if not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then return false end
    local char = LocalPlayer.Character; if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local target = coin.Position + Vector3.new(0, 2, 0)
    if (hrp.Position - target).Magnitude < 5 then return true end
    if Cache.CurrentTween then pcall(function() Cache.CurrentTween:Cancel() end) end
    Cache.CurrentTween = TweenService:Create(hrp,
        TweenInfo.new((hrp.Position-target).Magnitude / Settings.AutoFarmSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {CFrame = CFrame.new(target)}
    )
    hum.Sit = true
    Cache.CurrentTween:Play()
    local done = false
    local c; c = Cache.CurrentTween.Completed:Connect(function() done=true safeDisconnect(c) end)
    local t0 = tick()
    while not done and Settings.AutoFarmEnabled do
        task.wait(0.1)
        if not coin or not coin.Parent or not coin:FindFirstChild("TouchInterest") then
            if Cache.CurrentTween then pcall(function() Cache.CurrentTween:Cancel() end) end
            hum.Sit = false; return false
        end
        if tick() - t0 > 30 then
            if Cache.CurrentTween then pcall(function() Cache.CurrentTween:Cancel() end) end
            hum.Sit = false; return false
        end
    end
    hum.Sit = false; return done
end

local function collectCoin(coin)
    if not coin or not coin.Parent then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        firetouchinterest(hrp, coin, 0)
        task.wait(0.05)
        firetouchinterest(hrp, coin, 1)
    end)
end

local function farmLoop()
    while Settings.AutoFarmEnabled do
        if not LocalPlayer.Character then task.wait(1) continue end
        
        local coins = getCurrentCoins()
        if coins >= Settings.AutoFarmCoinLimit then
            if Settings.AutoRespawn then
                notify("Авто фарм", "Респавн... (" .. coins .. " монет)", 2)
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.Health = 0
                    end
                end
                task.wait(5)
                continue
            else
                Settings.AutoFarmEnabled = false
                notify("Авто фарм", "Сумка полна - остановлено", 3)
                break
            end
        end
        
        local validCoins = getValidCoins()
        if #validCoins == 0 then task.wait(2) continue end
        
        local ok = tweenToCoin(validCoins[1].part)
        if ok and Settings.AutoFarmEnabled then
            collectCoin(validCoins[1].part)
            task.wait(Settings.AutoFarmCoinDelay)
        end
        task.wait(0.1)
    end
    Cache.AutoFarmConn = nil
end

local function setupAutoFarm()
    if Settings.AutoFarmEnabled then
        if not LocalPlayer.Character then return end
        Cache.AutoFarmConn = task.spawn(farmLoop)
        notify("Авто фарм", "Запущен", 3)
    else
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.Sit = false end
        end
        if Cache.CurrentTween then
            pcall(function() Cache.CurrentTween:Cancel() end)
            Cache.CurrentTween = nil
        end
    end
end

-- ========================================
-- ===== ЗАЩИТА ОТ ФЛИНГА =====
-- ========================================

local antiFlingConn = nil
local antiFlingNewConn = nil

local function stopAntiFling()
    safeDisconnect(antiFlingConn); antiFlingConn = nil
    safeDisconnect(antiFlingNewConn); antiFlingNewConn = nil
end

local function setupAntiFling()
    stopAntiFling()
    if not Settings.AntiFlingEnabled then return end

    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not Settings.AntiFlingEnabled then stopAntiFling() return end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        local char = LocalPlayer.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if hrp.AssemblyLinearVelocity.Magnitude > 200 then
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end
        if hrp.AssemblyAngularVelocity.Magnitude > 20 then
            hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
        end
    end)

    antiFlingNewConn = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(charNew)
            task.wait(0.5)
            if not Settings.AntiFlingEnabled then return end
            for _, part in ipairs(charNew:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end)
end

-- ========================================
-- ===== НОКЛИП =====
-- ========================================

local noclipConn = nil

-- ========================================
-- ===== КНОПКА ВЫСТРЕЛА =====
-- ========================================

local function createShootButton()
    if Cache.ShootButton then
        pcall(function() Cache.ShootButton:Destroy() end)
        Cache.ShootButton = nil
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShootButton"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 50)
    button.Position = UDim2.new(0.5, -50, 0.6, 0)
    button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    button.BackgroundTransparency = 0.15
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = "Выстрел"
    button.TextSize = 18
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderTransparency = 0.3
    button.Parent = screenGui
    button.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = button
    
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    local clickStartPos = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            dragStart = input.Position
            clickStartPos = input.Position
            startPos = button.Position
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            button.BackgroundTransparency = 0.1
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if not dragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if delta.Magnitude > 10 then
                isDragging = true
            end
            if isDragging then
                button.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            button.BackgroundTransparency = 0.15
            
            if clickStartPos and (input.Position - clickStartPos).Magnitude < 10 then
                task.spawn(function()
                    if not LocalPlayer.Character then return end
                    
                    if not equipGun() then
                        notify("Выстрел", "Оружие не найдено", 2)
                        return
                    end
                    
                    local target = nil
                    local targetDist = math.huge
                    local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not myHRP then return end
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            if checkKnife(player) and isPlayerVisible(player) then
                                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local dist = (myHRP.Position - hrp.Position).Magnitude
                                    if dist < targetDist then
                                        targetDist = dist
                                        target = player
                                    end
                                end
                            end
                        end
                    end
                    
                    if not target then
                        notify("Выстрел", "Убийца не найден", 2)
                        return
                    end
                    
                    local tHRP = target.Character:FindFirstChild("HumanoidRootPart")
                    if not tHRP then return end
                    
                    local beamStart = Camera.CFrame.Position
                    local beamEnd = tHRP.Position
                    createGunBeam(beamStart, beamEnd, Color3.fromRGB(180, 50, 255), 0.2)
                    
                    local vel = tHRP.AssemblyLinearVelocity
                    local predictedPos = tHRP.Position + Vector3.new(vel.X, 0, vel.Z) * 0.1
                    
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
                    
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.MouseButton1, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.MouseButton1, false, game)
                    end)
                end)
            end
            
            isDragging = false
            dragStart = nil
            clickStartPos = nil
        end
    end)
    
    Cache.ShootButton = screenGui
    return screenGui
end

local function toggleShootButton(enabled)
    Settings.ShootButtonEnabled = enabled
    if enabled then
        createShootButton()
    else
        if Cache.ShootButton then
            pcall(function() Cache.ShootButton:Destroy() end)
            Cache.ShootButton = nil
        end
    end
end

-- ========================================
-- ===== ГЛАВНЫЙ ЦИКЛ ОБНОВЛЕНИЯ =====
-- ========================================

local function updateVisuals()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then
            if Settings.ChamsEnabled then applyChams(player)
            elseif Cache.ChamsPartsList[player.UserId] then removeChams(player) end
            continue
        end
        if not player.Character then continue end
        local role = getRole(player)
        if Settings.MurderESP and role == "Убийца" then
            createOrUpdateHighlight(player, COLORS.Murder)
        elseif Settings.SheriffESP and role == "Шериф" then
            createOrUpdateHighlight(player, COLORS.Sheriff)
        elseif Settings.InnocentESP and role == "Невинный" then
            createOrUpdateHighlight(player, COLORS.Innocent)
        else
            removeHighlight(player)
        end
        if Settings.ChamsEnabled then applyChams(player)
        elseif Cache.ChamsPartsList[player.UserId] then removeChams(player) end
    end
end

local function startMainUpdate()
    if Cache.mainConn then
        safeDisconnect(Cache.mainConn)
        Cache.mainConn = nil
    end
    
    Cache.mainConn = RunService.Heartbeat:Connect(function()
        local any = Settings.MurderESP or Settings.SheriffESP or Settings.InnocentESP
            or Settings.ChamsEnabled or Settings.Trails or Settings.TracersEnabled
        
        if any then
            updateVisuals()
        end
        
        if Settings.TracersEnabled then
            updateTracers()
        end
        
        if Settings.JumpCircles then
            updateJumpCircles()
        end
    end)
end

-- ========================================
-- ===== УВЕДОМЛЕНИЕ О СМЕРТИ ШЕРИФА =====
-- ========================================

local function setupSheriffDeadNotif()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.CharacterRemoving:Connect(function()
                if checkGun(player) then
                    notify("Шериф", player.Name .. " мёртв", 3)
                end
            end)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Died:Connect(function()
                    if checkGun(player) then
                        notify("Шериф", player.Name .. " мёртв", 3)
                    end
                end)
            end
        end)
    end)
end

-- ========================================
-- ===== ИНТЕРФЕЙС =====
-- ========================================

local VisualTab = Window:Tab({Title = "Визуал", Icon = "eye"})
local VisualSection = VisualTab:Section({Title = "ESP", Side = "Left"})

VisualSection:Toggle({Title = "ESP Убийца", Default = false, Callback = function(v) Settings.MurderESP = v startMainUpdate() end})
VisualSection:Toggle({Title = "ESP Шериф", Default = false, Callback = function(v) Settings.SheriffESP = v startMainUpdate() end})
VisualSection:Toggle({Title = "ESP Невинный", Default = false, Callback = function(v) Settings.InnocentESP = v startMainUpdate() end})

local ChamsSection = VisualTab:Section({Title = "Chams", Side = "Right"})

ChamsSection:Toggle({Title = "Включить Chams", Default = false, Callback = function(v)
    Settings.ChamsEnabled = v
    updateChamsForAll()
    startMainUpdate()
end})

ChamsSection:Input({
    Title = "Цвет Chams",
    Default = "Purple",
    Placeholder = "Purple, Blue, Red, Green",
    Callback = function(value)
        if value == "Purple" or value == "Blue" or value == "Red" or value == "Green" then
            Settings.ChamsColor = value
            if Settings.ChamsEnabled then
                updateChamsForAll()
            end
        else
            notify("Chams", "Доступные цвета: Purple, Blue, Red, Green", 3)
        end
    end
})

ChamsSection:Toggle({Title = "RGB Humanoid (отдельно)", Default = false, Callback = function(v)
    Settings.RGBHumanoid = v
    setupRGBHumanoid()
end})

VisualSection:Toggle({Title = "Трассеры", Default = false, Callback = function(v)
    Settings.TracersEnabled = v
    if v then
        for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then createTracer(p) end end
    else
        clearAllTracers()
    end
    startMainUpdate()
end})

local WorldSection = VisualTab:Section({Title = "World", Side = "Left"})

WorldSection:Toggle({Title = "Texture Pack", Default = false, Callback = function(v)
    toggleTexturePack(v)
end})

WorldSection:Toggle({Title = "Орбизы / Снег", Default = false, Callback = function(v)
    toggleOrbiz(v)
end})

local AuraSection = VisualTab:Section({Title = "Аура", Side = "Right"})

AuraSection:Toggle({Title = "Включить ауру", Default = false, Callback = function(v)
    toggleAura(v)
end})

for _, name in ipairs(AURA_ORDER) do
    AuraSection:Toggle({
        Title = name:upper(),
        Default = false,
        Callback = function(v)
            AuraSelected[name] = v
            if Settings.AuraEnabled then
                applyAura()
            end
        end
    })
end

AuraSection:Input({
    Title = "Цвет (R,G,B)",
    Default = "133,220,255",
    Placeholder = "133,220,255",
    Callback = function(v)
        local parts = {}
        for p in v:gmatch("[^,]+") do table.insert(parts, tonumber(p)) end
        if #parts == 3 then
            Settings.AuraColor = Color3.fromRGB(parts[1], parts[2], parts[3])
            if Settings.AuraEnabled then
                applyAura()
            end
        end
    end
})

local EffectsTab = Window:Tab({Title = "Эффекты", Icon = "sparkles"})
local EffectsL = EffectsTab:Section({Title = "Эффекты", Side = "Left"})
local EffectsR = EffectsTab:Section({Title = "Мир", Side = "Right"})

EffectsL:Toggle({Title = "Круги прыжка", Default = false, Callback = function(v)
    Settings.JumpCircles = v; startMainUpdate()
end})
EffectsL:Toggle({Title = "Фиолетовый след", Default = false, Callback = function(v)
    Settings.Trails = v
    if v then createLocalPlayerTrail() else removeLocalPlayerTrail() end
    startMainUpdate()
end})
EffectsL:Toggle({Title = "XRay", Default = false, Callback = function(v)
    Settings.XRayEnabled = v; setupXRay()
end})
EffectsL:Toggle({Title = "Bloom", Default = false, Callback = function(v) Settings.BloomEnabled = v setupBloom(v) end})
EffectsL:Toggle({Title = "Цветокоррекция", Default = false, Callback = function(v) Settings.ColorCorrectionEnabled = v setupColorCorrection(v) end})
EffectsL:Toggle({Title = "Виньетка", Default = false, Callback = function(v) Settings.VignetteEnabled = v setupVignette(v) end})

local ChinaHatSection = EffectsTab:Section({Title = "China Hat", Side = "Left"})

ChinaHatSection:Toggle({Title = "Включить", Default = false, Callback = function(v)
    toggleChinaHat(v)
end})

ChinaHatSection:Input({
    Title = "Стиль (Classic/Drawing)",
    Default = "Classic",
    Placeholder = "Classic или Drawing",
    Callback = function(v)
        if v == "Classic" or v == "Drawing" then
            hatChangeStyle(v)
        else
            notify("China Hat", "Доступно: Classic, Drawing", 2)
        end
    end
})

ChinaHatSection:Input({
    Title = "Прозрачность (0-1)",
    Default = "0.3",
    Placeholder = "0.3",
    Callback = function(v)
        local n = tonumber(v)
        if n then Settings.ChinaHatTransparency = math.clamp(n, 0, 1) end
    end
})

ChinaHatSection:Input({
    Title = "Радиус",
    Default = "2.4",
    Placeholder = "2.4",
    Callback = function(v)
        local n = tonumber(v)
        if n then Settings.ChinaHatRadius = math.max(n, 0.5) end
    end
})

ChinaHatSection:Input({
    Title = "Высота",
    Default = "1.6",
    Placeholder = "1.6",
    Callback = function(v)
        local n = tonumber(v)
        if n then Settings.ChinaHatHeight = math.max(n, 0.5) end
    end
})

ChinaHatSection:Toggle({Title = "Радужный режим", Default = false, Callback = function(v)
    Settings.ChinaHatRainbow = v
end})

ChinaHatSection:Input({
    Title = "Цвет (R,G,B)",
    Default = "0,255,255",
    Placeholder = "0,255,255",
    Callback = function(v)
        local parts = {}
        for p in v:gmatch("[^,]+") do table.insert(parts, tonumber(p)) end
        if #parts == 3 then
            Settings.ChinaHatColor = Color3.fromRGB(parts[1], parts[2], parts[3])
        end
    end
})

EffectsR:Input({Title = "Выбор неба", Default = "HD", Placeholder = "HD, Space, Galaxy, etc.", Callback = function(v)
    Settings.CustomSkyId = v
end})
EffectsR:Button({Title = "Применить небо", Callback = function()
    if Settings.CustomSkyId and Settings.CustomSkyId ~= "" then
        setupSky(Settings.CustomSkyId)
    end
end})
EffectsR:Button({Title = "Удалить небо", Callback = function() removeSky() end})
EffectsR:Button({Title = "Космос", Callback = function() setupSky("Space") end})
EffectsR:Button({Title = "Галактика", Callback = function() setupSky("Galaxy") end})

local RageTab = Window:Tab({Title = "Рейдж", Icon = "sword"})
local RageL = RageTab:Section({Title = "Движение", Side = "Left"})
local RageR = RageTab:Section({Title = "Полёт", Side = "Right"})
local RageM = RageTab:Section({Title = "Телепорты", Side = "Left"})
local RageA = RageTab:Section({Title = "Действия", Side = "Right"})

RageR:Toggle({Title = "Полёт", Default = false, Callback = function(v)
    toggleFly(v)
end})

RageL:Toggle({Title = "Бани Хоп", Default = false, Callback = function(v)
    toggleBHop(v)
end})
RageL:Input({Title = "Скорость BHop", Default = "30", Placeholder = "30", Callback = function(v)
    local n = tonumber(v); if n then Settings.BHopSpeed = n end
end})

RageL:Toggle({Title = "Спин Бот", Default = false, Callback = function(v)
    toggleSpinBot(v)
end})
RageL:Input({Title = "Скорость спина", Default = "9999", Placeholder = "9999", Callback = function(v)
    local n = tonumber(v); if n then SpinBot.Speed = n end
end})

RageL:Toggle({Title = "Ноклип", Default = false, Callback = function(v)
    if v then
        if not noclipConn then
            noclipConn = RunService.Stepped:Connect(function()
                if not LocalPlayer.Character then return end
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
    end
end})

RageM:Button({Title = "Телепорт к убийце", Callback = function() teleportToRole("Убийца") end})
RageM:Button({Title = "Телепорт к шерифу", Callback = function() teleportToRole("Шериф") end})

RageA:Button({Title = "Grab Gun", Callback = function() toggleGrabGun() end})

local FunTab = Window:Tab({Title = "Fun", Icon = "smile"})
local FunSection = FunTab:Section({Title = "Приколы", Side = "Left"})

FunSection:Toggle({Title = "Jerk (дёрганье)", Default = false, Callback = function(v)
    toggleJerk(v)
end})

local CombatTab = Window:Tab({Title = "Комбат", Icon = "crosshair"})
local CombatL = CombatTab:Section({Title = "Комбат", Side = "Left"})
local CombatR = CombatTab:Section({Title = "Аимбот", Side = "Right"})

CombatL:Toggle({Title = "Кнопка выстрела", Default = false, Callback = function(v) toggleShootButton(v) end})

CombatL:Toggle({Title = "Sheriff AutoShoot", Default = false, Callback = function(v)
    toggleSheriffAutoShoot(v)
end})

CombatL:Toggle({Title = "Защита от флинга", Default = false, Callback = function(v)
    Settings.AntiFlingEnabled = v; setupAntiFling()
end})

CombatL:Toggle({Title = "Wall Hop (Infinity Jump)", Default = false, Callback = function(v)
    toggleWallHop(v)
end})

CombatR:Toggle({Title = "FOV Аимбот", Default = false, Callback = function(v)
    Settings.FovAimbotEnabled = v
    if v then createFovCircle() end
    setupFovAimbot()
end})
CombatR:Input({Title = "Радиус FOV", Default = "120", Placeholder = "120", Callback = function(v)
    local n = tonumber(v)
    if n then
        Settings.FovRadius = math.clamp(n, 10, 600)
        if Cache.FovCircle then Cache.FovCircle.Radius = Settings.FovRadius end
    end
end})

local FarmTab = Window:Tab({Title = "Авто фарм", Icon = "star"})
local FarmL = FarmTab:Section({Title = "Фарм", Side = "Left"})
local FarmR = FarmTab:Section({Title = "Настройки", Side = "Right"})

FarmL:Toggle({Title = "Авто фарм", Default = false, Callback = function(v) Settings.AutoFarmEnabled = v setupAutoFarm() end})
FarmL:Toggle({Title = "Авто респавн", Default = true, Callback = function(v) Settings.AutoRespawn = v end})
FarmR:Input({Title = "Скорость фарма", Default = "20", Placeholder = "20", Callback = function(v) local n = tonumber(v) if n then Settings.AutoFarmSpeed = n end end})
FarmR:Input({Title = "Лимит монет", Default = "40", Placeholder = "40", Callback = function(v) local n = tonumber(v) if n then Settings.AutoFarmCoinLimit = n end end})
FarmR:Input({Title = "Задержка монет", Default = "0.15", Placeholder = "0.15", Callback = function(v) local n = tonumber(v) if n then Settings.AutoFarmCoinDelay = n end end})

local MiscTab = Window:Tab({Title = "Разное", Icon = "timer"})
local MiscL = MiscTab:Section({Title = "Разное", Side = "Left"})

MiscL:Toggle({Title = "Защита от АФК", Default = false, Callback = function(v)
    Settings.AntiAFKEnabled = v; setupAntiAFK()
end})
MiscL:Button({Title = "Рейджоин", Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end})

-- ========================================
-- ===== СОБЫТИЯ ИГРОКОВ =====
-- ========================================

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Settings.ChamsEnabled then cacheCharacterParts(player) applyChams(player) end
        if Settings.TracersEnabled and player ~= LocalPlayer then createTracer(player) end
        if Settings.MurderESP or Settings.SheriffESP or Settings.InnocentESP then
            local r = getRole(player)
            if Settings.MurderESP and r == "Убийца" then createOrUpdateHighlight(player, COLORS.Murder)
            elseif Settings.SheriffESP and r == "Шериф" then createOrUpdateHighlight(player, COLORS.Sheriff)
            elseif Settings.InnocentESP and r == "Невинный" then createOrUpdateHighlight(player, COLORS.Innocent) end
        end
        if Settings.AntiFlingEnabled and player ~= LocalPlayer then
            task.spawn(function()
                task.wait(0.5)
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    Cache.ChamsPartsList[player.UserId] = nil
    Cache.Highlights[player.UserId] = nil
    if Cache.Tracers[player.UserId] then
        pcall(function() Cache.Tracers[player.UserId]:Remove() end)
        Cache.Tracers[player.UserId] = nil
    end
end)

-- ФИКС СТАДА: удаляем Core при респавне
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    if workspace:FindFirstChild("Core") then
        workspace.Core:Destroy()
    end
    if Cache.FlyCore and Cache.FlyCore.Parent then
        Cache.FlyCore:Destroy()
        Cache.FlyCore = nil
    end
    if Cache.FlyRunning then
        Cache.FlyRunning = false
        if Cache.FlyE1 then
            Cache.FlyE1:Disconnect()
            Cache.FlyE1 = nil
        end
        if Cache.FlyE2 then
            Cache.FlyE2:Disconnect()
            Cache.FlyE2 = nil
        end
        Cache.FlyKeys = {a=false,d=false,w=false,s=false}
        Cache.FlySpeed = 10
    end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    clearAllHighlights(); clearAllChams(); clearAllTracers()
    Cache.ChamsPartsList = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if Settings.ChamsEnabled then cacheCharacterParts(player) applyChams(player) end
        if Settings.TracersEnabled and player ~= LocalPlayer then createTracer(player) end
        if Settings.MurderESP or Settings.SheriffESP or Settings.InnocentESP then
            local r = getRole(player)
            if Settings.MurderESP and r == "Убийца" then createOrUpdateHighlight(player, COLORS.Murder)
            elseif Settings.SheriffESP and r == "Шериф" then createOrUpdateHighlight(player, COLORS.Sheriff)
            elseif Settings.InnocentESP and r == "Невинный" then createOrUpdateHighlight(player, COLORS.Innocent) end
        end
    end

    setupRGBHumanoid()
    Cache.JumpTracking = {wasJumping = false}

    if Settings.Trails then
        task.wait(0.1)
        createLocalPlayerTrail()
    end
    
    if Settings.FlyEnabled then
        task.wait(0.5)
        startFly()
    end
    
    if Settings.BHopEnabled then
        startBHop()
    end
    
    if Settings.AntiFlingEnabled then
        setupAntiFling()
    end
    
    if Settings.FovAimbotEnabled then
        setupFovAimbot()
    end
    
    if Settings.ShootButtonEnabled then
        createShootButton()
    end
    
    if Settings.WallHopEnabled then
        setupWallHop()
    end
    
    if Settings.SheriffAutoShootEnabled then
        toggleSheriffAutoShoot(true)
    end
    
    if Settings.TexturePackEnabled then
        task.wait(0.3)
        applyTexturePack()
    end
    
    if Settings.ChinaHatEnabled then
        task.wait(0.2)
        if Settings.ChinaHatStyle == "Classic" then
            hatAddClassic(LocalPlayer.Character)
        end
    end
    
    if Settings.AuraEnabled then
        task.wait(0.3)
        applyAura()
    end
    
    if Settings.OrbizEnabled then
        task.wait(0.2)
        createOrbiz()
    end
end)

-- ========================================
-- ===== ЗАПУСК =====
-- ========================================

startMainUpdate()
setupSheriffDeadNotif()
createFovCircle()
createChinaHatDrawings()

notify("PlanetHub", "Загружен - Violet тема", 4)

-- ========================================
-- ===== ШАПКА-ОВЕРЛЕЙ =====
-- ========================================

local overlayGui = Instance.new("ScreenGui")
overlayGui.Name = "PlanetHubOverlay"
overlayGui.ResetOnSpawn = false
overlayGui.IgnoreGuiInset = true
overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlayGui.DisplayOrder = 999
overlayGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(0, 150, 0, 30)
header.Position = UDim2.new(1, -160, 0, 10)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
header.BackgroundTransparency = 0.05
header.BorderSizePixel = 0
header.ClipsDescendants = true
header.Parent = overlayGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = header

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 50)
stroke.Thickness = 1
stroke.Transparency = 0.5
stroke.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 48, 1, 0)
title.Position = UDim2.new(0, 4, 0, 0)
title.BackgroundTransparency = 1
title.Text = "PLANET"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.Parent = header

local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(0, 1, 0, 16)
sep1.Position = UDim2.new(0, 56, 0.5, -8)
sep1.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
sep1.BorderSizePixel = 0
sep1.Parent = header

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 38, 1, 0)
fpsLabel.Position = UDim2.new(0, 61, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "60"
fpsLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
fpsLabel.TextSize = 12
fpsLabel.Font = Enum.Font.GothamMedium
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
fpsLabel.Parent = header

local frameCount = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        local fps = math.floor(frameCount / (currentTime - lastTime))
        fpsLabel.Text = fps
        if fps >= 60 then
            fpsLabel.TextColor3 = Color3.fromRGB(180, 255, 180)
        elseif fps >= 30 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
        end
        frameCount = 0
        lastTime = currentTime
    end
end)

local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(0, 1, 0, 16)
sep2.Position = UDim2.new(0, 103, 0.5, -8)
sep2.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
sep2.BorderSizePixel = 0
sep2.Parent = header

local freeLabel = Instance.new("TextLabel")
freeLabel.Size = UDim2.new(0, 40, 1, 0)
freeLabel.Position = UDim2.new(0, 108, 0, 0)
freeLabel.BackgroundTransparency = 1
freeLabel.Text = "Free"
freeLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
freeLabel.TextSize = 11
freeLabel.Font = Enum.Font.GothamMedium
freeLabel.TextXAlignment = Enum.TextXAlignment.Center
freeLabel.TextYAlignment = Enum.TextYAlignment.Center
freeLabel.Parent = header

local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = header.Position
    end
end)

header.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        header.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("✅ Planet Hub v3.0 ULTIMATE загружен!")
print("✅ Texture Pack, China Hat, Skybox, Аура, Jerk, Орбизы, BHop, Spin Bot, Fly интегрированы!")
