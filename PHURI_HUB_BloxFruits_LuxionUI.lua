-- [AI HUB V2] Type: LOADSTRING
-- Name: no_name

-- L UXION  HUB  |  Thai + Galaxy edition
--
local cloneref = cloneref or function(o) return o end
COREGUI = cloneref(game:GetService("CoreGui"))
Players = cloneref(game:GetService("Players"))
if not _G.Bin then
	_G.Bin = {}
end
for i,v in next, _G.Bin do
	task.cancel(v)
end

if not game:IsLoaded() then
	local notLoaded = Instance.new("Message")
	notLoaded.Parent = COREGUI
	notLoaded.Text = "Waiting for the game to load"
	game.Loaded:Wait()
	notLoaded:Destroy()
end
-- [Electrified] 
if _G.ReelAA then
	_G.ReelAA:Disconnect()
end

do
	Clients = game.Players
	Client = Clients.LocalPlayer

	-- Service
	CollectionService = game:GetService("CollectionService")

	-- Modules
	request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
	Util = require(game:GetService("ReplicatedStorage").Util)
    ReplicatedStorage = game:GetService("ReplicatedStorage")

	loadFun = {}

	local pid = game.PlaceId
	Sea1 = pid == 2753915549 or pid == 85211729168715
	Sea2 = pid == 4442272183 or pid == 79091703265657
	Sea3 = pid == 7449423635 or pid == 100117331123089
	Dungeons = pid == 73902483975735
	if Dungeons then
		Sea1 = true -- (same behaviour as the original script inside the dungeon place)
	elseif not (Sea1 or Sea2 or Sea3) then
		-- Unknown PlaceId: work out the sea from the map instead of leaving every Sea flag nil
		local map = workspace:WaitForChild("Map", 10)
		if map and map:FindFirstChild("TikiOutpost") then
			Sea3 = true
		elseif map and map:FindFirstChild("WindMill") then
			Sea1 = true
		elseif map then
			Sea2 = true
		else
			Sea1 = true
		end
	end

	SeaIndex = Sea3 and 3 or Sea2 and 2 or Sea1 and 1 
	islandlist = Sea1 and {
		"WindMill",
		"Marine",
		"Middle Town",
		"Jungle",
		"Pirate Village",
		"Desert",
		"Snow Island",
		"MarineFord",
		"Colosseum",
		"Sky Island 1",
		"Sky Island 2",
		"Sky Island 3",
		"Prison",
		"Magma Village",
		"Under Water Island",
		"Fountain City",
		"Shank Room",
		"Mob Island",
	} or Sea2 and {
		"The Cafe",
		"Frist Spot",
		"Dark Area",
		"Flamingo Mansion",
		"Flamingo Room",
		"Green Zone",
		"Factory",
		"Colossuim",
		"Zombie Island",
		"Two Snow Mountain",
		"Punk Hazard",
		"Cursed Ship",
		"Ice Castle",
		"Forgotten Island",
		"Ussop Island",
		"Mini Sky Island",
	} or Sea3 and {
		"Mansion",
		"Port Town",
		"Great Tree",
		"Castle On The Sea",
		"MiniSky", 
		"Hydra Island",
		"Floating Turtle",
		"Haunted Castle",
		"Ice Cream Island",
		"Peanut Island",
		"Cake Island",
		"ChocolateIsland",
		"Tiki Out post"
	}

	BloxFruitsCodes = {
		"KITT_RESET",
		"Sub2CaptainMaui",
		"kittgaming",
		"Sub2Fer999",
		"Enyu_is_Pro",
		"Magicbus",
		"JCWK",
		"Starcodeheo",
		"Bluxxy",
		"SUB2GAMERROBOT_EXP1",
		"Sub2NoobMaster123",
		"Sub2UncleKizaru",
		"Sub2Daigrock",
		"Axiore",
		"TantaiGaming",
		"StrawHatMaine",
		"Sub2OfficialNoobie",
		"TheGreatAce",
		"Fudd10",
		"fudd10_v2",
		"Bignews"
	}


	allMaterials = {
		[1] = {
			["Yeti Fur"] = {"Yeti"},
			["Fish Tail"] = {
				"Fishman Commando",
				"Fishman Warrior",
			},
			['Angel Wings'] = {
				"Shanda",
				"Royal Squad",
				"Royal Soldier",
			}
		},
		[2] = {
			["Mystic Droplet"] = {
				"Sea Soldier",
				"Water Figher"
			},
			["Magma Ore"] = {
				"Lava Pirate",
				"Magma Ninja"
			},
			["Vampire Fang"] = {
				"Vampire"
			},
			["Ectoplasm"] = {
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer",
				"Cursed Captain"
			},
			["Radioactive Material"] = {
				"Factory Staff"
			},
			["Meteorite"] = {
				"Fajita"
			},
			["Dark Fragment"] = {
				"Darkbeard"
			},
		},
		[3] = {
			["Leather"] = {
				"Pirate Millionaire",
				"Pistol Billionaire"
			},
			["Gunpowder"] = {
				"Pistol Billionaire"
			},
			["Dragon Scale"] = {
				"Dragon Crew Archer",
				"Dragon Crew Warrior"
			},
			["Demonic Wisp"] = {
				"Demonic Soul"
			},
			["Mini Tusk"] = {
				"Mythological Pirate"
			},
			["Conjured Cocoa"] = {
				"Cocoa Warrior",
				"Chocolate Bar Battler"
			},
			["Fish Tail"] = {
				"Fishman Raider",
				"Fishman Captain"
			},
			["Bones"] = {
				'Reborn Skeleton',
				'Living Zombie',
				'Demonic Soul',
				'Posessed Mummy'
			},
			["Scrap Metal"] = {
				"Pirate Millionaire",
				"Pistol Billionaire"
			},
		},
	}

	LockAim = false 
	LockPosition = Vector3.new(0,0,0)
end

foldername = "L UXION HUB";
filename = game.Players.LocalPlayer.Name.." _G.Settings.json"

_G.Settings = {
	SelectWeapon = "Melee",
	['Bring Mob'] =  true
}

function Current_Exploit()
	local decode = game:GetService('HttpService'):JSONDecode(request({Url = "https://httpbin.org/get",Method = "GET"}).Body)
	return decode.headers['User-Agent']
end

foldername = "L UXION HUB";
filename = game.Players.LocalPlayer.Name..".json"
function SaveSettings()
	local HttpService = game:GetService("HttpService")
	local json = HttpService:JSONEncode(_G.Settings)
	if writefile then
		if isfolder(foldername) then
			if isfolder(foldername.."/Blox Fruits Update 0.0.1") then
				writefile(foldername.."/Blox Fruits Update 0.0.1/"..filename, json)
			else
				makefolder(foldername.."/Blox Fruits Update 0.0.1")
				writefile(foldername.."/Blox Fruits Update 0.0.1/"..filename, json)
			end
		else
			makefolder(foldername)
			makefolder(foldername.."/Blox Fruits Update 0.0.1")
			writefile(foldername.."/Blox Fruits Update 0.0.1/"..filename, json)
		end
	end
end

function LoadSettings()
	local HttpService = game:GetService("HttpService")
	if isfile(foldername.."/Blox Fruits Update 0.0.1/"..filename) then
		_G.Settings = HttpService:JSONDecode(readfile(foldername.."/Blox Fruits Update 0.0.1/"..filename))
	end
end

LoadSettings()
if _G.Settings['Auto Buso'] == nil then _G.Settings['Auto Buso'] = true end
if _G.Settings.Language ~= "EN" then _G.Settings.Language = "TH" end
if _G.Debug == nil then _G.Debug = true end
do
	local seen = {}
	DebugLog = function(...)
		local parts = {}
		for i = 1, select('#', ...) do parts[#parts + 1] = tostring((select(i, ...))) end
		local msg = table.concat(parts, ' ')
		local now = tick()
		if not seen[msg] or now - seen[msg] > 5 then
			seen[msg] = now
			warn(msg)
		end
	end
end

vu = game:GetService("VirtualUser")
Client.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame) task.wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

Utilities = {
	Priority = game:HttpGet('https://raw.githubusercontent.com/aresZee7/NetworkAndPriority/main/Priority.lua');
	Network = game:HttpGet('https://raw.githubusercontent.com/aresZee7/NetworkAndPriority/main/Network.lua');
}

for i,v in pairs(Utilities) do
	Utilities[i] = loadstring(v)()
end

_C = function(...)
	local Data = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(...)
	return Data
end

if Client.Team == nil then
	repeat task.wait()
		if Client.PlayerGui:FindFirstChild("TeamSelection") then
			game:GetService("ReplicatedStorage").Remotes['CommF_']:InvokeServer("SetTeam2", 'Pirates') 
		end
	until Client.Team ~= nil
	task.wait(1)
end

repeat task.wait() until Client.Character
if not ReplicatedStorage:FindFirstChild('GuideModule') then
	local TeleportService = game:GetService("TeleportService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	if player then
		TeleportService:Teleport(game.PlaceId, player)
	end
end

IsRaiding = function()
	return Client:GetAttribute('IslandRaiding')
end

getInventoryFruits = function()
	local FruitAll = {}
	for i,v in pairs(game:GetService("ReplicatedStorage").Remotes['CommF_']:InvokeServer("getInventory")) do
		if (v.Type == "Blox Fruit") then
			table.insert(FruitAll, v.Name)
		end
	end
	return FruitAll
end

FruitCheckOnStock = function( Price, Max)
	local FruitPrice,FruitStore,FruitPriceNum = {},{},{}
	for i,v in next,game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
		if ( v.Price >= tonumber(Price) ) and (v.Price <= tonumber(Max) ) then  
			table.insert(FruitPrice,v.Name)
			table.insert(FruitPriceNum,v.Price)
		end
	end

	return {
		["FruitPriceNum"] = FruitPriceNum,
		["FruitPrice"] = FruitPrice,
		["FruitStore"] = getInventoryFruits()
	}
end


local RemoveAllClip = function()
	if Client.Character.HumanoidRootPart:FindFirstChild('BodyClip') then
		Client.Character.HumanoidRootPart:FindFirstChild('BodyClip'):Destroy()
	end
    _G.TweenIng = false
    Client.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.GettingUp)
	Client.Character:FindFirstChild("Humanoid").PlatformStand = false

    for _, v in pairs(Client.Character:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CanCollide = true
			v.CanTouch = true
		end
	end

	_G.StopTween = true wait(.2) _G.StopTween = false
end

local GetIsland = function (...)
	local RealtargetPos = {...}
	local targetPos = RealtargetPos[1]
	local RealTarget
	if type(targetPos) == "vector" then
		RealTarget = targetPos
	elseif type(targetPos) == "userdata" then
		RealTarget = targetPos.Position
	elseif type(targetPos) == "number" then
		RealTarget = CFrame.new(unpack(RealtargetPos))
		RealTarget = RealTarget.p
	end

	local ReturnValue
	local CheckInOut = math.huge;
	if game.Players.LocalPlayer.Team then
		for i,v in pairs(game.Workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(game.Players.LocalPlayer.Team)):GetChildren()) do 
			local ReMagnitude = (RealTarget - v:GetModelCFrame().p).Magnitude;
			if ReMagnitude < CheckInOut then
				CheckInOut = ReMagnitude;
				ReturnValue = v.Name
			end
		end
		for i,v in pairs(workspace.Map:GetChildren()) do 
			if v:IsA('Model') then
				local ReMagnitude = (RealTarget - v:GetModelCFrame().p).Magnitude;
				if ReMagnitude < CheckInOut then
					CheckInOut = ReMagnitude;
					ReturnValue = v.Name
				end
			end
		end
		if ReturnValue then
			return ReturnValue
		end 
	end
end

local CofingQ = {}
local tp -- forward declaration (tp is assigned further down, but GetQuestData calls it)

GetQuestData = function()
	CofingQ.Mylevel = Client.Data.Level.Value
	local TableQuests = {
		["GuideModule"] = require(ReplicatedStorage.GuideModule),
		["Quests"] = require(ReplicatedStorage.Quests)
	}
	local LevelRequire, MobName, QuestName, QuestLevel, Mon, NPCPosition
	if CofingQ.Mylevel >= 1 and CofingQ.Mylevel <= 9 then
		if tostring(Client.Team) == "Marines" then
			MobName = "Trainee"
			QuestName = "MarineQuest"
			QuestLevel = 1
			Mon = "Trainee"
			NPCPosition = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929)
		elseif tostring(Client.Team) == "Pirates" then
			MobName = "Bandit"
			Mon = "Bandit"
			QuestName = "BanditQuest1"
			QuestLevel = 1
			NPCPosition = CFrame.new(1059.99731, 16.9222069, 1549.28162, -0.95466274, 7.29721794e-09, 0.297689587, 1.05190106e-08, 1, 9.22064114e-09, -0.297689587, 1.19340022e-08, -0.95466274)
		end
		return {["QuestLevel"] = QuestLevel,["NPCPosition"] = NPCPosition,["MobName"] = MobName,["QuestName"] = QuestName}
	end
	for i,v in pairs(TableQuests["GuideModule"]["Data"]["NPCList"]) do
		for i1,v1 in pairs(v["Levels"]) do
			if CofingQ.Mylevel >= v1 then
				if not LevelRequire then
					LevelRequire = 0
				end
				if v1 > LevelRequire then
					NPCPosition = i["CFrame"]
					QuestLevel = i1
					LevelRequire = v1
				end
				if #v["Levels"] == 3 and QuestLevel == 3 then
					NPCPosition = i["CFrame"]
					QuestLevel = 2
					LevelRequire = v["Levels"][2]
				end
			end
		end
	end

	for i,v in  pairs(TableQuests["Quests"]) do
		for i1,v1 in pairs(v) do
			if v1["LevelReq"] == LevelRequire and i ~= "CitizenQuest" then
				QuestName = i
				for i2,v2 in 
					pairs(v1["Task"]) do
					MobName = i2
					Mon = i2 .. " [Lv. ".. v1["LevelReq"] .. "]"
				end
			end
		end
	end
	if QuestName == "MarineQuest2" then
		QuestLevel, MobName, Mon, LevelRequire = 1, "Chief Petty Officer", "Chief Petty Officer", 120
	elseif QuestName == "ImpelQuest" then
		QuestName, QuestLevel, MobName, Mon, LevelRequire = "PrisonerQuest", 2, "Dangerous Prisoner", "Dangerous Prisoner", 210
		NPCPosition = CFrame.new(5310.60547, 0.350014925, 474.946594, 0.0175017118, 0, 0.999846935, 0, 1, 0, -0.999846935, 0, 0.0175017118)
	elseif QuestName == "SkyExp1Quest" then
		if QuestLevel == 1 then
			NPCPosition = CFrame.new(-4721.88867, 843.874695, -1949.96643, 0.996191859, -0, -0.0871884301, 0, 1, -0, 0.0871884301, 0, 0.996191859)
		elseif QuestLevel == 2 then
			NPCPosition = CFrame.new(-7859.09814, 5544.19043, -381.476196, -0.422592998, 0, 0.906319618, 0, 1, 0, -0.906319618, 0, -0.422592998)
		end
	elseif QuestName == "Area2Quest" and QuestLevel == 2 then
		QuestName, QuestLevel, MobName, Mon, LevelRequire = "Area2Quest", 1, "Swan Pirate", "Swan Pirate", 775
	end

	if CofingQ.Mylevel >= 375 and CofingQ.Mylevel <= 399 then
		if _G.Settings['Farm Level'] and (NPCPosition.Position - Client.Character.HumanoidRootPart.Position).Magnitude > 3000 then
			_C("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			return
		end
	end
	if CofingQ.Mylevel >= 400 and CofingQ.Mylevel <= 449 then
		if _G.Settings['Farm Level'] and (NPCPosition.Position - Client.Character.HumanoidRootPart.Position).Magnitude > 3000 then
			_C("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			return
		end
	end
	if CofingQ.Mylevel >= 475 and CofingQ.Mylevel <= 524 then
		if _G.Settings['Farm Level'] and (NPCPosition.Position - Client.Character.HumanoidRootPart.Position).Magnitude > 5000 then
			_C("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
			return
		end
	end
	if CofingQ.Mylevel >= 525 and CofingQ.Mylevel <= 624 then
		if _G.Settings['Farm Level'] and (NPCPosition.Position - Client.Character.HumanoidRootPart.Position).Magnitude > 5000 then
			_C("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
			return
		end
	end

	if CofingQ.Mylevel >= 2650 and CofingQ.Mylevel <= 2810 then
		if _G.Settings['Farm Level'] and (GetIsland(Client.Character.HumanoidRootPart.Position) ~= 'SubmergedIsland' and GetIsland(Client.Character.HumanoidRootPart.Position) ~= 'Submerged Island' ) then
			if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineWorkerSpeak"):InvokeServer('TravelToSubmergedIsland') ~= false then
				RemoveAllClip()
				if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local Noclip = Instance.new("BodyVelocity")
					Noclip.Name = "BodyClip"
					Noclip.Parent = Client.Character.HumanoidRootPart
					Noclip.MaxForce = Vector3.new(5, math.huge, 5)
					Noclip.Velocity = Vector3.new(0, 0, 0)
				end
				task.wait(1.5)
				return
			else
                tp({Target = CFrame.new(-16269.408203125, 23.979995727539062, 1371.662353515625)})
				return
			end
		end
	end
	
	return {
		["QuestLevel"] = QuestLevel,["NPCPosition"] = NPCPosition,["MobName"] = MobName,["QuestName"] = QuestName,['Mon'] = Mon
	}
end

function GetPureWeaponName(WeaponName) -- Line 27
	return string.lower(string.gsub(WeaponName, "%s", ""))
end

function GetAnimation()
	local WeaponData = require(game:GetService('ReplicatedStorage').Modules.WeaponData)

	local WeaponName = Client.Character:FindFirstChildOfClass("Tool")
	if not WeaponName then return end
	WeaponName = WeaponName.Name
	local TableChecking = {WeaponName, GetPureWeaponName(WeaponName), string.gsub(WeaponName, "%s", ""), string.lower(WeaponName), string.lower(WeaponName:sub(1, 1))..WeaponName:sub(2, #WeaponName), string.upper(WeaponName:sub(1, 1))..WeaponName:sub(2, #WeaponName)}
	local GetBasic 
	local AllAnimation = {}
	for _, v in TableChecking do 
		local Geting = WeaponData[v]
		if Geting then
			GetBasic = Geting.Moveset.Basic
			break
		end 
	end
	if GetBasic then
		for i,v in pairs(GetBasic) do
			table.insert(AllAnimation, v.AnimationId)
		end
	end

	return AllAnimation
end

dist = function(a,b,noHeight)
	if not b then
		b = Client.Character.HumanoidRootPart.Position
	end
	return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
end
local Tweenchecking, TaskTween, TweenOld

local DfCanCollide = _G.DfCanCollide or {}
if #DfCanCollide <= 0 then
	for _, v in pairs(Client.Character:GetDescendants()) do
		if v:IsA('BasePart') then
			DfCanCollide[v.Name] = {
				CanCollide = v.CanCollide,
				CanTouch = v.CanTouch,
			}
		end
	end
	_G.DfCanCollide = DfCanCollide
end

game:GetService("RunService").RenderStepped:Connect(function()
	if Client.Character and _G.TweenIng then
		Client.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
		Client.Character:FindFirstChild("Humanoid").PlatformStand = true
        for _, v in pairs(Client.Character:GetDescendants()) do
            if v:IsA('BasePart') then
                v.CanCollide = false
                v.CanTouch = false
            end
        end
	end
end)

local AllIsland = {}
for i,v in next,game.Workspace._WorldOrigin.PlayerSpawns:FindFirstChild(tostring(Client.Team)):GetChildren() do
	table.insert(AllIsland, v.Name)
end

local DebugDely = tick()
local notBypass = false

setfpscap(60)
local RunService = game:GetService("RunService")

local RunService = game:GetService("RunService")

tp = function(target, ValueFrame)
    if not target or not target.Target then return end
    
    local character = Client.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    
    if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then return end
    ValueFrame = ValueFrame or humanoidRootPart

    local targetCFrame = target.Target
    local targetPos = targetCFrame.Position

    if tick() - DebugDely > 1.5 and (_G.StopTween or _G.TweenIng) then
        DebugDely = tick()
        _G.StopTween = false
        _G.TweenIng = false
    end

    if _G.StopTween or _G.TweenIng then return end

    local startPos = ValueFrame.Position
    local totalDist = (targetPos - startPos).Magnitude

    if totalDist <= 15 then
        ValueFrame.CFrame = targetCFrame
        _G.TweenIng = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        humanoid.PlatformStand = false
        return
    end

    _G.TweenIng = true

    if humanoid.Sit then
        humanoid.Sit = false
    end

    local bodyClip = humanoidRootPart:FindFirstChild("BodyClip")
    if not bodyClip then
        bodyClip = Instance.new("BodyVelocity")
        bodyClip.Name = "BodyClip"
        bodyClip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyClip.Velocity = Vector3.new(0, 0, 0)
        bodyClip.Parent = humanoidRootPart
    end

    local noclipConnection = RunService.Stepped:Connect(function()
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end)

    local flySpeed = 150
    local estimatedTime = totalDist / flySpeed
    local startTime = os.clock()

    while _G.TweenIng and not _G.StopTween and humanoid.Health > 0 do
        local deltaTime = RunService.Heartbeat:Wait()
        local clampedDelta = math.min(deltaTime, 0.033)

        local elapsed = os.clock() - startTime
        local alpha = math.clamp(elapsed / estimatedTime, 0, 1)

        ValueFrame.CFrame = CFrame.new(startPos:Lerp(targetPos, alpha)) * (targetCFrame - targetCFrame.Position)

        if alpha >= 1 or (targetPos - ValueFrame.Position).Magnitude <= 3 then
            ValueFrame.CFrame = targetCFrame
            break
        end
    end

    if bodyClip then
        bodyClip:Destroy()
    end
    
    if noclipConnection then
        noclipConnection:Disconnect()
    end

    _G.TweenIng = false
    _G.StopTween = false

    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    humanoid.PlatformStand = false
end

tp2 = function(target, ValueFrame)
	if not target.Target then return end
	local pos = target.Target and target.Target.p
	local HumanoidRootPart = Client.Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Client.Character:FindFirstChild("Humanoid")
	local NoclipFun
	ValueFrame = ValueFrame or HumanoidRootPart

	if BostTweenchecking then return end
	if not ValueFrame then return end

	if ValueFrame.Name == "HumanoidRootPart" and _G["_POST"] ~= "Third World" then
		if Humanoid and Humanoid.Sit and _G["_POST"] ~= "Boats" then
			Humanoid.Sit = false 
		end
	end

	if BostTaskTween and pos ~= TweenOld then
		if type(BostTaskTween) == "function" then
			task.cancel(BostTaskTween)
		end
		BostTaskTween = nil
		TweenOld = pos
	end

	if _G.StopTween then
		task.wait(0.2)
		_G.StopTween = false
	end

	local currentDist = (pos - ValueFrame.Position).Magnitude
	TweenOld = target.Target.Position
	BostTaskTween = task.spawn(function()
		if not _G.StopTween and currentDist > 100 and Humanoid and Humanoid.Health > 0 then
			repeat
				if Humanoid.Sit and _G["_POST"] ~= "Boats" then
					Humanoid.Sit = false
				end
				BostTweenchecking = true
				if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					local Noclip = Instance.new("BodyVelocity")
					Noclip.Name = "BodyClip"
					Noclip.Parent = Client.Character.HumanoidRootPart
					Noclip.MaxForce = Vector3.new(5, math.huge, 5)
					Noclip.Velocity = Vector3.new(0, 0, 0)
				end


				currentDist = (pos - ValueFrame.Position).Magnitude
				local Fps = Util.FPSTracker.FPS
				local Percent = (60 / math.clamp(Fps, 15, 60))
				local Speed = 3.8 * Percent
				if Fps > 60 and Fps < 100 then
					Speed = 3.5 * Percent
				elseif Fps > 100 then
					Speed = 3 * Percent
				end
				local Root = HumanoidRootPart
				local Current = Root.Position
				local Dift = Vector3.new(target.Target.X, 0, target.Target.Z) - Vector3.new(Current.X, 0, Current.Z)
				local Sx = (Dift.X < 0 and -1 or 1) * Speed
				local Sz = (Dift.Z < 0 and -1 or 1) * Speed
				local SpeedX = math.abs(Dift.X) < math.abs(Sx) and Dift.X or Sx
				local SpeedZ = math.abs(Dift.Z) < math.abs(Sz) and Dift.Z or Sz

				ValueFrame.CFrame = ValueFrame.CFrame + Vector3.new(
					math.abs(SpeedZ) < Speed and SpeedX or SpeedX / 1.5,
					0,
					math.abs(SpeedX) < Speed and SpeedZ or SpeedZ / 1.5
				)
				ValueFrame.CFrame = CFrame.new(ValueFrame.Position.X, target.Target.Y, ValueFrame.CFrame.Position.Z)
				task.wait(math.random(0.1, 0.3))
			until _G.StopTween or pos ~= TweenOld or currentDist < 100 or not ValueFrame or (Humanoid and Humanoid.Health <= 0) or not Client.Character

			if _G.StopTween then
				_G.StopTween = false
			end
			BostTweenchecking = false
		end
		if currentDist < 100 then
			ValueFrame.CFrame = target.Target
		end
		if type(BostTaskTween) == "function" then
			task.cancel(BostTaskTween)
		end
		BostTaskTween = nil
	end)
end

ResolveSelectWeapon = function()
	local want = ({ Melee = "Melee", Sword = "Sword", Fruit = "Blox Fruit" })[_G.Settings.SelectWeapon] or "Melee"
	local found
	for _, container in ipairs({ Client.Backpack, Client.Character }) do
		if container then
			for _, v in ipairs(container:GetChildren()) do
				if v:IsA("Tool") and v.ToolTip == want then
					found = v.Name
				end
			end
		end
	end
	if found then _G.Select_Weapon = found end
	return _G.Select_Weapon
end

EquipTools = function(ToolSe)
	ToolSe = ToolSe or _G.Select_Weapon or ResolveSelectWeapon()
	if not ToolSe then return end
	local char = Client.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return end
	if char:FindFirstChild(ToolSe) then return end -- already equipped
	local Tool = Client.Backpack:FindFirstChild(ToolSe)
	if Tool then
		hum:EquipTool(Tool)
	end
end

UnEquipTools = function(Weapon)
	if Client.Character:FindFirstChild(Weapon) then
		Client.Character:FindFirstChild(Weapon).Parent = Client.Backpack
	end
end

swordChecking = function(s)
	for i, v in pairs(game:GetService("ReplicatedStorage").Remotes['CommF_']:InvokeServer("getInventory")) do
		if (v.Type == "Sword") then
			if v.Name == s then
				return true
			end
		end
	end
	return false
end

local RemoteUtil = require(ReplicatedStorage.Controllers.UI.Inventory.RemoteUtil)
local ItemConfig = require(ReplicatedStorage.ItemConfig)
local ItemReplicationService = require(ReplicatedStorage.ItemReplicationService)
local KEYS = require(ReplicatedStorage.ItemReplicationService.KEYS)

local function getInventory()
    local success, tiles = pcall(function()
        return RemoteUtil.getTiles():await()
    end)

    if not success or not tiles then
        return {}
    end

    local inventoryList = {}

    for _, tileData in pairs(tiles) do
        local itemId = tileData.ItemId
        local networkedUID = tileData.NetworkedUID

        local configMatch = ItemConfig.match(itemId)
        if configMatch and configMatch:isOk() then
            local config = configMatch:unwrap()
            
            local count = ItemReplicationService:ReadItem(KEYS.QUANTITY, itemId, networkedUID) or 1

            table.insert(inventoryList, {
                Name = config.Index.DebugLabel or "Unknown",
                Type = config.Index.IdType or "Unknown",
                StorageKey = config.Index.StorageKey or "",
                Count = count,
                ItemId = itemId,
                UID = networkedUID
            })
        end
    end

    return inventoryList
end

function CheckMaterialCount(MaterialI)
    local items = getInventory()
    
    for _, v in pairs(items) do
        if v.Type == "Material" or v.Type == "MaterialItem" then
            if v.Name == MaterialI or v.StorageKey == MaterialI then
                return v.Count
            end
        end
    end

    return 0
end

_hasItem  = function(name)
	return Client.Backpack:FindFirstChild(name) or Client.Character:FindFirstChild(name)
end

_hasChip = function()
	local Backpack = Client.Backpack:GetChildren()
	for i=1,#Backpack do local v = Backpack[i]
		if v.Name:lower():find("microchip") then
			return true
		end
	end
	local Character = Client.Character:GetChildren()
	for i=1,#Character do local v = Character[i]
		if v:IsA("Tool") and v.Name:lower():find("microchip") then
			return true
		end
	end
	return false
end

Notify = function(a, t) 
	warn(a,t)
end

local Nearbymob = false
local CanHits = {}
task.spawn(function()
	while task.wait(.075) do
		Nearbymob = nil
		table.clear(CanHits)
		for i,v in pairs(workspace.Enemies:GetChildren()) do
			if v:FindFirstChild("HumanoidRootPart") and  Client.Character:FindFirstChild("HumanoidRootPart") then
				if (v.HumanoidRootPart.Position - Client.Character:FindFirstChild("HumanoidRootPart") .Position).magnitude < 50 then
					Nearbymob = v.HumanoidRootPart
					table.insert(CanHits, {v, v.HumanoidRootPart})
				end
			end
		end
	end
end)

EquipToolsType = function(ToolType)
	for i,v in pairs(Client.Backpack:GetChildren()) do
		if v.ToolTip == ToolType then
			Client.Character.Humanoid:EquipTool(v)
		end
	end
end

-- Always keep the selected weapon up to date (independent from the UI loop)
task.spawn(function()
	while task.wait(.2) do
		pcall(ResolveSelectWeapon)
	end
end)

-- Auto Buso Haki
task.spawn(function()
	local lastTry = 0
	while task.wait(.5) do
		pcall(function()
			if _G.Settings['Auto Buso'] ~= false then
				local char = Client.Character
				if char and char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("HasBuso") and tick() - lastTry > 3 then
					lastTry = tick()
					_C('Buso')
				end
			end
		end)
	end
end)

task.wait(1.5)

do -- Intitalize Fast Attack
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local CombatUtils = require(ReplicatedStorage.Modules.CombatUtil)
	local CachedAim = {}
	local AimIndex, CurrentWeapon = 1, ""
	local Net = require(ReplicatedStorage.Modules.Net)
	local RegisterHitEvent = Net:RemoteEvent("RegisterHit", true)
	local gameFlags = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Flags"));
	local RegisterHitRemoteThread = nil 

	_G.SomFunsc = nil
	_G.InHasanQ = nil
	_G.getProgressHasan = {}

	pcall(function()
		if getgc then
			_G.LoadBack = function()
				for i, v in pairs(getgc()) do 
					if type(v) == "function" and not isexecutorclosure(v) then
						local success, env = pcall(getfenv, v)
						
						if success and env and env.script then
							local scriptObj = env.script
							
							if scriptObj == game:GetService("ReplicatedStorage"):FindFirstChild("FishReplicated") and scriptObj.FishReplicated:FindFirstChild("FishingClient") then
								if debug.getinfo(v).name == "OnBegin" then
									_G.SomFunsc = v
								end
							elseif scriptObj == game:GetService("ReplicatedStorage"):FindFirstChild("FishReplicated") and scriptObj.Name == "FishingClient" then
								if debug.getinfo(v).name == "OnBegin" then
									_G.SomFunsc = v
								end
							end

							if scriptObj == game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and scriptObj.Modules:FindFirstChild("CombatUtil") then
								if rawget(_G, "gameFlags") and _G.gameFlags.COMBAT_REMOTE_THREAD and debug.getinfo(v).name == "registerHit" then
									RegisterHitRemoteThread = debug.getupvalue(v, 4)
								end
							end

							local rescueScript = game:GetService("ReplicatedStorage"):FindFirstChild("BonusMoments") and game.ReplicatedStorage.BonusMoments:FindFirstChild("Rescue Hasan")
							if rescueScript and scriptObj == rescueScript then
								local upvalues = debug.getupvalues(v)

								for idx, val in pairs(upvalues) do
									if type(val) == "table" and rawget(val, "Progress") ~= nil then
										_G.getProgressHasan = val
									end
								end

								local hasTable = false
								local hasBool = false
								
								for idx, val in pairs(upvalues) do
									if type(val) == "table" then hasTable = true end
									if type(val) == "boolean" then hasBool = true end
								end
								
								if hasTable and hasBool then
									_G.InHasanQ = v
								end
							end
						end
					end
				end
			end
			_G.LoadBack()
		end
	end)

	function getWeaponName(Instnace) 
		local Humanoid = game.Players.LocalPlayer.Character.Humanoid
		if not Humanoid then return end 
		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if Tool then
			if Instnace then
				return Tool
			end
			if Tool:GetAttribute("WeaponName") then
				return Tool:GetAttribute("WeaponName")
			end 
			return Tool.Name
		end
		return nil 
	end

	function getWeapon() 
		local Humanoid = game.Players.LocalPlayer.Character.Humanoid
		if not Humanoid then return end 
		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if Tool then
			return Tool
		end
		return nil 
	end

	function getCacheAim(k) 
		if CurrentWeapon ~= k then
			AimIndex = 1
		end
		if CachedAim[k .. tostring(AimIndex)] == nil then
			AimIndex = 1 
			if CachedAim[k .. tostring(AimIndex)] then return CachedAim[k .. tostring(AimIndex)] end
			local GetMovesetAnimCache = CombatUtils:GetMovesetAnimCache(game.Players.LocalPlayer.Character.Humanoid)
			local WeaponName = getWeaponName()
			if not GetMovesetAnimCache then return end
			if not WeaponName then return end
			for i, AnimCache in pairs(GetMovesetAnimCache) do
				local SpeedMult = AnimCache:GetAttribute("SpeedMult") or 1
				local registerBlade = AnimCache.Length / SpeedMult

				CachedAim[i] = registerBlade
			end
		end
		AimIndex = AimIndex + 1
		return CachedAim[k .. tostring(AimIndex)]
	end

	function getRegisterBladeHit() 
		local WeaponName = getWeaponName()
		if not WeaponName then 
			return nil
		end
		return getCacheAim(CombatUtils:GetPureWeaponName(WeaponName) .. "-basic")
	end
	local AllTarget = {
		"RightUpperArm", 
		"RightLowerArm", 
		"RightHand", 
		"RightUpperLeg", 
		"RightLowerLeg", 
		"RightFoot", 
		"LeftUpperArm", 
		"LeftLowerArm", 
		"LeftHand", 
		"LeftUpperLeg", 
		"LeftLowerLeg", 
		"LeftFoot", 
		"UpperTorso", 
		"LowerTorso", 
		"Head"
	};

	function getAllBladeHits(Sizes)
		local Hits = {}
		local Client = game.Players.LocalPlayer
		local Enemies
		if _G.attackply then
			Enemies = game:GetService("Workspace").Characters:GetChildren()
		else
			Enemies = game:GetService("Workspace").Enemies:GetChildren()
		end
		for i=1,#Enemies do local v = Enemies[i]
			local Human = v:FindFirstChildOfClass("Humanoid")
			local Target = v:FindFirstChild(tostring(AllTarget[math.random(1, #AllTarget)]))
			if not Target then
				Target = v:FindFirstChild('HumanoidRootPart')
			end
			if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 and (Human.RootPart.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 300  then
				table.insert(Hits, Target)
			end
		end    
		if #Hits > 0  then
			local FirstHit = Hits[1]
			local MulitHit = {}
			local SpamHit = {}
			for i = 2, #Hits do
				local Hit = Hits[i]
				table.insert(MulitHit, {
					Hit.Parent,
					Hit
				})
			end
			for i, v in pairs(MulitHit) do
				table.insert(SpamHit, v)
			end
			return FirstHit, SpamHit
		end
		return nil, {}
	end

	function AttackFunction()
		local bladehit, mulithit = getAllBladeHits(120)
		local WeaponName = getWeaponName(true)
		if bladehit and WeaponName then 
			local registerBlade = getRegisterBladeHit()
			if registerBlade then 
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack"):FireServer(registerBlade)
				if gameFlags.COMBAT_REMOTE_THREAD and RegisterHitRemoteThread then 
					coroutine.resume(RegisterHitRemoteThread, bladehit, mulithit);
				else
					RegisterHitEvent:FireServer(bladehit, mulithit)
				end
			end
		end
	end

	task.spawn(function()
		while task.wait() do
			pcall(function()
				AttackFunction()
			end)
		end
	end)
end

local MonsertBringPos = {}
local blacklistD = {
	"Boss",
	"Minion"
}
local Entity = {}

CheckMobLevel = function(name)
	local Name = name:split("[Lv. ")[2]
	if Name then
		Name = Name:sub(1,#Name-1)
		if Name:find("Boss") then
			Name = Name:sub(1,#Name-7)
		end
	end
	return tonumber(Name) or math.huge
end

task.spawn(function() 
	while task.wait() do
		if _G.Settings['Bring Mob'] and _G.Mon ~= nil and _G.StartAttack and _G.IsBring then
			local success, err = pcall(function()
				for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
					if v.Name == _G.Mon.Name and v:FindFirstChild('HumanoidRootPart') and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then
						if isnetworkowner then
							if isnetworkowner(v:FindFirstChild('HumanoidRootPart')) then
								v:FindFirstChild('HumanoidRootPart').CanCollide = false
								v:FindFirstChild('HumanoidRootPart').Anchored = false
								v:FindFirstChild('HumanoidRootPart').CFrame = _G.Pos
								v:FindFirstChild('HumanoidRootPart').Velocity = Vector3.new(0, 0, 0)
								v:FindFirstChild('Humanoid'):ChangeState(14)
								if v.Humanoid:FindFirstChild("Animator") then
									v.Humanoid.Animator:Destroy()
								end
								if v.Humanoid.Health < v.Humanoid.MaxHealth then
									v:SetAttribute("Attacked", true)
								end
							end
						else
							if (v:FindFirstChild('HumanoidRootPart').Position - _G.Mon.HumanoidRootPart.Position).Magnitude < 250 then
								v:FindFirstChild('HumanoidRootPart').CanCollide = false
								v:FindFirstChild('HumanoidRootPart').Anchored = false
								v:FindFirstChild('HumanoidRootPart').CFrame = _G.Pos
								v:FindFirstChild('HumanoidRootPart').Velocity = Vector3.new(0, 0, 0)
								v:FindFirstChild('Humanoid'):ChangeState(14)
								if v.Humanoid:FindFirstChild("Animator") then
									v.Humanoid.Animator:Destroy()
								end
								if v.Humanoid.Health < v.Humanoid.MaxHealth then
									v:SetAttribute("Attacked", true)
								end
							end
						end
					end
				end
			end)
			if not success then DebugLog('Bring Mob : ', err) end
		end
	end
end)	

local attackTable = {}
local attackTableTake = {}
StepTospawn = 1
loadFun['To Spawn'] = function(NameMob)
	local PathAll = {}
	if type(NameMob) == 'table' then
		NameMob = NameMob[math.random(1, #NameMob)]
	end
	
	for _, v in pairs(workspace._WorldOrigin.EnemySpawns:GetChildren()) do
		if v.Name:find(NameMob) then
			if not string.find(v.Name, "%s".. NameMob) then
				table.insert(PathAll, v)
			end
		end
	end
	for i,v in pairs(ReplicatedStorage.FortBuilderReplicatedSpawnPositionsFolder:GetChildren()) do
		if v.Name:find(NameMob) then
			if not string.find(v.Name, "%s".. NameMob) then
				table.insert(PathAll, v)
			end
		end
	end
	
	if StepTospawn >= #PathAll then
		StepTospawn = 1
	else
		if dist(PathAll[StepTospawn].Position) <= 15 then
			StepTospawn += 1
		end
	end

	tp({ Target = PathAll[StepTospawn].CFrame * CFrame.new(0, 15, 0) })
end

TeleportService = game:GetService("TeleportService")
HopServer = function(FullServer) -- Hop Server (Low)
	local s,e = pcall(function()
		local FullServer = FullServer or false
		local Http = game:GetService("HttpService")
		local Api = "https://games.roblox.com/v1/games/"

		local _place = game.PlaceId
		local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
		local ListServers = function (cursor)
			local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
			return Http:JSONDecode(Raw)
		end

		local Server, Next; repeat wait()
			local Servers = ListServers(Next)
			Server = Servers.data[1]
			Next = Servers.nextPageCursor
		until Server

		repeat
			if not FullServer then
				TeleportService:TeleportToPlaceInstance(_place,Server.id,Client)
			else
				if request then
					local servers = {}
					local req = request(
						{
							Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)
						}
					).Body;
					local body = game:GetService("HttpService"):JSONDecode(req)
					if body and body.data then
						for i, v in next, body.data do
							if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
								table.insert(servers, 1, v.id)
							end
						end
					end
					if #servers > 0 then
						TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], Client)
					else
						return "Couldn't find a server."
					end
				end
			end
			wait()
		until game.PlaceId ~= game.PlaceId
	end)
	if not s then
		if _G.Debug then
			DebugLog('[Debug]', e)
		end
	end
end

local attackTable = {}
local ThradeSkill = {}
local monterChecking = tick()
local OldHealth = 0
_G.IsBring = false
Entity['attack'] = function(inTable, Expression, PositionM, unt, Safe)
	local unt = unt or {
		NoQuest = false
	}
	local PositionM = PositionM or 0
	local Data
	if Expression == "Farm Level" then
		Data = GetQuestData()
	end
	local SeaMonster, CheckGhost
	local attackTarget = function(target)
		if (Expression == "Farm Level" and unt and not unt.NoQuest and not Client.PlayerGui:FindFirstChild('TrackedQuestFrame')) or not _G.Settings[Expression] then 
			return 
		end
		if Expression == "Farm Level" and target:GetAttribute('LocalEnemy') == game.Players.LocalPlayer.Name then
			return
		end
		-- streamed-out / half-loaded enemy models have no HumanoidRootPart: skip them instead of erroring
		if not target:FindFirstChild("HumanoidRootPart") then
			return
		end
		local Old = target.HumanoidRootPart
		repeat 
			task.wait()
			if not target.Parent or not target:FindFirstChild("HumanoidRootPart") then
				break
			end
			if target:GetAttribute('LocalEnemy') == game.Players.LocalPlayer.Name then
				target.Humanoid.Health = 0
			end
			local healthPercentage = (Client.Character.Humanoid.Health / Client.Character.Humanoid.MaxHealth) * 100
			_G.StartAttack = true
			_G.Mon = target
			_G.Pos = unt and unt.MonsterPosition or target.HumanoidRootPart.CFrame
			if (target.Name == "SeaBeast1" and  target:FindFirstChild("Health")  and target:FindFirstChild("Health").Value > 0) then
				if Safe then
					EquipTools(_G.Select_Weapon)
					if not Client.Character:FindFirstChild("HasBuso") then
						_C('Buso')
					end
					if healthPercentage < 30 then
						if target.Name == "SeaBeast1"  then
							if target.HumanoidRootPart.Position.Y <= -800 then
								tp({ Target = CFrame.new(target.HumanoidRootPart.Position.X, 10, target.HumanoidRootPart.Position.Z), })
							else
								tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 700, 0), })
							end
						else
							tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 200, 0), })
						end
					else
						if target.Name == "SeaBeast1"  then
							if target.HumanoidRootPart.Position.Y <= -800 then
								tp({ Target = CFrame.new(target.HumanoidRootPart.Position.X, 10, target.HumanoidRootPart.Position.Z), })
							else
								tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0), })
							end
						else
							tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0), })
						end
					end
					if _G.Settings['Auto Use Skill'] and (target.Name == "SeaBeast1" and dist(target.HumanoidRootPart.Position) < 720 )  or dist(target.HumanoidRootPart.Position) < 40  then
						ThradeSkill[#ThradeSkill+1] = task.spawn(function()
							for i,skill in _G.Settings['Select Skill Use'] do 
								LockAim = true
								LockPosition = target.HumanoidRootPart.Position
								UseSkill(tostring(skill)) 
							end
						end)
					end
					
					--CheckMobDistance(target.Name)
				else
					EquipTools(_G.Select_Weapon)
					if not Client.Character:FindFirstChild("HasBuso") then
						_C('Buso')
					end
					if target.Name == "SeaBeast1"  then
						if target.HumanoidRootPart.Position.Y <= -800 then
							tp({ Target = CFrame.new(target.HumanoidRootPart.Position.X, 10, target.HumanoidRootPart.Position.Z), })
						else
							tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0), })
						end
					else
						tp({ Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0), })
					end
					if _G.Settings['Auto Use Skill'] and dist(target.HumanoidRootPart.Position) < 40 then
						ThradeSkill[#ThradeSkill+1] = task.spawn(function()
							for i,skill in _G.Settings['Select Skill Use'] do 
								LockAim = true
								LockPosition = target.HumanoidRootPart.Position
								UseSkill(tostring(skill)) 
							end
						end)
					end
				end
			else
				if not isnetworkowner(target:FindFirstChild("HumanoidRootPart")) then
					_G.IsBring = false
				else
					_G.IsBring  = true
				end
				if ( target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") and target.Humanoid.Health > 0) then
					if target.Name == "SeaBeast1"  then
						if target.HumanoidRootPart.Position.Y <= -800 then
							tp({
								Target = CFrame.new(target.HumanoidRootPart.Position.X, 10, target.HumanoidRootPart.Position.Z),
							})
						else
							tp({
								Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 300, 0),
							})
						end
					else
						tp({
							Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0),
						})
					end
					EquipTools(_G.Select_Weapon)
					if not Client.Character:FindFirstChild("HasBuso") then
						_C('Buso')
					end
					
					target:FindFirstChild('HumanoidRootPart').CanCollide = false
					target:FindFirstChild('HumanoidRootPart').Anchored = false
					target:FindFirstChild('HumanoidRootPart').CFrame = _G.Pos
					target:FindFirstChild('HumanoidRootPart').Velocity = Vector3.new(0, 0, 0)
					target:FindFirstChild('Humanoid'):ChangeState(14)
					if target.Humanoid:FindFirstChild("Animator") then
						target.Humanoid.Animator:Destroy()
					end

					if _G.Settings['Auto Use Skill'] and dist(target.HumanoidRootPart.Position) < 40 then
						ThradeSkill[#ThradeSkill+1] = task.spawn(function()
							for i,skill in _G.Settings['Select Skill Use'] do 
								LockAim = true
								LockPosition = target.HumanoidRootPart.Position
								UseSkill(tostring(skill)) 
							end
						end)
					end
				end
			end
		until (target.Name ~= "SeaBeast1" and target:FindFirstChild("Humanoid") and target.Humanoid.Health <= 0) 
			or (target.Name == "SeaBeast1" and target:FindFirstChild("Health") and target.Health.Value <= 0) 
			or ( unt and unt.Monster and unt.get == "have" and Entity.find(unt.Monster) )
			or ( unt and unt.Monster and unt.get == "not" and not Entity.find(unt.Monster) )
			or ( unt and unt.Func and unt.Func()) 
			or (Expression == "Farm Level" and unt and not unt.NoQuest and not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find(Data['MobName']))
			or not _G.Settings[Expression] 
			or not target:FindFirstChild("HumanoidRootPart") 
			or not target.Parent 
			or Client.Character.Humanoid.Health <= 0
		for i,v in next, ThradeSkill do task.cancel(v) end
		_G.StartAttack = false
		_G.Mon = nil
	end
	for _, category in ipairs({
		workspace.SeaBeasts:GetChildren(),
		workspace.Enemies:GetChildren(),
		game:GetService("ReplicatedStorage"):GetChildren(),
		}) do
		for _, target in ipairs(category) do
			if table.find(inTable, target.Name) then
				if _G.Settings[Expression] then
					attackTarget(target)
				else
					repeat
						task.wait()
						if not target.Parent or 
							(target.Name == "SeaBeast1" and target:FindFirstChild("Health") .Value <= 0) or 
							(target.Name ~= "SeaBeast1"and target.Humanoid.Health <= 0) or 
							not target:FindFirstChild("HumanoidRootPart")
							or target.HumanoidRootPart.Position.Y < -100 then
							break
						end
						attackTarget(target)
					until false
				end
			elseif category == game:GetService("ReplicatedStorage"):GetChildren() then
				if table.find(inTable, target.Name) and 
					target:FindFirstChild("Humanoid") and 
					target:FindFirstChild("HumanoidRootPart") and 
					target.Humanoid.Health > 0 then
					tp({Target = target.HumanoidRootPart.CFrame * CFrame.new(0, 200, 0)})
				end
			end
		end
	end
end

Entity.SeaAttack = function(SeaBeastsName, Expression, PositionY, PositionM, checkMode)
	local PositionY = PositionY or 0
	local Success,Error = pcall(function()
		for _i, _v in pairs(workspace.SeaBeasts:GetChildren()) do
			if table.find(SeaBeastsName, _v.Name) and (_v.HumanoidRootPart.Position - Client.Character.HumanoidRootPart.Position).magnitude <= PositionM then
				repeat task.wait()
					SeaSkill[1] = true;SeaSkill[2] = _v.HumanoidRootPart.Position
					if (_v.HumanoidRootPart.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= PositionY + 50 then
						ThradeSkill[#ThradeSkill+1] = task.spawn(function()
							for i,skill in _G.Settings['Select Skill Use'] or {"Z","X","C","V"} do 
								LockAim = true
								LockPosition = _v.HumanoidRootPart.Position
								UseSkill(tostring(skill)) 
							end
						end)
					end
					tp(_v.HumanoidRootPart.CFrame * CFrame.new(0, PositionY, 0),SeaBeastsName)
				until not _G.Settings[Expression] or _v.Humanoid.Health <= 0 or Client.PlayerGui.Main.Timer.Visible == true or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0
				if checkMode == "V4" then
					_G.StopTween = true
				end
				SeaSkill[1] = false
				for i,v in next, ThradeSkill do task.cancel(v) end
			end
		end
	end)
end

Entity.find = function(EnemiesName, PositionM, Type, Test)
	local Boats = {'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}

	local function isValidEnemy(enemy)
		if enemy.Name == "SeaBeast1" then
			return enemy:FindFirstChild("Health") and enemy.Health.Value > 0
		elseif table.find(Boats, enemy.Name) then
			return enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0
		elseif enemy:FindFirstChild("Humanoid") then
			return enemy.Humanoid.Health > 0
		end
		return false
	end

	local function isWithinRange(enemy, positionM)
		local enemyPosition = Type == "Boat" and enemy.VehicleSeat.CFrame.Position or enemy.HumanoidRootPart.CFrame.Position
		return (enemyPosition - Client.Character.HumanoidRootPart.Position).Magnitude < positionM
	end

	local function checkEnemies(enemies)
		for _, enemy in pairs(enemies) do
			if enemy:FindFirstChild('HumanoidRootPart') then
				local valid = table.find(EnemiesName, enemy.Name) and isValidEnemy(enemy)
				if valid then
					if PositionM then
						if isWithinRange(enemy, PositionM) then
							return true
						end
					else
						return true
					end
				end
			end
		end
		return false
	end

	return checkEnemies(workspace.Enemies:GetChildren()) or
		checkEnemies(workspace.SeaBeasts:GetChildren()) or
		checkEnemies(game:GetService("ReplicatedStorage"):GetChildren())
end

Entity.getCFrame = function(EnemiesName )
	local Boats = {'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}

	local function isValidEnemy(enemy)
		if enemy.Name == "SeaBeast1" then
			return enemy:FindFirstChild("Health") and enemy.Health.Value > 0
		elseif table.find(Boats, enemy.Name) then
			return enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0
		elseif enemy:FindFirstChild("Humanoid") then
			return enemy.Humanoid.Health > 0
		end
		return false
	end

	local function checkEnemies(enemies)
		for _, enemy in pairs(enemies) do
			if enemy:FindFirstChild('HumanoidRootPart') then
				local valid = table.find(EnemiesName, enemy.Name) and isValidEnemy(enemy)
				if valid then
					return enemy:FindFirstChild('HumanoidRootPart').Position
				end
			end
		end
		return nil
	end

	return checkEnemies(workspace.Enemies:GetChildren()) or
		checkEnemies(workspace.SeaBeasts:GetChildren()) or
		checkEnemies(game:GetService("ReplicatedStorage"):GetChildren())
end

loadFun['getPcall'] = function(funload, fun)
	local success, debugfun = pcall(fun)
	if not success then
		if _G.Debug then
			DebugLog('[DEBUG]', debugfun, ' : ', funload)
		end
	end
end


local getEyeStast = function()
    return workspace.Map.TikiOutpost.IslandModel.Eye2.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.Eye1.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye3.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.Eye1.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye4.Transparency == 0
end

local getEyeStast2 = function(s)
	if s == 1 then
    	return workspace.Map.TikiOutpost.IslandModel.Eye2.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.Eye1.Transparency == 0 
	elseif s == 2 then
		return workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye3.Transparency == 0 and workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye4.Transparency == 0
	end
end

local allIsDisEye = function()
    return workspace.Map.TikiOutpost.IslandModel.Eye2.Transparency == 1 and workspace.Map.TikiOutpost.IslandModel.Eye1.Transparency == 1 and workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye3.Transparency == 1 and workspace.Map.TikiOutpost.IslandModel.Eye1.Transparency == 1 and workspace.Map.TikiOutpost.IslandModel.IslandChunks.E.Eye4.Transparency == 1
end

local VirtualInputManager = game:GetService("VirtualInputManager")
local recheckTime2650 = tick()
local needrecheck = false
IsFarming = false
local nowSkill = ""
loadFun['Farm Level'] = function()
	local funx = 'Farm Level'
	IsFarming = _G.Settings['Farm Level']
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if not IsFarming then return end
			if Sea3 then
				if not game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineWorkerSpeak"):InvokeServer("AskKilledTikiBoss") and Client.Data.Level.Value >= 2650 and _G.Settings.Auto_Go_New_Island then
					if Entity.find({'Tyrant of the Skies'}) then
						Entity.attack({'Tyrant of the Skies'}, funx, nil ,{ NoQuest = true })
					else
						if getEyeStast() then
							for i,v in next,workspace.Map.TikiOutpost.IslandModel.IslandChunks.D.EagleBossArena:GetChildren() do
								if v.Name == "Tree" and v:GetAttribute('TikiUrn') and not v:GetAttribute('Skip') and v.PrimaryPart and v.PrimaryPart.Name == 'Meshes/brokenurns_Cylinder.014' and v and v.Parent then
									tp({Target = v.PrimaryPart.CFrame})
									if dist(v.PrimaryPart.Position) <= 5 then
										local Weapons = { "Melee", "Sword", "Blox Fruit", "Gun" }
										local Skills = { "Z","X","C","V" }
										for _, Weapon in next, Weapons do
											for _, Weaponr in pairs(Client.Backpack:GetChildren()) do
												if Weaponr.ToolTip == Weapon then
													if _hasItem(Weaponr.Name) then
														EquipTools(Weaponr.Name) 
														for i,skill in next, Skills do
															if require(Weaponr.Data)['Lvl'][skill] and Weaponr.Level.Value >= require(Weaponr.Data)['Lvl'][skill] then
																tp({Target = v.PrimaryPart.CFrame})
																LockAim = true
																UseSkill(tostring(skill)) 
																LockPosition = v.PrimaryPart.Position
															end
														end
													end
												end
											end
										end
										task.wait(2)
										v:SetAttribute('Skip', true)
										task.delay(5, function()
											v:SetAttribute('Skip', false)
										end)
									end
								end
							end
						else
							if not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
								tp({ Target = CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621) * CFrame.new( 0, 0, 5)  })
								if dist(CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621)) <= 5 then
									_C("StartQuest", "TikiQuest3", 2)
								end
							else
								if not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find('Skull Slayer') then
									_C("AbandonQuest")
								end
								local enemyNames = { "Serpent Hunter", "Skull Slayer" }
								if Entity.find(enemyNames) then
									Entity.attack(enemyNames, funx, nil, { NoQuest = true })
								else
									loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
								end
							end
						end
					end
					return
				elseif not game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/SubmarineWorkerSpeak"):InvokeServer("AskKilledTikiBoss") and Client.Data.Level.Value >= 2650 then
					if not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
						tp({ Target = CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621) * CFrame.new( 0, 0, 5)  })
						if dist(CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621)) <= 5 then
							_C("StartQuest", "TikiQuest3", 2)
						end
					else
						if not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find('Skull Slayer') then
							_C("AbandonQuest")
						end
						local enemyNames = { "Skull Slayer" }
						if Entity.find(enemyNames) then
							Entity.attack(enemyNames,funx,nil, { NoQuest = true })
						else
							loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
						end
					end
					return
				end
			end
			
			local GetQuestData = GetQuestData()
			if not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
				tp({ Target = GetQuestData['NPCPosition'] * CFrame.new(0, 5, 0) })
				if dist(GetQuestData['NPCPosition']) <= 5 then
					task.wait(1)
					_C("StartQuest", GetQuestData['QuestName'], GetQuestData["QuestLevel"])
				end
			else
				if not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find(GetQuestData['MobName']) then
					_C("AbandonQuest")
				end

				if Entity.find({ GetQuestData['MobName']:gsub("%%%-", "-") }) then
					Entity.attack({
						GetQuestData['MobName']:gsub("%%%-", "-")
					}, funx, nil, { Func = function() return not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') end })
				else
					repeat task.wait()
						if _G.Debug then
							DebugLog('[DEBUG]', 'Not Fond Mon')
						end
						loadFun['To Spawn'](GetQuestData['MobName'])
					until not _G.Settings[funx] or Entity.find({GetQuestData['MobName']:gsub("%%%-", "-")}) or not Client.PlayerGui:FindFirstChild('TrackedQuestFrame')
				end
			end
		end)
	end
end

loadFun['Auto Tyrant of the Skies'] = function()
	local funx = 'Auto Tyrant of the Skies'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if Entity.find({'Tyrant of the Skies'}) then
				Entity.attack({'Tyrant of the Skies'}, funx, nil ,{ NoQuest = true })
			else
				if getEyeStast() then
					for i,v in next,workspace.Map.TikiOutpost.IslandModel.IslandChunks.D.EagleBossArena:GetChildren() do
						if v.Name == "Tree" and v:GetAttribute('TikiUrn') and not v:GetAttribute('Skip') and v.PrimaryPart and v.PrimaryPart.Name == 'Meshes/brokenurns_Cylinder.014' and v and v.Parent then
							tp({Target = v.PrimaryPart.CFrame})
							if dist(v.PrimaryPart.Position) <= 5 then
								local Weapons = { "Melee", "Sword", "Blox Fruit", "Gun" }
								local Skills = { "Z","X","C","V" }
								for _, Weapon in next, Weapons do
									for _, Weaponr in pairs(Client.Backpack:GetChildren()) do
										if Weaponr.ToolTip == Weapon then
											if _hasItem(Weaponr.Name) then
												EquipTools(Weaponr.Name) 
												for i,skill in next, Skills do
													if require(Weaponr.Data)['Lvl'][skill] and Weaponr.Level.Value >= require(Weaponr.Data)['Lvl'][skill] then
														tp({Target = v.PrimaryPart.CFrame})
														LockAim = true
														UseSkill(tostring(skill)) 
														LockPosition = v.PrimaryPart.Position
													end
												end
											end
										end
									end
								end
								task.wait(2)
								v:SetAttribute('Skip', true)
								task.delay(5, function()
									v:SetAttribute('Skip', false)
								end)
							end
						end
					end
				else
					if not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
						tp({ Target = CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621) * CFrame.new( 0, 0, 5)  })
						if dist(CFrame.new(-16660.2305, 105.279953, 1583.80298, 0.789520621, -9.85452715e-08, 0.613724053, 5.24816954e-08, 1, 9.30546733e-08, -0.613724053, -4.12593053e-08, 0.789520621)) <= 5 then
							_C("StartQuest", "TikiQuest3", 2)
						end
					else
						if not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find('Skull Slayer') then
							_C("AbandonQuest")
						end
						local enemyNames = { "Serpent Hunter", "Skull Slayer" }
						if Entity.find(enemyNames) then
							Entity.attack(enemyNames, funx, nil, { NoQuest = true })
						else
							loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
						end
					end
				end
			end
		end)
	end
end

local MagnitudePositionChest = 100
loadFun['Auto Chests'] = function()
	local funx = 'Auto Chests'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			for i,v in pairs(game:GetService('Workspace').ChestModels:GetDescendants()) do
				if v.Name == "SilverChest" or v.Name == "GoldChest" or v.Name == "DiamondChest" then
					if not v:FindFirstChild('Zee Hub') and (v.RootPart.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 500 + MagnitudePositionChest then
						repeat wait()
							tp({Target = v.RootPart.CFrame})
							if (v.RootPart.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 1 then
								MagnitudePositionChest = 500
								if not v:FindFirstChild('Zee Hub') then
									local F = Instance.new('Folder', v)
									F.Name = "Zee Hub"
								end
								UnEquipTools(_G.Select_Weapon) task.wait(0.01)
								EquipTools(_G.Select_Weapon)
							else
								EquipTools(_G.Select_Weapon)
							end
						until _G.Settings[funx] == false or not v.Parent or v:FindFirstChild('Zee Hub')
						MagnitudePositionChest = MagnitudePositionChest + 10
						break
					else
						MagnitudePositionChest = MagnitudePositionChest + 50
					end
				end
			end
		end)
	end
end

loadFun['Auto New World'] = function()
	local funx = 'Auto New World'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if game.Players.LocalPlayer.Data.Level.Value >= 700 and Sea1 then
				if _G.Settings['Farm Level'] then IsFarming = false end
				if workspace:WaitForChild("Map").Ice.Door.CanCollide == false and workspace:WaitForChild("Map").Ice.Door.Transparency == 1 then
					if Entity.find({"Ice Admiral"}) then
						Entity.attack({
							tostring("Ice Admiral")
						},funx)
					else
						_C("TravelDressrosa")
					end
				elseif workspace:WaitForChild("Map").Ice.Door.CanCollide == true and workspace:WaitForChild("Map").Ice.Door.Transparency == 0 then
					repeat wait() tp({ Target = CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563) }) until (CFrame.new(4851.8720703125, 5.6514348983765, 718.47094726563).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.Settings[funx]
					_C('DressrosaQuestProgress', 'Detective')
					repeat wait() tp({ Target = CFrame.new(1347.7124, 37.3751602, -1325.6488) }) until (CFrame.new(1347.7124, 37.3751602, -1325.6488).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 or not _G.Settings[funx]
					EquipTools("Key")
					wait(3.5)
				else
					_C("TravelDressrosa")
				end
			end
		end)
	end
end

local FruitPrice = {}
local FruitStore = {}
loadFun['Auto Third World'] = function()
	local funx = 'Auto Third World'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if Client.Data.Level.Value >= 1500 then
				if _C("BartiloQuestProgress","Bartilo") == 3 then
					if _C("GetUnlockables").FlamingoAccess ~= nil then							
						if _C("ZQuestProgress","Check") == 0 then
							_C("ZQuestProgress","Begin")
							if Entity.find({"rip_indra"}) then
								Entity.attack({
									"rip_indra"
								},funx)
							else
								_C("ZQuestProgress","Check")
								_C("ZQuestProgress","Begin")
							end
						else
							_C("TravelZou")
							if _C("ZQuestProgress","Check") ~= 0 then
								if Entity.find({"Don Swan"}) then
									Entity.attack({
										"Don Swan"
									},funx)
								else
									loadFun['To Spawn']("Don Swan")
								end
							end
						end
					else
						for i,v in next,game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
							if v.Price >= 1000000 then  
								table.insert(FruitPrice,v.Name)
							end
						end
						for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
							for _,x in pairs(v) do
								if _ == "Name" then 
									table.insert(FruitStore,x)
								end
							end
						end
						local function CheckFruit()
							local player = game.Players.LocalPlayer
							for _, tool in pairs(player.Backpack:GetDescendants()) do
								if tool:FindFirstChild("Fruit") then
									return tool
								end
							end
						end
						local function AddToNpc()
							if Client.Backpack:FindFirstChild(tostring(CheckFruit())) then
								wait(1.5)
								EquipTools(tostring(CheckFruit()))
								wait(0.5)
								_C("TalkTrevor","1")
								wait(0.5)
								_C("TalkTrevor","2")
								wait(0.5)
								_C("TalkTrevor","1")
								wait(0.5)
								_C("TalkTrevor","3")
							end
						end
						for _,y in pairs(FruitPrice) do
							for _,z in pairs(FruitStore) do
								if y == z and _C("GetUnlockables").FlamingoAccess == nil then
									local args = {
										[1] = "LoadFruit",
										[2] = tostring(y)
									}

									_C(unpack(args))
									AddToNpc()
								end
							end 
						end
					end
				else
					if _C("BartiloQuestProgress","Bartilo") == 0 then
						IsFarming = false
						if Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
							if Entity.find({"Swan Pirate"}) then
								Entity.attack({
									"Swan Pirate"
								},funx)
							else
								loadFun['To Spawn']("Swan Pirate")
							end
						else
							repeat wait() tp({Target = CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312)}) until (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 20 or not _G.Settings[funx]
							if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 1 then
								game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
							end
						end
					elseif  _C("BartiloQuestProgress","Bartilo") == 1 then
						IsFarming = false
						if Entity.find({"Jeremy"}) then
							Entity.attack({
								"Jeremy"
							},funx)
						else
							loadFun['To Spawn']("Jeremy")
						end
					elseif  _C("BartiloQuestProgress","Bartilo") == 2 then
						repeat wait() tp({Target = CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456)}) until (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 1 or not _G.Settings[funx] 
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
						wait(0.7)
						Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
					end
				end
			end
		end)
	end
end

loadFun['Auto Find Pole'] = function()
	local funx = 'Auto Find Pole'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if not Sea1 then
				_C("TravelMain")
				return
			end
			if Entity.find({'Thunder God'}) then
				Entity.attack({'Thunder God'}, funx)
			else
				if dist(CFrame.new(-7779.26123, 5606.93652, -2421.9502, -0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, -0.996191859)) < 1 then
					if _G.Settings[funx .. " Hop"] then
						HopServer()
					end
				else
					tp({Target = CFrame.new(-7779.26123, 5606.93652, -2421.9502, -0.996191859, 0, 0.0871884301, 0, 1, 0, -0.0871884301, 0, -0.996191859)})
				end
			end
		end)
	end
end

loadFun['Auto Find Saber'] = function()
	local funx = 'Auto Find Saber'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if not Sea1 then
				_C("TravelMain")
				return
			end
			local MyLevel = Client.Data.Level.Value
			if MyLevel >= 200 and not swordChecking("Saber") then
				if not Sea1 then
					_C("TravelMain")
					return
				end
				local Data_ProQuestProgress = _C("ProQuestProgress")
				local Press = Data_ProQuestProgress.Plates
				if _G.Settings['Farm Level'] then IsFarming = false end
				if Data_ProQuestProgress.UsedRelic == true then
					if Entity.find({"Saber Expert"}) then
						Entity.attack({
							"Saber Expert"
						}, funx)
					end
				else
					for i=1,#Press do
						if not Press[i] then
							_C("ProQuestProgress","Plate",i)
						end
					end
					if not Data_ProQuestProgress.UsedTorch then
						repeat 
							_C("ProQuestProgress","GetTorch")
							wait() 
						until Client.Backpack:FindFirstChild("Torch") 
						repeat
							_C("ProQuestProgress","DestroyTorch")
							wait()
						until not Client.Backpack:FindFirstChild("Torch")
					end
					if not Data_ProQuestProgress.UsedCup then
						repeat
							_C("ProQuestProgress","GetCup")
							wait()
						until Client.Backpack:FindFirstChild("Cup")
						_C("ProQuestProgress","FillCup",Client.Backpack.Cup)
						repeat
							_C("ProQuestProgress","SickMan")
							wait()
						until not Client.Backpack:FindFirstChild("Cup")
					end
					if not Data_ProQuestProgress.TalkedSon then
						_C("ProQuestProgress","RichSon")
					end
					if Data_ProQuestProgress.KilledMob and not Data_ProQuestProgress.UsedRelic then
						_C("ProQuestProgress","RichSon")
						_C("ProQuestProgress","PlaceRelic")                            
					elseif not Data_ProQuestProgress.KilledMob then
						if Entity.find({"Mob Leader"}) then
							Entity.attack({
								"Mob Leader"
							}, funx)
						else
							tp({Target = EnemySpawns['Mob Leader [Lv. 120] [Boss]'].CFrame})
						end
					end
				end
			end
		end)
	end
end

loadFun['AutoBringFruit'] = function()
	local funx = 'AutoBringFruit'
	loadFun['getPcall'](funx, function()
		for _, v in pairs(workspace:GetChildren()) do
			if Client.Character:FindFirstChildOfClass("Humanoid") and Client.Character:FindFirstChild('HumanoidRootPart') and not IsRaiding() then
				if v:IsA("Tool") and (v:FindFirstChild("Fruit") or v:FindFirstChild("EatRemote")) and v.Name ~= "Fruit" then
					if Client.Character.Humanoid.Sit == true then Client.Character.Humanoid.Sit = false end
					for _, _v in pairs(Client.Character:GetDescendants()) do if _v:IsA("BasePart") then _v.CanCollide = true  end end
					v.Handle.CFrame = Client.Character:WaitForChild("Head").CFrame
				else
					wait(.2)
					for _, _v in pairs(Client.Character:GetDescendants()) do if _v:IsA("BasePart") then _v.CanCollide = false  end end
				end
			end
		end
	end)
end

local LastTospawn = tick()
loadFun['Auto Farm Bone'] = function()
	local funx = 'Auto Farm Bone'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			local enemyNames = {
				'Reborn Skeleton',
				'Living Zombie',
				'Demonic Soul',
				'Posessed Mummy'
			}
			if not Sea3 then
				_C("TravelZou")
				return
			end
			if Entity.find(enemyNames) then
				Entity.attack(enemyNames, funx)
			else
				if tick() - LastTospawn > 0.3 then
					loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
					LastTospawn = tick()
				end
			end
		end)
	end
end

local LastTospawn = tick()
loadFun['Auto Cake Prince'] = function()
	local funx = 'Auto Cake Prince'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if not Sea3 then
				_C("TravelZou")
				return
			end
			if Entity.find({"Cake Prince","Dough King"}) then
				Entity.attack({
					"Cake Prince",
					"Dough King"
				}, funx)
			else
				local enemyNames = {
					"Baking Staff",
					"Head Baker",
					"Cake Guard",
					"Cookie Crafter"
				}
				if Entity.find( enemyNames ) then
					Entity.attack( enemyNames, funx)
				else
					if tick() - LastTospawn > 0.3 then
						loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
						LastTospawn = tick()
					end
				end
			end
		end)
	end
end

local LastTospawn = tick()
loadFun['Trading Bone'] = function()
	local funx = 'Trading Bone'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			_C("Bones","Buy",1,1)
		end)
	end
end

loadFun['Auto Elite Hunter'] = function()
	local funx = 'Auto Elite Hunter'
	_C("EliteHunter")
	while task.wait() and _G.Settings[funx] do 
		loadFun['getPcall'](funx, function()
			if not Sea3 then
				_C("TravelZou")
				return
			end
			local QuestUI = Client.PlayerGui:FindFirstChild('TrackedQuestFrame')
			local en = {
				"Diablo",
				"Deandre",
				"Urban"
			}
			if Entity.find(en) and QuestUI then
				Entity.attack(en, funx)
			else
				if _hasItem("God's Chalice") then
					tp({ Target = CFrame.new(-12549.5, 337.2, -7515.1)})
					return
				else
					if not QuestUI then
						_C("EliteHunter")
					end
				end
			end
		end)
	end
end

loadFun['Auto Find MidnightBlade'] = function()
	local funx = 'Auto Find MidnightBlade'
	while task.wait() and _G.Settings[funx] do 
		local Ecto = _C("Ectoplasm","Buy",3)
		if Ecto == 1 or Ecto == 2 then
			_G.Settings[funx]  = false
			break
		end
		if not Sea2 then _C("TravelDressrosa") continue end
		local Em = {"Ship Deckhand","Ship Engineer","Ship Officer","Ship Steward"}
		if Entity.find(Em) then
			Entity.attack(Em, "Auto Find MidnightBlade")
		else
			if tick() - LastTospawn > 0.3 then
				loadFun['To Spawn'](Em[math.random(1, #Em)])	
				LastTospawn = tick()
			end
		end
	end
end

local Boats = {'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}
--[[task.spawn(function()
	while task.wait() do
		if IsRaiding() and _G.Settings['Auto Clear Dungeons']  then
			for i,v in pairs(workspace.Enemies:GetChildren()) do
				if not table.find( Boats, v.Name) then
					v.Humanoid.Health = 0
					v.Humanoid:ChangeState(15)
					v.HumanoidRootPart.CanCollide = false;
					sethiddenproperty(Client, "SimulationRadius", math.huge)
				end
			end
		end
	end
end)]]

loadFun['Auto Clear Dungeons'] = function()
	local funx = 'Auto Clear Dungeons'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if IsRaiding()  then
				local maxIslandNum = 0
				local maxIslandPosition = nil
				for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
					local islandNum = tonumber(string.match(v.Name, "%d+"))
					if islandNum and islandNum > maxIslandNum then
						local distance = dist(v.Position, Client.Character.HumanoidRootPart.Position)
						if distance < 8500 then
							maxIslandNum = islandNum
							maxIslandPosition = v.CFrame * CFrame.new(0,50,100)
						end
					end
				end
				for _,target in pairs(workspace.Enemies:GetChildren()) do
					if target and target:FindFirstChild('HumanoidRootPart') and dist(target.HumanoidRootPart.Position) <= 8500 then
						if Entity.find({target.Name}) then
							Entity.attack({target.Name}, "Auto Clear Dungeons")
						end
					end
				end
				if maxIslandPosition then
					tp({Target = maxIslandPosition})
				end
				_C("Awakener","Teleport")
			else
				if _hasChip() and not IsRaiding() then
					if Sea2 then
						tp({ Target = workspace.Map.CircleIsland.RaidSummon:GetPivot() })
						fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
					end
					if Sea3 then
						tp({ Target = game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2:GetPivot() })
						fireclickdetector(game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button.Main:FindFirstChild("ClickDetector"))
					end
				elseif not  _hasChip() and not IsRaiding() and _G.Settings['Auto Buy Microchip'] then
					_C("RaidsNpc", "Select", _G.Settings['Select Raid'])
				end
			end
		end)
	end
end

function Checkmobdrop(Name)
	local Table = {}
	local Sea;
	for categoryIndex, category in ipairs(allMaterials) do
		for material, drops in pairs(category) do
			if material == Name then
				for _, drop in ipairs(drops) do
					Sea = categoryIndex
					table.insert(Table,drop)
				end
			end
		end
	end

	return {
		['Sea'] = Sea,
		['Mobs'] = Table
	}
end

toSea = function(i)
	if i == SeaIndex then return end
	if (type(i)~='number') or i > 3 then return warn("sea in dex is not exist") end
	if i == 1 then
		_C("TravelMain")
	end
	if i == 2 then
		_C("TravelDressrosa")
	end
	if i == 3 then
		_C("TravelZou")
	end
end

loadFun['Find Material'] = function()
	while _G.Settings['Find Material'] and task.wait() do
		loadFun['getPcall']('Find Material', function()
			local Onsea,Mobs = Checkmobdrop( _G.Settings['Select Material'] )['Sea'], Checkmobdrop( _G.Settings['Select Material'] )['Mobs']
			if (Onsea == 1 and not Sea1) or (Onsea == 2 and not Sea2) or (Onsea == 3 and not Sea3) then
				toSea(Onsea)
			end
			if Entity.find(Mobs) then
				Entity.attack(Mobs, 'Find Material')
			else
				loadFun['To Spawn'](Mobs)
			end
		end)
	end
end

loadFun['Auto Yama'] = function()
	local funx = 'Auto Yama'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if _C("EliteHunter","Progress") >= 30 then
				fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
			else
				local en = {
					"Diablo",
					"Deandre",
					"Urban"
				}
				local QuestUI = Client.PlayerGui:FindFirstChild('TrackedQuestFrame')
				if Entity.find(en) and QuestUI then
					Entity.attack(en, funx)
				else
					if string.find(_C("EliteHunter"), "Come back later.") then
						if _G.Settings[funx .. " Fully" ] then
							HopServer()
						end
					elseif QuestUI then
						_C("EliteHunter")
					end
				end
			end
		end)
	end
end

local getGojoQuest = function()
	local data = {
		['BeltName'] = "",
		['Goal'] = 0,
		['QuestName'] = "",
		['Description'] = "",
		['Progress'] = 0,
	}
	local get = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest"):InvokeServer({
		["NPC"] = "Dojo Trainer",
		["Command"] = "RequestQuest"
	})
	if type(get) == 'table' then
		for i,v in pairs(get) do
			if type(v) == 'table' then
				return v
			end
		end
	end
	return nil
end


local getMonsterLevel = function(playerLevel)
	local Folder = workspace:FindFirstChild("EnemySpawns")
	local closestMonster = nil
	local closestLevelDifference = math.huge
	local closestMonsterLevel = nil
	for i, v in pairs(Folder:GetChildren()) do
		if not v.Name:find('Boss') then
			local monsterLevelStr = v.Name:match("Lv. (%d+)")
			if monsterLevelStr then
				local monsterLevel = tonumber(monsterLevelStr) 
				local levelDifference = math.abs(playerLevel - monsterLevel)
				if levelDifference < closestLevelDifference then
					closestMonster = v
					closestLevelDifference = levelDifference
					closestMonsterLevel = monsterLevel
				end
			end
		end
	end
	if closestMonster then
		return {
			['Name'] = closestMonster.Name:gsub("%s%[Lv. %d+%]", ""),
			['Level'] = closestMonsterLevel
		}
	end
end

local ClaimQuesDojotTrainer = function()
	local args = {
		[1] = {
			["NPC"] = "Dojo Trainer",
			["Command"] = "ClaimQuest"
		}
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
end

local tableSaveDojo = {}
local setQuset = {}
local data = getGojoQuest()
local L = 0
local PositionSea = 0
local GG = false
local DojoTick = tick()
loadFun['Auto Dojo Quest'] = function()
	local funx = 'Auto Dojo Quest'
	data = {}
	PositionSea = 0
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			local getGojoQuest2 = getGojoQuest()
			if type(getGojoQuest2) == 'table' then
				data = getGojoQuest2
			end
			if not data['QuestName']  then
				tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
				if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
					repeat task.wait()
						ClaimQuesDojotTrainer()
						local getGojoQuest2 = getGojoQuest()
						if type(getGojoQuest2) == 'table' then
							data = getGojoQuest2
						end
					until not _G.Settings[funx] or type(data) == 'table'
				end
			else
				if data['QuestName'] == "Admittance" then
					if not setQuset['Admittance'] then
						tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
						if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
							setQuset['Admittance'] = data['Goal'] + 20 + 10
						end
					else
						if setQuset['Admittance'] > 0 then
							local playerlevel = Client.Data.Level.Value
							local monsterData = getMonsterLevel(playerlevel)
							local MonName = monsterData['Name']:gsub("-", "%%-")
							local Mon = MonName:gsub("%%","")
							if Entity.find({Mon}) then
								Entity.attack({Mon}, funx)
								setQuset['Admittance'] -= 1
							else
								if tick() - LastTospawn >= .3 then
									loadFun['To Spawn'](Mon)
									LastTospawn = tick()
								end
							end
						else
							tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
							if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
								data = {}
								repeat task.wait()
									ClaimQuesDojotTrainer()
									local getGojoQuest2 = getGojoQuest()
									if type(getGojoQuest2) == 'table' then
										data = getGojoQuest2
									end
								until not _G.Settings[funx] or type(data) == 'table'
							end
						end
					end
				elseif data['QuestName'] == "Water Warrior" then
					if not setQuset['Water Warrior'] then
						tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
						if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
							setQuset['Water Warrior'] = data['Goal'] + 1
						end
					else
						local Terror_Shark = {
							[1] = CFrame.new(-18961.4277, 10.8767843, 821.362305, -0.292515308, 0.00162690994, 0.956259489, 0.0055617094, 0.999984562, 2.57972838e-10, -0.956244648, 0.00531843724, -0.292519808),
							[2] = CFrame.new(-16928.2617, 14.0881872, 435.386047, 0.0157553777, -5.09521803e-09, 0.999875903, 1.48630752e-08, 1, 4.86164797e-09, -0.999875903, 1.4784634e-08, 0.0157553777),
							[3] = false
						}
						if setQuset['Water Warrior'] > 0 then
							if Entity.find({'Terrorshark'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Terrorshark'}, funx, nil, nil, true)
								if Entity.find({'Terrorshark'}, 1000, nil, true) then
									setQuset['Water Warrior'] -= 1
								end
								PositionSea += 100
							elseif Entity.find({'SeaBeast1'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'SeaBeast1'}, funx, nil, nil, true)
								if Entity.find({'SeaBeast1'}, 1000, nil, true) then
									setQuset['Water Warrior'] -= 1
								end
								PositionSea += 100
							elseif Entity.find({'Shark'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Shark'}, funx, nil, nil, true)
								if Entity.find({'Shark'}, 1000, nil, true) then
									setQuset['Water Warrior'] -= 1
								end
								PositionSea += 100
							elseif Entity.find({'Piranha'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Piranha'}, funx, nil, nil, true)
								setQuset['Water Warrior'] -= 1
								PositionSea += 100
								if Entity.find({'Piranha'}, 1000, nil, true) then
									setQuset['Water Warrior'] -= 1
								end
							elseif  Entity.find({'Fish Crew Member'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Fish Crew Member'}, funx, nil, nil, true)
								if Entity.find({'Fish Crew Member'}, 1000, nil, true) then
									setQuset['Water Warrior'] -= 1
								end
								PositionSea += 100
							else
								local Boats = workspace.Boats
								_G["_POST"] = "Boats"
								if Boats:FindFirstChild("PirateBrigade") and tostring(Boats:FindFirstChild("PirateBrigade").Owner.Value) == tostring(Client.Name) then
									for _, v in pairs(workspace.Boats:GetDescendants()) do
										if v.Name == "PirateBrigade" and tostring(v.Owner.Value) == tostring(Client.Name) then
											if Client.Character.Humanoid.Sit == false then
												tp({Target = v.VehicleSeat.CFrame * CFrame.new(0, 5, 0)})
												if (v.VehicleSeat.CFrame.Position - Client.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 15 then
													RemoveAllClip()
												end
											else
												if (v.VehicleSeat.CFrame.Position - CFrame.new(-42170.15234375, 15, 4071.352294921875).Position).Magnitude > 8000 then
													tp({Target = CFrame.new(-42170.15234375, 15, 4071.352294921875)}, v.VehicleSeat)
												else
													if Entity.find({'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}, 1000, "Boat") then
														tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
														PositionSea = PositionSea + 225
													end
													if game:GetService("Lighting").RainCorrection.Enabled == true then
														tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
														PositionSea = PositionSea + 225
													end
												end
											end
										end
									end
								else
									tp({ Target = Terror_Shark[2]})
									if (Terror_Shark[2].Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										_C("BuyBoat", "PirateBrigade")
										wait(1.2)
									end
								end
							end
						else
							tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
							if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
								data = {}
								repeat task.wait()
									ClaimQuesDojotTrainer()
									local getGojoQuest2 = getGojoQuest()
									if type(getGojoQuest2) == 'table' then
										data = getGojoQuest2
									end
								until not _G.Settings[funx] or type(data) == 'table'
							end
						end
					end
				elseif data['QuestName'] == "Diplomacy" then
					if not GG then
						GG = true
						Notify(data['Description'], 1)
						delay(60*2, function()
							GG = false
						end)
					end
				elseif data['QuestName'] == "Beyond The Horizon" then
					if not setQuset['Beyond The Horizon'] then
						tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
						if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
							setQuset['Beyond The Horizon'] = data['Goal'] + 15
						end
					else
						local Terror_Shark = {
							[1] = CFrame.new(-18961.4277, 10.8767843, 821.362305, -0.292515308, 0.00162690994, 0.956259489, 0.0055617094, 0.999984562, 2.57972838e-10, -0.956244648, 0.00531843724, -0.292519808),
							[2] = CFrame.new(-16928.2617, 14.0881872, 435.386047, 0.0157553777, -5.09521803e-09, 0.999875903, 1.48630752e-08, 1, 4.86164797e-09, -0.999875903, 1.4784634e-08, 0.0157553777),
							[3] = false
						}
						if setQuset['Beyond The Horizon'] > 0 then
							local Boats = workspace.Boats
							_G["_POST"] = "Boats"
							if Boats:FindFirstChild("PirateBrigade") and tostring(Boats:FindFirstChild("PirateBrigade").Owner.Value) == tostring(Client.Name) then
								for _, v in pairs(workspace.Boats:GetDescendants()) do
									if v.Name == "PirateBrigade" and tostring(v.Owner.Value) == tostring(Client.Name) then
										if Client.Character.Humanoid.Sit == false then
											tp({Target = v.VehicleSeat.CFrame * CFrame.new(0, 5, 0)})
											if (v.VehicleSeat.CFrame.Position - Client.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 15 then
												RemoveAllClip()
											end
										else
											if (v.VehicleSeat.CFrame.Position - CFrame.new(-99999.15234375, 15, 4071.352294921875).Position).Magnitude > 8000 then
												tp({Target = CFrame.new(-99999.15234375, 15, 4071.352294921875)}, v.VehicleSeat)
											else
												if Entity.find({'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}, 1000, "Boat") then
													tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
													PositionSea = PositionSea + 225
												end
												if game:GetService("Lighting").RainCorrection.Enabled == true then
													tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
													PositionSea = PositionSea + 225
												end
												if tick() - DojoTick > 1 then
													DojoTick = tick()
													setQuset['Beyond The Horizon'] -= 1
												end
											end
										end
									end
								end
							else
								tp({ Target = Terror_Shark[2]})
								if (Terror_Shark[2].Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 10 then
									_C("BuyBoat", "PirateBrigade")
									wait(1.2)
								end
							end
						else
							tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
							if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
								data = {}
								repeat task.wait()
									ClaimQuesDojotTrainer()
									local getGojoQuest2 = getGojoQuest()
									if type(getGojoQuest2) == 'table' then
										data = getGojoQuest2
									end
								until not _G.Settings[funx] or type(data) == 'table'
							end
						end
					end
				elseif data['QuestName']:find('Saikeirei') then
					if not GG then
						GG = true
						Notify(data['Description'], 1)
						delay(60*2, function()
							GG = false
						end)
					end
				elseif data['QuestName']:find('Hanto') then
					if Entity.find({"Diablo","Deandre","Urban"}) and Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
						Entity.attack(
							{ "Diablo","Deandre","Urban" }
							,funx)
					else
						if not string.find(_C("EliteHunter"), "Come back later.") then
							if _G.Settings['Farm Level'] then 
								IsFarming = false 
								RemoveAllClip()
							end
						end 
						if Client.PlayerGui:FindFirstChild('TrackedQuestFrame') == false then
							_C("EliteHunter")
						end
					end
				elseif data['QuestName']:find('Teitoku') then
					if not setQuset['Teitoku'] then
						tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
						if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
							setQuset['Teitoku'] = data['Goal']
						end
					else
						local Terror_Shark = {
							[1] = CFrame.new(-18961.4277, 10.8767843, 821.362305, -0.292515308, 0.00162690994, 0.956259489, 0.0055617094, 0.999984562, 2.57972838e-10, -0.956244648, 0.00531843724, -0.292519808),
							[2] = CFrame.new(-16928.2617, 14.0881872, 435.386047, 0.0157553777, -5.09521803e-09, 0.999875903, 1.48630752e-08, 1, 4.86164797e-09, -0.999875903, 1.4784634e-08, 0.0157553777),
							[3] = false
						}
						if setQuset['Teitoku'] > 0 then
							if Entity.find({'Terrorshark'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Terrorshark'}, funx, nil, nil, true)
								if not Entity.find({'Terrorshark'}, 1000) then
									setQuset['Teitoku'] -= 1
								end
								PositionSea += 100
							elseif Entity.find({'SeaBeast1'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'SeaBeast1'}, funx, nil, nil, true)
								PositionSea += 100
							elseif Entity.find({'Shark'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Shark'}, funx, nil, nil, true)
								PositionSea += 100
							elseif Entity.find({'Piranha'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Piranha'}, funx, nil, nil, true)
								PositionSea += 100
							elseif  Entity.find({'Fish Crew Member'}, 1000) then
								_G["_POST"] = ""
								Entity.attack({'Fish Crew Member'}, funx, nil, nil, true)
								PositionSea += 100
							else
								local Boats = workspace.Boats
								_G["_POST"] = "Boats"
								if Boats:FindFirstChild("PirateBrigade") and tostring(Boats:FindFirstChild("PirateBrigade").Owner.Value) == tostring(Client.Name) then
									for _, v in pairs(workspace.Boats:GetDescendants()) do
										if v.Name == "PirateBrigade" and tostring(v.Owner.Value) == tostring(Client.Name) then
											if Client.Character.Humanoid.Sit == false then
												tp({Target = v.VehicleSeat.CFrame * CFrame.new(0, 5, 0)})
												if (v.VehicleSeat.CFrame.Position - Client.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 15 then
													RemoveAllClip()
												end
											else
												if (v.VehicleSeat.CFrame.Position - CFrame.new(-42170.15234375, 15, 4071.352294921875).Position).Magnitude > 8000 then
													tp({Target = CFrame.new(-42170.15234375, 15, 4071.352294921875)}, v.VehicleSeat)
												else
													if Entity.find({'PirateBrigade', 'PirateGrandBrigade', 'FishBoat'}, 1000, "Boat") then
														tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
														PositionSea = PositionSea + 225
													end
													if game:GetService("Lighting").RainCorrection.Enabled == true then
														tp({ Target = v.VehicleSeat.CFrame * CFrame.new(-150,0,15) }, v.VehicleSeat)
														PositionSea = PositionSea + 225
													end
												end
											end
										end
									end
								else
									tp({ Target = Terror_Shark[2]})
									if (Terror_Shark[2].Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										_C("BuyBoat", "PirateBrigade")
										wait(1.2)
									end
								end
							end
						else
							tp({ Target = CFrame.new(5868.453125, 1207.7763671875, 870.819580078125) })
							if dist(CFrame.new(5868.453125, 1207.7763671875, 870.819580078125)) < 10 then
								data = {}
								repeat task.wait()
									ClaimQuesDojotTrainer()
									local getGojoQuest2 = getGojoQuest()
									if type(getGojoQuest2) == 'table' then
										data = getGojoQuest2
									end
								until not _G.Settings[funx] or type(data) == 'table'
							end
						end
					end
				else
					if not GG then
						GG = true
						Notify(data['Description'], 10)
						delay(60*2, function()
							GG = false
						end)
					end
				end
			end
		end)
	end
end

VirtualInputManager = game:GetService("VirtualInputManager")
UseSkill = function(Skill)
	VirtualInputManager:SendKeyEvent(true,Skill,false,game)
	VirtualInputManager:SendKeyEvent(false,Skill,false,game)
end

CheckingQuestBlaze = function()
	local args = {
		[1] = {
			["Context"] = "Check"
		}
	}
	local Remote
	pcall(function()
		Remote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(args))
	end)
	if not Remote then
		return nil
	end
	if Remote["Text"] ~= nil then
		return Remote["Text"]
	else
		return false
	end
end

TryQuestBlaze = function()
	local args = {
		[1] = {
			["Context"] = "RequestQuest"
		}
	}

	local Success, Error = pcall(function()
		game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(args))
	end)


	return Success
end

loadFun['Auto Blaze Ember'] = function()
	local funx = 'Auto Blaze Ember'
	local HasQuest = false
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			if not HasQuest then
				tp({Target = CFrame.new(5866.52294921875, 1209.7017822265625, 812.3942260742188)})
				if dist(CFrame.new(5866.52294921875, 1209.7017822265625, 812.3942260742188)) < 5 then
					local QuestBlaze = CheckingQuestBlaze()
					if not QuestBlaze then
						TryQuestBlaze()
					else
						HasQuest = QuestBlaze
					end
				end
			else
				local Path =  workspace:FindFirstChild("EmberTemplate")
				if Path then	
					for _=1,3 do
						game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/DragonDojoEmber"):FireServer()
					end
					HasQuest = false
					Path.Name = "Ready Keep"
				end
				if string.find(HasQuest , "trees") then
					for i,v in pairs(workspace.Map.Waterfall.IslandModel:GetChildren()) do
						if workspace:FindFirstChild("EmberTemplate") then
							if dist(workspace:FindFirstChild("EmberTemplate").Part.CFrame) < 1000 then
								break
							end
						end
						if v.Name == "Tree" then
							repeat
								if workspace:FindFirstChild("EmberTemplate") then
									if dist(workspace:FindFirstChild("EmberTemplate").Part.CFrame) < 1000 then
										break
									end
								end
								task.wait()
								tp({Target = CFrame.new(5179.01025390625, 1004.2967529296875, 273.8126220703125)})
								EquipToolsType("Melee")
								UseSkill("X")
								UseSkill("C")
							until not v or not  _G.Settings[funx] 
						end
					end
				elseif string.find(HasQuest , "Hydra Enforcer") then
					if Entity.find({"Hydra Enforcer"}) then
						Entity.attack({"Hydra Enforcer"}, funx, nil, {Func = function()
							if workspace:FindFirstChild("EmberTemplate") then
								if dist(workspace:FindFirstChild("EmberTemplate").Part.CFrame) < 1000 then
									return true
								end
							end
							if not HasQuest then
								return true
							end

							return false
						end})
					else
						if tick() - LastTospawn >= .3 then
							loadFun['To Spawn']("Hydra Enforce")
							LastTospawn = tick()
						end
					end
				elseif string.find(HasQuest , "Venomous Assailant") then
					if Entity.find({"Venomous Assailant"}) then
						Entity.attack({"Venomous Assailant"}, funx, nil, {Func = function()
							if workspace:FindFirstChild("EmberTemplate") then
								if dist(workspace:FindFirstChild("EmberTemplate").Part.CFrame) < 1000 then
									return true
								end
							end

							if not HasQuest then
								return true
							end

							return false
						end})
					else
						if tick() - LastTospawn >= .3 then
							loadFun['To Spawn']("Venomous Assailant")
							LastTospawn = tick()
						end
					end
				end
			end
		end)
	end
end

loadFun['Auto Berries'] = function()
	local funx = 'Auto Berries'
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			for i,PathBerries in pairs(CollectionService:GetTagged("BerryBush")) do
				local FindBerry = PathBerries.Parent
				if  PathBerries:GetAttribute("_BerryCFrame1") or PathBerries:GetAttribute("_BerryCFrame2") or PathBerries:GetAttribute("_BerryCFrame3") or PathBerries:GetAttribute("_BerryCFrame4") or PathBerries:GetAttribute("_BerryCFrame5") or PathBerries:GetAttribute("_BerryCFrame6") or PathBerries:GetAttribute("_BerryCFrame7") or PathBerries:GetAttribute("_BerryCFrame8")  then
					repeat
						if #PathBerries:GetChildren() > 0 then
							for i,v in pairs(PathBerries:GetChildren()) do
								tp({Target = v:GetPivot()})
								fireproximityprompt(v.ProximityPrompt)
							end
						else
							tp({Target = FindBerry:GetPivot()})
						end
						task.wait()
					until not  _G.Settings[funx] or  not PathBerries:GetAttribute("_BerryCFrame1") and not PathBerries:GetAttribute("_BerryCFrame2") and not PathBerries:GetAttribute("_BerryCFrame3") and not PathBerries:GetAttribute("_BerryCFrame4") and not PathBerries:GetAttribute("_BerryCFrame5") and not PathBerries:GetAttribute("_BerryCFrame6") and not PathBerries:GetAttribute("_BerryCFrame7") and not PathBerries:GetAttribute("_BerryCFrame8")
				end
			end
		end)
	end
end

loadFun['Auto Relic Events'] = function()
	local funx = 'Auto Relic Events'
	local GetRock = function()
		for i,v in pairs(workspace.Map.PrehistoricIsland.Core.VolcanoRocks:GetChildren()) do
			if v.Name == 'Rock' and v:FindFirstChild('VFXLayer') and v:FindFirstChild('VFXLayer'):FindFirstChild('At1Beam') and v:FindFirstChild('VFXLayer'):FindFirstChild('At1Beam').Enabled == true then
				return v.VFXLayer
			end
		end
		return nil
	end
	while _G.Settings[funx] and task.wait() do
		loadFun['getPcall'](funx, function()
			local Terror_Shark = {
				[1] = CFrame.new(-18961.4277, 10.8767843, 821.362305, -0.292515308, 0.00162690994, 0.956259489, 0.0055617094, 0.999984562, 2.57972838e-10, -0.956244648, 0.00531843724, -0.292519808),
				[2] = CFrame.new(-16928.2617, 14.0881872, 435.386047, 0.0157553777, -5.09521803e-09, 0.999875903, 1.48630752e-08, 1, 4.86164797e-09, -0.999875903, 1.4784634e-08, 0.0157553777),
				[3] = false
			}
			if game.Workspace.Map:FindFirstChild('PrehistoricIsland') and not ( _G.Settings['Auto Collect Dragon Bones'] and game.Workspace:FindFirstChild("DinoBone")) and not (_G.Settings['Auto Collect Dragon Eggs'] and workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChildOfClass("Model")) then
				_G["_POST"]  = ''
				for _,target in pairs(workspace.Enemies:GetChildren()) do
					if target and target:FindFirstChild('HumanoidRootPart') and dist(target.HumanoidRootPart.Position) <= 5000 then
						if Entity.find({target.Name}) then
							Entity.attack({target.Name}, funx)
						end
					else
						if workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava") then
							workspace.Map.PrehistoricIsland.Core:FindFirstChild("InteriorLava"):Destroy()
						end
						if Client.PlayerGui.Main.TopHUDList.RaidTimer.Visible == false then
							if workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") then
								tp({ Target = workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame })
								if dist(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame) <= 10 then
									fireproximityprompt(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.ProximityPrompt)
								end
							else
								if workspace.Map.PrehistoricIsland.Core:FindFirstChild('RockLandingZone') then
									tp({ Target = workspace.Map.PrehistoricIsland.Core.RockLandingZone.CFrame  * CFrame.new( 0, 30, 0) })
								else
									tp({ Target = workspace.Map.PrehistoricIsland:GetPivot() * CFrame.new( -70, 0, 50) })
								end
							end
						else
							if GetRock() ~= nil then
								tp({ Target = GetRock().CFrame * CFrame.new( 0, 0, 20) })
								if dist(GetRock().CFrame) <= 70 then
									EquipTools(_G.Select_Weapon)
									for i,skill in {"Z","X","C","V"} do 
										LockAim = true
										LockPosition = GetRock().Position
										UseSkill(tostring(skill)) 
									end
								end
							else
								if workspace.Map.PrehistoricIsland.Core:FindFirstChild('RockLandingZone') then
									tp({ Target = workspace.Map.PrehistoricIsland.Core.RockLandingZone.CFrame  * CFrame.new( 0, 30, 0) })
								else
									tp({ Target = workspace.Map.PrehistoricIsland:GetPivot() * CFrame.new( -70, 0, 50) })
								end
							end
						end
					end
				end
			elseif _G.Settings['Auto Collect Dragon Bones'] and game.Workspace:FindFirstChild("DinoBone") then
				tp({ Target = game.Workspace:FindFirstChild("DinoBone").CFrame })
			elseif _G.Settings['Auto Collect Dragon Eggs'] and game.Workspace.Map:FindFirstChild('PrehistoricIsland') and workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChildOfClass("Model") then
				tp({ Target = workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChildOfClass("Model"):GetPivot() })
				for i,v in pairs(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:GetDescendants()) do
					if v.Name == 'ProximityPrompt' then
						fireproximityprompt(v)
					end
				end
			else
				local Boats = workspace.Boats
				_G["_POST"] = "Boats"
				if Boats:FindFirstChild("PirateBrigade") and tostring(Boats:FindFirstChild("PirateBrigade").Owner.Value) == tostring(Client.Name) then
					for _, v in pairs(workspace.Boats:GetDescendants()) do
						if v.Name == "PirateBrigade" and tostring(v.Owner.Value) == tostring(Client.Name) then
							if Client.Character.Humanoid.Sit == false then
								tp({Target = v.VehicleSeat.CFrame * CFrame.new(0, -1, 0)})
								if (v.VehicleSeat.CFrame.Position - Client.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 15 then
									RemoveAllClip()
								end
							else
								if (v.VehicleSeat.CFrame.Position - CFrame.new(-9999999999999.3828, 8.99999714, 96592.1328, -0.996820271, -4.0539166e-07, 0.0796831176, -4.06684819e-07, 1, -2.5351118e-15, -0.0796831176, -3.24059179e-08, -0.996820271).Position).Magnitude > 3000 + PositionSea then
									tp2({Target = CFrame.new(-9999999999999.3828, 8.99999714, 96592.1328, -0.996820271, -4.0539166e-07, 0.0796831176, -4.06684819e-07, 1, -2.5351118e-15, -0.0796831176, -3.24059179e-08, -0.996820271)}, v.VehicleSeat)
								end
							end
							if Client.Character.Humanoid.Health <= 0 then
								v:Destroy()
							end
						end
					end
				else
					tp({ Target = Terror_Shark[2]})
					if (Terror_Shark[2].Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("BuyBoat", "PirateBrigade")
						wait(1.2)
					end
				end
			end
		end)
	end
end 

loadFun['Auto Enemies Aura'] = function()
	local funx = 'Auto Enemies Aura'
	while _G.Settings['Auto Enemies Aura'] and task.wait() do
		loadFun['getPcall'](funx, function()
			for _, target in pairs(workspace.Enemies:GetChildren()) do
				if target and target:FindFirstChild('HumanoidRootPart') then
					if dist(target.HumanoidRootPart.Position) <= tonumber(_G.Settings['Enemies Aura']) then
						Entity.attack({target.Name}, funx)
					end
				end
			end
		end)
	end
end

getMeleeNow = function(d)
	return _C("Buy"..d, true) == 1 --[[
			Superhuman, DeathStep or BlackLeg, SharkmanKarate or FishmanKarate, ElectricClaw or Electro, DragonTalon, Godhuman
		]]
end

function toServerFruit2(Text)
	local Slice = Text:split("-")  
	return Slice[1]
end

FindFruit = 0
local checkMelee2 = {
	DeathStep = {Level = 0},
	SharkmanKarate = {Level = 0},
	ElectricClaw = {Level = 0},
	Superhuman = {Level = 0},
	DragonTalon = {Level = 0},
}

RaidMicroship = table.clone(require(ReplicatedStorage.Raids).raids)
loadFun['Fully Do'] = function()
	local Funx = 'Fully Do'
	while _G.Settings[Funx] and task.wait() do
		loadFun['getPcall'](Funx, function()
			local GetWeapons = _G.Settings['Select Type Fighting style']
			if GetWeapons == "Super Human" then
				if _C("BuySuperhuman", true) ~= (1 or "1") and Client.Character:FindFirstChild("HumanoidRootPart") then
					-- [[ Farm BlackLeg > 300 ]] --
					if _hasItem("Combat") and Client.Data.Beli.Value > 150000 then
						_C("BuyBlackLeg")
					end
					-- [[ Farm Electro > 300 ]] --
					if _hasItem("Black Leg") and _hasItem("Black Leg").Level.Value >= 300 then
						_C("BuyElectro")
					end
					-- [[ Farm Fishman Karate > 300 ]] --
					if _hasItem("Electro") and _hasItem("Electro").Level.Value >= 300 then
						_C("BuyFishmanKarate")
					end
					-- [[ Farm Dragon Talon > 300 ]] --
					if _hasItem("Fishman Karate") and _hasItem("Fishman Karate").Level.Value >= 300 then
						local m,f = Client.Data.Level.Value,Client.Data.Fragments.Value
						if m > 1099 then
							if f >= 1500 then
								_C("BlackbeardReward","DragonClaw","1")
								_C("BlackbeardReward","DragonClaw","2")
							else
								if not IsRaiding() then
									for i, child in pairs(Client.Backpack:GetChildren() or Client.Character:GetChildren()) do
										if child:IsA("Tool") and child:FindFirstChild("Fruit")  then
											local Name = tostring(toServerFruit2(Client.Data.DevilFruit.Value))
											if Name == "" or not table.find(RaidMicroship, Name) then
												Name = "Flame"
											end
											_C("RaidsNpc", "Select", Name)
											task.wait(1)
										else
											FindFruit = FindFruit + 1
											if FindFruit > 1 then
												FindFruit = 0
												for i = 1,5 do wait(1)
													_G.LoadFruit = true
												end
												local FrintStocks = FruitCheckOnStock(5000,500000)
												for _, y in pairs(FrintStocks["FruitPrice"]) do
													for _, z in pairs(FrintStocks["FruitStore"]) do
														if y == z and _G.LoadFruit == true and not Client.Backpack:FindFirstChild("Special Microchip") and Client.Character:FindFirstChild("Humanoid").Health > 0 and not IsRaiding() then
															_C("LoadFruit", tostring(y))
														end
													end
												end
											end
										end
									end
									if Client.Backpack:FindFirstChild("Special Microchip") then
										repeat task.wait()
											if Sea2 then
												tp({ Target = workspace.Map.CircleIsland.RaidSummon:GetPivot() })
												fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
											end
											if Sea3 then
												tp({ Target = game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2:GetPivot() })
												fireclickdetector(game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button.Main:FindFirstChild("ClickDetector"))
											end
										until not _G.Settings[Funx] or IsRaiding()
										_G.LoadFruit = false
									end
								else
									if _G.LoadFruit then _G.LoadFruit = false end
									local maxIslandNum = 0
									local maxIslandPosition = nil
									for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
										local islandNum = tonumber(string.match(v.Name, "%d+"))
										if islandNum and islandNum > maxIslandNum then
											local distance = dist(v.Position, Client.Character.HumanoidRootPart.Position)
											if distance < 8500 then
												maxIslandNum = islandNum
												maxIslandPosition = v.CFrame * CFrame.new(0,50,100)
											end
										end
									end
									for _,target in pairs(workspace.Enemies:GetChildren()) do
										if target and target:FindFirstChild('HumanoidRootPart') and dist(target.HumanoidRootPart.Position) <= 8500 then
											if Entity.find({target.Name}) then
												Entity.attack({target.Name}, Funx)
											end
										else
											if maxIslandPosition then
												tp({Target = maxIslandPosition})
											end
										end
									end
								end
								--print(_G.LoadFruit ,  IsRaiding())
							end
						end
					end
					_C("Awakener","Teleport")
					_C("BuySuperhuman")
				end
			elseif GetWeapons == "Sharkman Karate" then
				if not Client.Backpack:FindFirstChild("Fishman Karate") or not Client.Character:FindFirstChild("Fishman Karate") then
					_C("BuyFishmanKarate")
				end		
				if string.find(_C("BuySharkmanKarate"), "keys") then  
					if Client.Character:FindFirstChild("Water Key") or Client.Backpack:FindFirstChild("Water Key") then
						tp({ Target = CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365) })
						if (CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 then
							wait(1.2)
							_C("BuySharkmanKarate",true)
							_C("BuySharkmanKarate")
							wait(0.5)
						end
					elseif Client.Backpack:FindFirstChild("Fishman Karate") and Client.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 400 or Client.Backpack:FindFirstChild("Fishman Karate") and Client.Backpack:FindFirstChild("Fishman Karate").Level.Value >= 400 then
						if Entity.find({"Tide Keeper"}) then
							Entity.attack({"Tide Keeper"}, Funx)
						else
							HopServer()
						end
					end
				else 
					_C("BuySharkmanKarate")
				end
			elseif GetWeapons == "Electric Claw" then
				if not _hasItem("Electric Claw") then
					IsFarming = false
					_G.Settings['Select Type Fighting style'] = nil
				end
				local electro = _hasItem("Electro")
				local electricClaw = _hasItem("Electric Claw")
				if electricClaw or electro then
					if electro and electro.Level.Value >= 400 then
						_C("BuyElectricClaw")
					end
				else
					_C("BuyElectro")
				end
				if electro and electro.Level.Value >= 400 then
					local tpLocations = {
						CFrame.new(-10371.4717, 330.764496, -10131.4199),
						CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438),
						CFrame.new(-10371.4717, 330.764496, -10131.4199)
					}

					for _, location in ipairs(tpLocations) do
						repeat task.wait(0.2)
							tp({ Target = location })
						until not _G.Settings[Funx] or (Client.Character.HumanoidRootPart.Position - location.Position).Magnitude <= 10
						wait(1)
					end
					_C("BuyElectricClaw")
				end
			elseif GetWeapons == "Death Step" then
				if not _hasItem("Black Leg") then
					_C("BuyBlackLeg")
				end
				if game:GetService("Workspace").Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then  
					if Client.Character:FindFirstChild("Library Key") or Client.Backpack:FindFirstChild("Library Key") then
						EquipTools("Library Key")
						tp({ Target = CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) })
						if (CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 then
							wait(1.2)
							_C("BuyDeathStep",true)
							_C("BuyDeathStep")
							wait(0.5)
						end
					elseif _hasItem("Black Leg") and _hasItem("Black Leg").Level.Value >= 300  then   
						if Entity.find({"Awakened Ice Admiral"}) then
							Entity.attack({"Awakened Ice Admiral"}, Funx)
						else
							HopServer()
						end
					end
				else 
					_C("BuyDeathStep")
				end
			elseif GetWeapons == "Dragon Talon" then
				if _hasItem("Dragon Claw") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw") or _hasItem("Dragon Talon") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Talon") then
					if _hasItem("Dragon Claw") and _hasItem("Dragon Claw").Level.Value >= 400 then
						_C("BuyDragonTalon")
					end  
					if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Dragon Claw").Level.Value >= 400 then
						_C("BuyDragonTalon")
					end  
				else 
					_C("BlackbeardReward","DragonClaw","2")
				end
			elseif GetWeapons == "Godhuman" then
				if getMeleeNow('Superhuman') and not getMeleeNow('Godhuman') then
					if not getMeleeNow('DeathStep') then
						if IsFarming then
							IsFarming = false
						end
						if not Sea2 then
							toSea(2)
						end
						if _hasItem("Black Leg") and _hasItem("Death Step") then
							_C("BuyBlackLeg")
						end
						if game:GetService("Workspace").Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then  
							if _hasItem("Library Key") then
								EquipTools("Library Key")
								tp({ Target = CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) })
								if (CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 then
									wait(1.2)
									_C("BuyDeathStep",true)
									_C("BuyDeathStep")
									wait(0.5)
								end
							elseif _hasItem("Black Leg") and _hasItem("Black Leg").Level.Value >= 400 then
								if (CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
									if Entity.find({"Awakened Ice Admiral"}) then
										Entity.attack({"Awakened Ice Admiral"}, Funx)
									else
										HopServer()
									end
								else
									tp({ Target = CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) })
								end
							else
								if (CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
									if Entity.find({"Arctic Warrior","Snow Lurker"}) then
										Entity.attack({"Arctic Warrior","Snow Lurker"}, Funx)
									end
								else
									tp({ Target = CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) })
								end
							end
						else 
							_C("BuyDeathStep")
						end
					elseif getMeleeNow('DeathStep') and checkMelee2.DeathStep.Level < 400 then
						if not _hasItem("Death Step") then
							_C("BuyDeathStep")
						end
						if _hasItem("Death Step") and _hasItem("Death Step").Level.Value >= 400 then
							checkMelee2.DeathStep.Level = 400
						else
							if not IsFarming then
								IsFarming = true
							end
						end
					elseif not getMeleeNow('SharkmanKarate') then
						if IsFarming then
							IsFarming = false
						end
						if not Sea2 then
							toSea(2)
						end
						if not Client.Backpack:FindFirstChild("Fishman Karate") or not Client.Character:FindFirstChild("Fishman Karate") then
							_C("BuyFishmanKarate")
						end		

						if string.find(_C("BuySharkmanKarate"), "keys") then  
							if _hasItem('Water Key') then
								tp({ Target = CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365) })
								if (CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 3 then
									wait(1.2)
									_C("BuySharkmanKarate",true)
									_C("BuySharkmanKarate")
									wait(0.5)
								end
							elseif _hasItem("Fishman Karate") and _hasItem("Fishman Karate").Level.Value >= 400 then
								if Entity.find({"Tide Keeper"}) then
									Entity.attack({"Tide Keeper"}, Funx)
								else
									HopServer()
								end
							else
								if (CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
									if Entity.find({"Arctic Warrior","Snow Lurker"}) then
										Entity.attack({"Arctic Warrior","Snow Lurker"}, "Auto Find Rengoku")
									end
								else
									tp({ Target = CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) })
								end
							end
						else 
							_C("BuySharkmanKarate")
						end
					elseif getMeleeNow('SharkmanKarate') and checkMelee2.SharkmanKarate.Level < 400 then
						if not _hasItem("Sharkman Karate") then
							_C("BuySharkmanKarate")
						end
						if _hasItem("Sharkman Karate") and _hasItem("Sharkman Karate").Level.Value >= 400 then
							checkMelee2.SharkmanKarate.Level = 400
						else
							if not IsFarming then
								IsFarming = true
							end
						end
					elseif not getMeleeNow('ElectricClaw') then
						if IsFarming then
							IsFarming = false
						end
						if not Sea3 then
							toSea(3)
						end
						local electro = _hasItem("Electro")
						local electricClaw = _hasItem("Electric Claw")
						if electricClaw or electro then
							if electro and electro.Level.Value >= 400 then
								_C("BuyElectricClaw")
							end
						else
							_C("BuyElectro")
						end
						if electro and electro.Level.Value >= 400 then
							local tpLocations = {
								CFrame.new(-10371.4717, 330.764496, -10131.4199),
								CFrame.new(-12550.532226563, 336.22631835938, -7510.4233398438),
								CFrame.new(-10371.4717, 330.764496, -10131.4199)
							}

							for _, location in ipairs(tpLocations) do
								repeat task.wait(0.2)
									tp({ Target = location })
								until not _G.Settings[Funx] or (Client.Character.HumanoidRootPart.Position - location.Position).Magnitude <= 10
								wait(1)
							end
							_C("BuyElectricClaw")
						end
					elseif getMeleeNow('ElectricClaw') and checkMelee2.ElectricClaw.Level < 400 then
						if not _hasItem("Electric Claw") then
							_C("BuyElectricClaw")
						end
						if _hasItem("Electric Claw") and _hasItem("Electric Claw").Level.Value >= 400 then
							checkMelee2.ElectricClaw.Level = 400
						else
							if not IsFarming then
								IsFarming = true
							end
						end
					elseif getMeleeNow('Superhuman') and checkMelee2.Superhuman.Level < 400 then
						if not _hasItem("Superhuman") then
							_C("BuySuperhuman")
						end
						if _hasItem("Superhuman") and _hasItem("Superhuman").Level.Value >= 400 then
							checkMelee2.Superhuman.Level = 400
						else
							if not IsFarming then
								IsFarming = true
							end
						end
					elseif  not getMeleeNow('DragonTalon') then
						if IsFarming then
							IsFarming = false
						end
						if not Sea3 then
							toSea(3)
						end
						if _hasItem("Dragon Claw") or _hasItem("Dragon Talon") then
							if _hasItem("Dragon Claw") and _hasItem("Dragon Claw").Level.Value >= 400 and _hasItem("Fire Essence") then
								_C("BuyDragonTalon",1)
								_C("BuyDragonTalon")
							else
								local enemyNames = {
									'Reborn Skeleton',
									'Living Zombie',
									'Demonic Soul',
									'Posessed Mummy'
								}
								_C("Bones","Buy",1,1)
								if Entity.find(enemyNames) then
									Entity.attack(enemyNames, Funx)
								else
									loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
								end
							end  
						else 
							_C("BlackbeardReward","DragonClaw","1")
							_C("BlackbeardReward","DragonClaw","2")
						end
					elseif getMeleeNow('DragonTalon') and checkMelee2.DragonTalon.Level < 400 then
						if not _hasItem("Dragon Talon") then
							_C("BuyDragonTalon")
						end
						if _hasItem("Dragon Talon") and _hasItem("Dragon Talon").Level.Value >= 400 then
							checkMelee2.DragonTalon.Level = 400
						else
							if not IsFarming then
								IsFarming = true
							end
						end
					else
						if IsFarming then
							IsFarming = false
						end
						if CheckMaterialCount('Dragon Scale') < 10 then
							local enemyNames
							if Sea3 then
								enemyNames = allMaterials[3]['Dragon Scale']
							end
							if not Sea3 then
								toSea(3)
							end
							if Entity.find(enemyNames) then
								Entity.attack(enemyNames, Funx)
							else
								loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
							end
						elseif CheckMaterialCount('Fish Tail') < 20 then
							local enemyNames
							if Sea1 then
								enemyNames = allMaterials[1]['Fish Tail']
							elseif Sea3 then
								enemyNames = allMaterials[3]['Fish Tail']
							end
							if Sea2 then
								toSea(3)
							end
							if enemyNames then
								if Entity.find(enemyNames) then
									Entity.attack(enemyNames, Funx)
								else
									loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
								end
							end
						elseif CheckMaterialCount('Mystic Droplet') < 10 then
							local enemyNames
							if Sea2 then
								enemyNames = allMaterials[2]['Mystic Droplet']
							end
							if not Sea2 then
								toSea(2)
							end

							if enemyNames then
								if Entity.find(enemyNames) then
									Entity.attack(enemyNames, Funx)
								else
									loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
								end
							end
						elseif CheckMaterialCount('Magma Ore') < 20 then
							local enemyNames
							if Sea1 then
								enemyNames = allMaterials[1]['Magma Ore']
							elseif Sea2 then
								enemyNames = allMaterials[2]['Magma Ore']
							end
							if Sea3 then
								toSea(2)
							end
							if enemyNames then
								if Entity.find(enemyNames) then
									Entity.attack(enemyNames, Funx)
								else
									loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])
								end
							end
						else
							if not Sea3 then
								toSea(3)
							end
							_C("BuyGodhuman")
							_G.Settings['Select Type Fighting style'] = nil
							SaveSettings()
							return
						end
					end
				elseif not getMeleeNow('Superhuman') then
					if _C("BuySuperhuman", true) ~= (1 or "1") and Client.Character:FindFirstChild("HumanoidRootPart") then
						-- [[ Farm BlackLeg > 300 ]] --
						if _hasItem("Combat") and Client.Data.Beli.Value > 150000 then
							_C("BuyBlackLeg")
						end
						-- [[ Farm Electro > 300 ]] --
						if _hasItem("Black Leg") and _hasItem("Black Leg").Level.Value >= 300 then
							_C("BuyElectro")
						end
						-- [[ Farm Fishman Karate > 300 ]] --
						if _hasItem("Electro") and _hasItem("Electro").Level.Value >= 300 then
							_C("BuyFishmanKarate")
						end
						-- [[ Farm Dragon Talon > 300 ]] --
						if _hasItem("Fishman Karate") and _hasItem("Fishman Karate").Level.Value >= 300 then
							local m,f = Client.Data.Level.Value,Client.Data.Fragments.Value
							if m > 1099 then
								if f >= 1500 then
									_C("BlackbeardReward","DragonClaw","1")
									_C("BlackbeardReward","DragonClaw","2")
								else
									if not IsRaiding() then
										for i, child in pairs(Client.Backpack:GetChildren() or Client.Character:GetChildren()) do
											if child:IsA("Tool") and child:FindFirstChild("Fruit")  then
												local Name = tostring(toServerFruit2(Client.Data.DevilFruit.Value))
												if Name == "" or not table.find(RaidMicroship, Name) then
													Name = "Flame"
												end
												_C("RaidsNpc", "Select", Name)
												task.wait(1)
											else
												FindFruit = FindFruit + 1
												if FindFruit > 1 then
													FindFruit = 0
													for i = 1,5 do wait(1)
														_G.LoadFruit = true
													end
													local FrintStocks = FruitCheckOnStock(5000,500000)
													for _, y in pairs(FrintStocks["FruitPrice"]) do
														for _, z in pairs(FrintStocks["FruitStore"]) do
															if y == z and _G.LoadFruit == true and not Client.Backpack:FindFirstChild("Special Microchip") and Client.Character:FindFirstChild("Humanoid").Health > 0 and not IsRaiding() then
																_C("LoadFruit", tostring(y))
															end
														end
													end
												end
											end
										end
										if Client.Backpack:FindFirstChild("Special Microchip") then
											repeat task.wait()
												if Sea2 then
													tp({ Target = workspace.Map.CircleIsland.RaidSummon:GetPivot() })
													fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
												end
												if Sea3 then
													tp({ Target = game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2:GetPivot() })
													fireclickdetector(game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button.Main:FindFirstChild("ClickDetector"))
												end
											until not _G.Settings[Funx] or IsRaiding()
											_G.LoadFruit = false
										end
									else
										if _G.LoadFruit then _G.LoadFruit = false end
										local maxIslandNum = 0
										local maxIslandPosition = nil
										for _, v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
											local islandNum = tonumber(string.match(v.Name, "%d+"))
											if islandNum and islandNum > maxIslandNum then
												local distance = dist(v.Position, Client.Character.HumanoidRootPart.Position)
												if distance < 8500 then
													maxIslandNum = islandNum
													maxIslandPosition = v.CFrame * CFrame.new(0,50,100)
												end
											end
										end
										for _,target in pairs(workspace.Enemies:GetChildren()) do
											if target and dist(target.HumanoidRootPart.Position) <= 8500 then
												if Entity.find({target.Name}) then
													Entity.attack({target.Name}, Funx)
												else
													if maxIslandPosition then
														tp({Target = maxIslandPosition})
													end
												end
											end
										end
									end
									--print(_G.LoadFruit ,  IsRaiding())
								end
							end
						end
						_C("Awakener","Teleport")
						_C("BuySuperhuman")
					end
				end
			end	
		end)
		
	end
end

loadFun['goto_Kitsune_Island'] = function()
	local Funx = 'goto_Kitsune_Island'
	while _G.Settings[Funx] and task.wait() do
		loadFun['getPcall'](Funx, function()
			for _i,_v in pairs(workspace.Map.KitsuneIsland:GetChildren()) do
				if _v:IsA("Part") then
					tp({ Target = _v.CFrame })
					break
				end
			end
		end)
	end
end

loadFun['Teleport_EmberTemplate'] = function()
	local Funx = 'Teleport_EmberTemplate'
	while _G.Settings[Funx] and task.wait() do
		loadFun['getPcall'](Funx, function()
			local ToggleValue = _G.Settings[Funx]
			if workspace.Map:FindFirstChild("KitsuneIsland") and workspace:FindFirstChild("EmberTemplate") then
				for _i,_v in pairs(workspace:GetChildren()) do
					if _v.Name == "EmberTemplate" then
						repeat wait()
							ToggleValue = _G.Settings[Funx]
							Client.Character.HumanoidRootPart.CFrame = _v.Part.CFrame
						until not ToggleValue or not _v.Parent or (_v.Part.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 1
					end
				end
			else
				if not workspace:FindFirstChild("EmberTemplate") and workspace.Map:FindFirstChild('KitsuneIsland') then
					for _i,_v in pairs(workspace.Map.KitsuneIsland:GetChildren()) do
						if _v:IsA("Part") then
							tp({ Target = _v.CFrame })
							break
						end
					end
				end
			end
		end)
	end
end

Mastery = function(Weapon_Name)
	for i,v in pairs(getInventory()) do
		if v.Name == Weapon_Name then
			return v.Mastery
		end
	end
end

getCurrentQuest = function(Trial)
	Trial = Trial or "Evil"
	if Client.Character and Client.Character.Humanoid and Client.Character.Humanoid.Health > 0 then
		return _C("CDKQuest","Progress")[Trial]
	end
	return nil
end

EnemiesAura = function(Value,Expression)
	local _Settings = _G.Settings[Expression] or nil
	while _G.Settings[Expression] do task.wait()
		local Success,Error = pcall(function()
			for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
				if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position-LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= tonumber(Value) then
					if Entity.find({V.Name}) then
						Entity.attack({v.Name}, Expression)
					end
				end
			end
		end)
		if not Success then print(Error) end
	end
end

local function round(n)
	return math.floor(tonumber(n) + 0.5)
end

function ESP_Kitsune_Island()
	pcall(function()
		if _G.Settings.ESP_Kitsune_Island then
			for _i,_v in pairs(workspace.Map.KitsuneIsland:GetChildren()) do
				if _v:IsA("Part") then
					if not _v:FindFirstChild('Esp_Kitsune_Island') then
						local bill = Instance.new('BillboardGui',_v)
						bill.Name = 'Esp_Kitsune_Island'
						bill.ExtentsOffset = Vector3.new(0, 1, 0)
						bill.Size = UDim2.new(1,200,1,30)
						bill.Adornee = _v
						bill.AlwaysOnTop = true
						local name = Instance.new('TextLabel',bill)
						name.Font = "GothamBold"
						name.FontSize = "Size14"
						name.TextWrapped = true
						name.Size = UDim2.new(1,0,1,0)
						name.TextYAlignment = 'Top'
						name.BackgroundTransparency = 1
						name.TextStrokeTransparency = 0.5
						name.TextColor3 = Color3.fromRGB(28, 255, 255)
						name.Text = ("Kitsune Island" ..' \n'.." [ "..round((game:GetService('Players').LocalPlayer.Character.Head.Position - _v.Position).Magnitude/3) ..' M'.." ] ")
					else
						_v.Esp_Kitsune_Island.TextLabel.Text = ("Kitsune Island" ..' \n'.." [ "..round((game:GetService('Players').LocalPlayer.Character.Head.Position - _v.Position).Magnitude/3) ..' M'.." ] ")
						_v.Esp_Kitsune_Island.TextLabel.TextColor3 = Color3.fromRGB(28, 255, 255)
					end
					break
				end
			end
		else
			for _i,_v in pairs(workspace.Map.KitsuneIsland:GetChildren()) do
				if _v:IsA("Part") then
					if _v:FindFirstChild('Esp_Kitsune_Island') then
						_v:FindFirstChild('Esp_Kitsune_Island'):Destroy()
					end
					break
				end
			end
		end
	end)
end

loadFun['ESP_Kitsune_Island'] = function()
	local Expression = "ESP_Kitsune_Island"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			ESP_Kitsune_Island()
		end)
	end
	if not _G.Settings[Expression] then
		ESP_Kitsune_Island()
	end
end

loadFun['Auto_Castle_Raid'] = function()
	local Expression = "Auto_Castle_Raid"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local posMid = CFrame.new(-5542.39941, 365.312164, -2953.25317, 0.927571476, -6.73325431e-08, -0.373645753, 6.74327651e-08, 1, -1.28031159e-08, 0.373645753, -1.33201619e-08, 0.927571476)
			if dist(posMid.Position) > 4000 then
				tp(posMid)
			else
				for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
					if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position- Client.Character.HumanoidRootPart.Position).magnitude <= 5000 then
						if Entity.find({v.Name}) then
							Entity.attack({v.Name}, Expression)
						else
							tp(posMid)
						end
					end
				end
			end
		end)
	end
end

loadFun['Auto_Farm_All_Sword'] = function()
	local Expression = "Auto_Farm_All_Sword"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			_G.Settings.SelectWeapon = "Sword"
			for i,v in next, getInventory() do
				if tonumber(v.Mastery) >= 1 and tonumber(v.Mastery) < 600 then
					if _hasItem(v.Name) then
						if Sea3 then
							if Entity.find({"Cake Prince","Dough King"}) then
								Entity.attack({
									"Cake Prince",
									"Dough King"
								}, Expression)
							else
								local enemyNames = {
									"Baking Staff",
									"Head Baker",
									"Cake Guard",
									"Cookie Crafter"
								}
								if Entity.find( enemyNames ) then
									Entity.attack( enemyNames, Expression)
								else
									if tick() - LastTospawn > 0.3 then
										loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
										LastTospawn = tick()
									end
								end
							end
						else
							local GetQuestData = GetQuestData()
							if not Client.PlayerGui:FindFirstChild('TrackedQuestFrame') then
								tp({ Target = GetQuestData['NPCPosition']  * CFrame.new( 0, 0, 5)  })
								if dist(GetQuestData['NPCPosition']) <= 15 then
									task.wait(.5)
									_C("StartQuest", GetQuestData['QuestName'], GetQuestData["QuestLevel"])
									task.wait(.2)
								end
							else
								if not Client.PlayerGui:WaitForChild('TrackedQuestFrame'):WaitForChild('Frame'):WaitForChild('header'):WaitForChild('textLabel').Text:find(GetQuestData['MobName']) then
									_C("AbandonQuest")
								end
								if Entity.find({GetQuestData['MobName']}) then
									Entity.attack({
										GetQuestData['MobName']
									}, Expression)
								else
									repeat task.wait()
										if _G.Debug then
											DebugLog('[DEBUG]', 'Not Fond Mon')
										end
										loadFun['To Spawn'](GetQuestData['MobName'])
									until not _G.Settings[Expression] or Entity.find({GetQuestData['MobName']})
								end
							end
						end
					else
						_C("LoadItem", v.Name)
					end
				elseif v.Mastery > 599 and not _hasItem(v.Name) then
					_C("LoadItem", v.Name)
				end
			end
		end)
	end
end

getHitboxT = function()
	for i,v in next, workspace.Map.Waterfall.IslandModel:GetChildren() do
		if v:IsA('Model') then
			for i,v in v:GetDescendants() do
				if v.Name == "Hitbox" then
					return v
				end
			end
		end
	end
	return nil
end

loadFun['Auto_Cursed_Dual_Katana'] = function()
	local Expression = "Auto_Cursed_Dual_Katana"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local QuestUI = Client.PlayerGui.Main.Quest
			if not swordChecking("Yama") then
				if _C("EliteHunter","Progress") >= 30 then
					fireclickdetector(game:GetService("Workspace").Map.Waterfall.SealedKatana.Handle.ClickDetector)
				else
					if Entity.find({"Diablo","Deandre","Urban"}) and QuestUI.Visible == true then
						Entity.attack(
							{ "Diablo","Deandre","Urban" }
							,Expression)
					else
						if string.find(_C("EliteHunter"), "Come back later.") then
							HopServer()
						elseif QuestUI.Visible == false then
							_C("EliteHunter")
						end
					end
				end
			elseif not swordChecking("Tushita") then
				local Data = _C("TushitaProgress")
				if not Data.KilledLongma then
					if Data.OpenedDoor then
						if Entity.find({"Longma"}) then
							Entity.attack(
								{ "Longma" }
								,Expression)
						end
					else
						
						if Entity.find({"rip_indra True Form"}) then
							repeat
								if Current_Exploit() == "Roblox/WinInet" then 
									firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(), true)
									firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(), false)
								else
									firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(),0)
									firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(),1)
								end
								wait(.5)
							until _hasItem("Holy Torch")
							for i = 1,5 do task.wait()
								_C("TushitaProgress","Torch",i)
							end
						end
					end
				end
			else
				_G.Settings.SelectWeapon = "Sword"
				if swordChecking("Yama") and Mastery("Yama") <= 349 then
					if not _hasItem("Yama") then
						_C("LoadItem","Yama")
					elseif _hasItem("Tushita") then
						if Entity.find({"Reborn Skeleton","Demonic Soul","Living Zombie","Posessed Mummy"}) then
							Entity.attack(
								{
									"Reborn Skeleton",
									"Demonic Soul",
									"Living Zombie",
									"Posessed Mummy"
								}
								,Expression)
						else
							local mon = {"Reborn Skeleton","Demonic Soul","Living Zombie","Posessed Mummy"}
							if tick() - LastTospawn >= .3 then
								loadFun['To Spawn'](mon[math.random(1, #mon)])
								LastTospawn = tick()
							end
						end
					end
				elseif swordChecking("Tushita") and Mastery("Tushita") <= 349 then
					if not _hasItem("Tushita") then
						_C("LoadItem","Tushita")
					elseif _hasItem("Tushita") then
						if Entity.find({"Reborn Skeleton","Demonic Soul","Living Zombie","Posessed Mummy"}) then
							Entity.attack(
								{
									"Reborn Skeleton",
									"Demonic Soul",
									"Living Zombie",
									"Posessed Mummy"
								}
								,Expression)
						else
							local mon = {"Reborn Skeleton","Demonic Soul","Living Zombie","Posessed Mummy"}
							if tick() - LastTospawn >= .3 then
								loadFun['To Spawn'](mon[math.random(1, #mon)])
								LastTospawn = tick()
							end
						end
					end
				else
					if (swordChecking("Tushita") and Mastery("Tushita") > 349) and (swordChecking("Yama") and Mastery("Yama") > 349) then
						if getCurrentQuest("Evil") == 3 then
							game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("CDKQuest","Progress","Evil")
						end
						if getCurrentQuest("Good") == 3 then
							game:GetService("ReplicatedStorage").Remotes.CommF:InvokeServer("CDKQuest","Progress","Good")
						end
						if getCurrentQuest("Good") == 0 then
							for i,v in pairs(workspace.NPCs:GetChildren()) do
								if v.Name == "Luxury Boat Dealer" and _C("CDKQuest", "BoatQuest", v, "Check") == true then
									_C("CDKQuest", "BoatQuest", v)
								end
							end
							for i,v in pairs(game:GetService("ReplicatedStorage").NPCs:GetChildren()) do
								if v.Name == "Luxury Boat Dealer" and _C("CDKQuest", "BoatQuest", v, "Check") == true then
									_C("CDKQuest", "BoatQuest", v)
								end
							end
						elseif getCurrentQuest("Good") == 1 then
							for _i, _v in pairs(game.ReplicatedStorage:GetChildren()) do
								if _v:FindFirstChild("HumanoidRootPart") and (CFrame.new(-5545.57275, 410.014465, -2959.58716, 0.698926926, -6.25197094e-09, 0.715193093, 5.36379616e-08, 1, -4.36763798e-08, -0.715193093, 6.88880988e-08, 0.698926926).Position - _v.HumanoidRootPart.Position).Magnitude <= 5000 then
									if (CFrame.new(-5545.57275, 410.014465, -2959.58716, 0.698926926, -6.25197094e-09, 0.715193093, 5.36379616e-08, 1, -4.36763798e-08, -0.715193093, 6.88880988e-08, 0.698926926).Position - Client.Character.HumanoidRootPart.Position).Magnitude > 3000 then
										tp({Target = CFrame.new(-5545.57275, 410.014465, -2959.58716, 0.698926926, -6.25197094e-09, 0.715193093, 5.36379616e-08, 1, -4.36763798e-08, -0.715193093, 6.88880988e-08, 0.698926926)})
									else
										EnemiesAura(5000,Expression)
									end
								else
									if Entity.find({"Cake Prince","Dough King"}) then
										Entity.attack(
											{
												"Cake Prince",
												"Dough King"
											}
										,Expression)
									elseif Entity.find({"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}) then
										Entity.attack(
											{
												"Baking Staff",
												"Head Baker",
												"Cake Guard",
												"Cookie Crafter"
											}
											,Expression)
									else
										local mon = {"Baking Staff","Head Baker","Cake Guard","Cookie Crafter"}
										if tick() - LastTospawn >= .3 then
											loadFun['To Spawn'](mon[math.random(1, #mon)])
											LastTospawn = tick()
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end

loadFun['Auto_Evo_Race_V2'] = function()
	local Expression = "Auto_Evo_Race_V2"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if not Client.Data.Race:FindFirstChild("Evolved") then
				if _C("Alchemist","1") == 0 then
					tp({ Target = CFrame.new(-2779.83521, 72.9661407, -3574.02002, -0.730484903, 6.39014104e-08, -0.68292886, 3.59963224e-08, 1, 5.50667032e-08, 0.68292886, 1.56424669e-08, -0.730484903)})
					if dist(Vector3.new(-2779.83521, 72.9661407, -3574.02002)) <= 4 then
						wait(1.3)
						_C("Alchemist","2")
					end
				elseif _C("Alchemist","1") == 1 then
					if not _hasItem("Flower 1") then
						tp(game:GetService("Workspace").Flower1.CFrame)
					elseif not _hasItem("Flower 2") then
						tp(game:GetService("Workspace").Flower2.CFrame)
					elseif not _hasItem("Flower 3") then
						if Entity.find({"Swan Pirate"}) then
							Entity.attack( {"Swan Pirate"} ,Expression)
						else
							tp({ Target = CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375)})
						end
					end
				elseif _C("Alchemist","1") == 2 then
					_C("Alchemist","3")
				end
			end
		end)
	end
end

loadFun['Lock_Moon'] = function()
	local Lighting = game:GetService("Lighting")
	local Camera = workspace.CurrentCamera

	local Expression = "Lock_Moon"
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local root = Client.Character:WaitForChild("HumanoidRootPart")
			local moonDir = Lighting:GetMoonDirection()
			local targetPos = root.Position + moonDir * 1000
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
		end)
	end
end

inArea = function(CENTER, range)
	local playersInArea = 0
	centers = CENTER
	if type(CENTER) == "string" then centers = {CENTER} end
	for i, player in pairs(workspace.Characters:GetChildren()) do
		if player:FindFirstChild("HumanoidRootPart") then
			for _, getTable in pairs(centers) do
				if dist(getTable, player.HumanoidRootPart.Position) < (range or 10) then
					playersInArea = playersInArea + 1
				end
			end
		end
	end
	return playersInArea
end

resetCharacter = function()
	Char = LocalPlayer and Client.Character
	if not Char then return end
	Char.Humanoid:ChangeState(15)
end

killPlayer = function(Value,Expression)
	local _Settings = _G.Settings[Expression] or nil
	while _G.Settings[Expression] do task.wait()
		local Success,Error = pcall(function()
			for i, v in pairs(game:GetService("Workspace").Characters:GetChildren()) do
				if v.Name ~= Client.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position-game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude <= Value then
					repeat task.wait()
						_G.attackply = true
						_Settings = _G.Settings[Expression] or nil
						if not Client.Character:FindFirstChild("HasBuso") then
							_C('Buso')
						end
						v.HumanoidRootPart.CanCollide = false
						v.Humanoid.WalkSpeed = 0
						v.Head.CanCollide = false
						EquipTools(_G.Select_Weapon)
						ThradeSkill[#ThradeSkill+1] = task.spawn(function()
							for i,skill in _G.Settings['Select Skill Use'] or {"Z","X","C","V"} do 
								LockAim = true
								LockPosition = v.HumanoidRootPart.Position
								UseSkill(tostring(skill)) 
							end
						end)
						v.HumanoidRootPart.Transparency = 1
						tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))
					until (not _Settings or _Settings == false) or not v.Parent or v.Humanoid.Health <= 0 or not v:FindFirstChild("HumanoidRootPart")
					for i,v in next, ThradeSkill do task.cancel(v) end
					_G.attackply = false
				end
			end
		end)
	end
end

loadFun['Auto_Complete_Trial'] = function()
	local Expression = "Auto_Complete_Trial"
	_G.attackply = false
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if _C("TempleClock","Check") ~= nil and _C("TempleClock","Check") ~= "" then
				tp(workspace.Mote.CFrame)
				if Client.PlayerGui.ProximityPrompts:FindFirstChild("Prompt") then
					fireproximityprompt(workspace.Mote.ProximityPrompt,20)
					for i = 1,6 do
						_C("TempleClock","SpendPoint","Gear"..i,"Alpha")
					end
				end
			else
				if inArea({workspace.Map["Temple of Time"].FFABorder.Forcefield.Position}, 75) and workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0 then
					if _G.Settings.Select_Complete_Trial == "Surrender" then
						resetCharacter()
					elseif _G.Settings.Select_Complete_Trial == "Completer" then
						killPlayer(250,Expression)
					end
				else
					if inArea({
						workspace.Map["Temple of Time"].MinkCorridor.Door.Entrance.Position,
						workspace.Map["Temple of Time"].SkypieaCorridor.Door.Entrance.Position,
						workspace.Map["Temple of Time"].HumanCorridor.Door.Entrance.Position,
						workspace.Map["Temple of Time"].FishmanCorridor.Door.Entrance.Position,
						workspace.Map["Temple of Time"].CyborgCorridor.Door.Entrance.Position,
						workspace.Map["Temple of Time"].GhoulCorridor.Door.Entrance.Position,
					}) > 2 then
						game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
					end
					if Client.Data.Race.Value == "Skypiea" then
						if game:GetService("Workspace").Map:FindFirstChild("SkyTrial") then
							repeat task.wait()
								tp(game:GetService("Workspace").Map.SkyTrial.Model.FinishPart.CFrame)
							until _G.Settings[Expression] == false or Client.PlayerGui.Main.Timer.Visible == true or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0
						else
							if (game:GetService("Workspace").Map["Temple of Time"].SkypieaCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].SkypieaCorridor.Door.Entrance.CFrame)
							end
						end
					elseif Client.Data.Race.Value == "Mink" then
						if game:GetService("Workspace").Map:FindFirstChild("MinkTrial") then
							repeat task.wait()
								tp(game:GetService("Workspace").Map.MinkTrial.Ceiling.CFrame)
							until _G.Settings[Expression] == false or Client.PlayerGui.Main.Timer.Visible == true or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0
						else
							if (game:GetService("Workspace").Map["Temple of Time"].MinkCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].MinkCorridor.Door.Entrance.CFrame)
							end
						end
					elseif Client.Data.Race.Value == "Human" then
						if game:GetService("Workspace").Map:FindFirstChild("HumanTrial") then
							EnemiesAura(1000,Expression)
						else
							if (game:GetService("Workspace").Map["Temple of Time"].HumanCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].HumanCorridor.Door.Entrance.CFrame)
							end
						end
					elseif Client.Data.Race.Value == "Fishman" then
						if game:GetService("Workspace").Map:FindFirstChild("FishmanTrial") then
							repeat task.wait()
								Entity.SeaAttack({"SeaBeast1"},Expression,450,1000,"V4")
							until _G.Settings[Expression] == false or Client.PlayerGui.Main.Timer.Visible == true or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0
						else
							if (game:GetService("Workspace").Map["Temple of Time"].FishmanCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].FishmanCorridor.Door.Entrance.CFrame)
							end
						end
					elseif Client.Data.Race.Value == "Cyborg" then
						if game:GetService("Workspace").Map:FindFirstChild("CyborgTrial") then
							repeat task.wait()
								tp(game:GetService("Workspace").Map.CyborgTrial.Floor.CFrame * CFrame.new(0,-100,0))
							until _G.Settings[Expression] == false or Client.PlayerGui.Main.Timer.Visible == true or workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0
						else
							if (game:GetService("Workspace").Map["Temple of Time"].CyborgCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].CyborgCorridor.Door.Entrance.CFrame)
							end
						end
					elseif Client.Data.Race.Value == "Ghoul" then
						if game:GetService("Workspace").Map:FindFirstChild("GhoulTrial") then
							EnemiesAura(1000,Expression)
						else
							if (game:GetService("Workspace").Map["Temple of Time"].GhoulCorridor.Door.Entrance.CFrame.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 4000 then
								Client.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
							else
								tp(game:GetService("Workspace").Map["Temple of Time"].GhoulCorridor.Door.Entrance.CFrame)
							end
						end
					end
				end
			end
		end)
	end
end

local function TweenIsland(Island)
	for _, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
		if v.Name == Island then
			tp(v.CFrame * CFrame.new( 0,100 , 0))
			break
		else
			if Island == "Sky Island 2" then
				_C("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688))
				break
			elseif Island == "Sky Island 3" then
				_C("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
				break
			end
		end
	end
end

loadFun['Auto_Find_Bisento_V2'] = function()
	local Expression = 'Auto_Find_Bisento_V2'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if not swordChecking("Bisento") and Client.Data.Beli.Value > 1199999 then
				_C("BuyItem" ,"Bisento")
			elseif Client.Data.Beli.Value < 1199999 then
				Windown.Notify('success', { text = "Not Have Money 💸", time = 3 })
			else
				if Entity.find({"Greybeard"}) then
					Entity.attack({ tostring("Greybeard") },Expression)
				else
					if game:GetService("ReplicatedStorage"):FindFirstChild("Greybeard") then
						tp(game:GetService("ReplicatedStorage"):FindFirstChild("Greybeards").HumanoidRootPart.CFrame * CFrame.new(0,50,0))
					else
						TweenIsland("Marine Fortress")
					end
				end
			end
		end)
	end
end

loadFun['Auto_Hit_Core'] = function()
	local Expression = 'Auto_Hit_Core'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if Entity.find({"Core"}) then
				Entity.attack( { "Core", } ,Expression)
			else
				if game.ReplicatedStorage:FindFirstChild("Core") then
					tp(game.ReplicatedStorage.Core.HumanoidRootPart.CFrame * CFrame.new(0, 50 ,0))
				else
					TweenIsland("Café")
				end
			end
		end)
	end
end

Bartilo_Check_Quest = function(Value)
	return _C("BartiloQuestProgress", Value)
end

loadFun['Auto_Bartilo_Quest'] = function()
	local Expression = 'Auto_Bartilo_Quest'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if Client.Data.Level.Value >= 850 and W2 then
				local QuestC = Client.PlayerGui.Main.Quest
				if _G.Settings['Farm Level'] then IsFarming = false end
				if Bartilo_Check_Quest("Bartilo") == 2 then
					repeat wait() tp({Target = CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456)}) until (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1 or not _G.Settings[Expression]
					for value = 1,8 do task.wait(1)
						if _G.Settings[Expression] and dist(CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position) <= 150 then
							Client.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates["Plate"..value].CFrame
						end
					end
				elseif Bartilo_Check_Quest("Bartilo") == 1 then
					if Entity.find({"Jeremy"}) then
						Entity.attack( { tostring("Jeremy") } ,Expression)
					else
						if game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy") then
							tp(game:GetService("ReplicatedStorage"):FindFirstChild("Jeremy").HumanoidRootPart.CFrame * CFrame.new(0,50,0))
						else
							if _G.AutoFarmLv then
								IsFarming = true
							end
						end
					end
				elseif Bartilo_Check_Quest("Bartilo") == 0 then
					if QuestC.Visible == false then
						repeat wait() tp({Target = CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312)}) until (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 20 or not _G.Settings[Expression]
						if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 1 then
							game:GetService('ReplicatedStorage').Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
						end
					else
						if Entity.find({"Swan Pirate"}) then
							Entity.attack( { tostring("Swan Pirate") } ,Expression)
						else
							local mon = {"Swan Pirate"}
							if tick() - LastTospawn >= .3 then
								loadFun['To Spawn'](mon[math.random(1, #mon)])
								LastTospawn = tick()
							end
						end
					end
				end
			end
		end)
	end
end

loadFun['Auto_Find_Rengoku'] = function()
	local Expression = 'Auto_Find_Rengoku'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if ( not _hasItem("Hidden Key")) then
				if Entity.find({"Snow Lurker","Arctic Warrior","Awakened Ice Admiral"}) then
					Entity.attack( { "Awakened Ice Admiral", "Snow Lurker", "Arctic Warrior" } ,Expression)
				else
					local mon = {"Snow Lurker","Arctic Warrior"}
					if tick() - LastTospawn >= .3 then
						loadFun['To Spawn'](mon[math.random(1, #mon)])
						LastTospawn = tick()
					end
				end
			else
				EquipTools("Hidden Key")
				tp({ Target = CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875)})
			end
		end)
	end
end

loadFun['Auto_Buy_Legendary_Sword'] = function()
	local Expression = 'Auto_Buy_Legendary_Sword'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			_C("LegendarySwordDealer","2") task.wait(1)
		end)
	end
end


local CheckNeed = {
	['Fist of Darkness'] = nil
}
loadFun['Auto_Cyborg_Race'] = function()
	local funx = 'Auto_Cyborg_Race'
	local Usekey = function()
		game:GetService("VirtualInputManager"):SendKeyEvent(false,"W",false,game)
		game:GetService("VirtualInputManager"):SendKeyEvent(false,"A",false,game)
	end
	local GetCoreBrain = function()
		for i,v in pairs(Client.PlayerGui.Notifications:GetChildren()) do
			if v.Name == 'NotificationTemplate' and v.Text:find('Core Brain') then
				return true
			end
		end
		return false
	end
	Usekey()
	_G["_POST"] = ""
	while Config[funx] and task.wait() do
		loadFun['getPcall'](Expression, function()
			local Door = workspace.Map.CircleIsland.BlockPart
			if not workspace.Map.CircleIsland:FindFirstChild("BlockPart") then --BlockPart
				tp({ Target = CFrame.new(-5570.93994140625, 301.3266906738281, -5964.7705078125)})
			else
				if CheckNeed['Fist of Darkness'] then
					if _hasItem("Core Brain") then
						tp({ Target = CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)})
						if dist(CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)) < 5 then
							fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
						end
					else
						if Entity.find({'Order'}, 2500) then
							_G["_POST"] = ""
							Entity.attack({'Order'}, funx, nil, nil, true)
						else
							if _hasChip() then
								tp({ Target = CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)})
								if dist(CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)) < 5 then
									fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
								end
							else
								tp({ Target = CFrame.new(-4976.31640625, 143.8214111328125, -5394.3583984375) })
								if dist(CFrame.new(-4976.31640625, 143.8214111328125, -5394.3583984375)) < 5 then
									game:GetService("ReplicatedStorage").Remotes.CommF_:FireServer("BlackbeardReward", "Microchip", "2")
								end
							end
						end
					end
				else
					if CheckNeed['Fist of Darkness']  == nil then
						tp({ Target = CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)})
						if dist(CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)) < 5 then
							for i = 1,	5 do wait()
								fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
							end
							if GetCoreBrain() then
								CheckNeed['Fist of Darkness'] = true
							else
								CheckNeed['Fist of Darkness'] = false
							end
						end
					else
						if _hasItem('Fist of Darkness') then
							tp({ Target = CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)})
							if dist(CFrame.new(-5563.91552734375, 331.89874267578125, -5961.92919921875)) < 5 then
								fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
								CheckNeed['Fist of Darkness'] = true
							end
						else
							if Config['Select Type Cyborg Mode'] == "Sea Beast" then
								if Entity.find({'SeaBeast1'}, 2500) then
									_G["_POST"] = ""
									Usekey()
									Entity.attack({'SeaBeast1'}, funx, nil, nil, true)
								else
									local Boats = workspace:WaitForChild("Boats"):FindFirstChild("PirateBrigade")
									_G["_POST"] = "Boats"
									if Boats and tostring(Boats.Owner.Value) == Client.Name then
										for _, v in pairs(workspace.Boats:GetChildren()) do
											if v:IsA("Model") and v:FindFirstChild("Owner") then
												if v.Name == "PirateBrigade" and v:FindFirstChild("Owner") and tostring(v.Owner.Value) == Client.Name then
													if Client.Character.Humanoid.Sit == false then
														Usekey()
														tp({ Target = v.VehicleSeat.CFrame * CFrame.new(0, -1, 0)})
														if (v.VehicleSeat.CFrame.Position - Client.Character.HumanoidRootPart.CFrame.Position).Magnitude <= 15 then
															RemoveAllClip()
														end
													else
														local boatlevelSea = CFrame.new(93.62639617919922, 15, 5623.783203125)
														if (v.VehicleSeat.CFrame.Position - boatlevelSea.Position).Magnitude > 1500 then
															tp({ Target = boatlevelSea}, v.VehicleSeat)
														end
													end
													game:GetService("VirtualInputManager"):SendKeyEvent(true,"W",false,game)
													game:GetService("VirtualInputManager"):SendKeyEvent(true,"A",false,game)
												end
											end
										end
									else
										Usekey()
										tp( {Target = CFrame.new(-107.817383, 8.97463989, 2955.38965, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693)} )
										if dist(CFrame.new(-107.817383, 8.97463989, 2955.38965, 0.819155693, -0, -0.573571265, 0, 1, -0, 0.573571265, 0, 0.819155693).Position) < 10 then
											game:GetService("ReplicatedStorage").Remotes.CommF_:FireServer("BuyBoat","PirateBrigade") wait(1)
										end
									end
								end
							elseif Config['Select Type Cyborg Mode'] == "Chests" then
								for i,v in pairs(game:GetService('Workspace').ChestModels:GetDescendants()) do
									if v.Name == "SilverChest" or v.Name == "GoldChest" or v.Name == "DiamondChest" then
										if not v:GetAttribute("Ready_Keep") and (v.RootPart.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 500 + MagnitudePositionChest then
											repeat wait()
												tp({Target = v.RootPart.CFrame})
												if (v.RootPart.CFrame.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 1 then
													MagnitudePositionChest = 500
													if not v:GetAttribute("Ready_Keep") then
														v:SetAttribute("Ready_Keep", true)
													end
												end
											until Config[funx] == false or not v.Parent or v:GetAttribute("Ready_Keep") 
											MagnitudePositionChest = MagnitudePositionChest + 10
											break
										else
											MagnitudePositionChest = MagnitudePositionChest + 50
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end

GuitarPuzzle = function( Value)
	for i, v in pairs(_C("GuitarPuzzleProgress", "Check")) do
		if i == Value then
			return v
		end
	end
end

function getTrophies(Amount)
	for i,v in pairs(game:GetService("Workspace").Map["Haunted Castle"].Trophies.Quest:GetChildren()) do
		if v.Handle.Orientation then
			local NameTro = tonumber(tostring(v.Name:match("%d+")))
			if tonumber(Amount) == tonumber(NameTro) then
				if tonumber(v.Handle.Orientation.Y) == 90 or tonumber(v.Handle.Orientation.Y) == -90 then
					return {"A", 180, -180}
				elseif tonumber(v.Handle.Orientation.Y) == 0 or tonumber(v.Handle.Orientation.Y) == 180 then
					return {"B", -90, 90}
				end
			end
		end
	end
end

loadFun['Auto_Soul_Guitar'] = function()
	local Expression = 'Auto_Soul_Guitar'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149431" then
				_C("gravestoneEvent", 2)
				_C("gravestoneEvent", 2, true)
			end
			if not GuitarPuzzle("Swamp") then
				local enemyNames = {
					'Reborn Skeleton',
					'Living Zombie',
					'Demonic Soul',
					'Posessed Mummy'
				}
				if not Sea3 then
					_C("TravelZou")
					return
				end
				if Entity.find(enemyNames) then
					Entity.attack(enemyNames, Expression, nil, {MonsterPosition = CFrame.new(-10164.7588, 138.652451, 5935.78418, -0.999782741, -8.01260214e-08, -0.0208426975, -7.95026338e-08, 1, -3.07377839e-08, 0.0208426975, -2.90740569e-08, -0.999782741)})
				else
					if tick() - LastTospawn > 0.3 then
						loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
						LastTospawn = tick()
					end
				end
			elseif not GuitarPuzzle("Gravestones") then
				local placardOrder = {"Placard7", "Placard6", "Placard5", "Placard3"}
				local placardOrder2 = {"Placard4", "Placard2", "Placard1"}
				for _, placardName in ipairs(placardOrder) do
					wait(0.2)
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"][placardName].Left.ClickDetector)
				end
				for _, placardName in ipairs(placardOrder2) do
					wait(0.2)
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"][placardName].Right.ClickDetector)
				end
			elseif not GuitarPuzzle("Ghost") then
				_C("GuitarPuzzleProgress", "Ghost")
				_C("GuitarPuzzleProgress", "Ghost", true)
			elseif not GuitarPuzzle("Trophies") then
				repeat wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment2:FindFirstChild("ClickDetector"))
				until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment2.Line.Position.Y == -1000 or not _G.Settings[Expression]
				repeat wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment5:FindFirstChild("ClickDetector"))
				until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment5.Line.Position.Y == -1000 or not _G.Settings[Expression]
				repeat wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment6:FindFirstChild("ClickDetector"))
				until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment6.Line.Position.Y == -1000 or not _G.Settings[Expression]
				repeat wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment8:FindFirstChild("ClickDetector"))
				until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment8.Line.Position.Y == -1000 or not _G.Settings[Expression]
				repeat wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment9:FindFirstChild("ClickDetector"))
				until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment9.Line.Position.Y == -1000 or not _G.Settings[Expression]
				if getTrophies(1)[1] then
					repeat wait()
						fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector"))
					until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1.Line.Rotation.Z == getTrophies(1)[2] or game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment1.Line.Rotation.Z == getTrophies(1)[3] or not _G.Settings[Expression] or _C("GuitarPuzzleProgress","Check").Trophies == true
				end
				if getTrophies(2)[1] then
					repeat wait()
						fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment3:FindFirstChild("ClickDetector"))
					until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment3.Line.Rotation.Z == getTrophies(2)[2] or game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment3.Line.Rotation.Z == getTrophies(1)[3] or not _G.Settings[Expression] or _C("GuitarPuzzleProgress","Check").Trophies == true
				end
				if getTrophies(3)[1] then
					repeat wait()
						fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment4:FindFirstChild("ClickDetector"))
					until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment4.Line.Rotation.Z == getTrophies(3)[2] or game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment4.Line.Rotation.Z == getTrophies(1)[3] or not _G.Settings[Expression] or _C("GuitarPuzzleProgress","Check").Trophies == true
				end
				if getTrophies(4)[1] then
					repeat wait()
						fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment7:FindFirstChild("ClickDetector"))
					until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment7.Line.Rotation.Z == getTrophies(4)[2] or game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment7.Line.Rotation.Z == getTrophies(1)[3] or not _G.Settings[Expression] or _C("GuitarPuzzleProgress","Check").Trophies == true
				end
				if getTrophies(5)[1] then
					repeat wait()
						fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment10:FindFirstChild("ClickDetector"))
					until game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment10.Line.Rotation.Z == getTrophies(5)[2] or  game:GetService("Workspace").Map["Haunted Castle"].Tablet.Segment10.Line.Rotation.Z == getTrophies(1)[3] or not _G.Settings[Expression] or _C("GuitarPuzzleProgress","Check").Trophies == true
				end
			elseif not GuitarPuzzle("Pipes") then
				repeat task.wait() tp({Target = CFrame.new(-9628.02734375, 6.13064432144165, 6157.47802734375)}) until not _G.Settings[Expression] or (CFrame.new(-9628.02734375, 6.13064432144165, 6157.47802734375).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10
				task.wait()
				for i = 1,3 do task.wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
				end
				fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
				for i = 1,2 do task.wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
				end
				for i = 1,3 do task.wait()
					fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
				end
				fireclickdetector(game:GetService("Workspace").Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
			elseif not GuitarPuzzle("CraftedOnce") then
				Windown.Notify('success', { text = "END QUSET GO BUY", time = 5 })
				_G.Settings[Expression] = false
			end
		end)
	end
end

local TeleportIs = function(Pos, More)
	repeat task.wait()
		tp({Target = Pos})
	until not More()
end

loadFun['Auto Tushita'] = function()
	local Expression = 'Auto Tushita'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local Data = _C("TushitaProgress")
			if not Data.KilledLongma then
				if Data.OpenedDoor then
					if Entity.find({"Longma"}) then
						Entity.attack(
							{ "Longma" }
						,Expression)
					end
				else
					if Entity.find({"rip_indra True Form"}) then
						if not getHitboxT() then
							TeleportIs(CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625),function()
								return _G.Settings['Teleport To Island']
							end)
							return
						end
						repeat
							firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(),0)
							firetouchinterest(Client.Character.HumanoidRootPart,getHitboxT(),1)
							wait(.5)
						until _hasItem("Holy Torch")
						for i = 1,5 do task.wait()
							_C("TushitaProgress","Torch",i)
						end
					end
				end
			end
		end)
	end
end

loadFun['Auto_Awakening_One_Quest'] = function()
	local Expression = 'Auto_Awakening_One_Quest'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if Entity.find({"Cake Prince","Dough King"}) then
				Entity.attack({
					"Cake Prince",
					"Dough King"
				}, Expression)
			else
				local enemyNames = {
					"Baking Staff",
					"Head Baker",
					"Cake Guard",
					"Cookie Crafter"
				}
				if Entity.find( enemyNames ) then
					Entity.attack( enemyNames, Expression)
				else
					if tick() - LastTospawn > 0.3 then
						loadFun['To Spawn'](enemyNames[math.random(1, #enemyNames)])	
						LastTospawn = tick()
					end
				end
			end
		end)
	end
end

loadFun['Auto_Farm_Boss'] = function()
	local Expression = 'Auto_Farm_Boss'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			if Entity.find({_G.Settings.Select_Boss}) then
				Entity.attack({ _G.Settings.Select_Boss }, Expression)
			end
		end)
	end
end

local getRod = function()
	for i,v in next, Client.Backpack:GetChildren() do
		if v.Name:find('Rod') then
			return v.Name
		end
	end
	for i,v in next, Client.Character:GetChildren() do
		if v.Name:find('Rod') then
			return v.Name
		end
	end
end

local function getCloudZone()
    local Character = Client.Character or Client.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    local nearestCloud
    local nearestDist = math.huge
	for i, v in next, workspace:GetChildren() do
		 if v.Name:find("LightningStrikesEventCloud") then
            local dist = (v.Cloud.Position - HRP.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestCloud = v.Cloud
            end
        end
	end
    return nearestCloud
end

loadFun['Auto Token Summer Event'] = function()
	local Expression = 'Auto Token Summer Event'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local CloudZone = getCloudZone()
			if CloudZone then
				local CloudZonePosition = CFrame.new(CloudZone.Position)
				if dist(CloudZonePosition) > 400 then
					tp({Target = CloudZonePosition * CFrame.new(0, -110, 0)})
				else
					local MonsterName = CloudZone.Parent.Name:split('_')[2]
					for _, target in pairs(workspace.Enemies:GetChildren()) do
						if target and target:FindFirstChild('HumanoidRootPart') and target:FindFirstChild('Humanoid') then
							Entity.attack({target.Name}, Expression, nil , { Func = function()
								return not target.Parent
							end})
						else
							loadFun['To Spawn'](MonsterName)
						end
					end
					
				end
			end
		end)
	end
end

local clicking = false
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Client = game.Players.LocalPlayer

local clicking = false
local threshold = 5
local lastClick = 0
local interval = 0.03

local SaveingCFrame = nil
local LoopReady = false

_G.ReelAA = RunService.RenderStepped:Connect(function(dt)
	local Data
	local fishingGui = Client.PlayerGui:FindFirstChild("Fishing_Reeling")
	local Fishing_Cast_Meter = Client.Character:FindFirstChild('Fishing_Cast Meter')
	if _G.SomFunsc then
		Data = debug.getupvalues(_G.SomFunsc)
	end
	if _G.Settings['Auto_Fishing'] and LoopReady then
        Client.Character:FindFirstChild("HumanoidRootPart").CFrame = SaveingCFrame
    end
	if Fishing_Cast_Meter and Fishing_Cast_Meter.CastMeter.Bar.Frame and Fishing_Cast_Meter.CastMeter.Bar.Frame.Size.Y.Scale >= 0.8 then
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
	end
    if not fishingGui or not _G.Settings or not _G.Settings['Auto_Fishing'] then return end

	if _G.Settings['Select Mode Reel'] == "Bypass" and _G.SomFunsc then
		Data[6]["progress"] = 100
		Data[6]["treasureProgress"] = 100
		debug.setupvalue(_G.SomFunsc, 6, Data[6])
		return
	end

    local container = fishingGui.Minigame.Container
    local reelZone = container.ReelZone
    local fish = container.Fish

    local reelX = reelZone.AbsolutePosition.X + reelZone.AbsoluteSize.X / 2
    local fishX = fish.AbsolutePosition.X + fish.AbsoluteSize.X / 2

    local distance = fishX - reelX

    if distance < -5 then
        if clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            clicking = false
        end
    elseif distance > 5 then
        if not clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            clicking = true
        end
    else
        if clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            clicking = false
        end
    end
	
end)

CheckBaitCount = function(MaterialI)
	for i, v in pairs(getInventory()) do
		if v.Type == "Bait" then
			if v.Name == MaterialI then
				return v.Count
			end
		end
	end
	return 0
end

loadFun['Auto_Fishing'] = function()
	local Expression = 'Auto_Fishing'
	LoopReady = false
	SaveingCFrame = Client.Character:FindFirstChild("HumanoidRootPart").CFrame
    task.wait(.5)
	while _G.Settings[Expression] do task.wait(.1)
		loadFun['getPcall'](Expression, function()
			if _G.Settings['Auto_Player_Position'] and (_G.Settings['Select Player Position'] ~= '' or _G.Settings['Select Player Position'] ~= nil ) then
				if dist(_G.Settings['Select Player Position']) > 5 then 
					tp({ Target = _G.Settings['Select Player Position']}) 
					return 
				else 
					SaveingCFrame = _G.Settings['Select Player Position']
				end
			end
			if _G.Settings['Auto_Buy_Bait'] and _G.Settings['Bait Num'] and CheckBaitCount('Basic Bait') < _G.Settings['Bait Num'] then
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft"):InvokeServer("Craft", "Basic Bait", {})
			end
			LoopReady = true
			local nowRod = Client.Character:FindFirstChild(getRod())
			if not nowRod then EquipTools(getRod()) return end
			if nowRod:GetAttribute('State') == 'ReelingIn' then
				task.wait(1.5)
				nowRod.Parent = Client.Backpack
			elseif nowRod:GetAttribute('State') == 'ReeledIn' or nowRod:GetAttribute('State') == 'StartCasting' then
				pcall(function()
                    local viewportSize = workspace.CurrentCamera.ViewportSize
                    local x, y = .5,.5
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                    task.wait(1)
                    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
                end)
                task.wait(1.5)
			elseif nowRod:GetAttribute('State') == 'Biting' then
				pcall(function()
                    local req = _G.fishingRequest or script.Parent:FindFirstChild("FishingRequest")
                    if req then
                        req:InvokeServer("Catching", true, { fastBite = true })
                    end
                end)
			end
		end)
	end
end

local getOniNpc = function()
	local closestNPC
	local minDistance = math.huge
	local root = Client.Character.HumanoidRootPart
	
	local function checkNPCs(npcs)
		for _, npc in ipairs(npcs) do
			if npc:IsA("Model") and npc.Name == "Oni1" and npc:FindFirstChild("HumanoidRootPart") then
				local dist = (npc.HumanoidRootPart.Position - root.Position).Magnitude
				if dist < minDistance then
					minDistance = dist
					closestNPC = npc
				end
			end
		end
	end

	checkNPCs(ReplicatedStorage:WaitForChild("NPCs"):GetChildren())
	checkNPCs(workspace.NPCs:GetChildren())
	return closestNPC
end


loadFun['Auto Oni Event'] = function()
	local Expression = 'Auto Oni Event'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local RedPos = Entity.getCFrame({"Red Commander", "Oni Soldier"})
			if RedPos and Entity.find({"Red Commander", "Oni Soldier"}) and dist(RedPos) >= 3000 then
				if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer("InitiateTeleportToTemple") then
					RemoveAllClip() 
					if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
						local Noclip = Instance.new("BodyVelocity")
						Noclip.Name = "BodyClip"
						Noclip.Parent = Client.Character.HumanoidRootPart
						Noclip.MaxForce = Vector3.new(5, math.huge, 5)
						Noclip.Velocity = Vector3.new(0, 0, 0)
					end
					task.wait(1)
				else
					local PosNpc = getOniNpc()
					tp({Target = PosNpc.HumanoidRootPart.CFrame})
				end
				return
			end
			if Entity.find({"Red Commander"}) then
				Entity.attack({ "Red Commander" }, Expression)
			else
				if Entity.find({"Oni Soldier"}) then
					Entity.attack({"Oni Soldier"}, Expression)
				else
					if not workspace.Map:FindFirstChild("Oni Realm (Interior)") then
						if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/OniTempleTransportation"):InvokeServer("InitiateTeleportToTemple") then
							RemoveAllClip() 
							if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
								local Noclip = Instance.new("BodyVelocity")
								Noclip.Name = "BodyClip"
								Noclip.Parent = Client.Character.HumanoidRootPart
								Noclip.MaxForce = Vector3.new(5, math.huge, 5)
								Noclip.Velocity = Vector3.new(0, 0, 0)
							end
							task.wait(1)
						else
							local PosNpc = getOniNpc()
							tp({Target = PosNpc.HumanoidRootPart.CFrame})
						end
					else
						tp({Target = workspace.Map:FindFirstChild("Oni Realm (Interior)"):GetPivot() * CFrame.new(0, 30, -140)})
					end
				end
			end
		end)
	end
end

local function getCelestialNpc()
    local closestNPC
    local minDistance = math.huge
    local root = Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local function checkNPCs(npcs)
        for _, npc in ipairs(npcs) do
            if npc:IsA("Model") and npc.Name == "Celestial" then
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    local dist = (npcRoot.Position - root.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        closestNPC = npc
                    end
                end
            end
        end
    end

    if workspace:FindFirstChild("NPCs") then
        checkNPCs(workspace.NPCs:GetChildren())
    end
    if not closestNPC and ReplicatedStorage:FindFirstChild("NPCs") then
        checkNPCs(ReplicatedStorage.NPCs:GetChildren())
    end
    return closestNPC
end

loadFun['Auto Rip Eevet'] = function()
	local Expression = 'Auto Rip Eevet'
	while _G.Settings[Expression] do task.wait()
		loadFun['getPcall'](Expression, function()
			local RedPos = Entity.getCFrame({"Rip Commander", "Celestial Soldier"})
			if Entity.find({"Rip Commander", "Celestial Soldier"}) and RedPos and dist(RedPos) >= 3000 then
				if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/CelestialDomainTransportation"):InvokeServer("InitiateTeleportToTemple") then
					RemoveAllClip() 
					if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
						local Noclip = Instance.new("BodyVelocity")
						Noclip.Name = "BodyClip"
						Noclip.Parent = Client.Character.HumanoidRootPart
						Noclip.MaxForce = Vector3.new(5, math.huge, 5)
						Noclip.Velocity = Vector3.new(0, 0, 0)
					end
					task.wait(1)
				else
					local PosNpc = getCelestialNpc()
					tp({Target = PosNpc.HumanoidRootPart.CFrame})
				end
				return
			end
			if Entity.find({"Rip Commander"}) then
				Entity.attack({ "Rip Commander" }, Expression)
			else
				if Entity.find({"Celestial Soldier"}) then
					Entity.attack({"Celestial Soldier"}, Expression)
				else
					if not workspace.Map:FindFirstChild("Celestial Domain") then
						if game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/CelestialDomainTransportation"):InvokeServer("InitiateTeleportToTemple") then
							RemoveAllClip() 
							if not Client.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
								local Noclip = Instance.new("BodyVelocity")
								Noclip.Name = "BodyClip"
								Noclip.Parent = Client.Character.HumanoidRootPart
								Noclip.MaxForce = Vector3.new(5, math.huge, 5)
								Noclip.Velocity = Vector3.new(0, 0, 0)
							end
							task.wait(1)
						else
							print(4)
							local PosNpc = getCelestialNpc()
							tp({Target = PosNpc.HumanoidRootPart.CFrame})
						end
					else
						local pos = workspace._WorldOrigin.Locations["Celestial Domain"].CFrame
						tp({Target = pos * CFrame.new(0, -500, 0)})
					end
				end
			end
		end)
	end
end



local function getPainCloudZone()
    local Character = Client.Character or Client.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")

    local nearestCloud
    local nearestDist = math.huge
	for i, v in next, workspace:GetChildren() do
		 if v.Name:find("PainEventCloud") and not v.Name:find('Longma') then
            local dist = (v.Cloud.Position - HRP.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestCloud = v.Cloud
            end
        end
	end
    return nearestCloud
end

loadFun['Auto Pain Boss Event'] = function()
	local Expression = 'Auto Pain Boss Event'
	while _G.Settings[Expression] and task.wait() do
		loadFun['getPcall'](Expression, function()
			local CloudZone = getPainCloudZone()
			if CloudZone then
				local MonsterName = CloudZone.Parent.Name:split('_')[2]
				if Entity.find({MonsterName}) then
					Entity.attack({ MonsterName }, Expression)
				else
					tp({Target = CloudZone.CFrame })
				end
			end
		end)
	end
end

local getPad = function()
    local Map = workspace:WaitForChild("Map")
    local Simulation = Map:WaitForChild("Simulation Hub")
    local Pads = Simulation:WaitForChild("Pads")

    local allInfo = {}

    for _, v in ipairs(Pads:GetChildren()) do
        table.insert(allInfo, {
            NumPlayersOnPad = v:GetAttribute("NumPlayersOnPad") or 0,
			Main = v,
            Path = v:WaitForChild("Pad"),
			Remote = v.DungeonSettingsChanged
        })
    end

    table.sort(allInfo, function(a, b)
        return a.NumPlayersOnPad > b.NumPlayersOnPad
    end)

    return allInfo[1]
end


loadFun['Auto Join Dungeon New'] = function()
	local Expression = 'Auto Join Dungeon New'
	while _G.Settings[Expression] and task.wait() do
		loadFun['getPcall'](Expression, function()
			if Dungeons and not Client.PlayerGui:FindFirstChild('DungeonInterface') then
				local padInfo = getPad()
				if padInfo.NumPlayersOnPad > 0 then
					tp({ Target = padInfo.Path.CFrame })
				else
					tp({ Target = CFrame.new(-363.97430419921875, 256.1496276855469, -330.1690979003906)})
				end
				if padInfo.Remote and padInfo.NumPlayersOnPad > 1 then
					if padInfo.Main:GetAttribute('Difficulty') ~= _G.Settings['Select Difficulty Dunnew'] then
						padInfo.Remote:FireServer("Difficulty", _G.Settings['Select Difficulty Dunnew'])
						task.wait(.2)
					end
					padInfo.Remote:FireServer('Start')
				end
			end
		end)
	end
end

local minDistance = math.huge
local closestTeleport = nil
local pos = nil

loadFun['Auto Dungeon New'] = function()
	local Expression = 'Auto Dungeon New'
	while _G.Settings[Expression] and task.wait() do
		loadFun['getPcall'](Expression, function()
			if Dungeons and Client.PlayerGui:FindFirstChild('DungeonInterface') then
				local pathMon = workspace:FindFirstChild('Enemies')
				if #pathMon:GetChildren() > 0 then
					for i,v in next, pathMon:GetChildren() do
						Entity.attack({ v.Name }, Expression)
					end
				else
					for _, v in ipairs(workspace.Map.Dungeon:GetChildren()) do
						local door = v:FindFirstChild("ExitTeleporter")
						if door and door:FindFirstChild("Root") then
							local root = door.Root
							if dist(root.Position) < minDistance then
								minDistance = distance
								pos = root.CFrame
								closestTeleport = root
							end
						end
					end
					if closestTeleport then
						tp({ Target = pos })
					end
				end
			end
		end)
	end
end

NetRF = function(name)
	local mods = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
	local net = mods and mods:FindFirstChild("Net")
	return net and net:FindFirstChild("RF/" .. name)
end

local MonkeyHet = function()
	local aa = false
	for i,v in pairs(workspace.Enemies:GetChildren()) do
		if v.Name == "Monkey" and v:FindFirstChild('Stolen Adventurer Hat') then
			aa = true
		end
	end
	return aa
end

local function IsTavernBrawlActive()
    return false
end


local Quests = {
	['Rescue Hasan'] = {
		['SetActive'] = false
	},
	["Chef's Kiss"] = false,
	['Prickly Harvest'] = {
		['Wait'] = false
	},
	['Fortress Flagpole'] = false,
	['Electric Fighting Teacher'] = {
		['Progress'] = 0
	},
	['Don Megalo'] = {
		['Progress'] = 0
	},
	['Unexpected Guest'] = {
		['Progress'] = 0,
		['Code'] = nil
	},
	["King's Apprentice"] = {
		['Progress'] = 0,
		['Time'] = nil
	}
}

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.Died:Connect(function()
        for _, quest in next, Quests do
            if type(quest) == "table" and quest.Progress ~= nil then
                quest.Progress = 0
				if quest.Time then
					quest.Time = nil
				end
            end
        end

        print("Reset Quest Progress")
    end)
end

if Client.Character then
    setupCharacter(Client.Character)
end

Client.CharacterAdded:Connect(setupCharacter)

if Sea1 then
	game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent.OnClientEvent:Connect(function(a1,a2,a3)
		if a1 == "Rescue Hasan" and a2 == "SetActive" and a3 then
			Quests['Rescue Hasan']['SetActive'] = true
			print('Rescue Hasan', 'SetActive')
		end
	end)

	game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteFunction.OnClientInvoke = function(a1, a2)
		if a2 == "GetState" then
			Quests[a1] = true
			task.delay(60*10, function()
				Quests[a1] = false
			end)
			print(a1, 'true')
		end
	end
end

local DisCheck = function(a1)
	for i,v in next,workspace.Enemies:GetChildren() do
		if v.Humanoid and v.Humanoid.Health > 0 and v.Humanoid.DisplayName == a1 then
			return true
		end
	end
	return false
end

local KillLocalEnemy = function()
	for i,v in next,workspace.Enemies:GetChildren() do
		if v:GetAttribute('LocalEnemy') == game.Players.LocalPlayer.Name then
			v.Humanoid.Health = 0
		end
	end
end

local CheckLocalEnemy = function()
	for i,v in next,workspace.Enemies:GetChildren() do
		if v:GetAttribute('LocalEnemy') == game.Players.LocalPlayer.Name then
			return true
		end
	end
	return false
end

local SnowmanStackRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SnowmanStackRemote")
local function getRoot()
    return Client.Character and Client.Character:FindFirstChild("HumanoidRootPart")
end

local NeedTypeTool = function(a)
	local b = {
		['Melee'] = false,
		['Sword'] = false,
		['Blox Fruit'] = false,
		['Gun'] = false
	}

	for _, v in pairs(Client.Backpack:GetChildren()) do
		if b[v.ToolTip] ~= nil then
			b[v.ToolTip] = true
		end
	end

	for _, toolType in pairs(a) do
		if not b[toolType] then
			return false
		end
	end

	return true
end

local BonusMomentsController = require(game.ReplicatedStorage.Controllers.BonusMomentsController):GetLoadedMoments()
local PodiumClient = require(ReplicatedStorage.ClientComponents.PodiumClient)

local BonusMomentsRemoteFunction = game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteFunction
local function getDataSecretDoor()
	local SecretDoor = workspace.Map:WaitForChild('Sky'):WaitForChild('SkyCastle'):WaitForChild('SecretDoor')
	return SecretDoor and SecretDoor.Part.cracks.Transparency > 0.5 and SecretDoor.Part.cracks.Transparency < 1
end

loadFun['Auto Quest Secrets'] = function()
	local Expression = 'Auto Quest Secrets'
	while _G.Settings[Expression] and task.wait() do
		loadFun['getPcall'](Expression, function()
			if not Sea1 then _C('TravelMain') return end
			local Data = NetRF("RequestBonusMomentReplication"):InvokeServer({ Type = "GetMomentProgress" }).Data
			local minutes = tonumber(os.date("%M"))
			local Guide = require(game:GetService("ReplicatedStorage").GuideModule.CompassTracker)
			local RequestNextRaidHint = game:GetService("ReplicatedStorage").Modules.Net["RF/RequestNextRaidHint"]:InvokeServer()
			
			if Guide.TrackedPosition then
				tp({ Target = CFrame.new(Guide.TrackedPosition) })
				if dist(CFrame.new(Guide.TrackedPosition)) <= 10 then
					local viewportSize = workspace.CurrentCamera.ViewportSize
					local x, y = .5,.5
					VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
					task.wait(1)
					VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
				end
				return
			end
			if not Data['Sea1/Jungle/Zipline Repair'] then
				if _hasItem('Grappling Hook') then
					if dist(CFrame.new(-1280, 74, -248)) <= 10 then
						local Event = BonusMomentsRemoteFunction
						Event:InvokeServer(
							"Zipline Repair",
							"Throw",
							"Grappling Hook",
							{
								Type = "AimData",
								Origin = CFrame.new(-1261.7573242188, 74.112991333008, -238.9328918457, -0.71121162176132, 0, 0.70297801494598, 0, 1, -0, -0.70297801494598, 0, -0.71121162176132),
								Target = Vector3.new(-1482.8410644531, 78.084884643555, -15.259704589844),
								InitialVelocity = Vector3.new(-151.6111907959, 145.66156005859, 153.38693237305),
								Arc = {
									ArcLength = 336.22097922932,
									AimDegrees = 20,
									HighestPointOffsetY = 54.113856500898,
									HighestPoint = Vector3.new(-1487.0539550781, 128.22685241699, -10.997451782227),
									TargetOffsetX = 314.49597167969,
									GroundPoint = Vector3.new(-1487.0539550781, 74.112991333008, -10.997451782227),
									GroundPointOffsetX = 320.48891307541,
									TargetOffsetY = 3.9718933105469
								}
							}
						)
					else
						tp({ Target = CFrame.new(-1280, 74, -248) })
					end
				else
					if dist(CFrame.new(-1237, 1, -286)) <= 10 then
						print('get')
						local Event = game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent
						Event:FireServer(
							"Zipline Repair",
							"PickupTool"
						)
					else
						tp({ Target = CFrame.new(-1237, 1, -286) })
					end
				end
			elseif not Data['Sea1/Jungle/The Thieving Monkey'] then
				if workspace._WorldOrigin:FindFirstChild("Adventurer's Hat") then
					local Hat =  workspace._WorldOrigin:FindFirstChild("Adventurer's Hat"):WaitForChild('Handle')
					tp({ Target = Hat.CFrame })
					fireproximityprompt( Hat.ProximityPrompt)
					Quests['KeepHat'] = true
					return
				elseif Quests['KeepHat'] then
					tp({ Target = CFrame.new(-1681, 50, 177) })
					if dist(CFrame.new(-1681, 50, 177)) <= 5 then
						game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer( "The Thieving Monkey", "ReturnHat" )
					end
					return
				end
				if MonkeyHet() then
					for i,v in pairs(workspace.Enemies:GetChildren()) do
						if v.Name == "Monkey" and v:FindFirstChild('Stolen Adventurer Hat') then
							repeat task.wait()
								tp({
									Target = v.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0),
								})
								EquipTools(_G.Select_Weapon)
							until not _G.Settings[Expression]
						end
					end
					return
				end
				if not Quests['fhats'] then
					tp({ Target = CFrame.new(-1681, 50, 177) })
					if dist(CFrame.new(-1681, 50, 177)) <= 5 then
						local data = game:GetService("ReplicatedStorage").Modules.Net["RF/BonusMomentsGuide"]:InvokeServer("InteractQuestGiver", "JungleQuest")
						task.wait(1)
						if data.RumorDialogue and data.RumorDialogue[1]:find("Hold onto your hats...") then
							Quests['fhats'] = true
							task.delay(60*3, function()
								if _G.Settings[Expression] and _G.Settings['Quest Secrets Hop'] and not MonkeyHet() and not workspace._WorldOrigin:FindFirstChild("Adventurer's Hat") then
									HopServer(false)
								end
							end)
						end
					end
					return
				end
				local hit = 0
				for i,v in next, workspace.Map.Jungle.BananaTrees:GetChildren() do
					if not MonkeyHet() and CollectionService:GetTags(v)[1] == "ValidMonkeyTree" and not v:GetAttribute('Hit') then
						repeat task.wait()
							if dist(v.PrimaryPart.CFrame) <= 10 then
								EquipTools(_G.Select_Weapon)
								local viewportSize = workspace.CurrentCamera.ViewportSize
								local x, y = .5,.5
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
								task.wait(.4)
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
								hit += 1
							end
							tp({ Target = v.PrimaryPart.CFrame })
						until not _G.Settings[Expression] or Data['Sea1/Jungle/The Thieving Monkey'] or hit >= 3 or MonkeyHet()
						if not v:GetAttribute('Hit') then
							v:SetAttribute('Hit', true)
							task.delay(3, function()
								v:SetAttribute('Hit', false)
							end)
							hit = 0
						end
						if Data['Sea1/Jungle/The Thieving Monkey'] then
							break
						end
					end
				end
			elseif not Data['Sea1/Jungle/Banana Tree'] and workspace:FindFirstChild('BananaTreeFX_'.. Client.UserId)  then
				if workspace.Enemies:FindFirstChild("The Gorilla King") and (workspace.Enemies:FindFirstChild("The Gorilla King"):GetAttribute('AwakenEyes') or workspace.Enemies:FindFirstChild("The Gorilla King"):GetAttribute('BossIndicatorAwakened') )then
					for i,v in pairs(workspace.Enemies:GetChildren()) do
						if v.Name == "The Gorilla King" then
							repeat task.wait()
								tp({
									Target = v.HumanoidRootPart.CFrame * CFrame.new(0, 35, 0),
								})
								EquipTools(_G.Select_Weapon)
							until not _G.Settings[Expression]
						end
					end
				else
					for i,v in next, workspace.Map.Jungle.BananaTrees:GetChildren() do
						if CollectionService:GetTags(v)[1] == "IsBananaTree" then
							repeat task.wait()
								if dist(v.PrimaryPart.CFrame) <= 10 then
									EquipTools(_G.Select_Weapon)
									local viewportSize = workspace.CurrentCamera.ViewportSize
									local x, y = .5,.5
									VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
									task.wait(.4)
									VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
								end
								tp({ Target = v.PrimaryPart.CFrame })
							until not _G.Settings[Expression] or Data['Sea1/Jungle/The Thieving Monkey'] or hit >= 3 or MonkeyHet()
							if not _G.Settings[Expression] or Data['Sea1/Jungle/The Thieving Monkey'] then
								break
							end
						end
					end
				end
			elseif not Data['Sea1/Pirate Village/Windmill Maintenance'] then
				local Windmill_rig = workspace.Map.Pirate.WindmillRig.Windmill_rig 
				local SwordNow
				if not Windmill_rig then
					tp({ Target = CFrame.new(-1259.2520751953125, 145.50088500976562, 4044.643798828125) })
					return
				end
				for i ,v in pairs(Client.Backpack:GetChildren()) do
					if v:IsA('Tool') and v.ToolTip == "Sword" then
						SwordNow = v.Name
					end
				end
				for i ,v in pairs(Client.Character:GetChildren()) do
					if v:IsA('Tool') and v.ToolTip == "Sword" then
						SwordNow = v.Name
					end
				end
				if not SwordNow then
					_C("BuyItem", "Katana")
				end
		
				for i,v in next, Windmill_rig:GetChildren() do
					if game.CollectionService:GetTags(v)[1] == "M1HitRegistry" and v.Transparency == 0 then
						repeat task.wait()
							tp({ Target = v.CFrame })
							if dist(v.CFrame) <= 10 then
								EquipTools(SwordNow)	
								local viewportSize = workspace.CurrentCamera.ViewportSize
								local x, y = .5,.5
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
								task.wait(.4)
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
							end
						until not _G.Settings[Expression] or v.Transparency == 1
						if not _G.Settings[Expression] then
							break
						end
					end
				end
			elseif not Data['Sea1/Pirate Village/Tavern Brawl'] and IsTavernBrawlActive() then
				
			elseif not Data["Sea1/Pirate Village/Chef's Kiss"] and false then

			elseif not Data["Sea1/Desert/Rescue Hasan"] then
				if _G.getProgressHasan and _G.getProgressHasan.Progress and _G.getProgressHasan.Progress == 1 then
					tp({ Target = CFrame.new(1308, 23, 4492) })
					if dist(CFrame.new(1308, 23, 4492)) <= 10 then
						game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer( "Rescue Hasan", "Interact")
					end
				else
					if not Quests['Rescue Hasan']['SetActive'] then
						tp({ Target = CFrame.new(1293, 0, 4437) })
						if game:GetService("Players").LocalPlayer.PlayerGui.DialogueGui:FindFirstChildOfClass('Frame') then
							Client.Character.Humanoid.Health = 0
							if not _G.InHasanQ then
								_G.LoadBack()
								task.wait(1.5)
							end
							return
						end
						if _G.InHasanQ then
							debug.setupvalue(_G.InHasanQ, 2, true)
						end
						if dist(CFrame.new(1293, 0, 4437)) <= 10 then
							game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer("Rescue Hasan","StartWaves")
						end
						
					else
						if Entity.find({'Desert Skeleton'}) then
							Entity.attack({'Desert Skeleton'}, Expression)
						else
							tp({ Target = CFrame.new(1302, 15, 4452) })
							task.wait(.5)
							_G.LoadBack()
						end
					end
				end
			elseif not Data["Sea1/Desert/Archaeologist's Tablet"] then
				if dist(CFrame.new(1278, 24, 4644)) > 150 then
					tp({ Target = CFrame.new(1278, 24, 4644) })
					return
				end
				for i,v in next, workspace["Archaeologist's Tablet"].Pillars:GetChildren() do
					if v:GetAttribute('NumHits') < 3 then
						repeat task.wait()
							tp({ Target = v.Stone.CFrame })
							if dist(v.Stone.CFrame) <= 10 then
								EquipTools(_G.Select_Weapon)
								local viewportSize = workspace.CurrentCamera.ViewportSize
								local x, y = .5,.5
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
								task.wait(.4)
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
							end
						until not _G.Settings[Expression] or v:GetAttribute('NumHits') >= 3
						if not _G.Settings[Expression] then
							break
						end
					end
				end
			elseif not Data["Sea1/Desert/Prickly Harvest"] and not Quests['Prickly Harvest']['Wait'] and false then
				if not BonusMomentsController['Prickly Harvest'].Active then
					if dist(CFrame.new(869, 6, 4454)) <= 10 then
						if BonusMomentsRemoteFunction:InvokeServer("Prickly Harvest","TurnInReady") then
							BonusMomentsRemoteFunction:InvokeServer("Prickly Harvest","Interact")
						else
							Quests['Prickly Harvest']['Wait'] = true
							delay(60*5, function()
								Quests['Prickly Harvest']['Wait'] = false
							end)
						end
					else

					end
				else

				end
			elseif not Data["Sea1/Frozen Village/Breaking the Ice"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Frozen Village" then
					tp({ Target = CFrame.new(1444, 24, -1393) })
					return
				end
				if workspace:FindFirstChild('Iceberg') then
					tp({ Target = CFrame.new(1444, 24, -1393) })
					if dist(CFrame.new(1444, 24, -1393)) <= 10 then
						EquipTools(_G.Select_Weapon)
						local viewportSize = workspace.CurrentCamera.ViewportSize
						local x, y = .5,.5
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
						task.wait(.4)
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
					end
				end
			elseif not Data["Sea1/Frozen Village/Snowman"] and workspace.Terrain:GetAttribute('SeaTheme') == "Cold" then
				if Client:GetAttribute('NearestLandLocation') ~= "Frozen Village" then
					tp({ Target = CFrame.new(1444, 24, -1393) })
					return
				end
				RemoveAllClip()

				local root = getRoot()
				if not root then return end

				local targetPiles = {}
				for _, item in pairs(workspace.Terrain:GetChildren()) do
					if item.Name == "Snow Pile" and item:FindFirstChild("HumanoidRootPart") then
						table.insert(targetPiles, item)
					end
				end

				if #targetPiles < 3 then
					return
				end

				local startPos = root.Position

				root.CFrame = targetPiles[1].HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.85)

				for i = 1, 15 do
					root.CFrame = CFrame.new(startPos + Vector3.new(i * 3, 0, 0))
					task.wait(0.04)
				end

				root.CFrame = targetPiles[2].HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.85)

				for i = 1, 15 do
					root.CFrame = CFrame.new(startPos + Vector3.new(0, 0, i * 3))
					task.wait(0.04)
				end

				local stackCFrame = CFrame.new(startPos)
				SnowmanStackRemote:FireServer({15, 15}, stackCFrame)
				task.wait(1)

				root.CFrame = targetPiles[3].HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				task.wait(0.85)

				for i = 1, 15 do
					root.CFrame = CFrame.new(startPos - Vector3.new(i * 3, 0, 0))
					task.wait(0.04)
				end

				SnowmanStackRemote:FireServer({15, 15, 15}, stackCFrame)
				task.wait(1)
				game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer("Snowman", "Finished" )

			elseif not Data["Sea1/Frozen Village/Frozen Defense"] and false then
				
			elseif not Data["Sea1/Marine Fortress/Fortress Flagpole"] then
				local root = getRoot()
				local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BonusMomentsRemoteEvent")
				if not root then return end
				if dist(CFrame.new(-4832, 234, 3850)) <= 10 then
					Remote:FireServer("Fortress Flagpole", "Start")
					Quests['Fortress Flagpole'] = true
				end
				if not Quests['Fortress Flagpole'] then
					tp({ Target = CFrame.new(-4832, 234, 3850) })
					return
				end

				local rope = workspace:FindFirstChild("FortressRope")
				if rope then
					tp({ Target = rope.CFrame })
					if dist(rope.CFrame) <= 5 then
						root.CFrame = rope.CFrame 
						Remote:FireServer("Fortress Flagpole", "TakeRope")
					end
				end

				local flag = workspace:FindFirstChild("FortressFlag")
				if flag and not rope then
					tp({ Target = flag:GetPivot() + Vector3.new(0, 3, 0) })
					if dist(flag:GetPivot() + Vector3.new(0, 3, 0)) <= 5 then
						root.CFrame = flag:GetPivot()
						Remote:FireServer("Fortress Flagpole", "Hoist")
					end
				end
			elseif not Data["Sea1/Prison/Escape from Alcatraz"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Prison" then
					tp({ Target = CFrame.new(4950, 12, 731) })
					return
				end
				game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteFunction:InvokeServer("Escape from Alcatraz" ,"Provoke", "Raft" )
				game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteFunction:InvokeServer("Escape from Alcatraz" ,"Provoke", "Digger" )
				game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteFunction:InvokeServer("Escape from Alcatraz" ,"Provoke", "Puncher" )
				if CheckLocalEnemy() then
					KillLocalEnemy()
				end
			elseif not Data["Sea1/Prison/Don Megalo"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Prison" then
					tp({ Target = CFrame.new(4950, 12, 731) })
					return
				end
				if Entity.find({'Megalo Guard'}) then
					Entity.attack({'Megalo Guard'}, Expression)
				end
				if Quests['Don Megalo']['Progress'] == 0 then
					local Pos22 = workspace.Map.Prison.BonusMoment_Locations.Key.CFrame
					tp({ Target = Pos22 })
					if dist(Pos22) <= 5 then
						BonusMomentsRemoteFunction:InvokeServer("Don Megalo", "TakeKey")
						Quests['Don Megalo']['Progress'] = 1
					end
				elseif Quests['Don Megalo']['Progress'] == 1 then
					local Pos22 = CFrame.new(5329, 185, 721)
					tp({ Target = Pos22 })
					if dist(Pos22) <= 5 then
						BonusMomentsRemoteFunction:InvokeServer("Don Megalo", "Unlock")
						Quests['Don Megalo']['Progress'] = 2
					end
				elseif Quests['Don Megalo']['Progress'] == 2 then
					local Pos22 = CFrame.new(5321, 275, 793)
					tp({ Target = Pos22 })
					if dist(Pos22) <= 5 then
						Quests['Don Megalo']['Progress'] = 3
						BonusMomentsRemoteFunction:InvokeServer("Don Megalo", "TakeCape")
					end
				elseif Quests['Don Megalo']['Progress'] == 3 then 
					local Pos22 = CFrame.new(5321, 275, 793)
					tp({ Target = Pos22 })
					if dist(Pos22) <= 5 then
						Quests['Don Megalo']['Progress'] = 3
						BonusMomentsRemoteFunction:InvokeServer("Don Megalo", "ClaimCape")
					end
				end
			elseif not Data["Sea1/Sky/Electric Fighting Teacher"] then
				local ElectroQuestState = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ElectroQuestState")
				if Quests['Electric Fighting Teacher']['Progress'] == 0 then
					tp({ Target = CFrame.new(-4628, 12, -355) })
					if dist(CFrame.new(-4628, 12, -355)) <= 15 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer( "AcceptElectroQuest")
						Quests['Electric Fighting Teacher']['Progress'] = 1
					end
				elseif Quests['Electric Fighting Teacher']['Progress'] == 1 and CheckMaterialCount('Lightning Bolt') <= 0 then
					for _,v in ipairs(workspace.Map.Sky:GetChildren()) do
						if v:FindFirstChild('Cloud_Rumble_Indicator_Loop_01') then
							tp({ Target = v.CFrame })
							if dist(v.CFrame) <= 70 then
								EquipTools(_G.Select_Weapon)
								local viewportSize = workspace.CurrentCamera.ViewportSize
								local x, y = .5,.5
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
								task.wait(.4)
								VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
							end
						end
					end
				else
					tp({ Target = CFrame.new(-4628, 12, -355) })
					if dist(CFrame.new(-4628, 12, -355)) <= 15 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("DeliverLightningBolt")
					end
				end
			elseif not Data["Sea1/Sky/The Clown's Jewels"] and Workspace._WorldOrigin.PersistentParts:FindFirstChild('ClownJewelsCloud') then
				local Remotes = ReplicatedStorage:WaitForChild("Remotes")
				if CheckLocalEnemy() then
					KillLocalEnemy()
				elseif Workspace:FindFirstChild('ClownJewelsLockedChest') then
					local lockedChest = Workspace:FindFirstChild('ClownJewelsLockedChest')
					local chestCFrame = lockedChest:GetModelCFrame()
					
					tp({ Target = chestCFrame })
					if dist(chestCFrame) <= 30 then
						Remotes.BonusMomentsRemoteEvent:FireServer("The Clown's Jewels", "Provoke")
						Remotes.BonusMomentsRemoteEvent:FireServer("The Clown's Jewels", "BeginFight")
					end
				elseif Workspace:FindFirstChild('ClownJewelsChest') or Workspace:FindFirstChild('ClownJewelsChestHitbox') then
					local chest = Workspace:FindFirstChild('ClownJewelsChest') or Workspace:FindFirstChild('ClownJewelsChestHitbox')
					local targetCFrame = chest:IsA("Model") and chest:GetModelCFrame() or chest.CFrame
					
					tp({ Target = targetCFrame })
				elseif Workspace._WorldOrigin.PersistentParts:FindFirstChild('ClownJewelsCloud') then
					local ClownJewelsCloud = nil
					for _, v in ipairs(Workspace._WorldOrigin.PersistentParts.ClownJewelsClouds:GetChildren()) do
						if v.Name == "ClownJewelsCloud" then
							ClownJewelsCloud = v
							break
						end
					end

					if ClownJewelsCloud then
						tp({ Target = ClownJewelsCloud.CFrame })
						
						if dist(ClownJewelsCloud.CFrame) <= 70 then
							EquipTools(_G.Select_Weapon)
							local viewportSize = Workspace.CurrentCamera.ViewportSize
							local x, y = .5,.5

							VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
							task.wait(0.05)
							VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
						end
					end
				end

			elseif not Data["Sea1/Sky/Unexpected Guest"] and Data["Sea1/Sky/The Clown's Jewels"] and getDataSecretDoor() then
				repeat task.wait()
					if CheckLocalEnemy() then
						KillLocalEnemy()
					end
					game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer("Unexpected Guest","CutsceneDone")
					if Quests['Unexpected Guest']['Progress'] == 0 then
						tp({ Target = CFrame.new(-5035, 359, -1232) })
						if dist(CFrame.new(-5035, 359, -1232)) <= 15 then
							fireproximityprompt(SecretDoor.Part.ProximityPrompt)
							Quests['Unexpected Guest']['Progress'] = 1
						end
					elseif Quests['Unexpected Guest']['Progress'] == 1 then
						tp({Target = CFrame.new(-5009, 279, -1236)})
						if dist(CFrame.new(-5009, 279, -1236)) <= 15 then
							local code = BonusMomentsRemoteFunction:InvokeServer("Unexpected Guest", "ReadLetter")
							Quests['Unexpected Guest']['Code'] = code
						end
					elseif Quests['Unexpected Guest']['Progress'] == 1 and Quests['Unexpected Guest']['Code'] then
						tp({Target = CFrame.new(-5122, 281, -1227)})
						if dist(CFrame.new(-5122, 281, -1227)) <= 15 then
							local success = BonusMomentsRemoteFunction:InvokeServer("Unexpected Guest", "TryCode", Quests['Unexpected Guest']['Code'])
							BonusMomentsRemoteFunction:InvokeServer("Unexpected Guest", "TakeChest")
						end
					end
				until not _G.Settings[Expression] or Guide.TrackedPosition
			elseif not Data["Sea1/Underwater City/Fishman Karate"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Underwater City" then
					tp({ Target = CFrame.new(4050, -1, -1814) })
					if dist(CFrame.new(4050, -1, -1814)) <= 20 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.680007934570312, 1819.7840576171875) )
						task.wait(1)
						RemoveAllClip()
					end
					return
				end
				
				tp({ Target = CFrame.new(61678, 52, 1056) })
				if dist(CFrame.new(61678, 52, 1056)) <= 20 then
					BonusMomentsRemoteFunction:InvokeServer("Fishman Karate", "Complete")
				end
			elseif not Data["Sea1/Underwater City/Beyond the Bubble"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Underwater City" then
					tp({ Target = CFrame.new(4050, -1, -1814) })
					if dist(CFrame.new(4050, -1, -1814)) <= 20 then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163.8515625, 11.680007934570312, 1819.7840576171875) )
						task.wait(1)
						RemoveAllClip()
					end
					return
				end
				
				if CheckLocalEnemy() then
					KillLocalEnemy()
				end
				local chest = nil
				for _, v in pairs(CollectionService:GetTagged("CursedChest")) do
					if v:IsDescendantOf(workspace) then
						chest = v
						break
					end
				end
				if chest then
					local chestPart = chest:IsA("BasePart") and chest or chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart", true)
					if chestPart then
						tp({ Target = chestPart.CFrame })
						if dist(chestPart.CFrame) <= 20 then
							BonusMomentsRemoteFunction:InvokeServer( "Beyond the Bubble", "OpenChest")
						end
					end
				end
			elseif not Data["Sea1/Colosseum/King's Apprentice"] then
				if Client:GetAttribute('NearestLandLocation') ~= "Colosseum" then
					tp({ Target = CFrame.new(-1738, 13, -3253) })
					return
				end

				if CheckLocalEnemy() then
					KillLocalEnemy()
				end
				if Quests["King's Apprentice"]['Progress'] == 0 then
					tp({ Target = CFrame.new(-1849, 92, -3330) })
					if dist(CFrame.new(-1849, 92, -3330)) <= 5 then
						game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer("King's Apprentice","Interact")
						Quests["King's Apprentice"]['Progress'] = 1
					end
				elseif Quests["King's Apprentice"]['Progress'] == 1 then
					tp({ Target = CFrame.new(-1738, 13, -3253) })
					Quests["King's Apprentice"]['Time'] = Quests["King's Apprentice"]['Time'] or tick()
					if tick() - Quests["King's Apprentice"]['Time'] > 30 then
						Quests["King's Apprentice"]['Progress'] = 2
					end
				elseif Quests["King's Apprentice"]['Progress'] == 2 then
					tp({ Target = CFrame.new(-1849, 92, -3330) })
					if dist(CFrame.new(-1849, 92, -3330)) <= 5 then
						game:GetService("ReplicatedStorage").Remotes.BonusMomentsRemoteEvent:FireServer("King's Apprentice","Report")
					end
				end
			elseif not Data["Sea1/Colosseum/Legendary Creator Statues"] and NeedTypeTool({'Melee', 'Sword', 'Blox Fruit', 'Gun'}) and false then 
				if Client:GetAttribute('NearestLandLocation') ~= "Colosseum" then
					tp({ Target = CFrame.new(-1738, 13, -3253) })
					return
				end

				local allPodiums = PodiumClient:GetAll()
				if #allPodiums == 0 then
					return
				end
				for i, podium in ipairs(allPodiums) do
					local model = podium:GetModel()
					local podiumType = podium.PodiumType
					if podiumType == "Fruit" then
						podiumType = 'Demon Fruit'
					end

					if model and podiumType then
						tp({ Target = model:GetPivot() })
						EquipToolsType(podiumType)
						local viewportSize = workspace.CurrentCamera.ViewportSize
						local x, y = .5,.5
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
						task.wait(.4)
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
						task.wait(1)
					end
				end
			else
				--
			end
		end)
	end
end

loadFun['Auto Clown Jewels Cloud']= function()
	local Expression = 'Auto Clown Jewels Cloud'
	while _G.Settings[Expression] and task.wait() do
		loadFun['getPcall'](Expression, function()
			if not Sea1 then _C('TravelMain') return end
			local Remotes = ReplicatedStorage:WaitForChild("Remotes")
			if CheckLocalEnemy() then
				KillLocalEnemy()
			elseif Workspace:FindFirstChild('ClownJewelsLockedChest') then
				local lockedChest = Workspace:FindFirstChild('ClownJewelsLockedChest')
				local chestCFrame = lockedChest:GetModelCFrame()
				
				tp({ Target = chestCFrame })
				if dist(chestCFrame) <= 30 then
					RemoveAllClip()
					Remotes.BonusMomentsRemoteEvent:FireServer("The Clown's Jewels", "Provoke")
					Remotes.BonusMomentsRemoteEvent:FireServer("The Clown's Jewels", "BeginFight")
				end
			elseif Workspace:FindFirstChild('ClownJewelsChest') or Workspace:FindFirstChild('ClownJewelsChestHitbox') then
				local chest = Workspace:FindFirstChild('ClownJewelsChest') or Workspace:FindFirstChild('ClownJewelsChestHitbox')
				local targetCFrame = chest:IsA("Model") and chest:GetModelCFrame() or chest.CFrame
				
				tp({ Target = targetCFrame })
				if dist(targetCFrame) <= 30 then
					RemoveAllClip()
				end
			elseif Workspace._WorldOrigin.PersistentParts:FindFirstChild('ClownJewelsCloud') then
				local ClownJewelsCloud = nil
				for _, v in ipairs(Workspace._WorldOrigin.PersistentParts.ClownJewelsClouds:GetChildren()) do
					if v.Name == "ClownJewelsCloud" then
						ClownJewelsCloud = v
						break
					end
				end

				if ClownJewelsCloud then
					tp({ Target = ClownJewelsCloud.CFrame })
					
					if dist(ClownJewelsCloud.CFrame) <= 70 then
						EquipTools(_G.Select_Weapon)
						local viewportSize = Workspace.CurrentCamera.ViewportSize
						local x, y = .5,.5

						VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
						task.wait(0.05)
						VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
					end
				end
			end
		end)
	end
end

local Remote_GetFruits = game.ReplicatedStorage:FindFirstChild("Remotes").CommF_:InvokeServer("GetFruits");
Table_DevilFruitSniper = {}
ShopDevilSell = {}
for i,v in next,Remote_GetFruits do
	table.insert(Table_DevilFruitSniper,v.Name)
	if v.OnSale then 
		table.insert(ShopDevilSell,v.Name)
	end
end

CollectedFruit = {}
StoredSuccessFully = 0
function toServerFruit(Text)
	local Slice = Text:split(":")
	return (Slice[1].."-"..Slice[1]..((Slice[2] and ":"..Slice[2]) or "")):gsub(" Fruit","")
end

function printMinutesAndSeconds()
	local currentTime = game:GetService("Lighting").ClockTime * 60
	local targetTime = 18.2 * 60

	local remainingTime = targetTime - currentTime
	local remainingMinutes = math.floor(remainingTime / 60)
	local remainingSeconds = math.floor(remainingTime % 60) - 20

	if remainingMinutes >= 0 and remainingSeconds >= 0 then
		return "Next Moon In : " .. remainingMinutes .. " m, " .. remainingSeconds .. " s 🌑"
	else
		return "Wait End Moon 🌑"
	end
end

local function getNextRedCommanderSpawn()
    local t = os.date("!*t", os.time())
    local minute = t.min
    local hour = t.hour
    
    if minute < 30 then
        t.min = 30
    else
        t.hour = t.hour + 1
        t.min = 30
    end
    t.sec = 0
    
    return os.time(t)
end

local getBossTime = function()
    local now = os.time()
    local nextSpawn = getNextRedCommanderSpawn()
    local remain = nextSpawn - now

    local hours = math.floor(remain / 3600)
    remain = remain % 3600
    local minutes = math.floor(remain / 60)
    local seconds = remain % 60

    return hours, minutes, seconds
end

local t,T = {}, {}
task.spawn(function()
	while task.wait(.2) do
		local s,e = pcall(function()
			if _G.Settings.Auto_Stats then
				for _,g in next, _G.Settings.Select_Stats do
					if Client.Data.Points.Value > 0 then
						_C("AddPoint",tostring(g),_G.Settings.Point)
					end
				end
			end
			pcall(function() t['FPS']:Set("Player FPS : " .. tostring(math.clamp(math.floor(Util.FPSTracker.FPS) + 5, 0, 60))) end)
			t['Berries']:Set("Berries Spawn : NOT SPAWN")
			for i,PathBerries in pairs(CollectionService:GetTagged("BerryBush")) do
				if  PathBerries:GetAttribute("_BerryCFrame1") or PathBerries:GetAttribute("_BerryCFrame2") or PathBerries:GetAttribute("_BerryCFrame3") or PathBerries:GetAttribute("_BerryCFrame4") or PathBerries:GetAttribute("_BerryCFrame5") or PathBerries:GetAttribute("_BerryCFrame6") or PathBerries:GetAttribute("_BerryCFrame7") or PathBerries:GetAttribute("_BerryCFrame8")  then
					t['Berries']:Set("Berries Spawn : SPAWN")
				end
			end
			if _G.Settings.Auto_Buy_Devil_Fruit then
				game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("PurchaseRawFruit",_G.Settings.Select_Devil_Fruit,false)
			end
			if _G.Settings.Auto_Random_Fruit then
				_C("Cousin","Buy")
			end
			if _G.Settings.Auto_Store_Fruit then
				local Stored = 0
				local MyFruit = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")
				for i,v in pairs(Client.Backpack:GetChildren()) do
					if v.Name:find("Fruit") and not table.find(CollectedFruit,v.Name) then
						local Name = toServerFruit(v.Name)
						_C("StoreFruit",Name,v)
						Stored = Stored + 1
						table.insert(CollectedFruit,v.Name)
					end
				end
				for i,v in pairs(Client.Character:GetChildren()) do
					if v.Name:find("Fruit") and not table.find(CollectedFruit,v.Name) then
						local Name = toServerFruit(v.Name)
						_C("StoreFruit",Name,v)
						Stored = Stored + 1
						table.insert(CollectedFruit,v.Name)
					end
				end
				StoredSuccessFully = tick()
			end
			if _G.Stats_Moon and _G.Stats_Moon_Time and game:GetService("Lighting"):FindFirstChild('Sky') then
				_G.Stats_Moon_Time:Set(printMinutesAndSeconds())
				if game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149431" then
					_G.Stats_Moon:Set("Stats Moon : 100% 🌕")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149052" then
					_G.Stats_Moon:Set("Stats Moon : 75% 🌖")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709143733" then
					_G.Stats_Moon:Set("Stats Moon : 50% 🌗")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709150086" then
					_G.Stats_Moon:Set("Stats Moon : 50% 🌓")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709150401" then
					_G.Stats_Moon:Set("Stats Moon : 25% 🌒")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709149680" then
					_G.Stats_Moon:Set("Stats Moon : 75% 🌔")
				elseif game:GetService("Lighting").Sky.MoonTextureId=="http://www.roblox.com/asset/?id=9709135895" then
					_G.Stats_Moon:Set("Stats Moon : 0% 🌑")
				else
					_G.Stats_Moon:Set("Stats Moon : 25% 🌘")
				end
			end
			if _G.Settings['Walk On Water'] then
				Client.Character:SetAttribute('WaterWalking', _G.Settings['Walk On Water'])
			end
			if _G.Settings['Romove Fog'] then
				game:GetService("Lighting").FogEnd = math.huge
			end
			if _G.Settings['daytimd'] then
				game:GetService("Lighting").TimeOfDay = '12:00:00'
			end
			if _G.Settings.SelectWeapon == "Melee" then
				for i ,v in pairs(Client.Backpack:GetChildren()) do
					if v.ToolTip == "Melee" then
						if Client.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
				for i ,v in pairs(Client.Character:GetChildren()) do
					if v.ToolTip == "Melee" then
						if Client.Character:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
			elseif _G.Settings.SelectWeapon == "Sword" then
				for i ,v in pairs(Client.Backpack:GetChildren()) do
					if v.ToolTip == "Sword" then
						if Client.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
				for i ,v in pairs(Client.Character:GetChildren()) do
					if v.ToolTip == "Sword" then
						if Client.Character:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
			elseif _G.Settings.SelectWeapon == "Fruit" then
				for i ,v in pairs(Client.Backpack:GetChildren()) do
					if v.ToolTip == "Blox Fruit" then
						if Client.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
				for i ,v in pairs(Client.Character:GetChildren()) do
					if v.ToolTip == "Blox Fruit" then
						if Client.Character:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
			else
				for i ,v in pairs(Client.Backpack:GetChildren()) do
					if v.ToolTip == "Melee" then
						if Client.Backpack:FindFirstChild(tostring(v.Name)) then
							_G.Select_Weapon = v.Name
						end
					end
				end
			end
			
			-- Set Text
			t['BoneCount']:Set("🦴 Bone Count : "..CheckMaterialCount("Bones"))
			t['Summer Token']:Set('Summer Token : '..CheckMaterialCount("Summer Token"))
			local h, m, s = getBossTime()
			t['Oni Token']:Set('Celestial Token : '..CheckMaterialCount("Celestial Token") ..'\n'.. string.format("Next Boss in: %02d:%02d:%02d ", h, m, s))
			if getPainCloudZone() then
				t['haveCloud']:Set( "⛈️ Cloud Zone : 🟢" )
			else
				t['haveCloud']:Set( "⛈️ Cloud Zone : 🔴" )
			end
			local len = string.len(_C("CakePrinceSpawner"))
			local kills = string.match(_C("CakePrinceSpawner"),"%d+")
			t['Cake Kill']:Set(len >= 86 and "Kill : [ ".. kills .." ]" or "['Boss Is Spawned!!!']")
			t['EliteMon']:Set("Total Elite Hunter : ".. tostring(_C("EliteHunter","Progress")) or 0) 
			 
			if Entity.find({'Tyrant of the Skies'}) then
				t['have Tyrant of the Skies']:Set('☁️ Tyrant of the Skies : 🟢')
			else
				t['have Tyrant of the Skies']:Set('☁️ Tyrant of the Skies : 🔴')
			end
			
			if Entity.find({"Red Commander"}) and Entity.find({"Oni Soldier"}) then
				t['have Oni Event']:Set('👹 Oni Event : 🟢 ( Boss And  Soldier)')
			else
				if Entity.find({"Red Commander"}) then
					t['have Oni Event']:Set('👹 Oni Event : 🟢 ( Boss )')
				elseif  Entity.find({"Oni Soldier"}) then
					t['have Oni Event']:Set('👹 Oni Event : 🟢 ( Soldier )')
				else
					t['have Oni Event']:Set('👹 Oni Event : Not Have 🔴')
				end
			end
			if workspace.Map:FindFirstChild("KitsuneIsland") then
				t['Kitsune Island']:Set("Kitsune Island : 🟢") 
			else 
				t['Kitsune Island']:Set("Kitsune Island : 🔴") 
			end
		end)
		--if not s then warn('[Debug] All Loop :', e) end
	end
end)

-- ============================================================
-- Language system (EN / TH)  |  เลือกภาษาได้ที่ Settings > Language
-- ============================================================
do
	local D = {
		-- Tabs / headers
		["Default"] = "ค่าเริ่มต้น",
		["Automatic"] = "อัตโนมัติ",
		["Shoping"] = "ร้านค้า",
		["TP & WebHook"] = "วาร์ป & เว็บฮุก",
		["Misc"] = "อื่นๆ",
		["Settings"] = "ตั้งค่า",
		["Debug (F9 Console)"] = "ดีบัก (คอนโซล F9)",
		["General"] = "ทั่วไป",
		["Other"] = "อื่นๆ",
		["Other Page1"] = "อื่นๆ หน้า 1",
		["Other Page2"] = "อื่นๆ หน้า 2",
		["Teleports"] = "วาร์ป",
		["Teleport World"] = "วาร์ปข้ามซี",
		["Web Hooks"] = "เว็บฮุก",
		["Web Hooks Soon"] = "เว็บฮุก (เร็วๆ นี้)",
		["Summer Event"] = "อีเวนต์ซัมเมอร์",
		["Fishing"] = "ตกปลา",
		["Chests"] = "หีบ",

		-- Farm / Auto
		["Auto Farm Level"] = "ออโต้ฟาร์มเลเวล",
		["Auto Farm Boss"] = "ออโต้ฟาร์มบอส",
		["Auto Kill Boss"] = "ออโต้ฆ่าบอส",
		["Auto Farm Bone"] = "ออโต้ฟาร์มกระดูก",
		["Auto Farm Bounty Hunter"] = "ออโต้ล่าค่าหัว",
		["Auto Farm All Mastery Sword"] = "ออโต้ฟาร์มมาสเตอรี่ดาบทั้งหมด",
		["Farm All Mastery Sword"] = "ฟาร์มมาสเตอรี่ดาบทั้งหมด",
		["Auto Kill Enemies Aura"] = "ออโต้ฆ่าศัตรูรอบตัว (ออร่า)",
		["Auto Chests"] = "ออโต้เก็บหีบ",
		["Auto Berries"] = "ออโต้เก็บเบอร์รี่",
		["Auto Bring Fruit"] = "ออโต้เก็บผลปีศาจ",
		["Auto Store Fruit"] = "ออโต้เก็บผลปีศาจเข้าคลัง",
		["Auto Random Fruit"] = "ออโต้สุ่มผลปีศาจ",
		["Auto Buy Devil Fruit"] = "ออโต้ซื้อผลปีศาจ",
		["Auto Buy Legendary Swords"] = "ออโต้ซื้อดาบเลเจนดารี",
		["Auto Buy Legendary Sword"] = "ออโต้ซื้อดาบเลเจนดารี",
		["Auto Buy Microchip"] = "ออโต้ซื้อไมโครชิป",
		["Auto Buy Bait"] = "ออโต้ซื้อเหยื่อตกปลา",
		["Auto Stats"] = "ออโต้อัปสเตตัส",
		["Auto Use Skill"] = "ออโต้ใช้สกิล",
		["Auto Haki (Buso)"] = "ออโต้ฮาคิ (Buso)",
		["Auto Look Moon"] = "ออโต้มองดวงจันทร์",
		["Auto Player Position"] = "ออโต้ตามตำแหน่งผู้เล่น",
		["Auto Fishing"] = "ออโต้ตกปลา",
		["Auto Material"] = "ออโต้วัตถุดิบ",
		["Auto World"] = "ออโต้ข้ามซี",
		["Auto New World"] = "ออโต้ไปซีที่ 2",
		["Auto Third World"] = "ออโต้ไปซีที่ 3",
		["Auto Go New Island 2650+"] = "ออโต้ไปเกาะใหม่ 2650+",
		["Auto Complete Trial"] = "ออโต้ทำด่านทดสอบ (Trial)",
		["Auto Quest Secrets"] = "ออโต้เควสความลับ",
		["Quest Secrets Hop"] = "เควสความลับ (เปลี่ยนเซิร์ฟ)",
		["Auto Hit Core"] = "ออโต้ตีคอร์",

		-- Quests / items / events
		["Auto Awakening One Quest"] = "ออโต้เควสปลุกพลัง (Awakening)",
		["Auto Bartilo Quest"] = "ออโต้เควส Bartilo",
		["Bartilo Quest"] = "เควส Bartilo",
		["Auto Blaze Ember"] = "ออโต้ Blaze Ember",
		["Auto Cake Prince"] = "ออโต้เจ้าชายเค้ก (Cake Prince)",
		["Cake Prince"] = "เจ้าชายเค้ก (Cake Prince)",
		["Auto Castle Raid"] = "ออโต้เรดปราสาท",
		["Auto Clear Dungeons"] = "ออโต้เคลียร์ดันเจี้ยน",
		["Auto Dungeons"] = "ออโต้ดันเจี้ยน",
		["Auto Dungeon ( New )"] = "ออโต้ดันเจี้ยน ( ใหม่ )",
		["Auto Join Dungeon ( New )"] = "ออโต้เข้าดันเจี้ยน ( ใหม่ )",
		["Auto Join Dungeon New"] = "ออโต้เข้าดันเจี้ยนใหม่",
		["Auto Clown Jewels Cloud"] = "ออโต้เก็บอัญมณีตัวตลก (Cloud)",
		["Auto Collect Dragon Bones"] = "ออโต้เก็บกระดูกมังกร",
		["Auto Collect Dragon Eggs"] = "ออโต้เก็บไข่มังกร",
		["Auto Cursed Dual Katana"] = "ออโต้คาตานะคู่สาปแช่ง (CDK)",
		["Cursed Dual Katana"] = "คาตานะคู่สาปแช่ง (CDK)",
		["Auto Cyborg Race"] = "ออโต้เผ่าไซบอร์ก",
		["Auto Races V2"] = "ออโต้เผ่า V2",
		["Auto Evo Race [V2]"] = "ออโต้อัปเผ่า [V2]",
		["Races V4"] = "เผ่า V4",
		["Auto Dojo Quest"] = "ออโต้เควสโดโจ",
		["Auto Elite Hunter"] = "ออโต้ Elite Hunter",
		["Auto Fighting style"] = "ออโต้สไตล์การต่อสู้",
		["Do Fighting style"] = "ทำสไตล์การต่อสู้",
		["Auto Find Bisento [V2]"] = "ออโต้หา Bisento [V2]",
		["Bisento V2"] = "Bisento V2",
		["Auto Find MidnightBlade"] = "ออโต้หา MidnightBlade",
		["Auto Find Pole"] = "ออโต้หา Pole",
		["Auto Find Pole( Hop )"] = "ออโต้หา Pole ( เปลี่ยนเซิร์ฟ )",
		["Auto Find Rengoku"] = "ออโต้หา Rengoku",
		["Auto Find Saber"] = "ออโต้หา Saber",
		["Auto Oni Event"] = "ออโต้อีเวนต์ Oni",
		["Auto Pain Boss Event"] = "ออโต้อีเวนต์บอส Pain",
		["Pain Boss Event"] = "อีเวนต์บอส Pain",
		["Auto Relic Events"] = "ออโต้อีเวนต์ Relic",
		["Auto Rip Eevet"] = "ออโต้อีเวนต์ Rip",
		["Auto Soul Guitar Quest"] = "ออโต้เควส Soul Guitar",
		["Auto Soul Guitar"] = "ออโต้ Soul Guitar",
		["Auto Token Summer Event"] = "ออโต้เก็บโทเคนอีเวนต์ซัมเมอร์",
		["Auto Trading Bone"] = "ออโต้แลกกระดูก",
		["Auto Tushita"] = "ออโต้ Tushita",
		["Auto Yama"] = "ออโต้ Yama",
		["Auto Yama Fully"] = "ออโต้ Yama แบบเต็ม",
		["Auto Tyrant of the Skies"] = "ออโต้ Tyrant of the Skies",
		["Roll Something Event"] = "ทอยอีเวนต์",
		["Get Free Rod"] = "รับเบ็ดฟรี",
		["User Candys"] = "ใช้ลูกอม",
		["Find Material"] = "หาวัตถุดิบ",
		["Material FirstSea"] = "วัตถุดิบ ซี 1",
		["Material SecondSea"] = "วัตถุดิบ ซี 2",
		["Material ThirdSea"] = "วัตถุดิบ ซี 3",

		-- Shop
		["Devil Fruit Shop"] = "ร้านผลปีศาจ",
		["Ability Shop"] = "ร้านความสามารถ",
		["Accessory Shop"] = "ร้านเครื่องประดับ",
		["Fighting Style Shop"] = "ร้านสไตล์การต่อสู้",
		["Guns Shop"] = "ร้านปืน",
		["Races&Fragment Shop"] = "ร้านเผ่า & Fragment",
		["Swords Shop"] = "ร้านดาบ",
		["Buy Bait"] = "ซื้อเหยื่อ",
		["Buy Buso Haki"] = "ซื้อฮาคิ Buso",
		["Buy Cyborg"] = "ซื้อเผ่าไซบอร์ก",
		["Buy DragonClaw"] = "ซื้อ DragonClaw",
		["Buy Fruits Summer Event"] = "ซื้อผลปีศาจอีเวนต์ซัมเมอร์",
		["Buy Geppo"] = "ซื้อ Geppo",
		["Buy Kabucha"] = "ซื้อ Kabucha",
		["Buy Ken Haki"] = "ซื้อฮาคิ Ken",
		["Buy Microchip"] = "ซื้อไมโครชิป",
		["Buy Race Ghoul"] = "ซื้อเผ่ากูล (Ghoul)",
		["Buy Random Race"] = "ซื้อสุ่มเผ่า",
		["Buy Reset Stats"] = "ซื้อรีเซ็ตสเตตัส",
		["Buy Soru"] = "ซื้อ Soru",
		["Buy"] = "ซื้อ",

		-- Teleport / world
		["First World [1]"] = "ซีที่ 1 [1]",
		["Second World [2]"] = "ซีที่ 2 [2]",
		["Third World [3]"] = "ซีที่ 3 [3]",
		["Teleport to Player"] = "วาร์ปไปหาผู้เล่น",
		["Teleport to"] = "วาร์ปไป",
		["Teleport Kitsune Island"] = "วาร์ปไปเกาะ Kitsune",
		["Teleport To EmberTemplate"] = "วาร์ปไป EmberTemplate",
		["Go To Room Radc V4"] = "ไปห้องเผ่า V4",
		["Start Tween Island"] = "เริ่มบินไปเกาะ",
		["Kitsune Island"] = "เกาะ Kitsune",
		["ESP Kitsune Island"] = "ESP เกาะ Kitsune",
		["Start Kitsune"] = "เริ่ม Kitsune",
		["Start Dungeons"] = "เริ่มดันเจี้ยน",
		["Hop"] = "เปลี่ยนเซิร์ฟ",
		["Hop Low"] = "เปลี่ยนเซิร์ฟ (คนน้อย)",
		["Rejoin"] = "เข้าเซิร์ฟใหม่",
		["Redeem All Code"] = "ใช้โค้ดทั้งหมด",

		-- Select / settings
		["Select Weapon"] = "เลือกอาวุธ",
		["Select Skill"] = "เลือกสกิล",
		["Select Stats"] = "เลือกสเตตัส",
		["Select Point"] = "เลือกจำนวนแต้ม",
		["Select Boss"] = "เลือกบอส",
		["Select Devil Fruit"] = "เลือกผลปีศาจ",
		["Select Difficulty"] = "เลือกความยาก",
		["Select How to Complete"] = "เลือกวิธีทำให้สำเร็จ",
		["Select Island"] = "เลือกเกาะ",
		["Select Mode Reel"] = "เลือกโหมดกรอเบ็ด",
		["Select Player"] = "เลือกผู้เล่น",
		["Select Player Position"] = "เลือกตำแหน่งผู้เล่น",
		["Select Type Dungeon"] = "เลือกประเภทดันเจี้ยน",
		["Select Type Fighting style"] = "เลือกประเภทสไตล์การต่อสู้",
		["Refres Select Boss Manu"] = "รีเฟรชรายชื่อบอส",
		["Bring Mob"] = "ดึงมอนมารวม",
		["Enemies Aura"] = "ระยะออร่าศัตรู",
		["Aim Bot FOV"] = "ระยะ FOV เอมบอท",
		["Aim Bot Skill Player"] = "เอมบอทสกิลใส่ผู้เล่น",
		["Walk On Water"] = "เดินบนน้ำ",
		["Walk Speed"] = "ความเร็วเดิน",
		["Set Walk Speed"] = "ตั้งความเร็วเดิน",
		["Jump Power"] = "พลังกระโดด",
		["Set Jump Power"] = "ตั้งพลังกระโดด",
		["Fix Bug Walk / Jump"] = "แก้บั๊กเดิน / กระโดด",
		["Noclip"] = "ทะลุสิ่งกีดขวาง (Noclip)",
		["Romove Fog"] = "ลบหมอก",
		["Set day time"] = "ตั้งเวลากลางวัน",
		["RemoveAllClip"] = "ลบ Clip ทั้งหมด",
		["Bait Num"] = "จำนวนเหยื่อ",
		["Name Position Fish"] = "ชื่อตำแหน่งตกปลา",
		["Save Position Fish"] = "บันทึกตำแหน่งตกปลา",
		["Sell Fish"] = "ขายปลา",

		-- Status labels (dynamic)
		["Player FPS"] = "FPS ผู้เล่น",
		["Bone Count"] = "จำนวนกระดูก",
		["Summer Token"] = "โทเคนซัมเมอร์",
		["Celestial Token"] = "โทเคนสวรรค์ (Celestial)",
		["Oni Token"] = "โทเคน Oni",
		["Next Boss in"] = "บอสถัดไปใน",
		["Total Elite Hunter"] = "Elite Hunter ทั้งหมด",
		["Total"] = "ทั้งหมด",
		["Cake Kill"] = "ฆ่าเค้ก",
		["Kill :"] = "ฆ่า :",
		["Boss Is Spawned!!!"] = "บอสเกิดแล้ว!!!",
		["Berries Spawn"] = "เบอร์รี่เกิด",
		["NOT SPAWN"] = "ยังไม่เกิด",
		["SPAWN"] = "เกิดแล้ว",
		["Stats Moon"] = "ดวงจันทร์",
		["Time Next Moon"] = "เวลาดวงจันทร์ถัดไป",
		["Next Moon In"] = "ดวงจันทร์ถัดไปใน",
		["Wait End Moon"] = "รอดวงจันทร์สิ้นสุด",
		["Cloud Zone"] = "โซนเมฆ",
		["Oni Event"] = "อีเวนต์ Oni",
		["Not Have"] = "ไม่มี",
		["( Boss And  Soldier)"] = "( บอส และ ทหาร )",
		["( Boss )"] = "( บอส )",
		["( Soldier )"] = "( ทหาร )",
		["Tyrant of the Skies"] = "ทรราชแห่งท้องฟ้า",
	}

	-- fallback prefixes for names built at runtime
	local PrefixRules = {
		{ "Auto ", "ออโต้ " },
		{ "Select ", "เลือก " },
		{ "Buy ", "ซื้อ " },
		{ "Teleport ", "วาร์ป " },
		{ "Farm ", "ฟาร์ม " },
	}

	local Phrases = {}
	for k in pairs(D) do
		if #k >= 5 then table.insert(Phrases, k) end
	end
	table.sort(Phrases, function(a, b)
		if #a ~= #b then return #a > #b end
		return a < b
	end)

	local cache, cacheN = {}, 0
	local function isAlnum(c) return c ~= "" and c:match("^%w$") ~= nil end

	local function replacePhrase(s, key, val)
		local out, pos = {}, 1
		local firstAlnum = isAlnum(key:sub(1, 1))
		local lastAlnum = isAlnum(key:sub(-1))
		while true do
			local i, j = s:find(key, pos, true)
			if not i then break end
			local before = i > 1 and s:sub(i - 1, i - 1) or ""
			local after = s:sub(j + 1, j + 1)
			if (firstAlnum and isAlnum(before)) or (lastAlnum and isAlnum(after)) then
				table.insert(out, s:sub(pos, i))
				pos = i + 1
			else
				table.insert(out, s:sub(pos, i - 1))
				table.insert(out, val)
				pos = j + 1
			end
		end
		table.insert(out, s:sub(pos))
		return table.concat(out)
	end

	-- Translate a string to the current language (returns it unchanged for EN)
	function TR(s)
		if type(s) ~= "string" or s == "" or _G.Settings.Language ~= "TH" then return s end
		local hit = cache[s]
		if hit then return hit end
		local result
		local pre, core, suf = s:match("^([^%w]*)(.-)([^%w%)%]]*)$")
		if core and D[core] then
			result = pre .. D[core] .. suf
		else
			result = s
			for _, key in ipairs(Phrases) do
				if result:find(key, 1, true) then
					result = replacePhrase(result, key, D[key])
				end
			end
			if result == s then
				for _, rule in ipairs(PrefixRules) do
					if s:sub(1, #rule[1]) == rule[1] then
						result = rule[2] .. s:sub(#rule[1] + 1)
						break
					end
				end
			end
		end
		if cacheN > 600 then cache, cacheN = {}, 0 end
		cache[s] = result
		cacheN += 1
		return result
	end

	local function insidePopup(d)
		local a = d.Parent
		while a do
			if (a.Name == "Dropdown" or a.Name == "ColorPicker") and a.Parent and a.Parent.Name == "Main" then
				return true
			end
			a = a.Parent
		end
		return false
	end

	local function translateInstance(d)
		if not (d:IsA("TextLabel") or d:IsA("TextButton")) then return end
		local cur = d.Text
		if cur == "" or insidePopup(d) then return end
		local en, th = d:GetAttribute("ZH_EN"), d:GetAttribute("ZH_TH")
		if _G.Settings.Language == "TH" then
			if en and cur == th then return end -- already translated
			local t = TR(cur)
			if t ~= cur then
				d:SetAttribute("ZH_EN", cur)
				d:SetAttribute("ZH_TH", t)
				d.Text = t
			end
		else
			if en and cur == th then
				d.Text = en
			end
			if en then
				d:SetAttribute("ZH_EN", nil)
				d:SetAttribute("ZH_TH", nil)
			end
		end
	end

	local function getGuis()
		local list = {}
		local a = COREGUI:FindFirstChild("yesheeGUI")
		if a then table.insert(list, a) end
		local pg = Client:FindFirstChild("PlayerGui")
		local b = pg and pg:FindFirstChild("yesheeGUI")
		if b and b ~= a then table.insert(list, b) end
		-- Also include our custom Luxion-style UI so EN/TH translation applies
		local c = pg and pg:FindFirstChild("LuxionHubUI")
		if c then table.insert(list, c) end
		return list
	end

	-- Re-translate every visible label (called when the language changes)
	function ApplyLanguage()
		for _, gui in ipairs(getGuis()) do
			for _, d in ipairs(gui:GetDescendants()) do
				pcall(translateInstance, d)
			end
		end
	end

	-- Hook the UI window: translate new labels + dynamic Label:Set() text
	function HookLanguage(win)
		for _, gui in ipairs(getGuis()) do
			gui.DescendantAdded:Connect(function(d)
				if _G.Settings.Language == "TH" then
					task.defer(function() pcall(translateInstance, d) end)
				end
			end)
		end

		local oldAddTap = win.AddTap
		win.AddTap = function(options)
			local tab = oldAddTap(options)
			if tab and tab.CreatePage then
				local oldCreatePage = tab.CreatePage
				tab.CreatePage = function(o)
					local sec = oldCreatePage(o)
					if sec and sec.CreateLable then
						local oldLabel = sec.CreateLable
						sec.CreateLable = function(lo)
							local lbl = oldLabel(lo)
							if lbl and lbl.Set then
								local rawSet = lbl.Set
								lbl.Set = function(self, v) return rawSet(self, TR(v)) end
							end
							return lbl
						end
					end
					return sec
				end
			end
			return tab
		end
	end
end

-- ============================================================
-- LUXION-STYLE CUSTOM UI LIBRARY (replaces yesHeeOpenScrKubb)
-- API-compatible: Library.Create / AddTap / CreatePage /
-- CreateToggle / CreateButton / CreateDropdown / CreateSlider /
-- CreateLable / CreateInput / Notify
-- Visual theme taken from ยูไอจ้าาา.lua (dark navy + blue accent)
-- ============================================================
local Library = (function()
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	-- Remove old instance if re-run
	if PlayerGui:FindFirstChild("LuxionHubUI") then
		PlayerGui.LuxionHubUI:Destroy()
	end

	-- ---------- Theme (from ยูไอจ้าาา.lua) ----------
	local Theme = {
		MainBg      = Color3.fromRGB(11, 15, 25),
		SidebarBg   = Color3.fromRGB(7, 10, 16),
		CardBg      = Color3.fromRGB(16, 22, 36),
		CardBgHover = Color3.fromRGB(22, 32, 55),
		Accent      = Color3.fromRGB(50, 140, 255),
		AccentDim   = Color3.fromRGB(25, 35, 55),
		Text        = Color3.fromRGB(255, 255, 255),
		TextMuted   = Color3.fromRGB(110, 125, 150),
		ToggleOff   = Color3.fromRGB(30, 40, 60),
		Stroke      = Color3.fromRGB(25, 35, 55),
	}

	-- Icon asset IDs (known-good, from ยูไอจ้าาา.lua icon set)
	local Icons = {
		Default = "rbxassetid://6031068426",
		Auto    = "rbxassetid://6031094678",
		Shop    = "rbxassetid://6031075931",
		TP      = "rbxassetid://6031082533",
		Player  = "rbxassetid://6031082920",
		Logo    = "rbxassetid://91099679470963",
	}
	local function pickIcon(text)
		local t = string.lower(text or "")
		if string.find(t, "auto") or string.find(t, "farm") or string.find(t, "boss") then return Icons.Auto end
		if string.find(t, "shop") or string.find(t, "fruit") or string.find(t, "buy") or string.find(t, "material") then return Icons.Shop end
		if string.find(t, "tp") or string.find(t, "teleport") or string.find(t, "webhook") or string.find(t, "island") or string.find(t, "world") then return Icons.TP end
		if string.find(t, "player") or string.find(t, "misc") or string.find(t, "setting") then return Icons.Player end
		return Icons.Default
	end

	-- Strip emojis / non-text symbols; keep ASCII printable + Thai + newline
	local function cleanText(str)
		if str == nil then return "" end
		str = tostring(str)
		local out = {}
		local i = 1
		while i <= #str do
			local b = string.byte(str, i)
			if b < 0x80 then
				if b >= 0x20 or b == 0x0A then table.insert(out, string.sub(str, i, i)) end
				i = i + 1
			elseif b == 0xE0 then
				local b2 = string.byte(str, i + 1) or 0
				if b2 == 0xB8 or b2 == 0xB9 then -- Thai block U+0E00-U+0E7F
					table.insert(out, string.sub(str, i, i + 2))
				end
				i = i + 3
			elseif b >= 0xC2 and b <= 0xDF then
				i = i + 2
			elseif b >= 0xE1 and b <= 0xEF then
				i = i + 3
			elseif b >= 0xF0 and b <= 0xF4 then
				i = i + 4
			else
				i = i + 1
			end
		end
		local r = table.concat(out)
		r = string.gsub(r, "%s+", " ")
		r = string.gsub(r, "^%s+", "")
		r = string.gsub(r, "%s+$", "")
		return r
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "LuxionHubUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = PlayerGui

	-- ---------- Loading screen ----------
	local LoadFrame = Instance.new("Frame")
	LoadFrame.Name = "LoadFrame"
	LoadFrame.Size = UDim2.new(0, 320, 0, 180)
	LoadFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
	LoadFrame.BackgroundColor3 = Theme.MainBg
	LoadFrame.BorderSizePixel = 0
	LoadFrame.ClipsDescendants = true
	LoadFrame.Parent = ScreenGui
	local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0,12); lc.Parent = LoadFrame
	local ls = Instance.new("UIStroke"); ls.Color = Theme.Accent; ls.Thickness = 1.5; ls.Parent = LoadFrame

	local LoadIcon = Instance.new("ImageLabel")
	LoadIcon.Size = UDim2.new(0,50,0,50); LoadIcon.Position = UDim2.new(0.5,-25,0,18)
	LoadIcon.BackgroundTransparency = 1; LoadIcon.Image = "rbxassetid://91099679470963"
	LoadIcon.Parent = LoadFrame
	local lic = Instance.new("UICorner"); lic.CornerRadius = UDim.new(1,0); lic.Parent = LoadIcon

	local LoadTitle = Instance.new("TextLabel")
	LoadTitle.Size = UDim2.new(1,0,0,25); LoadTitle.Position = UDim2.new(0,0,0,75)
	LoadTitle.BackgroundTransparency = 1; LoadTitle.Text = "LUXION HUB"
	LoadTitle.TextColor3 = Theme.Text; LoadTitle.Font = Enum.Font.GothamBold; LoadTitle.TextSize = 16
	LoadTitle.Parent = LoadFrame

	local LoadStatus = Instance.new("TextLabel")
	LoadStatus.Size = UDim2.new(1,0,0,18); LoadStatus.Position = UDim2.new(0,0,0,100)
	LoadStatus.BackgroundTransparency = 1; LoadStatus.Text = "Loading... 0%"
	LoadStatus.TextColor3 = Theme.TextMuted; LoadStatus.Font = Enum.Font.Gotham; LoadStatus.TextSize = 11
	LoadStatus.Parent = LoadFrame

	local BarBg = Instance.new("Frame")
	BarBg.Size = UDim2.new(0.8,0,0,6); BarBg.Position = UDim2.new(0.1,0,0,132)
	BarBg.BackgroundColor3 = Color3.fromRGB(20,28,45); BarBg.BorderSizePixel = 0; BarBg.Parent = LoadFrame
	local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1,0); bbc.Parent = BarBg
	local BarFill = Instance.new("Frame")
	BarFill.Size = UDim2.new(0,0,1,0); BarFill.BackgroundColor3 = Theme.Accent; BarFill.BorderSizePixel = 0; BarFill.Parent = BarBg
	local bfc = Instance.new("UICorner"); bfc.CornerRadius = UDim.new(1,0); bfc.Parent = BarFill

	-- ---------- Notification system ----------
	local function ShowNotification(titleText, descText)
		local NotifFrame = Instance.new("Frame")
		NotifFrame.Size = UDim2.new(0,280,0,65)
		NotifFrame.Position = UDim2.new(1,10,1,-80)
		NotifFrame.BackgroundColor3 = Color3.fromRGB(14,20,32)
		NotifFrame.BorderSizePixel = 0
		NotifFrame.Parent = ScreenGui
		local nc = Instance.new("UICorner"); nc.CornerRadius = UDim.new(0,8); nc.Parent = NotifFrame
		local ns = Instance.new("UIStroke"); ns.Color = Theme.Accent; ns.Thickness = 1; ns.Parent = NotifFrame

		local NotifIcon = Instance.new("ImageLabel")
		NotifIcon.Size = UDim2.new(0,36,0,36); NotifIcon.Position = UDim2.new(0,12,0.5,-18)
		NotifIcon.BackgroundTransparency = 1; NotifIcon.Image = "rbxassetid://91099679470963"
		NotifIcon.Parent = NotifFrame
		local nic = Instance.new("UICorner"); nic.CornerRadius = UDim.new(1,0); nic.Parent = NotifIcon

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Size = UDim2.new(0,200,0,18); NotifTitle.Position = UDim2.new(0,58,0,12)
		NotifTitle.BackgroundTransparency = 1; NotifTitle.Text = titleText
		NotifTitle.TextColor3 = Theme.Text; NotifTitle.Font = Enum.Font.GothamBold; NotifTitle.TextSize = 12
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left; NotifTitle.Parent = NotifFrame

		local NotifDesc = Instance.new("TextLabel")
		NotifDesc.Size = UDim2.new(0,200,0,30); NotifDesc.Position = UDim2.new(0,58,0,30)
		NotifDesc.BackgroundTransparency = 1; NotifDesc.Text = descText
		NotifDesc.TextColor3 = Theme.TextMuted; NotifDesc.Font = Enum.Font.Gotham; NotifDesc.TextSize = 10
		NotifDesc.TextXAlignment = Enum.TextXAlignment.Left; NotifDesc.TextWrapped = true
		NotifDesc.Parent = NotifFrame

		TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.new(1,-295,1,-80)
		}):Play()
		task.delay(4, function()
			local out = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Position = UDim2.new(1,10,1,-80)
			})
			out:Play(); out.Completed:Wait(); NotifFrame:Destroy()
		end)
	end

	-- ---------- Floating toggle button ----------
	local ToggleBtn = Instance.new("ImageButton")
	ToggleBtn.Name = "ToggleBtn"
	ToggleBtn.Size = UDim2.new(0,48,0,48)
	ToggleBtn.Position = UDim2.new(0,20,0.5,-24)
	ToggleBtn.BackgroundColor3 = Theme.MainBg
	ToggleBtn.Image = "rbxassetid://91099679470963"
	ToggleBtn.Active = true; ToggleBtn.Draggable = true; ToggleBtn.Visible = false
	ToggleBtn.Parent = ScreenGui
	local tbc = Instance.new("UICorner"); tbc.CornerRadius = UDim.new(1,0); tbc.Parent = ToggleBtn
	local tbs = Instance.new("UIStroke"); tbs.Color = Theme.Accent; tbs.Thickness = 2; tbs.Parent = ToggleBtn

	-- ---------- Main window ----------
	local NormalSize = UDim2.new(0,740,0,460)
	local NormalPos  = UDim2.new(0.5,-370,0.5,-230)
	local ClosedSize = UDim2.new(0,0,0,0)
	local ClosedPos  = UDim2.new(0.5,0,0.5,0)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = NormalSize; MainFrame.Position = NormalPos
	MainFrame.BackgroundColor3 = Theme.MainBg
	MainFrame.BackgroundTransparency = 0.05
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true; MainFrame.Draggable = true
	MainFrame.ClipsDescendants = true
	MainFrame.Visible = false
	MainFrame.Parent = ScreenGui
	local mfc = Instance.new("UICorner"); mfc.CornerRadius = UDim.new(0,10); mfc.Parent = MainFrame
	local mfs = Instance.new("UIStroke"); mfs.Color = Theme.Stroke; mfs.Thickness = 1.5; mfs.Parent = MainFrame

	-- Floating particles inside main window
	local ParticleContainer = Instance.new("Frame")
	ParticleContainer.Size = UDim2.new(1,0,1,0); ParticleContainer.BackgroundTransparency = 1
	ParticleContainer.ClipsDescendants = true; ParticleContainer.ZIndex = 1
	ParticleContainer.Parent = MainFrame
	task.spawn(function()
		while task.wait(0.35) do
			if not MainFrame.Visible then continue end
			local pSize = math.random(2,6)
			local startX = math.random(5,95)/100
			local p = Instance.new("Frame")
			p.Size = UDim2.new(0,pSize,0,pSize)
			p.Position = UDim2.new(startX,0,1,10)
			p.BackgroundColor3 = Color3.fromRGB(255,255,255)
			p.BackgroundTransparency = math.random(30,60)/100
			p.BorderSizePixel = 0; p.ZIndex = 1; p.Parent = ParticleContainer
			local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(1,0); pc.Parent = p
			local glow = Instance.new("UIStroke"); glow.Color = Color3.fromRGB(180,220,255)
			glow.Thickness = 1; glow.Transparency = 0.4; glow.Parent = p
			local dur = math.random(4,7)
			local tw = TweenService:Create(p, TweenInfo.new(dur, Enum.EasingStyle.Linear), {
				Position = UDim2.new(startX + (math.random(-8,8)/100), 0, 0, -20),
				BackgroundTransparency = 1
			})
			tw:Play(); tw.Completed:Connect(function() p:Destroy() end)
		end
	end)

	-- ---------- Sidebar ----------
	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0,155,1,0); Sidebar.BackgroundColor3 = Theme.SidebarBg
	Sidebar.BackgroundTransparency = 0.3; Sidebar.BorderSizePixel = 0; Sidebar.ZIndex = 2
	Sidebar.Parent = MainFrame
	local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0,10); sbc.Parent = Sidebar
	local FixSide = Instance.new("Frame")
	FixSide.Size = UDim2.new(0,10,1,0); FixSide.Position = UDim2.new(1,-10,0,0)
	FixSide.BackgroundColor3 = Theme.SidebarBg; FixSide.BackgroundTransparency = 0.3
	FixSide.BorderSizePixel = 0; FixSide.ZIndex = 2; FixSide.Parent = Sidebar

	local LogoBox = Instance.new("ImageLabel")
	LogoBox.Size = UDim2.new(0,30,0,30); LogoBox.Position = UDim2.new(0,14,0,16)
	LogoBox.BackgroundTransparency = 1; LogoBox.Image = "rbxassetid://91099679470963"
	LogoBox.ZIndex = 3; LogoBox.Parent = Sidebar
	local lbc = Instance.new("UICorner"); lbc.CornerRadius = UDim.new(1,0); lbc.Parent = LogoBox

	local LogoText = Instance.new("TextLabel")
	LogoText.Size = UDim2.new(0,100,0,30); LogoText.Position = UDim2.new(0,50,0,16)
	LogoText.BackgroundTransparency = 1; LogoText.Text = "LUXION"
	LogoText.TextColor3 = Theme.Text; LogoText.Font = Enum.Font.GothamBold; LogoText.TextSize = 13
	LogoText.TextXAlignment = Enum.TextXAlignment.Left; LogoText.ZIndex = 3; LogoText.Parent = Sidebar

	-- Nav button container (we'll add tabs dynamically)
	local NavContainer = Instance.new("Frame")
	NavContainer.Size = UDim2.new(1,0,1,-110); NavContainer.Position = UDim2.new(0,0,0,56)
	NavContainer.BackgroundTransparency = 1; NavContainer.ZIndex = 3; NavContainer.Parent = Sidebar
	local NavList = Instance.new("UIListLayout")
	NavList.Padding = UDim.new(0,6); NavList.SortOrder = Enum.SortOrder.LayoutOrder
	NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	NavList.Parent = NavContainer
	local NavPad = Instance.new("UIPadding"); NavPad.PaddingTop = UDim.new(0,4); NavPad.Parent = NavContainer

	-- Profile at bottom of sidebar
	local SideProfile = Instance.new("Frame")
	SideProfile.Size = UDim2.new(0.9,0,0,44); SideProfile.Position = UDim2.new(0.05,0,1,-52)
	SideProfile.BackgroundColor3 = Color3.fromRGB(12,17,28); SideProfile.BackgroundTransparency = 0.2
	SideProfile.BorderSizePixel = 0; SideProfile.ZIndex = 3; SideProfile.Parent = Sidebar
	local spc = Instance.new("UICorner"); spc.CornerRadius = UDim.new(0,8); spc.Parent = SideProfile
	local SideAvatar = Instance.new("ImageLabel")
	SideAvatar.Size = UDim2.new(0,30,0,30); SideAvatar.Position = UDim2.new(0,7,0.5,-15)
	SideAvatar.BackgroundColor3 = Color3.fromRGB(20,28,45)
	pcall(function() SideAvatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end)
	SideAvatar.ZIndex = 3; SideAvatar.Parent = SideProfile
	local sac = Instance.new("UICorner"); sac.CornerRadius = UDim.new(1,0); sac.Parent = SideAvatar
	local SideName = Instance.new("TextLabel")
	SideName.Size = UDim2.new(0,95,0,15); SideName.Position = UDim2.new(0,42,0,7)
	SideName.BackgroundTransparency = 1; SideName.Text = LocalPlayer.Name
	SideName.TextColor3 = Theme.Text; SideName.Font = Enum.Font.GothamBold; SideName.TextSize = 10
	SideName.TextXAlignment = Enum.TextXAlignment.Left; SideName.TextScaled = false; SideName.ZIndex = 3; SideName.Parent = SideProfile
	local SideDesc = Instance.new("TextLabel")
	SideDesc.Size = UDim2.new(0,95,0,13); SideDesc.Position = UDim2.new(0,42,0,23)
	SideDesc.BackgroundTransparency = 1; SideDesc.Text = "PHURI HUB"
	SideDesc.TextColor3 = Theme.TextMuted; SideDesc.Font = Enum.Font.Gotham; SideDesc.TextSize = 9
	SideDesc.TextXAlignment = Enum.TextXAlignment.Left; SideDesc.ZIndex = 3; SideDesc.Parent = SideProfile

	-- ---------- Content area ----------
	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(1,-160,1,0); Content.Position = UDim2.new(0,160,0,0)
	Content.BackgroundTransparency = 1; Content.ZIndex = 2; Content.Parent = MainFrame

	local HeaderTitle = Instance.new("TextLabel")
	HeaderTitle.Size = UDim2.new(0,320,0,40); HeaderTitle.Position = UDim2.new(0,12,0,0)
	HeaderTitle.BackgroundTransparency = 1; HeaderTitle.Text = "PHURI HUB / Blox Fruits"
	HeaderTitle.TextColor3 = Color3.fromRGB(220,230,245); HeaderTitle.Font = Enum.Font.GothamBold
	HeaderTitle.TextSize = 13; HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
	HeaderTitle.ZIndex = 3; HeaderTitle.Parent = Content

	-- Tab pages container
	local TabContainer = Instance.new("Frame")
	TabContainer.Size = UDim2.new(1,-10,1,-48); TabContainer.Position = UDim2.new(0,8,0,44)
	TabContainer.BackgroundTransparency = 1; TabContainer.ZIndex = 3; TabContainer.Parent = Content

	-- ---------- Open/Close animation ----------
	local isOpen = true
	local isAnimating = false
	local function ToggleUI()
		if isAnimating then return end
		isAnimating = true
		TweenService:Create(ToggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0,42,0,42)}):Play()
		task.wait(0.1)
		TweenService:Create(ToggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,48,0,48)}):Play()
		if isOpen then
			local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = ClosedSize, Position = ClosedPos})
			tw:Play(); tw.Completed:Wait(); MainFrame.Visible = false; isOpen = false
		else
			MainFrame.Visible = true
			local tw = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = NormalSize, Position = NormalPos})
			tw:Play(); tw.Completed:Wait(); isOpen = true
		end
		isAnimating = false
	end
	ToggleBtn.MouseButton1Click:Connect(ToggleUI)
	-- RCtrl toggle shortcut
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.RightControl then ToggleUI() end
	end)

	local function AddClickAnimation(btn)
		local orig = btn.Size
		btn.MouseButton1Down:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = orig - UDim2.new(0,3,0,3)}):Play()
		end)
		btn.MouseButton1Up:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = orig}):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = orig}):Play()
		end)
	end

	-- ---------- Track tabs ----------
	local tabs = {}       -- {tabObj, navBtn, pageFrame}
	local currentTab = nil

	local function setActiveTab(tabObj)
		for _, entry in ipairs(tabs) do
			local active = (entry.tab == tabObj)
			entry.navBtn.BackgroundColor3 = active and Theme.CardBgHover or Theme.SidebarBg
			entry.navBtn.BackgroundTransparency = active and 0 or 0.5
			entry.navBtn.TextColor3 = active and Theme.Text or Theme.TextMuted
			entry.page.Visible = active
			if entry.indicator then entry.indicator.Visible = active end
		end
		currentTab = tabObj
	end

	-- ---------- Section / control builders ----------
	local function createSectionCard(parent, name)
		local card = Instance.new("Frame")
		card.BackgroundColor3 = Theme.CardBg
		card.BackgroundTransparency = 0.15
		card.BorderSizePixel = 0
		card.AutomaticSize = Enum.AutomaticSize.Y
		card.Size = UDim2.new(1,-8,0,0)
		card.Parent = parent
		local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0,8); cc.Parent = card
		local cs = Instance.new("UIStroke"); cs.Color = Theme.AccentDim; cs.Thickness = 1; cs.Transparency = 0.3; cs.Parent = card

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0,10); pad.PaddingRight = UDim.new(0,10)
		pad.PaddingTop = UDim.new(0,8); pad.PaddingBottom = UDim.new(0,8)
		pad.Parent = card

		local list = Instance.new("UIListLayout")
		list.Padding = UDim.new(0,6); list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Parent = card

		if name and name ~= "" then
			local headerRow = Instance.new("Frame")
			headerRow.Size = UDim2.new(1, 0, 0, 20)
			headerRow.BackgroundTransparency = 1
			headerRow.LayoutOrder = 0
			headerRow.Parent = card

			local iconImg = Instance.new("ImageLabel")
			iconImg.Size = UDim2.new(0, 16, 0, 16)
			iconImg.Position = UDim2.new(0, 0, 0.5, -8)
			iconImg.BackgroundTransparency = 1
			iconImg.Image = pickIcon(name)
			iconImg.ImageColor3 = Theme.Accent
			iconImg.Parent = headerRow

			local header = Instance.new("TextLabel")
			header.Size = UDim2.new(1, -22, 1, 0)
			header.Position = UDim2.new(0, 22, 0, 0)
			header.BackgroundTransparency = 1
			header.Text = cleanText(name)
			header.TextColor3 = Theme.Accent
			header.Font = Enum.Font.GothamBold
			header.TextSize = 12
			header.TextXAlignment = Enum.TextXAlignment.Left
			header.Parent = headerRow
		end
		return card, list
	end

	local function makeRow(card, h)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1,0,0,h or 30)
		row.BackgroundTransparency = 1
		row.Parent = card
		return row
	end

	-- ============ CONTROL: Toggle ============
	local function buildToggle(card, opts)
		local row = makeRow(card, 30)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,-50,1,0); label.Position = UDim2.new(0,4,0,0)
		label.BackgroundTransparency = 1; label.Text = cleanText(opts.Name or "")
		label.TextColor3 = Theme.Text; label.Font = Enum.Font.GothamMedium; label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left; label.TextWrapped = true
		label.Parent = row
		if opts.Dis and opts.Dis ~= "" then
			label.Text = cleanText(opts.Name) .. "  (" .. cleanText(opts.Dis) .. ")"
		end

		local switch = Instance.new("TextButton")
		switch.Size = UDim2.new(0,38,0,20); switch.Position = UDim2.new(1,-42,0.5,-10)
		switch.BackgroundColor3 = (opts.Value and Theme.Accent or Theme.ToggleOff)
		switch.Text = ""; switch.BorderSizePixel = 0; switch.AutoButtonColor = false
		switch.Parent = row
		local swc = Instance.new("UICorner"); swc.CornerRadius = UDim.new(1,0); swc.Parent = switch

		local knob = Instance.new("Frame")
		knob.Size = UDim2.new(0,14,0,14); knob.Position = opts.Value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
		knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.BorderSizePixel = 0
		knob.Parent = switch
		local knc = Instance.new("UICorner"); knc.CornerRadius = UDim.new(1,0); knc.Parent = knob

		local state = { value = not not opts.Value, locked = false }
		switch.MouseButton1Click:Connect(function()
			if state.locked then return end
			state.value = not state.value
			TweenService:Create(switch, TweenInfo.new(0.15), {BackgroundColor3 = state.value and Theme.Accent or Theme.ToggleOff}):Play()
			TweenService:Create(knob, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Position = state.value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
			}):Play()
			if opts.Callback then pcall(opts.Callback, state.value) end
		end)

		local toggleObj = {
			Lock = function(self)
				state.locked = true
				switch.BackgroundColor3 = Color3.fromRGB(40,40,40)
				label.TextColor3 = Theme.TextMuted
			end,
			SetValue = function(self, v)
				state.value = not not v
				switch.BackgroundColor3 = state.value and Theme.Accent or Theme.ToggleOff
				knob.Position = state.value and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
			end,
		}
		return toggleObj
	end

	-- ============ CONTROL: Button ============
	local function buildButton(card, opts)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,28)
		btn.BackgroundColor3 = Theme.CardBgHover
		btn.Text = cleanText(opts.Name or "Button")
		btn.TextColor3 = Color3.fromRGB(210,220,240)
		btn.Font = Enum.Font.GothamMedium
		btn.TextSize = 11
		btn.BorderSizePixel = 0
		btn.Parent = card
		local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,6); bc.Parent = btn
		AddClickAnimation(btn)
		btn.MouseButton1Click:Connect(function()
			if opts.Callback then pcall(opts.Callback) end
		end)
		return btn
	end

	-- ============ CONTROL: Label ============
	local function buildLabel(card, opts)
		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(1,0,0,20)
		lbl.BackgroundTransparency = 1
		lbl.Text = cleanText(opts.Name)
		lbl.TextColor3 = Theme.TextMuted
		lbl.Font = Enum.Font.Gotham
		lbl.TextSize = 11
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = true
		lbl.AutomaticSize = Enum.AutomaticSize.Y
		lbl.Parent = card

		local labelObj = {
			Set = function(self, text)
				lbl.Text = cleanText(tostring(text or ""))
			end,
			SetColor = function(self, color)
				lbl.TextColor3 = color
			end,
		}
		return labelObj
	end

	-- ============ CONTROL: Slider ============
	local function buildSlider(card, opts)
		local minV = opts.Min or 0
		local maxV = opts.Max or 100
		local floor = opts.Floor or false
		local cur = opts.Value or minV
		if cur < minV then cur = minV end
		if cur > maxV then cur = maxV end

		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1,0,0,44); holder.BackgroundTransparency = 1; holder.Parent = card

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,-50,0,18); label.Position = UDim2.new(0,2,0,0)
		label.BackgroundTransparency = 1; label.Text = cleanText(opts.Name or "Slider")
		label.TextColor3 = Theme.Text; label.Font = Enum.Font.GothamMedium; label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = holder

		local valLabel = Instance.new("TextLabel")
		valLabel.Size = UDim2.new(0,50,0,18); valLabel.Position = UDim2.new(1,-50,0,0)
		valLabel.BackgroundTransparency = 1
		valLabel.Text = tostring(cur)
		valLabel.TextColor3 = Theme.Accent; valLabel.Font = Enum.Font.GothamBold; valLabel.TextSize = 11
		valLabel.TextXAlignment = Enum.TextXAlignment.Right; valLabel.Parent = holder

		local barBg = Instance.new("Frame")
		barBg.Size = UDim2.new(1,0,0,6); barBg.Position = UDim2.new(0,0,0,26)
		barBg.BackgroundColor3 = Color3.fromRGB(20,28,45); barBg.BorderSizePixel = 0; barBg.Parent = holder
		local bbc2 = Instance.new("UICorner"); bbc2.CornerRadius = UDim.new(1,0); bbc2.Parent = barBg

		local barFill = Instance.new("Frame")
		local pct = (cur - minV) / (maxV - minV)
		barFill.Size = UDim2.new(pct,0,1,0); barFill.BackgroundColor3 = Theme.Accent
		barFill.BorderSizePixel = 0; barFill.Parent = barBg
		local bfc2 = Instance.new("UICorner"); bfc2.CornerRadius = UDim.new(1,0); bfc2.Parent = barFill

		local knob = Instance.new("TextButton")
		knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(pct,-7,0.5,-7)
		knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.Text = ""
		knob.BorderSizePixel = 0; knob.Parent = barBg
		local knc2 = Instance.new("UICorner"); knc2.CornerRadius = UDim.new(1,0); knc2.Parent = knob

		local dragging = false
		local function update(input)
			local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
			rel = math.clamp(rel, 0, 1)
			local v = minV + rel * (maxV - minV)
			if floor then v = math.floor(v + 0.5) end
			cur = v
			local p = (cur - minV) / (maxV - minV)
			barFill.Size = UDim2.new(p,0,1,0)
			knob.Position = UDim2.new(p,-7,0.5,-7)
			local display = tostring(cur)
			if opts.Format then
				local ok, fd = pcall(opts.Format, cur)
				if ok and fd then display = tostring(fd) end
			end
			valLabel.Text = display
			if opts.Callback then pcall(opts.Callback, cur) end
		end
		knob.MouseButton1Down:Connect(function() dragging = true end)
		barBg.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true; update(input)
			end
		end)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				update(input)
			end
		end)

		-- initial display
		if opts.Format then
			local ok, fd = pcall(opts.Format, cur)
			if ok and fd then valLabel.Text = tostring(fd) end
		end

		return { Set = function(self, v) cur = v; local p = (cur-minV)/(maxV-minV); barFill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,-7,0.5,-7); valLabel.Text=tostring(cur) end }
	end

	-- ============ CONTROL: Dropdown ============
	local function buildDropdown(card, opts)
		local multi = opts.Multi or false
		local listItems = opts.List or {}
		local selected = opts.Value
		if multi then
			if type(selected) ~= "table" then selected = {} end
		else
			selected = selected or ""
		end

		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1,0,0,30); holder.AutomaticSize = Enum.AutomaticSize.Y
		holder.BackgroundTransparency = 1; holder.Parent = card

		local header = Instance.new("TextButton")
		header.Size = UDim2.new(1,0,0,28); header.Position = UDim2.new(0,0,0,0)
		header.BackgroundColor3 = Theme.CardBgHover; header.BorderSizePixel = 0
		header.Text = ""; header.AutoButtonColor = false; header.Parent = holder
		local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0,6); hc.Parent = header

		local titleLbl = Instance.new("TextLabel")
		titleLbl.Size = UDim2.new(1,-30,1,0); titleLbl.Position = UDim2.new(0,8,0,0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = cleanText(opts.Name or "Dropdown")
		titleLbl.TextColor3 = Theme.Text; titleLbl.Font = Enum.Font.GothamMedium; titleLbl.TextSize = 11
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = header

		local arrow = Instance.new("TextLabel")
		arrow.Size = UDim2.new(0,20,1,0); arrow.Position = UDim2.new(1,-24,0,0)
		arrow.BackgroundTransparency = 1; arrow.Text = "▾"
		arrow.TextColor3 = Theme.TextMuted; arrow.Font = Enum.Font.Gotham; arrow.TextSize = 12
		arrow.Parent = header

		local listFrame = Instance.new("Frame")
		listFrame.Size = UDim2.new(1,0,0,0); listFrame.Position = UDim2.new(0,0,0,30)
		listFrame.BackgroundColor3 = Color3.fromRGB(10,14,24)
		listFrame.BorderSizePixel = 0; listFrame.ClipsDescendants = true
		listFrame.Visible = false; listFrame.AutomaticSize = Enum.AutomaticSize.Y
		listFrame.Parent = holder
		local lfc = Instance.new("UICorner"); lfc.CornerRadius = UDim.new(0,6); lfc.Parent = listFrame
		local listLayout = Instance.new("UIListLayout"); listLayout.Padding = UDim.new(0,2); listLayout.Parent = listFrame
		local listPad = Instance.new("UIPadding"); listPad.PaddingTop = UDim.new(0,4); listPad.PaddingBottom = UDim.new(0,4)
		listPad.PaddingLeft = UDim.new(0,4); listPad.PaddingRight = UDim.new(0,4); listPad.Parent = listFrame

		local open = false
		local function refreshTitle()
			if multi then
				local n = 0
				for _ in pairs(selected) do n = n + 1 end
				titleLbl.Text = (opts.Name or "") .. "  [" .. n .. " selected]"
			else
				titleLbl.Text = (opts.Name or "") .. "  :  " .. tostring(selected)
			end
		end
		refreshTitle()

		local function buildItems()
			-- clear
			for _, ch in ipairs(listFrame:GetChildren()) do
				if ch:IsA("TextButton") then ch:Destroy() end
			end
			for i, item in ipairs(listItems) do
				local itemBtn = Instance.new("TextButton")
				itemBtn.Size = UDim2.new(1,0,0,22)
				itemBtn.BackgroundColor3 = Theme.CardBg
				itemBtn.BackgroundTransparency = 0.5
				itemBtn.Text = cleanText(tostring(item))
				itemBtn.TextColor3 = Theme.Text
				itemBtn.Font = Enum.Font.Gotham
				itemBtn.TextSize = 10
				itemBtn.TextXAlignment = Enum.TextXAlignment.Left
				itemBtn.BorderSizePixel = 0
				itemBtn.LayoutOrder = i
				itemBtn.Parent = listFrame
				local ibc = Instance.new("UICorner"); ibc.CornerRadius = UDim.new(0,4); ibc.Parent = itemBtn
				local ibp = Instance.new("UIPadding"); ibp.PaddingLeft = UDim.new(0,8); ibp.Parent = itemBtn
				AddClickAnimation(itemBtn)
				itemBtn.MouseButton1Click:Connect(function()
					if multi then
						local found = false
						for k, v in pairs(selected) do
							if v == item then found = true; table.remove(selected, k); break end
						end
						if not found then table.insert(selected, item) end
					else
						selected = item
						open = false
						listFrame.Visible = false
						TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
					end
					refreshTitle()
					if opts.Callback then pcall(opts.Callback, selected) end
				end)
			end
		end
		buildItems()

		header.MouseButton1Click:Connect(function()
			open = not open
			listFrame.Visible = open
			TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = open and 180 or 0}):Play()
		end)

		return {
			Refresh = function(self, newList)
				listItems = newList or listItems
				buildItems()
			end,
			Add = function(self, newList)
				listItems = newList or listItems
				buildItems()
			end,
			Set = function(self, v)
				selected = v; refreshTitle()
			end,
		}
	end

	-- ============ CONTROL: Input / TextBox ============
	local function buildInput(card, opts)
		local holder = Instance.new("Frame")
		holder.Size = UDim2.new(1,0,0,48); holder.BackgroundTransparency = 1; holder.Parent = card

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,0,18); label.Position = UDim2.new(0,2,0,0)
		label.BackgroundTransparency = 1; label.Text = cleanText(opts.Name or "Input")
		label.TextColor3 = Theme.Text; label.Font = Enum.Font.GothamMedium; label.TextSize = 11
		label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = holder

		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1,0,0,26); box.Position = UDim2.new(0,0,0,20)
		box.BackgroundColor3 = Theme.CardBgHover
		box.PlaceholderText = opts.Placeholder or ""
		box.PlaceholderColor3 = Theme.TextMuted
		box.Text = tostring(opts.Value or "")
		box.TextColor3 = Theme.Text; box.Font = Enum.Font.Gotham; box.TextSize = 11
		box.BorderSizePixel = 0; box.ClearTextOnFocus = false
		box.Parent = holder
		local xc = Instance.new("UICorner"); xc.CornerRadius = UDim.new(0,6); xc.Parent = box

		box.FocusLost:Connect(function(enter)
			if opts.Callback then pcall(opts.Callback, box.Text) end
		end)
		return box
	end

	-- ---------- Tab object ----------
	local function createTab(opts)
		local title = opts.Title or "Tab"

		-- Nav button in sidebar
		local navBtn = Instance.new("TextButton")
		navBtn.Size = UDim2.new(0.9,0,0,34)
		navBtn.BackgroundColor3 = Theme.SidebarBg
		navBtn.BackgroundTransparency = 0.5
		navBtn.Text = "  " .. cleanText(title)
		navBtn.TextColor3 = Theme.TextMuted
		navBtn.Font = Enum.Font.GothamMedium
		navBtn.TextSize = 11
		navBtn.TextXAlignment = Enum.TextXAlignment.Left
		navBtn.BorderSizePixel = 0
		navBtn.Parent = NavContainer
		local nbc = Instance.new("UICorner"); nbc.CornerRadius = UDim.new(0,8); nbc.Parent = navBtn

		local indicator = Instance.new("Frame")
		indicator.Size = UDim2.new(0,3,0,16); indicator.Position = UDim2.new(0,2,0.5,-8)
		indicator.BackgroundColor3 = Theme.Accent; indicator.BorderSizePixel = 0
		indicator.Visible = false; indicator.Parent = navBtn

		-- Page frame in content
		local page = Instance.new("Frame")
		page.Size = UDim2.new(1,0,1,0); page.BackgroundTransparency = 1
		page.Visible = false; page.Parent = TabContainer

		local leftCol = Instance.new("ScrollingFrame")
		leftCol.Name = "LeftCol"
		leftCol.Size = UDim2.new(0.5,-4,1,0); leftCol.Position = UDim2.new(0,0,0,0)
		leftCol.BackgroundTransparency = 1; leftCol.BorderSizePixel = 0
		leftCol.ScrollBarThickness = 3; leftCol.ScrollBarImageColor3 = Theme.Accent
		leftCol.CanvasSize = UDim2.new(0,0,0,0); leftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
		leftCol.Parent = page
		local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0,8); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = leftCol
		local lp = Instance.new("UIPadding"); lp.PaddingLeft = UDim.new(0,2); lp.PaddingRight = UDim.new(0,2); lp.PaddingTop = UDim.new(0,2); lp.Parent = leftCol

		local rightCol = Instance.new("ScrollingFrame")
		rightCol.Name = "RightCol"
		rightCol.Size = UDim2.new(0.5,-4,1,0); rightCol.Position = UDim2.new(0.5,4,0,0)
		rightCol.BackgroundTransparency = 1; rightCol.BorderSizePixel = 0
		rightCol.ScrollBarThickness = 3; rightCol.ScrollBarImageColor3 = Theme.Accent
		rightCol.CanvasSize = UDim2.new(0,0,0,0); rightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
		rightCol.Parent = page
		local rl = Instance.new("UIListLayout"); rl.Padding = UDim.new(0,8); rl.SortOrder = Enum.SortOrder.LayoutOrder; rl.Parent = rightCol
		local rp = Instance.new("UIPadding"); rp.PaddingLeft = UDim.new(0,2); rp.PaddingRight = UDim.new(0,2); rp.PaddingTop = UDim.new(0,2); rp.Parent = rightCol

		local tabObj = {}
		-- store page reference
		tabObj._page = page

		tabObj.CreatePage = function(pageOpts)
			local side = pageOpts.Side or "Left"
			local name = pageOpts.Name or ""
			local column = page:FindFirstChild(side == "Right" and "RightCol" or "LeftCol")
			local card = createSectionCard(column, name)
			local section = {}
			section.CreateToggle   = function(o) return buildToggle(card, o) end
			section.CreateButton   = function(o) return buildButton(card, o) end
			section.CreateLable    = function(o) return buildLabel(card, o) end
			section.CreateSlider   = function(o) return buildSlider(card, o) end
			section.CreateDropdown = function(o) return buildDropdown(card, o) end
			section.CreateInput    = function(o) return buildInput(card, o) end
			return section
		end

		navBtn.MouseButton1Click:Connect(function() setActiveTab(tabObj) end)
		AddClickAnimation(navBtn)

		table.insert(tabs, {tab = tabObj, navBtn = navBtn, page = page, indicator = indicator})

		-- first tab becomes active
		if #tabs == 1 then setActiveTab(tabObj) end

		return tabObj
	end

	-- ---------- Window object ----------
	local Window = {}
	Window.AddTap = function(opts) return createTab(opts) end
	Window.Notify = function(typ, info)
		local text = (info and info.text) or ""
		ShowNotification("PHURI HUB", text)
	end

	-- ---------- Run loading animation then show ----------
	task.spawn(function()
		for i = 1, 100 do
			BarFill.Size = UDim2.new(i/100, 0, 1, 0)
			LoadStatus.Text = "Loading... " .. i .. "%"
			task.wait(0.012)
		end
		task.wait(0.2)
		local fade = TweenService:Create(LoadFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0)
		})
		fade:Play(); fade.Completed:Wait(); LoadFrame:Destroy()
		MainFrame.Visible = true
		ToggleBtn.Visible = true
		ShowNotification("PHURI HUB", "Loading Success Good Luck >_<")
	end)

	return {
		Create = function(config)
			return Window
		end
	}
end)()

Windown = Library.Create({
	Name = "PHURI HUB | Blox Fruits",
	LoadName = "PHURI HUB | พร้อมลุย",
	Logo = {
		['Main'] = '15755672846',
		['Close'] = '15755672846'
	},
	BackgroundTransparency = 0.05,
	BackgroundColorMain = Color3.fromRGB(7, 6, 20),
	BackgroundColor = Color3.fromRGB(20, 16, 44),
	BackgroundColor2 = Color3.fromRGB(13, 11, 32),
	BackgroundColor3 = Color3.fromRGB(17, 14, 40),
	Color = Color3.fromRGB(150, 100, 255),
	ToggleOn = Color3.fromRGB(96, 56, 200),
	ColorEffect = Color3.fromRGB(40, 18, 90)
})

HookLanguage(Windown)

-- ==== PHURI HUB skin: cover image + galaxy nebula/stars ====
do
	local PHURI_IMG = [=[
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
]=]
	local COVER_PATH = "PHURI/assets/phuri_cover_v1.png"
	local OLD_LOGO = "15755672846"
	local MAIN_BG = Color3.fromRGB(7, 6, 20)

	local function b64decode(s)
		local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
		local lookup = {}
		for i = 1, 64 do
			lookup[string.byte(alphabet, i)] = i - 1
		end
		s = (string.gsub(s, "[^%w%+/=]", ""))
		local pad = 0
		if string.sub(s, -2) == "==" then
			pad = 2
		elseif string.sub(s, -1) == "=" then
			pad = 1
		end
		local out, n = {}, 0
		for i = 1, #s, 4 do
			local a, b, c, d = string.byte(s, i, i + 3)
			local v = (lookup[a] or 0) * 262144 + (lookup[b] or 0) * 4096 + (lookup[c] or 0) * 64 + (lookup[d] or 0)
			n = n + 1
			out[n] = string.char(math.floor(v / 65536) % 256, math.floor(v / 256) % 256, v % 256)
		end
		local r = table.concat(out)
		return string.sub(r, 1, #r - pad)
	end

	local cover
	pcall(function()
		local gca = getcustomasset or getsynasset
		if not (gca and writefile and isfile and isfolder and makefolder) then
			return
		end
		if not isfolder("PHURI") then makefolder("PHURI") end
		if not isfolder("PHURI/assets") then makefolder("PHURI/assets") end
		local okE, exists = pcall(function()
			return isfile(COVER_PATH) and #readfile(COVER_PATH) > 1000
		end)
		if not (okE and exists) then
			local raw
			local decoder = (crypt and crypt.base64decode) or base64decode or base64_decode
			if decoder then
				local ok, res = pcall(decoder, (string.gsub(PHURI_IMG, "%s", "")))
				if ok and type(res) == "string" and string.sub(res, 2, 4) == "PNG" then
					raw = res
				end
			end
			if not raw then
				raw = b64decode(PHURI_IMG)
			end
			writefile(COVER_PATH, raw)
		end
		local a = gca(COVER_PATH)
		if type(a) == "string" and a ~= "" then
			cover = a
		end
	end)

	local function skinImage(d)
		if not cover then return end
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then
			if string.find(tostring(d.Image), OLD_LOGO, 1, true) then
				d.Image = cover
				d.ScaleType = Enum.ScaleType.Crop
			end
		end
	end

	local function addGalaxy(gui)
		if gui.ZIndexBehavior ~= Enum.ZIndexBehavior.Sibling then
			return true
		end
		local main, best = nil, 0
		for _, d in ipairs(gui:GetDescendants()) do
			if d:IsA("Frame") and d.BackgroundColor3 == MAIN_BG then
				local area = d.AbsoluteSize.X * d.AbsoluteSize.Y
				if area > best then
					main, best = d, area
				end
			end
		end
		if not main or best < 300 * 200 then
			return false
		end
		if main:FindFirstChild("PHURI_Nebula") then
			return true
		end
		if main:FindFirstChildOfClass("UIListLayout") or main:FindFirstChildOfClass("UIGridLayout") or main:FindFirstChildOfClass("UIPageLayout") then
			return true
		end
		local TweenService = game:GetService("TweenService")
		local nebula = Instance.new("Frame")
		nebula.Name = "PHURI_Nebula"
		nebula.Size = UDim2.new(1, 0, 1, 0)
		nebula.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		nebula.BackgroundTransparency = 0.3
		nebula.BorderSizePixel = 0
		nebula.ZIndex = 0
		local mc = main:FindFirstChildOfClass("UICorner")
		if mc then
			local c = Instance.new("UICorner")
			c.CornerRadius = mc.CornerRadius
			c.Parent = nebula
		end
		local g = Instance.new("UIGradient")
		g.Rotation = 125
		g.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 30)),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(44, 20, 96)),
			ColorSequenceKeypoint.new(0.65, Color3.fromRGB(20, 16, 64)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 24, 56)),
		})
		g.Parent = nebula
		nebula.Parent = main
		local rng = Random.new(77)
		local starColors = {
			Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 180, 255),
			Color3.fromRGB(170, 215, 255), Color3.fromRGB(255, 200, 240),
		}
		for i = 1, 60 do
			local sz = rng:NextInteger(1, 3)
			local star = Instance.new("Frame")
			star.Name = "PHURI_Star"
			star.Position = UDim2.new(rng:NextNumber(0, 1), 0, rng:NextNumber(0, 1), 0)
			star.Size = UDim2.new(0, sz, 0, sz)
			star.BackgroundColor3 = starColors[rng:NextInteger(1, #starColors)]
			star.BackgroundTransparency = rng:NextNumber(0.35, 0.8)
			star.BorderSizePixel = 0
			star.ZIndex = 0
			star.Parent = main
			if i % 3 == 0 then
				task.spawn(function()
					task.wait(rng:NextNumber(0, 3))
					while star.Parent do
						local t = rng:NextNumber(0.8, 2)
						TweenService:Create(star, TweenInfo.new(t, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.9 }):Play()
						task.wait(t)
						TweenService:Create(star, TweenInfo.new(t, Enum.EasingStyle.Sine), { BackgroundTransparency = 0.2 }):Play()
						task.wait(t)
					end
				end)
			end
		end
		return true
	end

	task.spawn(function()
		local hooked = {}
		for _ = 1, 40 do
			local list = {}
			local a = COREGUI:FindFirstChild("yesheeGUI")
			if a then table.insert(list, a) end
			local pg = Client:FindFirstChild("PlayerGui")
			local b = pg and pg:FindFirstChild("yesheeGUI")
			if b and b ~= a then table.insert(list, b) end
			for _, gui in ipairs(list) do
				if not hooked[gui] then
					hooked[gui] = {}
					for _, d in ipairs(gui:GetDescendants()) do
						pcall(skinImage, d)
					end
					gui.DescendantAdded:Connect(function(d)
						task.defer(function() pcall(skinImage, d) end)
					end)
				end
				if not hooked[gui].galaxy then
					local ok, done = pcall(addGalaxy, gui)
					if ok and done then
						hooked[gui].galaxy = true
					end
				end
			end
			task.wait(1)
		end
	end)
end


local MainTab = Windown.AddTap({
	Title = "Default"
})

local AutomaticTab = Windown.AddTap({
	Title = "Automatic",
	Icon = "crown"
})

local ShopTab = Windown.AddTap({
	Title = "Shoping",
	Icon = "shopping-bag"
})

local TapWebHook = Windown.AddTap({
	Title = "TP & WebHook",
	Icon = "venetian-mask"
})

local TapMisc = Windown.AddTap({
	Title = "Misc",
	Icon = "compass"
})

function Toggle(options, CallBack, SettingName)
	local Section = options.Section
	local Title = options.Title
	local Locker = options.Locker
	local tasks = #_G.Bin + 1
	if type(CallBack) == 'string' then
		if not SettingName then
			SettingName = CallBack
		end
		CallBack = nil
	end	

	if not SettingName then
		SettingName = Title
	end
	local mainToggle = Section.CreateToggle({Name = Title,Value = _G.Settings[SettingName] or false,Dis = options.Dis or "",Callback = CallBack or function(v)
		_G.Settings[SettingName] = v
		SaveSettings()
		local Succes, Error = pcall(function()
			_G.Bin[tasks] = task.spawn(function() 
				if loadFun[SettingName] ~= nil then 
					loadFun[SettingName](SettingName) 
				end 
			end)
			if (not v) and _G.Bin[tasks] then 
				task.cancel(_G.Bin[tasks])
				for i = 1,10 do wait() RemoveAllClip() end
			end
		end)
		if not Succes then
			warn(SettingName.." Error Pls OpenTicket For Report Bug ", Error)
		end
		if not v then
			delay(.2, function()
				_G.NeedNoClip = false
				NeedAttack = false
			end) 
		end
	end})
	if Locker then
		mainToggle:Lock()
	end
	return mainToggle
end;

function Label(options)
	local Section = options.Section
	local Title = options.Title

	return Section.CreateLable({Name = Title})
end;
function Button(options, CallBack, SettingName)
	local Section = options.Section
	local Title = options.Title

	if type(CallBack) == 'string' then
		if not SettingName then
			SettingName = CallBack
		end
		CallBack = nil
	end

	return Section.CreateButton({Name = Title ,Callback = CallBack or print("Kuy")})
end;
function Dropdown(options, CallBack, DropName)
	local Section = options.Section
	local Title = options.Title
	local List = options.List
	local Muti = options.Multi
	local Value = options.Value or nil

	if type(CallBack) == 'string' then
		if not DropName then
			DropName = CallBack
		end
		CallBack = nil
	end

	if not options.Multi then
		return options.Section.CreateDropdown({Name = Title ,Value = _G.Settings[DropName] or Value or "", List = options.List,Callback = CallBack or function(v)
			_G.Settings[DropName] = v
			SaveSettings()
		end,})
	else
		return options.Section.CreateDropdown({Name = Title ,Value = _G.Settings[DropName] or Value or {""}, Multi = true, List = options.List,Callback = CallBack or function(v)
			_G.Settings[DropName] = v
			SaveSettings()
		end,})
	end
end;
function TextBox(options, CallBack, TextBoxName)
	local Section = options.Section
	local Title = options.Title
	local Placeholder = options.Placeholder or ""
	local Value = options.Value or ""

	if type(CallBack) == 'string' then
		if not TextBoxName then
			TextBoxName = CallBack
		end
		CallBack = nil
	end

	return options.Section.CreateInput({Name = options.Title ,Value = _G.Settings[TextBoxName] or Value or 0, Placeholder = Placeholder, Callback = CallBack or function(v)
		_G.Settings[TextBoxName] = v
		SaveSettings()
	end,})
end
function Slider(options, CallBack, SliderName)
	local Section = options.Section
	local Title = options.Title
	local Value = options.Value

	local Floor = options.Floor or false


	if type(CallBack) == 'string' then
		if not SliderName then
			SliderName = CallBack
		end
		CallBack = nil
	end
	return options.Section.CreateSlider({Name = options.Title ,Value = _G.Settings[SliderName] or Value or 0, Floor = Floor, Min = options.Min, Max = options.Max,Format = CallBack or function(v)
		_G.Settings[SliderName] = v
		SaveSettings()
	end,})
end


do
	local MainSection = MainTab.CreatePage({
		Name = "🌍 General 🌍",
		Side = "Left"
	})

	t['FPS'] = MainSection.CreateLable({ Name = "Player FPS :" })
	MainSection.CreateLable({ Name = "🧑‍🌾 Auto Farm Level 🧑‍🌾" }):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Farm Level", Section = MainSection}, 'Farm Level')
	Toggle({Title = "Auto Quest Secrets", Section = MainSection}, 'Auto Quest Secrets')
	Toggle({Title = "Quest Secrets Hop", Section = MainSection}, 'Quest Secrets Hop')
	
	Button({Title = "RemoveAllClip", Section = MainSection}, function()
		RemoveAllClip()
	end)
	Button({Title = "User Candys", Section = MainSection}, function()
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("Cousin", 1)
	end)

	Toggle({Title = "Auto Go New Island 2650+", Section = MainSection}, 'Auto_Go_New_Island')
	Toggle({ Section = MainSection, Title = "Auto Kill Enemies Aura", }, "Auto Enemies Aura")

	Button({Title = "Redeem All Code", Section = MainSection}, function()
		for _,Value in pairs(BloxFruitsCodes) do wait(.2)
			Windown.Notify('success', { text = "Redeem : " .. Value , time = 3 })
			game.ReplicatedStorage.Remotes.Redeem:InvokeServer(Value)
		end
	end)

	Toggle({Title = "Auto Clown Jewels Cloud", Section = MainSection}, 'Auto Clown Jewels Cloud')

	MainSection.CreateLable({
		Name = "👿 Auto Join Dungeon New 👿"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Dropdown({ Section = MainSection, Title = 'Select Difficulty', List = {'Normal', 'Hard', 'Challenge'} }, 'Select Difficulty Dunnew')
	Toggle({Title = "Auto Join Dungeon ( New )", Section = MainSection}, 'Auto Join Dungeon New')
	Toggle({Title = 'Auto Dungeon ( New )', Section = MainSection}, 'Auto Dungeon New')
	
	MainSection.CreateLable({
		Name = "🌍 Auto World 🌍"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto New World", Section = MainSection}, 'Auto New World')
	Toggle({Title = "Auto Third World", Section = MainSection}, 'Auto Third World')

	MainSection.CreateLable({ Name = "🧰 Chests 🧰" }):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Chests", Section = MainSection}, 'Auto Chests')

	MainSection.CreateLable({ Name = "⚡ Auto Find Pole ⚡" }):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Find Pole", Section = MainSection}, 'Auto Find Pole')
	Toggle({Title = "Auto Find Pole( Hop )", Section = MainSection}, 'Auto Find Pole Hop')
	
	MainSection.CreateLable({ Name = "🤺 Auto Find Saber 🤺" }):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Find Saber", Section = MainSection}, 'Auto Find Saber')
	
	MainSection.CreateLable({ Name = "⚔️ Auto Find MidnightBlade ⚔️" }):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({ Section = MainSection, Title = "Auto Find MidnightBlade", }, "Auto Find MidnightBlade")

	MainSection.CreateLable({ Name = "💀 Auto Farm Bone 💀" }):SetColor(Color3.fromRGB(205, 130, 255))
	t['BoneCount'] = MainSection.CreateLable({ Name = "🦴 Bone Count :" })

	Toggle({Title = "Auto Farm Bone", Section = MainSection}, 'Auto Farm Bone')
	Toggle({Title = "Auto Trading Bone", Section = MainSection}, 'Trading Bone')

	MainSection.CreateLable({ Name = "😺 Kitsune Island 😺" }):SetColor(Color3.fromRGB(205, 130, 255))

	t['Kitsune Island'] = MainSection.CreateLable({ Name = "Kitsune Island : 🔴" 	})
	
	Toggle({Title = "Teleport Kitsune Island", Section = MainSection}, "goto_Kitsune_Island")
	Toggle({Title = "Teleport To EmberTemplate", Section = MainSection}, "Teleport_EmberTemplate")
	Toggle({Title = "ESP Kitsune Island", Section = MainSection}, 'ESP_Kitsune_Island')

	MainSection.CreateButton({
		Name = "Start Kitsune",
		Callback = function()
			game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/TouchKitsuneStatue"):FireServer()
		end
	})

end

do
	local SettingSection = MainTab.CreatePage({
		Name = "Settings",
		Side = "Right"
	});

	SettingSection.CreateLable({
		Name = "⚙️ Settings ⚙️"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	SettingSection.CreateDropdown({
		Name = "Language / ภาษา",
		Value = _G.Settings.Language or "EN",
		List = { "EN", "TH" },
		Callback = function(value)
			if type(value) == "table" then value = value[1] end
			if value ~= "EN" and value ~= "TH" then return end
			if _G.Settings.Language == value then return end
			_G.Settings.Language = value
			SaveSettings()
			ApplyLanguage()
		end
	})

	SettingSection.CreateToggle({
		Name = "Debug (F9 Console)",
		Value = _G.Debug == true,
		Callback = function(v)
			_G.Debug = v
		end
	})

	SettingSection.CreateDropdown({
		Name = "Select Weapon",
		Value = _G.Settings.SelectWeapon,
		List = { "Melee", "Sword", "Fruit" },
		Callback = function(value)
			_G.Settings.SelectWeapon = value
			SaveSettings()
		end
	})

	SettingSection.CreateDropdown({
		Name = "Select Skill",
		List = {"Z","X","C","V"},
		Value = _G.Settings['Select Skill Use'],
		Multi = true,
		Callback = function(value)
			_G.Settings['Select Skill Use'] = value
			SaveSettings()
		end
	})
	Toggle({
		Section = SettingSection,
		Title = "Bring Mob",
	}, "Bring Mob")
	
	Toggle({
		Section = SettingSection,
		Title = "Auto Use Skill",
	}, "Auto Use Skill")

	Toggle({
		Section = SettingSection,
		Title = "Auto Haki (Buso)",
	}, "Auto Buso")

	SettingSection.CreateSlider({Name = "Enemies Aura",Value = _G.Settings['Enemies Aura'] or 0,Min = 1,Max = 6000,Format = function(value)
		_G.Settings['Enemies Aura'] = value
		SaveSettings()
	end})
	SettingSection.CreateLable({
		Name = "Auto Stats"
	})

	SettingSection.CreateDropdown({
		Name = "Select Stats",
		List = {"Melee","Defense","Sword","Gun","Demon Fruit"},
		Value = _G.Settings.Select_Stats,
		Multi = true,
		Callback = function(value)
			_G.Settings.Select_Stats = value
			SaveSettings()
		end
	})

	SettingSection.CreateToggle({Name ="Auto Stats",Value = _G.Settings["Auto_Stats"], Mode = true,Callback = function(value)
		_G.Settings.Auto_Stats = value
		SaveSettings()
	end})
	SettingSection.CreateSlider({Name = "Select Point",Value = _G.Settings.Point,Min = 1,Max = 100,Format = function(value)
		_G.Settings.Point = value
		SaveSettings()
	end})
end

do
	local MainSection2 = MainTab.CreatePage({ Side = "Right" });
	MainSection2.CreateLable({
		Name = "👑 Auto Castle Raid 👑"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Castle Raid ", Section = MainSection2}, 'Auto_Castle_Raid')

	MainSection2.CreateLable({
		Name = "⚔️ Farm All Mastery Sword ⚔️"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({Title = "Auto Farm All Mastery Sword ", Section = MainSection2}, 'Auto_Farm_All_Sword')

	MainSection2.CreateLable({
		Name = "🔥 Cursed Dual Katana 🔥"
	}):SetColor(Color3.fromRGB(205, 130, 255))
	
	Toggle({Title = "Auto Cursed Dual Katana ", Section = MainSection2}, 'Auto_Cursed_Dual_Katana')

	MainSection2.CreateLable({ Name = "🎂 Cake Prince 🎂" 	}):SetColor(Color3.fromRGB(205, 130, 255))

	t['Cake Kill'] = MainSection2.CreateLable({ Name = "🎂 Cake Kill :" })

	Toggle({Title = "Auto Cake Prince", Section = MainSection2}, 'Auto Cake Prince')
	
	MainSection2.CreateLable({ Name = "😈 Auto Elite Hunter 😈" 	}):SetColor(Color3.fromRGB(205, 130, 255))

	t['EliteMon'] = MainSection2.CreateLable({ Name = "Total" })

	Toggle({Title = "Auto Elite Hunter", Section = MainSection2}, 'Auto Elite Hunter')
	
	MainSection2.CreateLable({
		Name = "😈 Auto Fighting style 😈"
	}):SetColor(Color3.fromRGB(205, 130, 255))
	
	MainSection2.CreateDropdown({
		Name = "Select Type Fighting style",
		Value = _G.Settings['Select Type Fighting style'],
		List = {"Electric Claw", "Dragon Talon", "Godhuman", "Super Human", "Death Step", "Sharkman Karate"},
		Callback = function(value)
			_G.Settings['Select Type Fighting style'] = value
			SaveSettings()
		end
	})
	
	Toggle({
		Section = MainSection2,
		Title = "Do Fighting style",
	}, "Fully Do")
	
end

do
	local DevilFruitShopSection = ShopTab.CreatePage({
		Name = "Devil Fruit Shop",
		Side = "Left"
	})

	DevilFruitShopSection.CreateLable({ Name = "🍎 Devil Fruit Shop 🍎" }):SetColor(Color3.fromRGB(205, 130, 255))

	DevilFruitShopSection.CreateDropdown({
		Name = "Select Devil Fruit",
		Flag = "Select_Devil_Fruit",
		List = Table_DevilFruitSniper,
		Value = _G.Settings.Select_Devil_Fruit,
		Callback = function(value)
			_G.Settings.Select_Devil_Fruit = value
			SaveSettings()  
		end
	})
	DevilFruitShopSection.CreateToggle({Name ="Auto Buy Devil Fruit",Value = _G.Settings["Auto_Buy_Devil_Fruit"], Mode = true,Callback = function(value)
		_G.Settings.Auto_Buy_Devil_Fruit = value
		SaveSettings()
	end})

	DevilFruitShopSection.CreateToggle({Name ="Auto Random Fruit",Value = _G.Settings["Auto_Random_Fruit"], Mode = true,Callback = function(value)
		_G.Settings.Auto_Random_Fruit = value
		SaveSettings()
	end})

	DevilFruitShopSection.CreateToggle({Name ="Auto Store Fruit",Value = _G.Settings["Auto_Store_Fruit"], Mode = true,Callback = function(value)
		_G.Settings.Auto_Store_Fruit = value
		SaveSettings()
	end})

	Toggle({Title = "Auto Bring Fruit", Section = DevilFruitShopSection}, 'AutoBringFruit')

	local function createSection(name, side)
		return ShopTab.CreatePage({
			Name = name,
			Side = side
		})
	end

	local function addButton(section, name, callback)
		section.CreateButton({
			Name = name,
			Callback = callback
		})
	end

	local AbilityShopSection = createSection("Ability Shop", "Right")
	AbilityShopSection.CreateLable({ Name = "🛒 Ability Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	addButton(AbilityShopSection, "Buy Geppo", function() _C("BuyHaki", "Geppo") end)
	addButton(AbilityShopSection, "Buy Buso Haki", function() _C("BuyHaki", "Buso") end)
	addButton(AbilityShopSection, "Buy Soru", function() _C("BuyHaki", "Soru") end)
	addButton(AbilityShopSection, "Buy Ken Haki", function() _C("KenTalk", "Buy") end)

	local FightingStyleShopSection = createSection("Fighting Style Shop", "Left")
	FightingStyleShopSection.CreateLable({ Name = "🛒 Fighting Style Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	local fightingStyles = {
		{"Black Leg", "BuyBlackLeg"},
		{"Electro", "BuyElectro"},
		{"Fishman Karate", "BuyFishmanKarate"},
		{"SuperHuman", "BuySuperhuman"},
		{"Death Step", "BuyDeathStep"},
		{"Sharkman Karate", { "BuySharkmanKarate", true }, "BuySharkmanKarate"},
		{"Electric Claw", "BuyElectricClaw"},
		{"Dragon Talon", "BuyDragonTalon"},
		{"God Human", "BuyGodhuman"}
	}
	for _, style in ipairs(fightingStyles) do
		addButton(FightingStyleShopSection, "Buy " .. style[1], function() _C(style[2], style[3]) end)
	end

	addButton(FightingStyleShopSection, "Buy DragonClaw", function()
		_C("BlackbeardReward",  "DragonClaw", 1)
		_C("BlackbeardReward",  "DragonClaw", 2)
	end)

	local AccessoryShopSection = createSection("Accessory Shop", "Right")
	AccessoryShopSection.CreateLable({ Name = "🛒 Accessory Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	local accessories = {"Tomoe Ring", "Black Cape", "Swordsman Hat"}
	for _, accessory in ipairs(accessories) do
		addButton(AccessoryShopSection, "Buy " .. accessory, function() _C("BuyItem", accessory) end)
	end

	local SwordShopSection = createSection("Sword Shop", "Left")
	SwordShopSection.CreateLable({ Name = "🛒 Swords Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	local swords = {"Cutlass", "Katana", "Iron Mace", "Duel Katana", "Triple Katana", "Pipe", "Dual-Headed Blade", "Bisento", "Soul Cane"}
	for _, sword in ipairs(swords) do
		addButton(SwordShopSection, "Buy " .. sword, function() _C("BuyItem", sword) end)
	end

	-- Gun Shop
	local GunShopSection = createSection("Gun Shop", "Right")
	GunShopSection.CreateLable({ Name = "🛒 Guns Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	local guns = {"Slingshot", "Musket", "Flintlock", "Refined Flintlock", "Cannon"}
	for _, gun in ipairs(guns) do
		addButton(GunShopSection, "Buy " .. gun, function() _C("BuyItem", gun) end)
	end
	addButton(GunShopSection, "Buy Kabucha", function() _C("BlackbeardReward", "Slingshot", "1") _C("BlackbeardReward", "Slingshot", "2") end)

	-- Race & Fragment Shop
	local RacefragmentSection = createSection("Race&Fragment Shop", "Right")
	RacefragmentSection.CreateLable({ Name = "🛒 Races&Fragment Shop 🛒" }):SetColor(Color3.fromRGB(205, 130, 255))
	addButton(RacefragmentSection, "Buy Race Ghoul", function() 
		_C("Ectoplasm", "BuyCheck", 4)
		_C("Ectoplasm", "Change", 4)
	end)
	addButton(RacefragmentSection, "Buy Cyborg", function() _C("CyborgTrainer", "Buy") end)
	addButton(RacefragmentSection, "Buy Random Race", function() _C("BlackbeardReward", "Reroll", "2") end)
	addButton(RacefragmentSection, "Buy Reset Stats", function() _C("BlackbeardReward", "Refund", "2") end)

end

do
	local function addButton(section, name, callback)
		section.CreateButton({
			Name = name,
			Callback = callback
		})
	end
	local AutoDungeons = AutomaticTab.CreatePage({
		Name = "Automatic",
		Side =  "Left"
	})

	AutoDungeons.CreateLable({
		Name = "🧟‍♀️ Auto Dungeons 🧟‍♀️"
	}):SetColor(Color3.fromRGB(205, 130, 255))


	AutoDungeons.CreateDropdown({
		Name = "Select Type Dungeon",
		List = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"},
		Value = _G.Settings['Select Raid'] or 'Flame',
		Callback = function(value)
			_G.Settings['Select Raid'] = value
			SaveSettings()  
		end
	})
	Toggle({
		Section = AutoDungeons,
		Title = "Auto Buy Microchip",
	}, "Auto Buy Microchip")
	Toggle({
		Section = AutoDungeons,
		Title = "Auto Clear Dungeons",
	}, "Auto Clear Dungeons")
	AutoDungeons.CreateButton({
		Name = "Buy Microchip",
		Callback = function()
			_C("RaidsNpc", "Select", _G.Settings['Select Raid'])
		end,
	})
	addButton(AutoDungeons,  "Start Dungeons", function()
		if Sea2 then
			if game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button:FindFirstChild("Main") then
				fireclickdetector(workspace.Map:FindFirstChild("RaidSummon2",true).Button.Main.ClickDetector)
			else
				Client.Character.HumanoidRootPart.CFrame = workspace.Map["RaidSummon2"].Button.Main:GetPivot()
			end
		end
		if Sea3 then
			if game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button:FindFirstChild("Main") then
				fireclickdetector(game.Workspace.Map:FindFirstChild("Boat Castle",true).RaidSummon2.Button.Main:FindFirstChild("ClickDetector"))
			else
				Client.Character.HumanoidRootPart.CFrame = workspace.Map["Boat Castle"].RaidSummon2.Button:GetPivot()
			end
		end
	end)
end

do
	local Automatic = AutomaticTab.CreatePage({
		Name = "Automatic",
		Side =  "Left"
	})

	Automatic.CreateLable({
		Name = "🐰 Auto Races V2 🐰"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({ Section = Automatic, Title = "Auto Evo Race [V2]", }, "Auto_Evo_Race_V2")

	Automatic.CreateLable({
		Name = "🦈 Races V4 🦈"
	})

	_G.Stats_Moon = Automatic.CreateLable({
		Name = "ดวงจัน|Stats Moon : 0% 🌑"
	})
	
	_G.Stats_Moon_Time = Automatic.CreateLable({
		Name = "Time Next Moon: 00.000.00"
	})

	Automatic.CreateDropdown({ Name = "Select How to Complete", List = {"Surrender","Complete"}, Value = _G.Settings.Select_Complete_Trial or 'Complete', Callback = function(value)
		_G.Settings.Select_Complete_Trial = value
		SaveSettings()  
	end })

	Toggle({ Section = Automatic, Title = "Auto Look Moon", }, "Lock_Moon")
	Toggle({ Section = Automatic, Title = "Auto Complete Trial"}, 'Auto_Complete_Trial')
	Automatic.CreateButton({ Name = "Go To Room Radc V4", Callback = function()
		game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map["Temple of Time"].DoNotEnter.CFrame
	end })



end

do
	local Automatic = AutomaticTab.CreatePage({
		Name = "Fishing",
		Side =  "Left"
	})
	Automatic.CreateLable({
		Name = "🐟 Fishing 🐟"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Automatic.CreateDropdown({
		Name = "Select Mode Reel",
		List = {'Bypass', 'Default'},
		Value = _G.Settings['Select Mode Reel'] or 'Bypass',
		Callback = function(value)
			_G.Settings['Select Mode Reel'] = value
			SaveSettings()
		end
	})

	Automatic.CreateButton({ Name = "Get Free Rod", Callback = function()
		game:GetService("ReplicatedStorage").Modules.Net["RF/JobsRemoteFunction"]:InvokeServer( "FishingNPC", "FirstTimeFreeRod" )
	end })
	
	Toggle({ Section = Automatic, Title = "Auto Fishing", }, "Auto_Fishing")
	Toggle({ Section = Automatic, Title = "Auto Buy Bait", }, "Auto_Buy_Bait")
	

	Automatic.CreateSlider({Name = "Bait Num",Value = _G.Settings['Bait Num'] or 10,Min = 1,Max = 99,Format = function(value)
		_G.Settings['Bait Num'] = value
		SaveSettings()
	end})
	
	Automatic.CreateButton({ Name = "Buy Bait", Callback = function()
		game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft"):InvokeServer("Craft", "Basic Bait", {})
	end })
	
	Automatic.CreateButton({ Name = "Sell Fish", Callback = function()
		game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/JobsRemoteFunction"):InvokeServer("FishingNPC", "SellFish")
	end })
	_G.SavePositionFish = {}

	local HttpService = game:GetService("HttpService")
	local player = game.Players.LocalPlayer
	local folder = "PHURI HUB/Blox Fruits Update 0.0.1"
	local path = folder.."/"..player.Name.."PositionFish.json"

	local function EncodeCFrame(cf)
		return table.concat({
			cf.X, cf.Y, cf.Z,
			cf:ToOrientation()
		}, ",")
	end

	local function DecodeCFrame(str)
		local data = {}
		for num in string.gmatch(str, "([^,]+)") do
			table.insert(data, tonumber(num))
		end
		if #data == 6 then
			return CFrame.new(data[1], data[2], data[3]) * CFrame.Angles(data[4], data[5], data[6])
		end
		return CFrame.new(0,0,0)
	end

	function SavePositionFish()
		local json = HttpService:JSONEncode(_G.SavePositionFish)
		if writefile then
			if not isfolder("PHURI HUB") then
				makefolder("PHURI HUB")
			end
			if not isfolder(folder) then
				makefolder(folder)
			end
			writefile(path, json)
		end
	end

	do
		if isfile(path) then
			_G.SavePositionFish = HttpService:JSONDecode(readfile(path))
		end
	end

	local gg = {}
	if isfile(path) then
		for i,_ in next, HttpService:JSONDecode(readfile(path)) do
			table.insert(gg, i)
		end
	end

	local updatePos = Automatic.CreateDropdown({
		Name = "Select Player Position",
		List = gg,
		Value = _G.Settings['Select Player Position'],
		Callback = function(value)
			if value ~= '' and value ~= nil then
				_G.Settings['Select Player Position'] = value
				SaveSettings()
				if isfile(path) then
					local jsonData = HttpService:JSONDecode(readfile(path))
					local cf = jsonData[value]
					if cf then
						_G.Settings['Select Player Position'] = DecodeCFrame(cf)
					end
				end
			end
		end
	})

	TextBox({ Section = Automatic, Title = "Name Position Fish", }, "Name_Position_Fish")

	Automatic.CreateButton({
		Name = "Save Position Fish",
		Callback = function()
			local cf = Client.Character.HumanoidRootPart.CFrame
			_G.SavePositionFish[_G.Settings.Name_Position_Fish] = EncodeCFrame(cf)
			SavePositionFish()

			local a = {}
			for i,_ in next, HttpService:JSONDecode(readfile(path)) do
				table.insert(a, i)
			end
			updatePos:Add(a)
		end
	})

	Toggle({ Section = Automatic, Title = "Auto Player Position", }, "Auto_Player_Position")

end

do
	local Automatic = AutomaticTab.CreatePage({
		Name = "Other",
		Side =  "Left"
	})

	Automatic.CreateLable({
		Name = "💁 Other Page1 💁"
	}):SetColor(Color3.fromRGB(205, 130, 255))
	Automatic.CreateLable({ Name = "⚔️ Bisento V2 ⚔️" })
	Toggle({ Section = Automatic, Title = "Auto Find Bisento [V2]", }, "Auto_Find_Bisento_V2")

	Automatic.CreateLable({ Name = "🏭 Auto Hit Core 🏭" })
	Toggle({ Section = Automatic, Title = "Auto Hit Core", }, "Auto_Hit_Core")

	Automatic.CreateLable({ Name = "👽 Bartilo Quest 👽" })
	Toggle({ Section = Automatic, Title = "Auto Bartilo Quest", }, "Auto_Bartilo_Quest")

	Automatic.CreateLable({ Name = "⚔️ Auto Find Rengoku ⚔️" })
	Toggle({ Section = Automatic, Title = "Auto Find Rengoku", }, "Auto_Find_Rengoku")

	Automatic.CreateLable({ Name = "⚔️ Auto Buy Legendary Sword ⚔️" })
	Toggle({ Section = Automatic, Title = "Auto Buy Legendary Swords", }, "Auto_Buy_Legendary_Sword")

	Automatic.CreateLable({ Name = "🤖 Auto Cyborg Race 🤖" })
	Toggle({ Section = Automatic, Title = "Auto Cyborg Race", }, "Auto_Cyborg_Race")
	
end

do
	local Auto_Material = AutomaticTab.CreatePage({
		Name = "🌍 Auto Material 🌍", Side = "Right"
	})

	Auto_Material.CreateLable({
		Name = "🌟 Auto Material 🌟"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Auto_Material.CreateDropdown({
		Name = "Material FirstSea", Flag = "Select Material", List = { "Yeti Fur", "Fish Tail", "Magma Ore", "Scrap Metal", }, 
		Value = _G.Settings['Select Material'], 
		Callback = function(value) 
			_G.Settings['Select Material'] = value 
			SaveSettings() 
		end
	})
	Auto_Material.CreateDropdown({
		Name = "Material SecondSea", Flag = "Select Material", List = {"Ectoplasm", "Radioactive Material", "Vampire Fang", "Meteorite", },
		Value = _G.Settings['Select Material'], 
		Callback = function(value) 
			_G.Settings['Select Material'] = value 
			SaveSettings() 
		end
	})
	Auto_Material.CreateDropdown({
		Name = "Material ThirdSea", Flag = "Select Material", List = { "Fish Tail", "Gun Powder", "Mini Tusk", "Conjured Cocoa", "Demonic Wisp", "Dragon Scale", },
		Value = _G.Settings['Select Material'], 
		Callback = function(value) 
			_G.Settings['Select Material'] = value 
			SaveSettings() 
		end
	})

	Toggle({
		Section = Auto_Material,
		Title = "Find Material ",
	}, "Find Material")
end

do 
	local Auto_Yama = AutomaticTab.CreatePage({
		Name = "🌍 Auto Yama 🌍", Side = "Right"
	})
	Auto_Yama.CreateLable({
		Name = "⚔️ Auto Yama ⚔️"
	}):SetColor(Color3.fromRGB(205, 130, 255))
	Toggle({
		Section = Auto_Yama,
		Title = "Auto Yama",
	}, "Auto Yama")
	Toggle({
		Section = Auto_Yama,
		Title = "Auto Yama Fully",
	}, "Auto Yama Fully")

	Auto_Yama.CreateLable({
		Name = "⚔️ Auto Tushita ⚔️"
	}):SetColor(Color3.fromRGB(205, 130, 255))
	Toggle({
		Section = Auto_Yama,
		Title = "Auto Tushita",
	}, "Auto Tushita")
	
end

do 
	local AutoDojoQuest = AutomaticTab.CreatePage({
		Name = "🥋 Auto Dojo Quest 🥋", Side = "Right"
	})
	AutoDojoQuest.CreateLable({
		Name = "🥋 Auto Dojo Quest 🥋"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({
		Section = AutoDojoQuest,
		Title = "Auto Dojo Quest",
	}, "Auto Dojo Quest")

	Toggle({
		Section = AutoDojoQuest,
		Title = "Auto Blaze Ember",
	}, "Auto Blaze Ember")

	AutoDojoQuest.CreateLable({
		Name = "🦖 Auto Relic Events 🦖"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Toggle({
		Section = AutoDojoQuest,
		Title = "Auto Relic Events",
	}, "Auto Relic Events")
	Toggle({
		Section = AutoDojoQuest,
		Title = "Auto Collect Dragon Bones",
	}, "Auto Collect Dragon Bones")
	Toggle({
		Section = AutoDojoQuest,
		Title = "Auto Collect Dragon Eggs",
	}, "Auto Collect Dragon Eggs")
end

do 
	local AutoBerries = AutomaticTab.CreatePage({
		Name = "Auto Berries", Side = "Right"
	})

	AutoBerries.CreateLable({
		Name = "🍒 Auto Berries 🍒"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	t['Berries'] = AutoBerries.CreateLable({
		Name = "Total",
		Flag = "Total",
		Log = true,
	})
	Toggle({
		Section = AutoBerries,
		Title = "Auto Berries",
	}, "Auto Berries")
	
end

do
	local Automatic = AutomaticTab.CreatePage({
		Name = "Other",
		Side =  "Right"
	})

	Automatic.CreateLable({
		Name = "💁 Other Page2 💁"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	Automatic.CreateLable({ Name = "🎸 Auto Soul Guitar 🎸" })
	Toggle({ Section = Automatic, Title = "Auto Soul Guitar Quest", }, "Auto_Soul_Guitar")

	Automatic.CreateLable({ Name = "👻 Auto Awakening One Quest 👻" })
	Toggle({ Section = Automatic, Title = "Auto Awakening One Quest", }, "Auto_Awakening_One_Quest")
	
	Automatic.CreateLable({ Name = "🦍 Auto Kill Boss 🦍" })
	local SelectBossManu = Automatic.CreateDropdown({ Name = "Select Boss", List = (function()
		local BossTable = {}
		for i, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if v:FindFirstChildOfClass("Humanoid") then
				if string.find(v:FindFirstChildOfClass("Humanoid").DisplayName, "Boss") then
					table.insert(BossTable, v.Name)
				end
			end
		end
		for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
			if v:FindFirstChildOfClass("Humanoid") then
				if string.find(v:FindFirstChildOfClass("Humanoid").DisplayName, "Boss") then
					table.insert(BossTable, v.Name)
				end
			end
		end
		return BossTable
	end)(), Callback = function(value)
		_G.Settings.Select_Boss = value
		SaveSettings()  
	end })
	
	Automatic.CreateButton({ Name = "Refres Select Boss Manu", Callback = function() 
		local BossTable = {}
		for i, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if v:FindFirstChildOfClass("Humanoid") then
				if string.find(v:FindFirstChildOfClass("Humanoid").DisplayName, "Boss") then
					table.insert(BossTable, v.Name)
				end
			end
		end
		for i, v in pairs(game:GetService("Workspace").Enemies:GetDescendants()) do
			if v:FindFirstChildOfClass("Humanoid") then
				if string.find(v:FindFirstChildOfClass("Humanoid").DisplayName, "Boss") then
					table.insert(BossTable, v.Name)
				end
			end
		end
		SelectBossManu:Add(BossTable)
	end})

	Toggle({ Section = Automatic, Title = "Auto Farm Boss", }, "Auto_Farm_Boss")
	
	Automatic.CreateLable({ Name = "☁️ Tyrant of the Skies ☁️" })
	t['have Tyrant of the Skies'] = Automatic.CreateLable({ Name = "☁️ Tyrant of the Skies : 🔴" })
	Toggle({ Section = Automatic, Title = "Auto Tyrant of the Skies", }, "Auto Tyrant of the Skies")
	

	--[[Automatic.CreateLable({ Name = "☀️ Summer Event ☀️" })
	t['haveCloud'] = Automatic.CreateLable({ Name = "⛈️ Cloud Zone : 🔴" })
	t['Summer Token'] = Automatic.CreateLable({ Name = "☀️ Summer Token : 0" })
	
	Toggle({ Section = Automatic, Title = "Auto Token Summer Event", }, "Auto Token Summer Event")

	Automatic.CreateButton({ Name = "Buy Fruits Summer Event", Callback = function() 
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local CommF_ = ReplicatedStorage.Remotes.CommF_

		CommF_:InvokeServer("Cousin","BuySummer")
	end})

	Automatic.CreateLable({ Name = "👹 Auto Oni Event 👹" })
	t['have Oni Event'] = Automatic.CreateLable({ Name = "👹 Oni Event : 🔴" })
	t['Oni Token'] = Automatic.CreateLable({ Name = "👹 Oni Token : 0" })
	Toggle({ Section = Automatic, Title = "Auto Oni Event", }, "Auto Oni Event")
	Automatic.CreateButton({ Name = "Roll Something Event", Callback = function() 
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("Cousin", "BuyRedHead")
	end})]]
	Automatic.CreateLable({ Name = "😈 Pain Boss Event 😈" })
	t['haveCloud'] = Automatic.CreateLable({ Name = "⛈️ Cloud Zone : 🔴" })
	t['Summer Token'] = Automatic.CreateLable({ Name = "☀️ Summer Token : 0" })
	Toggle({ Section = Automatic, Title = "Auto Pain Boss Event", }, "Auto Pain Boss Event")
	
	Automatic.CreateLable({ Name = "😈 Auto Rip Eevet 😈" })
	t['Oni Token'] = Automatic.CreateLable({ Name = "👹 Oni Token : 0" })
	Toggle({ Section = Automatic, Title = "Auto Rip Eevet", }, "Auto Rip Eevet")
	Automatic.CreateButton({ Name = "Roll Something Event", Callback = function() 
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("Cousin", "BuyRipEvent")
	end})
end

do
	local TeleportWorldSection = TapWebHook.CreatePage({
		Name = "🌍 Teleport World 🌍", Side = "Left"
	})

	TeleportWorldSection.CreateLable({
		Name = "🌍 Teleports 🌍"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	local worlds = {
		{Name = "First World [1]", Callback = "_C('TravelMain')"},
		{Name = "Second World [2]", Callback = "_C('TravelDressrosa')"},
		{Name = "Third World [3]", Callback = "_C('TravelZou')"}
	}

	for _, world in pairs(worlds) do
		TeleportWorldSection.CreateButton({
			Name = "Teleport to " .. world.Name,
			Callback = function() loadstring(world.Callback)() end
		})
	end

	TeleportWorldSection.CreateDropdown({
		Name = "Select Island", Flag = "Select_Island", List = islandlist, 
		Value = _G.Settings['Select Island'], 
		Callback = function(value) 
			_G.Settings['Select Island'] = value 
			SaveSettings() 
		end
	})

	TeleportWorldSection.CreateToggle({
		Name = "Start Tween Island", 
		Value = _G.Settings["Teleport To Island"], Mode = true, 
		Callback = function(value)
			_G.Settings['Teleport To Island'] = value
			if value then
				local SelectIsland = _G.Settings['Select Island']
				
				if SelectIsland == "WindMill" then
					TeleportIs(CFrame.new(979.79895019531, 16.516613006592, 1429.0466308594),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Marine" then
					TeleportIs(CFrame.new(-2566.4296875, 6.8556680679321, 2045.2561035156),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Middle Town" then
					TeleportIs(CFrame.new(-690.33081054688, 15.09425163269, 1582.2380371094),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Jungle" then
					TeleportIs(CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Pirate Village" then
					TeleportIs(CFrame.new(-1181.3093261719, 4.7514905929565, 3803.5456542969),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Desert" then
					TeleportIs(CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Snow Island" then
					TeleportIs(CFrame.new(1347.8067626953, 104.66806030273, -1319.7370605469),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "MarineFord" then
					TeleportIs(CFrame.new(-4914.8212890625, 50.963626861572, 4281.0278320313),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Colosseum" then
					TeleportIs( CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Sky Island 1" then
					TeleportIs(CFrame.new(-4869.1025390625, 733.46051025391, -2667.0180664063),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Sky Island 2" then  
					_C("requestEntrance",Vector3.new(-4607.82275, 872.54248, -1667.55688),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Sky Island 3" then
					_C("requestEntrance",Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Prison" then
					TeleportIs( CFrame.new(4875.330078125, 5.6519818305969, 734.85021972656),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Magma Village" then
					TeleportIs(CFrame.new(-5247.7163085938, 12.883934020996, 8504.96875),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Under Water Island" then
					_C("requestEntrance",Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
				elseif SelectIsland == "Fountain City" then
					TeleportIs(CFrame.new(5127.1284179688, 59.501365661621, 4105.4458007813),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Shank Room" then
					TeleportIs(CFrame.new(-1442.16553, 29.8788261, -28.3547478),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Mob Island" then
					TeleportIs(CFrame.new(-2850.20068, 7.39224768, 5354.99268),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "The Cafe" then
					TeleportIs(CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Frist Spot" then
					TeleportIs(CFrame.new(-11.311455726624, 29.276733398438, 2771.5224609375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Dark Area" then
					TeleportIs(CFrame.new(3780.0302734375, 22.652164459229, -3498.5859375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Flamingo Mansion" then
					TeleportIs(CFrame.new(-483.73370361328, 332.0383605957, 595.32708740234),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Flamingo Room" then
					TeleportIs(CFrame.new(2284.4140625, 15.152037620544, 875.72534179688),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Green Zone" then
					TeleportIs( CFrame.new(-2448.5300292969, 73.016105651855, -3210.6306152344),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Factory" then
					TeleportIs(CFrame.new(424.12698364258, 211.16171264648, -427.54049682617),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Colossuim" then
					TeleportIs( CFrame.new(-1503.6224365234, 219.7956237793, 1369.3101806641),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Zombie Island" then
					TeleportIs(CFrame.new(-5622.033203125, 492.19604492188, -781.78552246094),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Two Snow Mountain" then
					TeleportIs(CFrame.new(753.14288330078, 408.23559570313, -5274.6147460938),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Punk Hazard" then
					TeleportIs(CFrame.new(-6127.654296875, 15.951762199402, -5040.2861328125),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Cursed Ship" then
					TeleportIs(CFrame.new(923.40197753906, 125.05712890625, 32885.875),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Ice Castle" then
					TeleportIs(CFrame.new(6148.4116210938, 294.38687133789, -6741.1166992188),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Forgotten Island" then
					TeleportIs(CFrame.new(-3032.7641601563, 317.89672851563, -10075.373046875),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Ussop Island" then
					TeleportIs(CFrame.new(4816.8618164063, 8.4599885940552, 2863.8195800781),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Mini Sky Island" then
					TeleportIs(CFrame.new(-288.74060058594, 49326.31640625, -35248.59375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Great Tree" then
					TeleportIs(CFrame.new(2681.2736816406, 1682.8092041016, -7190.9853515625),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Castle On The Sea" then
					TeleportIs(CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "MiniSky" then
					TeleportIs(CFrame.new(-260.65557861328, 49325.8046875, -35253.5703125),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Port Town" then
					TeleportIs(CFrame.new(-83.59403991699219, 10.977038383483887, 5468.43798828125),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Hydra Island" then
					TeleportIs(CFrame.new(5228.8842773438, 604.23400878906, 345.0400390625),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Floating Turtle" then
					TeleportIs(CFrame.new(-13274.528320313, 531.82073974609, -7579.22265625),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Mansion" then
					_C("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
					TeleportIs(CFrame.new(-12471.169921875, 374.94024658203, -7551.677734375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Haunted Castle" then
					TeleportIs(CFrame.new(-9515.3720703125, 164.00624084473, 5786.0610351562),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Ice Cream Island" then
					TeleportIs(CFrame.new(-902.56817626953, 79.93204498291, -10988.84765625),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Peanut Island" then
					TeleportIs(CFrame.new(-2062.7475585938, 50.473892211914, -10232.568359375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "Cake Island" then
					TeleportIs(CFrame.new(-1884.7747802734375, 19.327526092529297, -11666.8974609375),function()
						return _G.Settings['Teleport To Island']
					end)
				elseif SelectIsland == "ChocolateIsland" then
					TeleportIs(CFrame.new(58.0104446, 24.7342396, -12061.5898),function()
						return _G.Settings['Teleport To Island']
					end) 
				elseif SelectIsland == "Tiki Out post" then
					TeleportIs(CFrame.new(-16249.8330078125, 9.403817176818848, 442.6405334472656),function()
						return _G.Settings['Teleport To Island']
					end) 
				end	
			else
				if Client.Character.HumanoidRootPart:FindFirstChild('BodyClip') then
					Client.Character.HumanoidRootPart:FindFirstChild('BodyClip'):Destroy()
				end
				_G.StopTween = true wait(.2) _G.StopTween = false
			end
			SaveSettings()
		end
	})
end

do 
	local WebHookSection = TapWebHook.CreatePage({
		Name = "💻 Web Hooks 💻", Side = "Right"
	})

	WebHookSection.CreateLable({
		Name = "💻 Web Hooks 💻"
	}):SetColor(Color3.fromRGB(205, 130, 255))

	WebHookSection.CreateLable({
		Name = "💻 Web Hooks Soon 💻"
	}):SetColor(Color3.fromRGB(255, 255, 0))
end

local CreatePage = TapMisc.CreatePage({Side = "Left"}) do
	CreatePage.CreateLable({
		Name = string.upper('⚙️ Misc ⚙️')
	}):SetColor(Color3.fromRGB(205, 130, 255))

	local BypassScWalkJump = task.spawn(function()
		Client.Character:FindFirstChild('Humanoid'):GetPropertyChangedSignal("JumpPower"):Connect(function()
			if _G.Settings['Set Jump']  then
				Client.Character:FindFirstChild('Humanoid').JumpPower = _G.Settings['Set Jump Power']
			end
		end)

		Client.Character:FindFirstChild('Humanoid'):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if _G.Settings['Set Walk'] then
				Client.Character:FindFirstChild('Humanoid').WalkSpeed = _G.Settings['Set Walk Speed']
			end
		end)
	end)
	Slider({
		Section = CreatePage,
		Title = "Walk Speed",
		Max = 300,
		Min = 16,
	}, "Set Walk Speed")
	Toggle({
		Section = CreatePage,
		Title = "Set Walk Speed",
	}, "Set Walk")
	Slider({
		Section = CreatePage,
		Title = "Jump Power",
		Max = 300,
		Min = 16,
	}, "Set Jump Power")
	Toggle({
		Section = CreatePage,
		Title = "Set Jump Power",
	}, "Set Jump")
	Toggle({
		Section = CreatePage,
		Title = "Walk On Water",
	}, "Walk On Water")
	Toggle({
		Section = CreatePage,
		Title = "Noclip",
	}, "Noclip Toggle")
	Toggle({
		Section = CreatePage,
		Title = "Romove Fog",
	}, "Romove Fog")
	Toggle({
		Section = CreatePage,
		Title = "Set day time",
	}, "daytimd")
	Button({
		Section = CreatePage,
		Title = "Fix Bug Walk / Jump"
	}, function()
		task.cancel(BypassScWalkJump)
		BypassScWalkJump = nil
		BypassScWalkJump = task.spawn(function()
			Client.Character:FindFirstChild('Humanoid'):GetPropertyChangedSignal("JumpPower"):Connect(function()
				if _G.Settings['Set Jump']  then
					Client.Character:FindFirstChild('Humanoid').JumpPower = _G.Settings['Set Jump Power']
				end
			end)

			Client.Character:FindFirstChild('Humanoid'):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				if _G.Settings['Set Walk'] then
					Client.Character:FindFirstChild('Humanoid').WalkSpeed = _G.Settings['Set Walk Speed']
				end
			end)
		end)
	end)
end
local CreatePage = TapMisc.CreatePage({Side = "Right"}) do
	CreatePage.CreateLable({
		Name = string.upper('💾 Jobid 💾')
	}):SetColor(Color3.fromRGB(205, 130, 255))
	CreatePage.CreateJobidUI()
	Button({
		Section = CreatePage,
		Title = "Hop"
	}, function()
		HopServer()
	end)
	Button({
		Section = CreatePage,
		Title = "Hop Low"
	}, function()
		HopServer(true)
	end)
	Button({
		Section = CreatePage,
		Title = "Rejoin"
	}, function()
		local TeleportService = game:GetService("TeleportService")
		local Players = game:GetService("Players")
		local player = Players.LocalPlayer
		if player then
			TeleportService:Teleport(game.PlaceId, player)
		end
	end)

	local Players = {}
	for _,v in pairs(game.Players:GetChildren()) do
		if v.Name ~= Client.Name then
			table.insert(Players, v.Name)
		end
	end

	CreatePage.CreateLable({
		Name = string.upper('Player')
	}):SetFontSize(20)
	local PlayersList = Dropdown({
		Section = CreatePage,
		Title = 'Select Player',
		List = Players
	}, 'Select Player')
	
	game.Players.PlayerAdded:Connect(function(player)
		Players = {}
		for _,v in pairs(game.Players:GetChildren()) do
			if v.Name ~= Client.Name then
				table.insert(Players, v.Name)
			end
		end
		PlayersList:Add(Players)
	end)
	
	game.Players.PlayerRemoving:Connect(function(player)
		Players = {}
		for _,v in pairs(game.Players:GetChildren()) do
			if v.Name ~= Client.Name then
				table.insert(Players, v.Name)
			end
		end
		PlayersList:Add(Players)
	end)

	Button({
		Section = CreatePage,
		Title = "Teleport to Player"
	}, function()
		tp({ Target = game.Players:FindFirstChild(_G.Settings['Select Player']).Character.HumanoidRootPart.CFrame })
		wait(.2)
		_G.NeedNoClip = false
	end)
	CreatePage.CreateLable({
		Name = string.upper('AimBot')
	})
	Toggle({
		Title = "Aim Bot Skill Player",
		Section = CreatePage,
		Locker = true
	}, 'Aim Bot Skill Player')
	Toggle({
		Title = "Aim Bot FOV",
		Section = CreatePage,
		Locker = true
	}, 'Aim Bot FOV')
	Toggle({
		Title = "Auto Farm Bounty Hunter",
		Section = CreatePage,
		Locker = true
	}, 'Auto Farm Bounty Hunter')
end

local SettingsTap = Windown.ApplyTheme(Windown)
Windown.ContinueGUI()
Windown.Notify('success', { text = "Loading Success Good Luck >_<", time = 3 })

wait(1)
for i,v in next, workspace:GetChildren() do
	if v.Name == "Menu Sound" then
		v:Destroy()
	end
end

do
	local gg = getrawmetatable(game)
	local old = gg.__namecall
	setreadonly(gg,false)
	gg.__namecall = newcclosure(function(...)
		local method = getnamecallmethod()
		local args = {...}
		if tostring(args[1]) == "RemoteEvent" then
			if LockPosition ~= Vector3.new(0,0,0) and LockAim  then
				if  tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
					args[2] = LockPosition
				end
			end
		elseif tostring(method) == "InvokeServer" then
			if tostring(args[1]) == "" then
				if LockPosition ~= Vector3.new(0,0,0) and LockAim  then
					if tostring(args[3]) ~= "true" and tostring(args[3]) ~= "false" then
						args[3] = LockPosition
					end
				end
			end
			if args[2] == 'CastLineAtLocation' then
				args[4] = 100
			end
		end

		return old(unpack(args))
	end)
end

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local function onErrorMessageChanged(errorMessage)
    if errorMessage and errorMessage ~= "" then
        print("Error detected: " .. errorMessage)

        if player then
            wait()
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end

GuiService.ErrorMessageChanged:Connect(onErrorMessageChanged)

task.spawn(function()
	while true do
		if workspace:FindFirstChild('Menu Sound') then
			for i,v in next,  workspace:GetChildren() do 
				if v.Name == 'Menu Sound' then
					v:Destroy()
				end
			end
		end
		if ThradeSkill then
			for i,v in next, ThradeSkill do task.wait()
				task.cancel(v)
			end
			table.clear(ThradeSkill)
		end
        task.wait(3)
	end
end)

-- Apply saved language once the UI is built
task.spawn(function()
	task.wait(1)
	ApplyLanguage()
	task.wait(2)
	ApplyLanguage()
end)
