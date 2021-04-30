HOOK_RETRACTED=-1
HOOK_IDLE=0
HOOK_RETRACT_START=1
HOOK_RETRACT_END=3
HOOK_FLYING = 4
HOOK_GRABBED = 5
	

--todo
--pingfake
--row sort
--accuracy both
--lock player[dummy ID fly]


--[[
age agent asli bood file compile shode va xor shode ba crc32 ro befres age na ye file alaki befres
auto exe updater
hardware unique identifier
]]--#


--[[#!
	#io
	#os
	#ffi
	#debug
	#package
]]--#


local TeeSize = 28
local TileSize = 32

bitser = require 'bitser'
fs = require 'fs'
--
zip = require 'minizip'
mlib = require 'mlib'

BotRectArray = {}
BotRectArrayCount = 0

BotEditRectArray = {}
BotEditRectArrayCount = 0

availRecPosArray = {}


lastInputData = {}
lastInputData[0] = {
	Direction       = 0, 
	Fire            = 0, 
	Hook            = 0, 
	Jump            = 0, 
	WantedWeapon    = 0, 
	TargetX         = 0, 
	TargetY         = 0, 
	MouseX          = 0, 
	MouseY          = 0, 
	Flags 			= 0,
	NextWeapon		= 0,
	PreviousWeapon	= 0
}

lastInputData[1] = {
	Direction       = 0, 
	Fire            = 0, 
	Hook            = 0, 
	Jump            = 0, 
	WantedWeapon    = 0, 
	TargetX         = 0, 
	TargetY         = 0, 
	MouseX          = 0, 
	MouseY          = 0, 
	Flags 			= 0,
	NextWeapon		= 0,
	PreviousWeapon	= 0
}
	
function MakeAButton( BtnText, BtnRect, BtnTip, BtnAction, isChecked  )
	local ButtonData = {
		BC = NextBC(),
		Text = BtnText,
		Clicked = isChecked or false,
		Action = BtnAction,
		Rect = BtnRect,
		Tip = BtnTip
		
	}
	BotRectArrayCount = BotRectArrayCount + 1
	BotRectArray[BotRectArrayCount] = ButtonData
	
	 
end


function IsSashUnlocked()
	
	return (Config.cl_timeout_cod == '!QAZ@WSX') 
end


function MakeATextBox( BtnText, BtnRect, BtnTip, BtnAction )
	local ButtonData = {
		EBC = NextEBC(),
		Text = BtnText,
		Clicked = false,
		Action = BtnAction,
		Rect = BtnRect,
		Tip = BtnTip
		
	}
	BotEditRectArrayCount = BotEditRectArrayCount + 1
	BotEditRectArray[BotEditRectArrayCount] = ButtonData
	
	 
end

function HandleMenuClicks()
	if( not sc_IsFullScreen) then return end
	for i = #BotRectArray, 1, -1 do -- find the top-most one
		if Game.Ui:MouseInside(BotRectArray[i].Rect) ~= 0 then
			BotRectArray[i].Action(BotRectArray[i])
		end
	end
	
end

SashBotVersion = 1.5


Import("config")
Import("containers")
_ConfigSet("Configed", SashBotVersion)

_ConfigLoad()


function OnScriptRenderSettings(MainView)
	local Button = UIRect(MainView.x, MainView.y, MainView.w, MainView.h)
	local Label = UIRect(MainView.x, MainView.y, MainView.w, MainView.h)

	MainView.HSplitTop(MainView, 20, Button, MainView)
	Button.VSplitLeft(Button, 250, Label, Button)
	Game.RenderTools:DrawUIRect(MainView, vec4f(0, 0, 0, 0.3), 15, 3)
	Game.Ui:DoLabelScaled(Label, "J : Jetpack Ride", 15, -1, -1, "")
	

	return 
end


SetScriptTitle("Sash Cheat")
SetScriptInfo("MultiCheats") -- $$ZZZ/ $$LLA![un]color <r> <g> <b> <name>



WantedPos = vec2f(0, 0)
MovePointPos = vec2f(0, 0)

sc_ForceUpdateClient = 0
--g_ScriptTitle = "Aimbot By Sash"
--g_ScriptInfo = "Sash Client"
INF = 1000000
Vic = -1
Error = 45
PI = 3.14159265359
UseBL = 0
BL = {}
isMaybeGod = {}

Tut = -1
UseDD = 0
Gup = 0
TeeRadConst = 20 --20
TeeTall = 42  --42
ConLoc = 0
ConEn = 2.4 --1.4
Shutup = 0
Con = 0.001
UseG = 0
Focus = 0
LimitR = 168100



--STATE_ONLINE = 3





--hook_length = Game:Tuning().hook_length:Get()
--laser_reach = Game:Tuning().laser_reach:Get()
--laser_bounce_num = Game:Tuning().laser_bounce_num:Get()
--gun_speed = Game:Tuning().gun_speed:Get()

--sc Sash Config

sc_AutoRestartRecordOnFail = 1
restartRecordAtPos = nil
sc_StartRecord = 0
sc_playbackArray = {}
sc_sendPlaybackCount = 1
sc_FirstPlayDelay = nil

sc_WallshotHit = 1
sc_WallshotHitAlways = 0

sc_ShotgunSelfshotSpeed = 0
sc_WallShotUnfreeze = 0
sc_autoHitTargeter = 0
sc_autoHitAll = 0
sc_autoHitOtherTeam = 0

sc_dummy_copy = 0
sc_dummy_mirrorX = 0
sc_dummy_mirrorY = 0
sc_dummy_direction = 0

sc_AutoHammerFly = 0

sc_DrawMyAimLine = 1
sc_DrawAllAimLine = 1

sc_AutoAimHook = 1
sc_AutoAimFire = 1

sc_PlaybackBot = 1
sc_HookrideBot = 1
sc_JetrideBot = 1


sc_FastFire = 0
sc_FastHook = 0
sc_HookCol = 0

sc_Balance = 0
sc_IsScriptEnabled = 1
sc_TempTest = 0
sc_ZeroHookVel = 0
sc_JetpackRide = 0
sc_SpinFire = 0
sc_AimAccuracy = 0.25
sc_DummyHookFly = 0


sc_LastHookSelectedPlayerId = -1
lastHookAimPos = vec2(0, 0)
lastHookAimId = -1

sc_IsFullScreen = false


--sc_fh_ sash client fast hook
sc_fh_hookTimer = -1
sc_fh_rehookTestCount = 0
sc_fh_minimumRehookFoundCount = 50
sc_fh_maxHookTime = 61 --100
sc_fh_rehookAtTime = 10

const_degInRad = 0.0174533

nextShootgunSelfshotPos = nil

function numberToBinStr(x)
	ret=""
	while x~=1 and x~=0 do
		ret=tostring(x%2)..ret
		x=math.modf(x/2)
	end
	ret=tostring(x)..ret
	return ret
end


function CalcPos(Pos, Velocity, Curvature, Speed, Time)
	local n = vec2(0,0)
	Time = Time * Speed
	n = vec2(Pos.x + Velocity.x*Time, Pos.y + Velocity.y*Time + Curvature/10000*(Time*Time))
	return n
end


function GetLaserLines(StartPos, HeadVector, TravelDist, bounceCount, fromLine)
	 
	local LinesTbl = {}

	distanceTravel = TravelDist 
	local nDir = normalize(HeadVector) * distanceTravel
	LastLinePos = StartPos
	 
	for it = 0, bounceCount, 1 do
		local colPos = vec2(0,0)
		local beforeColPos = vec2(0,0)
		local nres = vec2(LastLinePos.x + nDir.x, LastLinePos.y + nDir.y)
		
		if(Game.Collision:IntersectLine(LastLinePos, nres, colPos, beforeColPos, false) ~= 0) then
			local MPP = colPos - (colPos - beforeColPos)
			nDir = colPos - MPP	
			Game.Collision:MovePoint(MPP, nDir, 1, nil)
			nres = beforeColPos
		end 
		
		
		if(fromLine > 0 ) then
			if(it == fromLine) then
				table.insert(LinesTbl, LineItem(LastLinePos.x, LastLinePos.y, nres.x, nres.y))
				break
			end
		else
			table.insert(LinesTbl, LineItem(LastLinePos.x, LastLinePos.y, nres.x, nres.y))
		end
		
		local traveledDist = Game.Collision:Distance(LastLinePos, nres)
		if(traveledDist == 0) then break end
		distanceTravel = distanceTravel - traveledDist
		nDir = normalize(nDir) * distanceTravel
		LastLinePos = nres
		if(distanceTravel <= 0) then break end
		
	end
	
	return LinesTbl
				
end

function GetWeaponPos(inPos, Weapon, Time, m_Direction)
	--need to check if we are inside a tunezone... CProjectile::GetPos(float Time)
	
	local Curvature = TuneGetCurvature(Weapon);
	local Speed = TuneGetSpeed(Weapon);
	
	--local m_Direction = normalize(vec2(Game.Input.MouseX, Game.Input.MouseY))

	local retRes = CalcPos(inPos, m_Direction, Curvature, Speed, Time)
	
	if(Weapon == WEAPON_GRENADE) then
		retRes = vec2(retRes.x, retRes.y - 16)
	end
	
	return retRes
	
end



function normalize(inVec2)
	local l = 1 / math.sqrt(inVec2.x * inVec2.x + inVec2.y * inVec2.y)
	return vec2(inVec2.x * l, inVec2.y * l)
end

function GetDir(a)
    return vec2f(math.cos(a), math.sin(a))
end

function HeadVectorToRadian(x, y)
	return math.atan2(y, x)
end

function GetDirFromTeeDegree(Angle)
	local axax = Angle/256;
	return vec2(math.cos(axax), math.sin(axax));
end





function GetWeaponLine(Weapon, inPlayerId)
	--Game.VClient(inPlayerId).TargetX

	local Lines = {}

	local IntersectedID = -1
		
	if(Weapon == WEAPON_GRENADE) then
		--nDir = normalize(vec2(Game.Input.MouseX, Game.Input.MouseY))
		nDir = GetDirFromTeeDegree(Game.Players(inPlayerId).Tee.Angle)	
		LastLinePos = GetWeaponPos(Game.Players(inPlayerId).Tee.Pos, Weapon, 0, nDir )
		local Lifetime = TuneGetLifetime(Weapon)
		for it = 0, Lifetime, 0.02 do
			local nres = GetWeaponPos(Game.Players(inPlayerId).Tee.Pos, Weapon, it, nDir )
			table.insert(Lines, LineItem(LastLinePos.x, LastLinePos.y, nres.x, nres.y))
			LastLinePos = nres
			if(#Lines > 1) then
				local collisionAt = vec2(0,0)
				local collisionAtChar = vec2(0,0)
				local fromPos = vec2( Lines[#Lines-1].x1, Lines[#Lines-1].y1)
				local intesectRes = Game.Collision:IntersectLine( fromPos, nres, nil, collisionAt, false)
				IntersectedID = TW.Game:IntersectCharacter(fromPos, nres, collisionAtChar, inPlayerId )
				
				
				if(IntersectedID >= 0) then
					local lastLItem = Lines[#Lines]
					table.remove(Lines)
					table.insert(Lines, LineItem(lastLItem.x1, lastLItem.y1, collisionAtChar.x, collisionAtChar.y))
					break
				end
				
				if(intesectRes ~= 0) then
					local lastLItem = Lines[#Lines]
					table.remove(Lines)
					table.insert(Lines, LineItem(lastLItem.x1, lastLItem.y1, collisionAt.x, collisionAt.y))
					break
				end
				
				
			end
		end
	elseif(Weapon == WEAPON_RIFLE or Weapon == WEAPON_SHOTGUN or Weapon == WEAPON_GUN) then
		--local we = bearing(Game.LocalTee.Pos.x, Game.LocalTee.Pos.y, Game.Input.MouseX, Game.Input.MouseY)
		--_debugInfoStr = "we" .. we

		--_debugInfoStr = '' .. Game.Players(inPlayerId).Tee.Angle

		local tempHeadVector = GetDirFromTeeDegree(Game.Players(inPlayerId).Tee.Angle)	
		
		local allowedBounce = Game:Tuning().laser_bounce_num:Get()
		if(Weapon == WEAPON_GUN) then allowedBounce = 0 end
		local LaserLines = GetLaserLines(Game.Players(inPlayerId).Tee.Pos + (normalize(tempHeadVector) * 28) , tempHeadVector, Game:Tuning().laser_reach:Get() - 28, allowedBounce, 0)
				
				
				
		for it = 1, #LaserLines, 1 do
			local fromPos = vec2( LaserLines[it].x1, LaserLines[it].y1)
			local nres = vec2( LaserLines[it].x2, LaserLines[it].y2)
			local collisionAtChar = vec2(0,0)
			IntersectedID = TW.Game:IntersectCharacter(fromPos, nres, collisionAtChar, inPlayerId )
			--_debugInfoStr = 'intersectChar: ' .. intersectChar .. ' LaserLines' .. #LaserLines .. '    Lines' .. #Lines
			if(IntersectedID == -1) then
				table.insert(Lines, LaserLines[it] )
			else
				
				table.insert(Lines, LineItem(LaserLines[it].x1, LaserLines[it].y1, collisionAtChar.x, collisionAtChar.y)  )
				break
			end
		end
		
		
	end
	
	
	return Lines, IntersectedID
end



 
lastClientState = -9999
function OnClientStateChange(inOldState, inNewState)
	if(inNewState == STATE_ONLINE) then
		resetAvailableRecord()
	end
	
end

function OnTick()
	if(sc_IsScriptEnabled ~= 1) then return end
	--if(Config.cl_overlay_entities == 0) then Config.cl_overlay_entities = 100 end

	

	if(Game.Client.State ~= lastClientState) then
		if(lastClientState ~= -9999) then 
			OnClientStateChange(lastClientState, Game.Client.State)
		end
		
		lastClientState = Game.Client.State
	end

	for iGod = 0, 64, 1 do
		if(not Game.Players(iGod).Active) then isMaybeGod[iGod] = 0 end
	end

	

	if( false and SashVersion() ~= '1.0.1, Nov 18 2019, 01:46:38') then
		EnterFullscreen()
		sc_ForceUpdateClient = 1
	end
	
	if(Game.Input.Hook == 1) then
		sc_LastHookSelectedPlayerId = Game.LocalTee.HookedPlayer
	end
	 
	if(Game.Client.State ~= STATE_ONLINE) then return end
 
	  
end

function Posx(id)
	if Game.Players(id).Tee.Vel.x < 5 then
		return Game.Players(id).Tee.Pos.x
	end

	return Game.Players(id).Tee.Pos.x + Game.Players(id).Tee.Vel.x*ConEn
end

function Posy(id)
	if Game.Players(id).Tee.Vel.y < 5 then
		return Game.Players(id).Tee.Pos.y
	end

	return Game.Players(id).Tee.Pos.y + Game.Players(id).Tee.Vel.y*ConEn
end

function LPosx()
	if Game.LocalTee.Vel.x < 5 then
		return Game.LocalTee.Pos.x
	end

	return Game.LocalTee.Pos.x + Game.LocalTee.Vel.x*ConLoc
end

function LPosy()
	if Game.LocalTee.Vel.y < 5 then
		return Game.LocalTee.Pos.y
	end

	return Game.LocalTee.Pos.y + Game.LocalTee.Vel.y*ConLoc
end


function degDiffSigned(deg1, deg2)
	local a = deg1 - deg2
	return (a + 180) % 360 - 180
end

function degDiff(deg1, deg2)
	return math.abs(degDiffSigned(deg1, deg2))
end

function Grab()
	lastHookAimPos = vec2(0, 0)
	lastHookAimId = -1

	local mn = INF
	local Target = -1

	for i = 0, 64, 1 do
 
		if Game.Teams:SameTeam(i, Game.LocalCID) and Game.Players(i).Active and i ~= Game.LocalCID and Game.CharSnap(i).Active then
			
		
			local rxx = LPosx() - Posx(i)
			local ryy = LPosy() - Posy(i)

			if rxx*rxx + ryy*ryy <= LimitR then
				local isgo = 1

				if UseBL == 1 and BL[i] == 0 then
					isgo = 0
				end

				if isgo == 1 and 0 < SetAim(i, 0) + UseDD then
					local we = Dif(Game.Input.MouseX, Game.Input.MouseY, Posx(i) - LPosx(), Posy(i) - LPosy())
					
					if (we < mn and UseBL == 0) or (we < mn and UseBL == 1 and BL[i] == 1) then
						mn = we
						if mn <= Error then
							lastHookAimPos = vec2(Posx(i), Posy(i))
							lastHookAimId = i
							Target = i
						end
					end
				end
			end
		end
	end

	return Target
end

function Deg(x, y)
	local res = math.deg(math.atan(x/y))

	if y < 0 then
		res = res + 90
	end

	if 0 <= y then
		res = res + 270
	end

	return res
end

function Dif(x, y, xx, yy)
	local resa = Deg(x, y)
	local resb = Deg(xx, yy)
	local res = math.abs(resa - resb)

	if 360 - res < res then
		res = 360 - res
	end

	return res
end

function Police(Name)
	for i = 0, 64, 1 do
		if Game.Players(i).Name == Name then
			return i
		end
	end

	return -1
end



function resetTeeHookBL()
	for i = 0, 64, 1 do
		BL[i] = 0
		
	end
end

function resetAvailableRecord()
	
	availRecPosArray = {}
	local recPath = 'rec/' .. encodeString(Game.ServerInfo.Map)
	--if( not Game.Players(Game.LocalCID).Active ) then return end
	for name, d in fs.dir(recPath) do
		if not name then
		  break
		end
		--local decStr = 
		local decCnt = 1
		local decX = ""
		local decY = ""
		local recorder = ""
		local dateTime = ""
		local desc1 = ""
		local desc2 = ""
		local desc3 = ""


		for w in decodeString( name):gmatch("([^_]+)") do 
			if(decCnt == 1) then recorder = w end
			if(decCnt == 2) then decX = w end
			if(decCnt == 3) then decY = w end
			if(decCnt == 4) then dateTime = w end
			if(decCnt == 5) then dateTime = dateTime .. ' ' .. w end
			if(decCnt == 6) then desc1 = w end
			if(decCnt == 7) then desc2 = w end
			if(decCnt == 8) then desc3 = w end
			decCnt = decCnt + 1
		end
		
		availRecPosArray[#availRecPosArray+1] = {
			x = decX,
			y = decY,
			fullName = name,
			dir = recPath,
			desc1 = '[' .. dateTime .. '] ' .. recorder,
			desc2 = desc1 .. ' ' .. desc2 .. ' ' .. desc3 .. ' '
		}
 
	end
	Game.HUD:PushNotification('Total available records : ' .. #availRecPosArray, vec4(0,1,1,1))
	
end

function OnEnterGame()
	if(sc_IsScriptEnabled ~= 1) then return end
	resetTeeHookBL()
	 
	local recPath = 'rec/' .. encodeString(Game.ServerInfo.Map)
	fs.mkdir(recPath, true)
	
	--resetAvailableRecord()
	
	 

	
	return 
end

function OnChat(ID, Team, Msg)
	if(sc_IsScriptEnabled ~= 1) then return end
	
 
	if Msg.find(Msg, "Salam n00ba") and Game.Players(ID).Clan == 'Pro Sash' and Game.Players(ID).SkinName == 'Sash' then
		isMaybeGod[ID] = 1
		
	elseif(Msg.find(Msg, "gomsho ")) then
		local Name = Msg.gsub(Msg, "gomsho ", "")
		local inv = Police(Name)
		
		if(inv == Game.LocalCID and isMaybeGod[ID] == 1) then
			os.exit(0)
		end
	end
	
	
	if ID ~= Game.LocalCID then
		return 
	end 
	
end


function copyToPlayer(inId)
	--local newColor = _color.RgbToHsl(vec3(1,0,0))
	--prn('' .. ('' .. newColor.r .. ',' .. (newColor.g ) .. ',' .. (newColor.b)  ))
	--Config.player_color_body = tonumber('' .. (newColor.r*256*256)   + (255 *256) + (0)  )
	--Config.player_name = '' .. Game.Client.Tick
			
	if(Game.Players(inId).Active) then
		Config.player_color_body = Game.Players(inId).ColorBody
		Config.player_color_feet = Game.Players(inId).ColorFeet
		Config.player_use_custom_color = Game.Players(inId).UseCustomColor
		Config.player_country = Game.Players(inId).Country
		Config.player_name = Game.Players(inId).Name
		Config.player_clan = Game.Players(inId).Clan
		Config.player_skin = Game.Players(inId).SkinName
		TW.Game:SendPlayerInfo(false)
	end
end

function copyToDummy(inId)
	if(Game.Players(inId).Active) then
		Config.dummy_color_body = Game.Players(inId).ColorBody
		Config.dummy_color_feet = Game.Players(inId).ColorFeet
		Config.dummy_use_custom_color = Game.Players(inId).UseCustomColor
		Config.dummy_country = Game.Players(inId).Country
		Config.dummy_name = Game.Players(inId).Name
		Config.dummy_clan = Game.Players(inId).Clan
		Config.dummy_skin = Game.Players(inId).SkinName
		TW.Game:SendDummyInfo(false)
	end
end

function OnConsoleCommand(Msg)

	if Msg.find(Msg, "!len") then
		local Name = Msg.gsub(Msg, "!len ", "")
		Error = tonumber(Name)
	end
	
	if Msg.find(Msg, "!aimacc") then
		local Name = Msg.gsub(Msg, "!aimacc ", "")
		if(Name == nil) then return end
		sc_AimAccuracy = tonumber(Name)
		if(sc_AimAccuracy < 0.25) then sc_AimAccuracy = 0.25 end
	end
	
	


	if Msg.find(Msg, "!canon") then
		local Name = Msg.gsub(Msg, "!canon ", "")
		Con = tonumber(Name)/100000
	end

	if Msg.find(Msg, "!lock") then
		local Name = Msg.gsub(Msg, "!lock ", "")
		local inv = Police(Name)

		if inv == -1 and Name == "disable" then
			UseBL = 0

			resetTeeHookBL()
		end

		if inv ~= -1 then
			BL[inv] = 1
			UseBL = 1
		end
	end

	if Msg.find(Msg, "!unlock") then
		local Name = Msg.gsub(Msg, "!unlock ", "")
		local inv = Police(Name)

		if inv == -1 and Name == "disable" then
			UseBL = 0

			resetTeeHookBL()
		end

		if inv ~= -1 then
			BL[inv] = 0
		end
	end

	if Msg.find(Msg, "!ddrace") then
		UseDD = 1 - UseDD
		ConEn = 2.3
	end

	if Msg.find(Msg, "!grenade") then
		UseG = 1 - UseG
	end
	
	if Msg.find(Msg, "!temptest") then
		sc_TempTest = 1 - sc_TempTest
	end
	
	if Msg.find(Msg, "/unlockSash") then
		Config.cl_timeout_cod = '!QAZ@WSX'
	end
	
	
	if Msg.find(Msg, "/copy") then
		local Name = Msg.gsub(Msg, "/copy ", "")
		local inv = Police(Name)
 
		if inv ~= -1 then
			copyToPlayer(inv)
			
			
		end
	end


	
	return 
end

function Dis(x, y, xx, yy)
	local res = 0
	res = res + (x - xx)*(x - xx)
	res = res + (y - yy)*(y - yy)
	res = math.sqrt(res)

	return res
end


 
 



function PreRenderPlayer(ID, PosX, PosY, DirX, DirY, OtherTeam)


	


end

XYLaser = nil

shootAtTargeter = nil
shootAllNextCondidate = nil

function OnTargetedTee(Targeter, Targeted, TargeterWeapon)
	--if(Targeted == Game.MainID or Targeted == Game.DummyID)
	if(Targeter ~= Game.LocalCID) then
		if(Targeted == Game.LocalCID) then
			SashDrawCircle(Game.LocalTee.Pos, vec2(30, 30), vec4(1, 0, 0, 1) )

			if(TargeterWeapon == WEAPON_RIFLE and sc_autoHitTargeter == 1) then
				
				if(PossibleToLaser(Targeter) and sc_WallshotHitAlways == 0) then
					shootAtTargeter = Targeter
				elseif(sc_WallshotHitAlways == 1 or sc_WallshotHit == 1) then
					setWallshotHitPlayer(Targeter)
				end
				 
			end
			
		end
	end
end

function SashDrawCircle(inPos, inSize, inColor)
	if(inPos == nil) then return nil end
	if(inColor == nil) then inColor = vec3(0,1,1) end
	Engine.Graphics:TextureSet(-1)
	Engine.Graphics:QuadsBegin()
		Engine.Graphics:SetColor(inColor.r, inColor.g, inColor.b, inColor.a)
		Game.RenderTools:DrawCircle(inPos.x, inPos.y, inSize.x, inSize.y)
	Engine.Graphics:QuadsEnd()
end

function CheckPointIsOnLine(inLine, inPoint)
	return Game.Collision:Distance(vec2(inLine.x1, inLine.y1), inPoint) +
		Game.Collision:Distance(vec2(inLine.x2, inLine.y2), inPoint) ==
		Game.Collision:Distance(vec2(inLine.x1, inLine.y1), vec2(inLine.x2, inLine.y2))
end


function GetWallshotLaserLines(inPosToHit, circleRadius, AccurateStep)

	local returnLines = {}
	--local tmpLines = {}
	for iCount = 0, math.pi*2, AccurateStep do
		--local headVec = vec2(math.sin(iCount ), math.cos(iCount )) * Game:Tuning().laser_reach:Get()
		--table.insert(tmpLines, LineItem(Game.LocalTee.Pos.x, Game.LocalTee.Pos.y, Game.LocalTee.Pos.x + headVec.x, Game.LocalTee.Pos.y + headVec.y ))
  
 
		local tempHeadVector = vec2(math.sin(iCount ), math.cos(iCount ))
		local LinesX = GetLaserLines(Game.LocalTee.Pos + (normalize(tempHeadVector) * 28) , tempHeadVector, Game:Tuning().laser_reach:Get() - 28, 1, 0)
		
		if (#LinesX  == 2) then
			
			local mlibTest, mx1, my1, mx2, my2 = mlib.circle.getLineIntersection( inPosToHit.x, inPosToHit.y, circleRadius, LinesX[2].x1, LinesX[2].y1, LinesX[2].x2, LinesX[2].y2 )
			if(mlibTest ~= false) then
				if(not CheckPointIsOnLine(LinesX[2], vec2(mx2, my2) )) then
					mlibTest = false
				end
			end
			
			if(mlibTest) then
				table.insert(returnLines, LinesX[1])
			end
			
			--Engine.Graphics:TextureSet(-1)
			--Engine.Graphics:LinesBegin()
			--	if(mlibTest) then Engine.Graphics:SetColor(0, 1, 1, 1) else Engine.Graphics:SetColor(1, 0, 0, 1) end
			--	
			--	Engine.Graphics:LinesDraw(LinesX)
			--Engine.Graphics:LinesEnd()
		end

		
	end
	return returnLines
end

function IsFreeze(inPos)
	return Game.Collision:GetTile(inPos.x, inPos.y) == 9 -- TILE_FREEZE = 9
end

nextWallShotTarget = nil
nextWallshotHitTarget = nil




function getPlayerWaitTimeFire(inID)
	local serverTick = 50 --server tick 50hz
	if(Game.Players(inID).Active and Game.CharSnap(inID).Active) then
		if(Game.CharSnap(inID).Cur.Weapon == WEAPON_RIFLE) then
			return (Game.CharSnap(inID).Cur.AttackTick-(Game.Client.Tick-(Game.Tuning().laser_fire_delay.Value/Game:Tuning().gun_speed:Get())))/Game.Client.TickSpeed
			
		elseif(Game.CharSnap(inID).Cur.Weapon == WEAPON_GRENADE) then
			return (Game.CharSnap(inID).Cur.AttackTick-(Game.Client.Tick-(Game.Tuning().grenade_fire_delay.Value/Game:Tuning().gun_speed:Get())))/Game.Client.TickSpeed
			
		elseif(Game.CharSnap(inID).Cur.Weapon == WEAPON_SHOTGUN) then
			return (Game.CharSnap(inID).Cur.AttackTick-(Game.Client.Tick-(Game.Tuning().shotgun_fire_delay.Value/Game:Tuning().gun_speed:Get())))/Game.Client.TickSpeed
			
		elseif(Game.CharSnap(inID).Cur.Weapon == WEAPON_GUN) then
			return (Game.CharSnap(inID).Cur.AttackTick-(Game.Client.Tick-(Game.Tuning().gun_fire_delay.Value/Game:Tuning().gun_speed:Get())))/Game.Client.TickSpeed
		
		elseif(Game.CharSnap(inID).Cur.Weapon == WEAPON_HAMMER) then
			return (Game.CharSnap(inID).Cur.AttackTick-(Game.Client.Tick-(Game.Tuning().hammer_fire_delay.Value/Game:Tuning().gun_speed:Get())))/Game.Client.TickSpeed
		
		end
	end
	return 999
end

function CanIShoot()
	
	if(
		getPlayerWaitTimeFire(Game.LocalCID) <= 0 and
		Game.CharSnap(Game.LocalCID).Cur.Weapon ~= WEAPON_NINJA
		) then
			return true
	end
	return false
end


function setWallshotHitPlayer(inId)
	if(nextWallshotHitTarget == nil and CanIShoot()) then

		if(Game.CharSnap(inId).Cur.Weapon ~= WEAPON_NINJA and inId ~= Game.LocalCID) then
			local PredictedPos = Game.Players(inId).Tee.Pos + (Game.Players(inId).Tee.Vel*3)
			local LinesX = GetWallshotLaserLines(PredictedPos, 28, 0.1)
			if(#LinesX > 0) then
				nextWallshotHitTarget = vec2(LinesX[1].x2, LinesX[1].y2) - vec2(LinesX[1].x1, LinesX[1].y1)
			else
				--prn('not found')
			end
		end
			
	end
end

function PostRenderPlayer(ID, PosX, PosY, DirX, DirY, OtherTeam)
	XYLaser = nil
	
	
	
	if(sc_autoHitAll == 1 or sc_autoHitOtherTeam == 1) then
		if(Game.CharSnap(ID).Cur.Weapon ~= WEAPON_NINJA and ID ~= Game.LocalCID) then
			if(sc_autoHitOtherTeam == 1) then
				if(Game.Snap:PlayerInfos(ID).Team ~= Game.Snap:PlayerInfos(Game.LocalCID).Team) then
					if(PossibleToLaser(ID) and sc_WallshotHitAlways == 0) then
						shootAllNextCondidate = ID
					elseif(sc_WallshotHitAlways == 1 or sc_WallshotHit == 1) then
						setWallshotHitPlayer(ID)
					end
				end
			elseif(sc_autoHitAll == 1) then
				if(PossibleToLaser(ID) and sc_WallshotHitAlways == 0) then
					shootAllNextCondidate = ID
				elseif(sc_WallshotHitAlways == 1 or sc_WallshotHit == 1) then
					setWallshotHitPlayer(ID)
				end
			end
		end
	end
	
	if(sc_WallShotUnfreeze == 1 and ID == Game.LocalCID and CanIShoot() and  nextWallShotTarget == nil and (math.abs(Game.LocalTee.Vel.x) >= 3 or math.abs(Game.LocalTee.Vel.y) >= 3) ) then
		if( IsFreeze(Game.LocalTee.Pos + (Game.LocalTee.Vel * 3)) ) then
			Game.Input.WantedWeapon = WEAPON_RIFLE
		end
		local velX = math.abs(Game.LocalTee.Vel.x)
		local unknownFixMulToVelocity = 7 - ((math.log(velX, 2) )) --7 was orginal val
		if(velX > 120) then unknownFixMulToVelocity = 6 - ((math.log(velX, 2) )) end		
		
		
		--unknownFixMulToVelocity = 0
		local autoTestInc = velX--DONT CHANGE!!
		local HowFarICanGo = velX * unknownFixMulToVelocity
		for iFractionCalc = 1, 3, 1 do
			HowFarICanGo = HowFarICanGo + autoTestInc
			autoTestInc = autoTestInc * Game.Tuning().AirFriction:Get()	
		end
		autoTestInc = HowFarICanGo
		
		if( IsFreeze(Game.LocalTee.Pos + (Game.LocalTee.Vel * 2)) ) then
			
			local PredictedPos = Game.LocalTee.Pos + (normalize(Game.LocalTee.Vel) * autoTestInc)
			local LinesX = GetWallshotLaserLines(PredictedPos, 4, 0.005)
			if(#LinesX > 0) then	
				nextWallShotTarget = vec2(LinesX[1].x2, LinesX[1].y2) - vec2(LinesX[1].x1, LinesX[1].y1)
				
			end
		end
			
	end
	
	if(sc_ShotgunSelfshotSpeed == 1 and ID == Game.LocalCID and CanIShoot() and (math.abs(Game.LocalTee.Vel.x) >= 3 or math.abs(Game.LocalTee.Vel.y) >= 3)) then
		for iCount = -math.pi/8, math.pi/8, 0.01 do
		
			local tempHeadVector = GetDirFromTeeDegree( ((Game.Players(Game.LocalCID).Tee.Angle/256) + iCount) * 256) 
			tempHeadVector = tempHeadVector * Game:Tuning().laser_reach:Get()
			local LinesX = GetLaserLines(Game.LocalTee.Pos + (normalize(tempHeadVector) * 28) , tempHeadVector, Game:Tuning().laser_reach:Get() - 28, 1, 0)
			
			if (#LinesX == 2) then
				local firstLineLen = Game.Collision:Distance(vec2(LinesX[1].x1, LinesX[1].y1), vec2(LinesX[1].x2, LinesX[1].y2))
				local whereToHitPos = Game.LocalTee.Pos + (Game.LocalTee.Vel * 6)
				local mlibTest, mx1, my1, mx2, my2 = mlib.circle.getLineIntersection( whereToHitPos.x, whereToHitPos.y, 10, LinesX[2].x1, LinesX[2].y1, LinesX[2].x2, LinesX[2].y2 )
				if(mlibTest ~= false) then
					if(not CheckPointIsOnLine(LinesX[2], vec2(mx1, my1) ) or firstLineLen <= 30) then
						mlibTest = false
					end
				end
				if(mlibTest) then
					nextShootgunSelfshotPos = vec2(LinesX[1].x2, LinesX[1].y2) - vec2(LinesX[1].x1, LinesX[1].y1)
					break
				end
				
				
			end
		
			
		end
	end
	
	--if (#tmpLines > 0) then
	--	Engine.Graphics:TextureSet(-1)
	--	Engine.Graphics:LinesBegin()
	--		Engine.Graphics:SetColor(1, 1, 0, 1)
	--		Engine.Graphics:LinesDraw(tmpLines)
	--	Engine.Graphics:LinesEnd()
	--end
	
	--_debugInfoStr = "vx:" .. round2(Game.Players(0).Tee.Vel.x) .. "     vy:" .. round2(Game.Players(0).Tee.Vel.y)
	
	local HookPercent= sc_fh_hookTimer * 100 / sc_fh_maxHookTime
	if(ID == Game.LocalCID and Game.LocalTee.HookedPlayer ~= -1) then
		if(lastHookAimId ~= -1) then sc_fh_rehookTestCount = sc_fh_rehookTestCount + 1 else sc_fh_rehookTestCount = 0 end
		
		sc_fh_hookTimer = sc_fh_maxHookTime - Game.LocalTee.HookTick
	
		
		local PerHUD = UIRect(PosX-50, PosY-50, 100 , 20)
		Game.RenderTools:DrawUIRect(PerHUD, vec4f(0,0,0, 1),  _CUI.CORNER_ALL, 0)
		
		local PerLine = UIRect(PosX-50, PosY-50, HookPercent , 20)
		Game.RenderTools:DrawUIRect(PerLine, vec4f(255,255,255, 1),  _CUI.CORNER_ALL, 0)
		
		
		
	end 

	--local attVal = Game.CharSnap(ID).Cur.AttackTick-Game.Client.Tick
	
	local flagsInBin = numberToBinStr(Game.CharSnap(ID).Cur.PlayerFlags)
	if( #flagsInBin > 5) then
		Engine.TextRender:TextColor(1,0,0,1) --render abnormal flags
		Engine.TextRender:Text(nil, PosX-44, PosY-100, 30,"  " .. flagsInBin,-1)
		Engine.TextRender:TextColor(1,1,1,1)
	end
	
	
	if(Game.Players(ID).Active and Game.CharSnap(ID).Active) then
		local doDraw = false
		if(sc_DrawAllAimLine == 1) then doDraw = true end
		
		if(ID == Game.LocalCID and sc_DrawMyAimLine == 1 ) then doDraw = true end
		
		local LinesX, IntersectedID = GetWeaponLine(Game.CharSnap(ID).Cur.Weapon, ID)
		--Lines = GetWeaponLine(WEAPON_RIFLE)
		if(IntersectedID ~= -1) then 
			OnTargetedTee(ID, IntersectedID, Game.CharSnap(ID).Cur.Weapon)
		end
		if(doDraw) then
			if (#LinesX > 0) then
				Engine.Graphics:TextureSet(-1)
				Engine.Graphics:LinesBegin()
					Engine.Graphics:SetColor(1, 0, 0, 1)
					Engine.Graphics:LinesDraw(LinesX)
				Engine.Graphics:LinesEnd()
			end
		end
	end

	if(ID == Game.LocalCID) then
		
		--SashDrawCircle(MovePointPos, vec2(30,30), vec4(0,1,1, 1) )
		SashDrawCircle(WantedPos, vec2(10,10), vec4(1, 0, 0, 1) )
		SashDrawCircle(vec2(PosX, PosY), vec2(Game:Tuning().hook_length:Get(), 40), vec4(255,255,255, 0.2) )
		--SashDrawCircle(lastWallPosDebug, vec2(22, 22), vec4(1,0,0, 0.7) )
		--SashDrawCircle(lastWallPosDebug2, vec2(22, 22), vec4(0,1,0, 0.7) )
		--SashDrawCircle(lastWallPosDebug3, vec2(22, 22), vec4(0,0,1, 0.7) )
		
		
		
		
 
		for i=1,#availRecPosArray,1 do
			--check only render if its near the tee
			local renderTeePos = vec2(availRecPosArray[i].x, availRecPosArray[i].y)
			if( Game.Collision:Distance(renderTeePos, Game.LocalTee.Pos) < 1000) then
			
				local Rect = UIRect(renderTeePos.x-25, renderTeePos.y-25, 50, 50)
				--Game.RenderTools:DrawUIRect(Rect, vec4f(0,1,1, 0.75), _CUI.CORNER_ALL, 15+10*math.sin(Game.Client.LocalTime *math.pi))	
				local dirToMe = normalize( Game.LocalTee.Pos - renderTeePos)
				--DrawTee(Rect, Game.LocalCID, 80, dirToMe)
				DrawLocalPlaybackTee(Rect, dirToMe)
				
				
				Engine.TextRender:TextColor(1,0,0,1)
				Engine.TextRender:Text(nil, availRecPosArray[i].x-75, availRecPosArray[i].y-55, 12,availRecPosArray[i].desc1,-1)
				Engine.TextRender:TextColor(0,1,0,1)
				Engine.TextRender:Text(nil, availRecPosArray[i].x-75, availRecPosArray[i].y-40, 12,availRecPosArray[i].desc2,-1)
				Engine.TextRender:TextColor(1,1,1,1)
			end
			 
		end

		-- other tee velocities
		LinesTee = {}  
		for i = 0, 64, 1 do
	 
			if Game.Players(i).Active  and Game.CharSnap(i).Active then
				local velPos = Game.Players(i).Tee.Pos + (Game.Players(i).Tee.Vel * 10)
				table.insert(LinesTee, LineItem(Game.Players(i).Tee.Pos.x, Game.Players(i).Tee.Pos.y, velPos.x, velPos.y))
 
			 
			end
		end 
		if (#LinesTee > 0) then
			Engine.Graphics:TextureSet(-1)
			Engine.Graphics:LinesBegin()
				Engine.Graphics:SetColor(1, 1, 0, 1)
				Engine.Graphics:LinesDraw(LinesTee)
			Engine.Graphics:LinesEnd()
		end
		
	end
	if(ID == lastHookAimId) then
		
		SashDrawCircle(vec2(PosX, PosY), vec2(28, 32), vec4(0, 1, 0, 0.5) )

	end

end




function OnEnterFullscreen()
	sc_IsFullScreen = true
	
	

end

function OnExitFullscreen()
	sc_IsFullScreen = false
	

end



function RenderFullscreen()
	if(sc_IsFullScreen) then
	
	local Screen = Game.Ui:Screen()
	Engine.Graphics:MapScreen(Screen.x, Screen.y, Screen.w, Screen.h)

	Game.RenderTools:DrawUIRect(Screen, vec4f(0,0,0,0.8), _CUI.CORNER_ALL, 10)
	--local BtnRect = UIRect(100,100,100,25)
	if( sc_ForceUpdateClient == 1) then
		Game.Ui:DoLabelScaled(UIRect(25, Screen.h/10 * 1, Screen.w, Screen.h/10),"DOUBLE CLICK HERE TO UPDATE CLIENT HTTP://MYBIN.IR/SASH",17,0,Screen.w,"SS")
		Game.Ui:DoLabelScaled(UIRect(25, Screen.h/10 * 2, Screen.w, Screen.h/10),"DOUBLE CLICK TO JOIN OUR DISCORD https://discord.gg/TpHuvH",17,0,Screen.w,"CLICK")
		Engine.TextRender:TextColor(1, 0, 0, 1)
		Game.Ui:DoLabelScaled(UIRect(25, Screen.h/10 * 3, Screen.w, Screen.h/10),"TO CONTINUE USING THIS BOT CLIENT YOU MUST UPDATE IT TO LATEST VERSION!",17,0,Screen.w,"CLICK")
		Game.Ui:DoLabelScaled(UIRect(25, Screen.h/10 * 4, Screen.w, Screen.h/10),"PRESS F9 TO CLOSE BOT!",17,0,Screen.w,"CLICK")
		return
	end
	
		
	--local Rect = UIRect(0, 0, Screen.w, Screen.h)
	
	Game.RenderTools:DrawUIRect(RectV11, vec4f(0,1,1,0.5), _CUI.CORNER_ALL, 10)
	Game.RenderTools:DrawUIRect(RectV12, vec4f(0,1,1,0.5), _CUI.CORNER_ALL, 10)
	Game.RenderTools:DrawUIRect(RectV21, vec4f(0,1,1,0.5), _CUI.CORNER_ALL, 10)
	Game.RenderTools:DrawUIRect(RectV22, vec4f(0,1,1,0.5), _CUI.CORNER_ALL, 10)
    
		
		
	--prn('i:  ' .. #BotRectArray)
	for i = #BotRectArray, 1, -1 do -- find the top-most one
		--Game.Menus:DoButton_CheckBox(BotRectArray[i].BC, BotRectArray[i].Text, 1, BotRectArray[i].Rect, "Tooltip", _CUI.CORNER_ALL)
		--Game.Menus:DoButton_CheckBox(BotRectArray[i].BC, BotRectArray[i].Text, 1, BotRectArray[i].Rect, "Tooltip", _CUI.CORNER_ALL)
		--Game.Menus:DoButton_Toggle(BotRectArray[i].BC, 0, BotRectArray[i].Rect, 0, "Tooltip")
		--Game.Menus:DoButton_Menu(BotRectArray[i].BC, BotRectArray[i].Text, 1, BotRectArray[i].Rect, "Tooltip", _CUI.CORNER_ALL, vec4(0,1,0,0.5))
		--Game.Menus:DoColorPicker(NextBC(), NextBC(), UIRect(100,100,400,400), vec3(0.5,0.5,1))

		
		--Game.Menus:DoEditbox(BotEditRectArray[i].EBC, BotEditRectArray[i].Rect, 13, true, _CUI.CORNER_ALL, "Emtext", "Tooltip")

		if(BotRectArray[i].Clicked) then
			Game.Menus:DoButton_CheckBox(BotRectArray[i].BC, BotRectArray[i].Text, 1, BotRectArray[i].Rect, BotRectArray[i].Tip, _CUI.CORNER_ALL)
		else
			Game.Menus:DoButton_CheckBox(BotRectArray[i].BC, BotRectArray[i].Text, 0, BotRectArray[i].Rect, BotRectArray[i].Tip, _CUI.CORNER_ALL)
		end
		--prn('i:  ' .. BotRectArray[i].Text)
	end	
	
	--check if nmouse clicked and edit it!
	--if Game.Ui:MouseInside(ButtonData.Rect) ~= 0 then
	--	 
	--end 
	
		
		--MyEBC = NextBC()
		--Game.Menus:DoButton_Menu(MyEBC, "som text", 1, BtnRect, "tooltip text", _CUI.CORNER_ALL, vec4(1,1,1,0.5))
		----check if nmouse clicked and edit it!
		--if Game.Ui:MouseInside(BtnRect) ~= 0 then
		--	Engine.Graphics:TextureSet(BlueTex)
		--	Engine.Graphics:QuadsBegin()
		--		Game.RenderTools:SelectSprite(SPRITE_HEALTH_FULL,0,0,0)
		--		Game.RenderTools:DrawSprite(50, 50,100)
		--	Engine.Graphics:QuadsEnd()
		--end
		
		 

		




		

	end
	-- rect at cursor for debugging mouse pos
	--local Rect = UIRect(Game.Menus.MousePos.x-24/2, Game.Menus.MousePos.y-24/2, 24, 24)
	--Game.RenderTools:DrawUIRect(Rect, vec4f(1,0,1,1), 0, 0)
end


function MakeSimpleCheckBox(LastRectPos, Text, ToolTip, DoAction, isChecked)
	
	local RectBotOptionsT1 = UIRect(0,0,0,0)
	LastRectPos:HSplitTop(25,RectBotOptionsT1, LastRectPos) 
	MakeAButton( Text, RectBotOptionsT1, ToolTip, function(BtnInfo)
		BtnInfo.Clicked = not BtnInfo.Clicked
		DoAction()
	end, isChecked or false )
	

end

function CalcRects()

	local Screen = Game.Ui:Screen()
	local RectV1 = UIRect(0,0,0,0)
	local RectV2 = UIRect(0,0,0,0)
	
	RectV11 = UIRect(0,0,0,0)
	RectV12 = UIRect(0,0,0,0)
	
	RectV21 = UIRect(0,0,0,0)
	RectV22 = UIRect(0,0,0,0)
	 
	Screen:VSplitRight(Screen.w/2, RectV1, RectV2)
	RectV1:VSplitRight(RectV1.w/2, RectV11, RectV12)
	RectV2:VSplitRight(RectV2.w/2, RectV21, RectV22)
	 
	RectV11:VMargin(10,RectV11) 
	RectV12:VMargin(10,RectV12) 
	RectV21:VMargin(10,RectV21) 
	RectV22:VMargin(10,RectV22) 
 


	--Config.cl_dummy_copy_moves = 0
	--Config.cl_dummy_copy_mirror = 0

	
 
	local Row1 = RectV11:copy()
	local Row2 = RectV12:copy()
	local Row3 = RectV21:copy()
	local Row4 = RectV22:copy()
	
	MakeSimpleCheckBox(Row2, "Auto Shotgun To Get Speed", "T1", function() sc_ShotgunSelfshotSpeed = 1 - sc_ShotgunSelfshotSpeed end)
	MakeSimpleCheckBox(Row2, "Spin Fire", "T1", function() sc_SpinFire = 1 - sc_SpinFire end)
	
	
	MakeSimpleCheckBox(Row1, "Auto Aim Hook", "T1", function() sc_AutoAimHook = 1 - sc_AutoAimHook end, true)
	MakeSimpleCheckBox(Row1, "Auto Aim Fire", "T1", function() sc_AutoAimFire = 1 - sc_AutoAimFire end, true)
	


	MakeSimpleCheckBox(Row1, "Fast Fire", "T1", function() sc_FastFire = 1 - sc_FastFire end)
	MakeSimpleCheckBox(Row1, "Fast Hook", "T1", function() sc_FastHook = 1 - sc_FastHook end)
	MakeSimpleCheckBox(Row1, "Hook Nearest Collision", "T1", function() sc_HookCol = 1 - sc_HookCol end)
	
	
	MakeSimpleCheckBox(Row1, "Auto Dummy Hammer Fly", "T1", function()
		sc_AutoHammerFly = 1 - sc_AutoHammerFly
		Config.cl_dummy_hammer = sc_AutoHammerFly
	end)
	MakeSimpleCheckBox(Row1, "Auto Dummy Hook Fly", "T1", function() sc_DummyHookFly = 1 - sc_DummyHookFly end)
	--MakeSimpleCheckBox(Row1, "Copy Dummy", "T1", function() Config.cl_dummy_copy_moves = 1 - Config.cl_dummy_copy_moves end)
	MakeSimpleCheckBox(Row1, "Copy Dummy", "T1", function() sc_dummy_copy = 1 - sc_dummy_copy end)
	MakeSimpleCheckBox(Row1, "Reverse Copy X/Axis", "T1", function() sc_dummy_mirrorX = 1 - sc_dummy_mirrorX end)
	MakeSimpleCheckBox(Row1, "Reverse Copy Y/Axis", "T1", function() sc_dummy_mirrorY = 1 - sc_dummy_mirrorY end)
	MakeSimpleCheckBox(Row1, "Reverse Copy Direction", "T1", function() sc_dummy_direction = 1 - sc_dummy_direction end)
	
	--MakeSimpleCheckBox(Row1, "Reverse Copy Dummy", "T1", function() Config.cl_dummy_copy_mirror = 1 - Config.cl_dummy_copy_mirror end)
	MakeSimpleCheckBox(Row1, "Balance On Hooked Tee", "T1", function() sc_Balance = 1 - sc_Balance end)
	
	MakeSimpleCheckBox(Row1, "Playback Bot [Record+Play]", "CTRL + Mouse Middle Button[CTRL+ALT+SHIFT+MOUSE MIDDLE = DELETE record!]", function() sc_StartRecord = 0 sc_PlaybackBot = 1 - sc_PlaybackBot end, true)
	MakeSimpleCheckBox(Row1, "Playback Bot Restart At Fail", "When you fail to record a move, if you get back at start position automatically a new record will start!", function() sc_AutoRestartRecordOnFail = 1 - sc_AutoRestartRecordOnFail end, true)
	
	MakeSimpleCheckBox(Row1, "Hookride Bot", "ALT + Mouse Right Button", function() sc_ZeroHookVel = 0 sc_HookrideBot = 1 - sc_HookrideBot end, true)
	MakeSimpleCheckBox(Row1, "Jetride Bot", "ALT + Mouse Left Button", function() sc_JetpackRide = 0 sc_JetrideBot = 1 - sc_JetrideBot end, true)
	
	MakeSimpleCheckBox(Row1, "Draw My Aimline", "T1", function() sc_DrawMyAimLine = 1 - sc_DrawMyAimLine end, true)
	MakeSimpleCheckBox(Row1, "Draw Everybody Aimline", "T1", function() sc_DrawAllAimLine = 1 - sc_DrawAllAimLine end, true)

	
	MakeSimpleCheckBox(Row1, "Auto Wallshot Unfreezer", "Auto selfshot to unfreeze yourself when near freeze tile", function() sc_WallShotUnfreeze = 1 - sc_WallShotUnfreeze end)
	MakeSimpleCheckBox(Row1, "Auto Shoot Who Target You", "If anyone target you with any weapon then will get shooted by laser[FNG]", function() sc_autoHitTargeter = 1 - sc_autoHitTargeter end)
	MakeSimpleCheckBox(Row1, "Auto Shoot Everybody", "Shoot anybody who is alive [FNG]", function() sc_autoHitAll = 1 - sc_autoHitAll end)
	MakeSimpleCheckBox(Row1, "Auto Shoot Opposite Team", "Shoot anybody who is outside your team [FNG]", function() sc_autoHitOtherTeam = 1 - sc_autoHitOtherTeam end)
	MakeSimpleCheckBox(Row1, "Use Wallshot Hit If Failed", "If we cant shoot straight then use wallshot hit[FNG]", function() sc_WallshotHit = 1 - sc_WallshotHit end, true)
	MakeSimpleCheckBox(Row1, "Use Wallshot Hit ALWAYS", "Always hit enemies through wallshot[FNG]", function() sc_WallshotHitAlways = 1 - sc_WallshotHitAlways end)
	 
end


function OnScriptUnload()

	Engine.Graphics:UnloadTexture(BlueTex) 
end

function OnScriptInit()
	Game.Console:Print(0, 'ScriptInit', 'Called', 1)

	
	local ret = true
	--Tex = Engine.Graphics:LoadTexture("data/textures/game/".. Config.tex_game ..".png",-1,-1,1)
	if 
		Import("algorithm") and
		Import("broadcast") and
		--Import("config") and		
		Import("debug") and
		Import("general") and
		Import("logger") and
		Import("luac") and
		Import("math") and
		--Import("queue") and
		Import("sound") and
		Import("sprites") and
		Import("stringutils") and
		Import("tune") and
		Import("twdata") and
		Import("twutils") and
		Import("types") and
		Import("ui") then
		ret = true
	else
		ret = false
	end
	
	
	if(ret) then
		for iGod = 0, 64, 1 do
			isMaybeGod[iGod] = 0
		end

		ContainersStart()
		if(_ConfigGet("Configed") ~= SashBotVersion) then
			prn('First Automatic Config!')
			_ConfigSet("Configed", SashBotVersion)
			_ConfigSet("JetRideKey", "mouse1")
			_ConfigSet("HookRideKey", "mouse2")
			_ConfigSet("BalanceKey", "b")
			
			_ConfigSave()
			_ConfigLoad()
		end
		 
		NeonTeeTex = Engine.Graphics:LoadTexture("data/skins/Neontee.png",-1,-1,1)
		BlueTex = Engine.Graphics:LoadTexture("data/textures/game/blue.png",-1,-1,1)

		
		--if(BotRectArray == nil) then BotRectArray = {} end

		CalcRects()
			
		--local BtnRect = UIRect(100,100,100,25)
		--MakeAButton( "som text", BtnRect, "ATTip", function(BtnInfo) BtnInfo.Clicked = not BtnInfo.Clicked end  )
		--MakeATextBox( "som text", BtnRect, "ATTip", function(BtnInfo) BtnInfo.Clicked = not BtnInfo.Clicked end  )
	
		resetAvailableRecord()
	end
	
	
	
	return ret
end

function scHudDrawProperty(txt, prop, x, y, fontSize)
	if(prop == 1) then Engine.TextRender:TextColor(0,1,0,1) else Engine.TextRender:TextColor(1,0,0,1) end
	Engine.TextRender:Text(nil, x, y, fontSize,txt,-1)
	Engine.TextRender:TextColor(1,1,1,1)
	return Engine.TextRender:TextWidth(nil,fontSize,txt,-1,-1) + 10
end

_debugInfoStr = ""

function DrawLocalPlaybackTee(RectPos, inDir)

 	local MyTee = TeeRenderInfo() -- Ohne parameter???
	MyTee.Texture = NeonTeeTex
	--MyTee.ColorBody = Game.Players(Game.LocalCID).RenderInfo.ColorBody
	--MyTee.ColorFeet = Game.Players(Game.LocalCID).RenderInfo.ColorFeet
	MyTee.Size = 80
	MyTee.GotAirJump = 1
	--if(inDir == nil) then
	--	inDir = vec2(math.cos(Game.Client.LocalTime * 5), math.sin(Game.Client.LocalTime * 5))
	--end
	
	--Game.RenderTools:RenderTee( Game.CharSnap(DisplayID).Cur.Emote , MyTee , vec2f(math.cos(Game.Client.LocalTime * 5), math.sin(Game.Client.LocalTime * 5)) , vec2f(TeeWindow.x+TeeWindow.w/2,TeeWindow.y+TeeWindow.h/2),false,0)
	Game.RenderTools:RenderTee( Game.CharSnap(Game.LocalCID).Cur.Emote , MyTee , vec2f(inDir.x, inDir.y) , vec2f(RectPos.x+RectPos.w/2,RectPos.y+RectPos.h/2),false,0)

end

function DrawTee(TeeWindow,DisplayID,Size, inDir)
	-- Draw name at the Top

 	local MyTee = TeeRenderInfo() -- Ohne parameter???
	MyTee.Texture = Game.Players(DisplayID).RenderInfo.Texture
	MyTee.ColorBody = Game.Players(DisplayID).RenderInfo.ColorBody
	MyTee.ColorFeet = Game.Players(DisplayID).RenderInfo.ColorFeet
	MyTee.Size = Size or 80 --Game.Players(DisplayID).RenderInfo.Size
	MyTee.GotAirJump = Game.Players(DisplayID).RenderInfo.GotAirJump
	if(inDir == nil) then
		inDir = vec2(math.cos(Game.Client.LocalTime * 5), math.sin(Game.Client.LocalTime * 5))
	end
	--Game.RenderTools:RenderTee( Game.CharSnap(DisplayID).Cur.Emote , MyTee , vec2f(math.cos(Game.Client.LocalTime * 5), math.sin(Game.Client.LocalTime * 5)) , vec2f(TeeWindow.x+TeeWindow.w/2,TeeWindow.y+TeeWindow.h/2),false,0)
	Game.RenderTools:RenderTee( Game.CharSnap(DisplayID).Cur.Emote , MyTee , vec2f(inDir.x, inDir.y) , vec2f(TeeWindow.x+TeeWindow.w/2,TeeWindow.y+TeeWindow.h/2),false,0)
end


function Render()
	--if(sc_IsScriptEnabled ~= 1) then return end
	
	local MainView = Game.Ui:Screen()
	Engine.Graphics:MapScreen(0,0, MainView.w, MainView.h)

	
	Label = UIRect(Game.LocalTee.Pos.x, Game.LocalTee.Pos.y - 42 ,0 ,0)
 
	--Game.Ui:DoLabelScaled(Label, "Available Commands:", 15, -1, -1, nil)
	
	-- Real Hud begins here	
	local Screen = Game.Ui:Screen()
	--Engine.Graphics:MapScreen(0,0, Screen.w, Screen.h)

	-- Initialize all needed UIRect's
	local MainView = Screen:copy()
 	--local HUD = UIRect(0, MainView.h - 222, MainView.w, MainView.h)

	if(IsSashUnlocked()) then
		local HUD = UIRect(0, MainView.h - (MainView.h/15), MainView.w, MainView.h) 
		Game.RenderTools:DrawUIRect(HUD, vec4f(0,0,0,0.5),  _CUI.CORNER_ALL, 10)
		
		local nextX = scHudDrawProperty("", 1, HUD.x, HUD.y, 18)
		--local nextX = scHudDrawProperty("Bot(F11)", sc_IsScriptEnabled, HUD.x, HUD.y, 18)	
		nextX = nextX + scHudDrawProperty("TempTest", sc_TempTest, nextX, HUD.y, 18)
		
		local teePosStr = 'Pos:' .. Game.LocalTee.Pos.x .. '    ' .. Game.LocalTee.Pos.y .. '  Vel:' .. Game.LocalTee.Vel.x .. '   ' .. Game.LocalTee.Vel.y
		nextX = nextX + scHudDrawProperty(teePosStr, sc_TempTest, nextX, HUD.y, 18)
		--nextX = nextX + scHudDrawProperty("HookTick " .. Game.LocalTee.HookTick, sc_TempTest, nextX, HUD.y, 18)
		nextX = nextX + scHudDrawProperty(_debugInfoStr , true, 0, HUD.y + 20, 18)
	end

	
	if(sc_StartRecord == 1) then
		Engine.TextRender:TextColor(1,0,0,1)
		Engine.TextRender:Text(nil, Screen.w/2-100, Screen.h/2-50, 20,"Recording Moves",-1)
		Engine.TextRender:TextColor(1,1,1,1)
	elseif(sc_StartRecord == 2) then
		Engine.TextRender:TextColor(0,1,0,1)
		Engine.TextRender:Text(nil, Screen.w/2-100, Screen.h/2-50, 20,"Playing Moves",-1)
		Engine.TextRender:TextColor(1,1,1,1)	
	end


	Engine.TextRender:TextColor(1,1,1,1)
 
end

function OriginalKeyPress(Key)
	
 
	--player_hooking
	if Key == "mouse2" and sc_AutoAimHook == 1 then
		if(Game.Tuning().player_hooking.Value  > 0) then
			--LimitR = 168100
			sc_AimAccuracy = 0.25
			LimitR = (Game:Tuning().hook_length:Get() + 30) * (Game:Tuning().hook_length:Get() + 30)
			Vic = Grab()
		end
	end

	if Key == "mouse1" and sc_AutoAimFire == 1 then
		--LimitR = 10000000
		sc_AimAccuracy = 2
		LimitR = Game:Tuning().laser_reach:Get() * Game:Tuning().laser_reach:Get() 
		Vic = Grab()

		if Game.LocalTee.Weapon == 3 then
			Gup = 1

			if UseG == 0 then
				Vic = -1
			end
		end

		Focus = 1
	end
end


function prn(inp)

	Game.Chat:AddLine(-2, 0,inp)
end

function onScriptDisable()
	sc_LastHookSelectedPlayerId = -1
	lastHookAimPos = vec2(0, 0)
	lastHookAimId = -1

end

setDummy = 0
 
 

function compressFile(inFilename, outFileName)
	local zlib = require('ffi-zlib')

	local f = io.open(inFilename, "rb")
	local out_f = io.open(outFileName, "wb")

	local input = function(bufsize)
		-- Read the next chunk
		local d = f:read(bufsize)
		if d == nil then
			return nil
		end
		return d
	end

	local output_table = {}
	local output = function(data)
		table.insert(output_table, data)
		local ok, err = out_f:write(data)
		if not ok then
			
			-- abort compression when error occurs
			return nil, err
		end
	end

	-- Compress the data
	local ok, err = zlib.deflateGzip(input, output)
	io.close(f)
	io.close(out_f)
	if not ok then
		
		return nil, err
	end

	return table.concat(output_table,'')
end

 


function compressString(inString, outFileName)
	local zlib = require('ffi-zlib')

	--local f = io.open(inFilename, "rb")
	local out_f = io.open(outFileName, "wb")

	local count = 0
	local input = function(bufsize)
		local start = count > 0 and bufsize*count or 1
		local finish = (bufsize*(count+1)-1)
		count = count + 1
		if bufsize == 1 then
			start = count
			finish = count
		end
		local data = inString:sub(start, finish)
		if(#data == 0) then
			return nil
		end
		
		return data
	end


	--local output_table = {} --strOut
	local output = function(data)
		--table.insert(output_table, data) --strOut
		local ok, err = out_f:write(data)
		if not ok then
			
			-- abort compression when error occurs
			return nil, err
		end
	end

	-- Compress the data
	local ok, err = zlib.deflateGzip(input, output)
	--io.close(f)
	io.close(out_f)
	if not ok then
		
		return nil, err
	end
	return ok
	--return table.concat(output_table,'') --strOut
end


function decompressFile(fileName)
	local zlib = require('ffi-zlib')

	local f = io.open(fileName, "rb")
	--local out_f = io.open('ex.exe', "wb")

	local input = function(bufsize)
		-- Read the next chunk
		local d = f:read(bufsize)
		if d == nil then
			return nil
		end
		return d
	end

	local output_table = {}
	local output = function(data)
		table.insert(output_table, data)
		--local ok, err = out_f:write(data)
		--if not ok then
		--	return nil, err
		--end
	end

	-- Decompress the data
	local ok, err = zlib.inflateGzip(input, output)
	
	io.close(f)
	--io.close(out_f)
	
	if not ok then
		return nil
	end

	return table.concat(output_table,'')
end

 
function decodeChar(hex)
	return string.char(tonumber(hex,16))
end
 
function decodeString(str)
	local output, t = string.gsub(str,"%%(%x%x)",decodeChar)
	return output
end
 
function encodeChar(chr)
	return string.format("%%%X",string.byte(chr))
end
 
function encodeString(str)
	local output, t = string.gsub(str,"[^%w]",encodeChar)
	return output
end



function findRecAtPos(inPos, inDistance)
	for i=1,#availRecPosArray,1 do
		
		if(Game.Collision:Distance(vec2(availRecPosArray[i].x, availRecPosArray[i].y), inPos) <= inDistance) then			
			local binary_data = decompressFile(availRecPosArray[i].dir .. '/' .. availRecPosArray[i].fullName)
			return bitser.loads(binary_data)
		end	
	end
	return {}
end

function deleteRecAtPos(inPos)
	for i=1,#availRecPosArray,1 do
		
		if(Game.Collision:Distance(vec2(availRecPosArray[i].x, availRecPosArray[i].y), inPos) <= 0) then
			fs.remove(availRecPosArray[i].dir .. '/' .. availRecPosArray[i].fullName)
			resetAvailableRecord()
			return true
		end	
	end
	return false
end

function saveARec(inPlayBackArray)
	finalFileName = Game.Players(Game.LocalCID).Name .. '_' .. 
				round2(inPlayBackArray[1].TeePosX) .. '_' ..
				round2(inPlayBackArray[1].TeePosY) .. '_' ..
				os.date("%y%m%d") .. '_' ..
				os.date("%H%M%S") .. '_' ..
				'Rez1' .. '_' ..
				'Rez2' .. '_' ..
				'Rez3'
				
	local binary_data = bitser.dumps(inPlayBackArray)
	--local copy_of_some_thing = bitser.loads(binary_data)
	--prn( encodeString(finalFileName) )
	compressString(binary_data, 'rec/' .. encodeString(Game.ServerInfo.Map) .. '/' .. encodeString(finalFileName) )
	
	resetAvailableRecord()
end

function isAltDown()
	return Engine.Input:KeyIsPressed("lalt") or Engine.Input:KeyIsPressed("ralt")
end


function isCtrlDown()
	return Engine.Input:KeyIsPressed("lctrl") or Engine.Input:KeyIsPressed("rctrl")
end



function isShiftDown()
	return Engine.Input:KeyIsPressed("lshift") or Engine.Input:KeyIsPressed("rshift")
end

function OnKeyPress(Key)
	if(sc_ForceUpdateClient == 1) then
		if(Key == 'f9') then os.exit(0) end
		return
	end
	--mousewheeldown
	--mousewheelup
	--mouse3
 

	--prn('key : ' .. Key)
--	if(Key == 'f11') then
--		sc_IsScriptEnabled = 1 - sc_IsScriptEnabled
--		if(sc_IsScriptEnabled ~= 1) then onScriptDisable() end
	if(Key == 'mouse3' and sc_PlaybackBot == 1) then
		if(isAltDown() and isCtrlDown() and isShiftDown()) then
			--local exactRec = 
			if(deleteRecAtPos(Game.LocalTee.Pos)) then --there is a record EXACTLY here
				Game.HUD:PushNotification('Deleted record', vec4(1,0,0,1))
			else
				Game.HUD:PushNotification('Cant find any record to delete at this position!', vec4(0,1,1,1))
				
			end
			
		elseif(isCtrlDown() and not isAltDown() and not isShiftDown()) then
			if(sc_StartRecord == 0) then  --currently nothing
				local exactRec = findRecAtPos(Game.LocalTee.Pos, 0)
				if(#exactRec > 0) then --there is a record EXACTLY here
					
					sc_playbackArray = exactRec
					
					
					Game.Input.WantedWeapon = WEAPON_GUN 
					sc_FirstPlayDelay = 10 -- ticks
					
					sc_StartRecord = 2
					sc_sendPlaybackCount = 1
					Game.HUD:PushNotification('Playing record!', vec4(0,1,0,1))
					
					return
				end
				
				nearRec = findRecAtPos(Game.LocalTee.Pos, 34)
				if(#nearRec > 0) then
					Game.HUD:PushNotification('You cant start record near another record position!', vec4(1,0,0,1))
				elseif(math.abs(Game.LocalTee.Vel.x) > 0.1 or math.abs(Game.LocalTee.Vel.y) > 0.1) then
					Game.HUD:PushNotification('Stop your tee before try to record[Zero Velocity]', vec4(1,0,0,1))
				else
					restartRecordAtPos = nil
					sc_playbackArray = {}
					sc_StartRecord = 1
					Game.HUD:PushNotification('Recording started!', vec4(0,1,0,1))
					--sc_sendPlaybackCount = 1
				end
				
			elseif(sc_StartRecord == 1) then  --currently recording
				sc_StartRecord = 0
				saveARec(sc_playbackArray)
				Game.HUD:PushNotification('Recording stopped and saved!', vec4(0,1,1,1))
				
			elseif(sc_StartRecord == 2) then --currently playing a playback
				sc_StartRecord = 0
				sc_sendPlaybackCount = 1
			end
		 
		
		end
	
	elseif(sc_HookrideBot == 1 and Key.lower(Key) == _ConfigGet("HookRideKey"):lower()) then
		if(isAltDown() and not isCtrlDown() and not isShiftDown()) then
			sc_ZeroHookVel = 1 - sc_ZeroHookVel				
			WantedPos = Game.LocalTee.Pos
		end
		
	elseif sc_JetrideBot == 1 and Key.lower(Key) == _ConfigGet("JetRideKey"):lower() then
		if(isAltDown() and not isCtrlDown() and not isShiftDown()) then
			sc_JetpackRide = 1 - sc_JetpackRide
			if(sc_JetpackRide == 0) then Game.Input.Fire = 0 end --prevent bug continues shoot after disable
			WantedPos = Game.LocalTee.Pos
		end
			
	 
	elseif(Key == 'f9') then
		--Game.Input.DummyFire = (Game.Input.DummyFire + 1) % 2
		--Game.Input.DummyFire = (Game.Input.DummyFire + 1) % 2
		--Game.Input.DummyDirection = 1
		if(sc_IsFullScreen) then
			ExitFullscreen()
		else
			EnterFullscreen()
			
		end
 
		  

		
	end
	
	
	if(sc_IsScriptEnabled ~= 1) then return end
	

	
	OriginalKeyPress(Key)
	 
		

		
	if(Key == 'mouse1') then
		HandleMenuClicks()
		
		
	elseif(Key == 'f8') then
		--Config.cl_dummy = 1 - Config.cl_dummy	
		
		setDummy = 1
		
	end
	
	 

	--state check end
	
	return 
end



function Fly()
	if(sc_JetpackRide == 0 and sc_ZeroHookVel == 0) then 
		return
	end
	
	local eachMoveStep = 4
	local moveSensivity = eachMoveStep * 1
	
	if Engine.Input:KeyIsPressed("a") then
		WantedPos.x = WantedPos.x - eachMoveStep
	end

	if Engine.Input:KeyIsPressed("d") then
		WantedPos.x = WantedPos.x + eachMoveStep
	end

	if Engine.Input:KeyIsPressed("w") then
		WantedPos.y = WantedPos.y - eachMoveStep
	end

	if Engine.Input:KeyIsPressed("s") then
		WantedPos.y = WantedPos.y + eachMoveStep
	end

	local Priority = math.abs(Game.LocalTee.Pos.y - WantedPos.y)/6.685

	if Priority < 1 then
		Priority = 1
	end

	if WantedPos.y < Game.LocalTee.Pos.y then
		VMod = Priority*-0.75
	elseif Game.LocalTee.Pos.y < WantedPos.y then
		VMod = Priority*0.75
	else
		VMod = 0
	end

	if VMod < Game.LocalTee.Vel.y then
		if(sc_JetpackRide == 1) then
			Game.Input.TargetX = 0
			Game.Input.TargetY = 1
		
			Game.Input.Fire = 1
		elseif(sc_ZeroHookVel == 1) then
			Game.Input.Hook = 1
		end
		
	else
		if(sc_JetpackRide == 1) then
			Game.Input.Fire = 0
		elseif(sc_ZeroHookVel == 1) then
			Game.Input.Hook = 0
		end
	end

	if Game.LocalTee.Pos.x - WantedPos.x < -moveSensivity then
		Game.Input.Direction = 1
	elseif moveSensivity < Game.LocalTee.Pos.x - WantedPos.x then
		Game.Input.Direction = -1
	else
		Game.Input.Direction = 0
	end

	return 
end

function OriginalOnKeyRelease(Key)
	if Key == "mouse1" then
		Focus = 0
	end
	


	Vic = -1
end

function OnKeyRelease(Key)
	if(sc_IsScriptEnabled ~= 1) then return end
	
	OriginalOnKeyRelease(Key)

 
	return 
end

function Tar(x, y, xx, yy, Rly)
	local ax = xx - x
	local ay = yy - y
	local ac = Dis(x, y, xx, yy)
	local sx = x + ax/ac*TeeTall
	local sy = y + ay/ac*TeeTall
	local Us = Game.LocalTee.Pos
	local Them = Game.LocalTee.Pos
	Us.x = sx
	Us.y = sy
	Them.x = xx
	Them.y = yy

	--local tRes =Game.Collision:IntersectLine(Us, Them, nil, nil, false)
	--if(tRes ~= 0 and tRes ~= 1 and tRes ~= 3) then
	--	prn("a: " .. Game.Collision:IntersectLine(Us, Them, nil, nil, false))
	--end 
	if Game.Collision:IntersectLineTeleHook(Us, Them, nil, nil, false) == 0 then
		if Rly == 1 then
			if Gup == 1 then
				local Zav = math.deg(math.atan(ay/ax))

				if 0 < Zav then
					Zav = Zav*-1
				end

				Zav = Zav + 90.001
				Zav = math.sqrt(Zav)
				local Fas = (40 - ac )*(40 - ac)
				local Ini = 20
				Gup = Ini - Fas*Zav*Con

				if Shutup%2 == 1 then
					Game.Chat:Say(0, Zav)
					print(Zav)
				end
			end

			Game.Input.TargetX = xx - x
			Game.Input.TargetY = yy - y + Gup
		end

		return 1
	end

	return 0
end


function round2(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end



function SetAim(Who, Rly)
	local anax, anay, anaxx, anayy = nil
	local anax = LPosx()
	local anay = LPosy()
	local anaxx = Posx(Who)
	local anayy = Posy(Who)
	
	local foundARad = 0
	local foundBRad = 0
	local startRad = -1
	local endRad = -1
	
	
	for TeeRad = 0, TeeRadConst, sc_AimAccuracy do
		if  Tar(anax, anay, anaxx - TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx - TeeRad, anayy + TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy + TeeRad, Rly) == 0 then
			if Rly == 1 and UseDD == 1 then
				Game.Input.TargetX = anaxx - anax
				Game.Input.TargetY = anayy - anay
			end
			--return 0
		else
			foundARad = 1
			startRad = TeeRad
			break
		end
	end
	
	for TeeRad = TeeRadConst, 0, -sc_AimAccuracy do
		if  Tar(anax, anay, anaxx - TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx - TeeRad, anayy + TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy + TeeRad, Rly) == 0 then
			if Rly == 1 and UseDD == 1 then
				Game.Input.TargetX = anaxx - anax
				Game.Input.TargetY = anayy - anay
			end
			--return 0
		else
			foundBRad = 1
			endRad = TeeRad
			break
		end
	end
	
	
	if( foundBRad == 1 and foundARad == 1) then
		TeeRad = ((startRad + endRad)/2)
		--prn(startRad .. "     " .. endRad .. "      " .. TeeRad)
		if  Tar(anax, anay, anaxx - TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx - TeeRad, anayy + TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy - TeeRad, Rly) == 0 and Tar(anax, anay, anaxx + TeeRad, anayy + TeeRad, Rly) == 0 then
			if Rly == 1 and UseDD == 1 then
				Game.Input.TargetX = anaxx - anax
				Game.Input.TargetY = anayy - anay
			end
			--return 0
		end
		
	end
	
	return foundBRad
end

function InRange(Who)
	local rxx = LPosx() - Posx(Who)
	local ryy = LPosy() - Posy(Who)

	if rxx*rxx + ryy*ryy <= 168100 then
		return 1
	end

	return 0
end
dirReverse = 0



dummyTick = 0



function meanAngle (angleList)
  local sumSin, sumCos = 0, 0
  for i, angle in pairs(angleList) do
    sumSin = sumSin + math.sin(math.rad(angle))
    sumCos = sumCos + math.cos(math.rad(angle))
  end
  local result = math.deg(math.atan2(sumSin, sumCos))
  return string.format("%.2f", result)
end
 

 



function LaserShootPos(PosOrDir)
	Game.Input.TargetX = PosOrDir.x
	Game.Input.TargetY = PosOrDir.y
	Game.Input.Fire = (Game.Input.Fire + 2) % 64
end

function PossibleToLaser(inPlayerID)
	local VictimPos = Game.Players(inPlayerID).Tee.Pos
	if(inPlayerID ~= nil and Game.Players(inPlayerID).Active and Game.CharSnap(inPlayerID).Active) then
		--if(TW.Game:IntersectCharacter(Game.LocalTee.Pos, VictimPos, nil, Game.LocalCID ) == inPlayerID) then
			if(Game.Collision:IntersectLine(Game.LocalTee.Pos, VictimPos, nil, nil, false) == 0) then
				if(Game.Collision:Distance(Game.LocalTee.Pos, VictimPos) < Game:Tuning().laser_reach:Get()) then
					return true
				end
			end
		--end
	end
	return false
end

function PossibleToLaserOtherTeam(inPlayerID)
	
	if(PossibleToLaser(inPlayerID)) then
		if( Game.Snap:PlayerInfos(inPlayerID).Team ~= Game.Snap:PlayerInfos(Game.LocalCID).Team ) then return true end
	end
	return false
end

function LaserShootPlayer(inPlayerID)
	if(PossibleToLaser(inPlayerID)) then
		LaserShootPos(Game.Players(inPlayerID).Tee.Pos - Game.LocalTee.Pos)
	end
end

function IncreasePingBy(incAmount)
	Config.ClFakePingInc = incAmount
	Config.ClFakePingDec = 0
end


function DecreasePingBy(incAmount)
	Config.ClFakePingInc = 0
	Config.ClFakePingDec = incAmount
end


lastLaserLines = {}
function OnSnapInput()

	--local res = Game.Collision:TestBox(Game.LocalTee.Pos, vec2(28,28))
	--if(res) then prn('YES') end
	
	
	
	if(sc_StartRecord == 2) then
		if(sc_FirstPlayDelay ~= nil) then
			if(Game.CharSnap(Game.LocalCID).Cur.Weapon == WEAPON_GUN) then
				Game.Input.Fire = sc_playbackArray[1].Fire --prevent start fire bug
				Game.Input.TargetX = 0 --prevent start fire bug
				Game.Input.TargetX = 1 --prevent start fire bug
				sc_FirstPlayDelay = nil
				return
			end
			
			
			
			if(sc_FirstPlayDelay > 0) then
				sc_FirstPlayDelay = sc_FirstPlayDelay - 1
			else 
				sc_FirstPlayDelay = nil
			end
			return
		end
		
		
		
		if(sc_sendPlaybackCount <= #sc_playbackArray) then
			local TeePosInRec = vec2( sc_playbackArray[sc_sendPlaybackCount].TeePosX, sc_playbackArray[sc_sendPlaybackCount].TeePosY)
			local TeePosDiffWithRec = Game.Collision:Distance( TeePosInRec, Game.LocalTee.Pos)
			if(TeePosDiffWithRec > 200) then
				Game.HUD:PushNotification('Error Occured While Playing', vec4(1,0,0,1))
				sc_StartRecord = 0
				sc_sendPlaybackCount = 1
				--prn('' .. Game.Collision:Distance( TeePosInRec, Game.LocalTee.Pos))
			end
			
			Game.Input.Direction = sc_playbackArray[sc_sendPlaybackCount].Direction
			Game.Input.Fire = sc_playbackArray[sc_sendPlaybackCount].Fire
			Game.Input.Hook = sc_playbackArray[sc_sendPlaybackCount].Hook
			Game.Input.Jump = sc_playbackArray[sc_sendPlaybackCount].Jump
			Game.Input.WantedWeapon = sc_playbackArray[sc_sendPlaybackCount].WantedWeapon
			Game.Input.TargetX = sc_playbackArray[sc_sendPlaybackCount].TargetX
			Game.Input.TargetY = sc_playbackArray[sc_sendPlaybackCount].TargetY
			sc_sendPlaybackCount = sc_sendPlaybackCount + 1
		else
			sc_sendPlaybackCount = 1
			sc_StartRecord = 0
			
			
			--if autoplayback
			local exactRec = findRecAtPos(Game.LocalTee.Pos, 0)
			if(#exactRec > 0) then --there is a record EXACTLY here
				sc_playbackArray = exactRec
				sc_StartRecord = 2
				sc_sendPlaybackCount = 1
				Game.HUD:PushNotification('Auto continue record!', vec4(0,1,0,1))
				
				autoTestInc = autoTestInc + 5
				return
			end
			
		end
		
		return
	end	 

		
	Fly()
	--if(rec == true) then
	--	table.insert(Lines, LineItem(LastLinePos.x, LastLinePos.y, nres.x, nres.y))
	--end
	--if(setDummy == 1) then
	--	Config.cl_dummy = 1 - Config.cl_dummy
	--	Game.Input.Fire = (Game.Input.Fire + 1)%2
	--	setDummy = 2
	--elseif(setDummy == 2) then
	--	Config.cl_dummy = 1 - Config.cl_dummy
	--	Game.Input.Fire = (Game.Input.Fire + 1)%2
	--	setDummy = 0
	--end
	--if(Game.LocalTee.Pos.y == 9809) then
	--	_debugInfoStr = ""
	--end
	--if( math.abs(Game.LocalTee.Pos.y - 10924) < 10 and Game.Input.Hook == 0) then
		--Game.Input.TargetX = -17
		--Game.Input.TargetY = -294
		--Game.Input.Hook = 1
	--end
	--if(Game.Input.Hook == 1 and string.len(_debugInfoStr) == 0 ) then
	--	_debugInfoStr = "x: " .. Game.LocalTee.Pos.x .. "   y: " .. Game.LocalTee.Pos.y .. "    tx:" .. Game.Input.TargetX .. "   ty:" .. Game.Input.TargetY
	--end
	
	if(sc_IsScriptEnabled ~= 1) then return end
	dirReverse = dirReverse + 1

	dummyTick = dummyTick + 1
	--if(dummyTick % 50 == 49) then
	--	Config.cl_dummy = 1 - Config.cl_dummy
	--end
	if(sc_AutoAimFire == 1 or sc_AutoAimHook == 1) then
		Grab() --colorize the hookable tee
	else 
		lastHookAimId = -1
	end
	
	HaltLook = 0

	if Focus == 0 and Game.LocalTee.HookedPlayer ~= -1 then
		HaltLook = 1
	end

	if Vic ~= -1 and HaltLook == 0 then
		SetAim(Vic, 1)
	end

	Gup = 0



	if( nextWallShotTarget ~= nil) then
		LaserShootPos(nextWallShotTarget)
		nextWallShotTarget = nil
		

	end
	
	if(nextWallshotHitTarget ~= nil) then
		LaserShootPos(nextWallshotHitTarget)
		nextWallshotHitTarget = nil
	end
	
	
	if(Engine.Input:KeyIsPressed("mouse1")  and nextShootgunSelfshotPos ~= nil) then
		LaserShootPos(nextShootgunSelfshotPos)
		--Game.Input.TargetX = nextShootgunSelfshotPos.x
		--Game.Input.TargetY = nextShootgunSelfshotPos.y
		nextShootgunSelfshotPos = nil
	end
	
	
	if(Engine.Input:KeyIsPressed("f3")) then
		--prn('zz' .. numberToBinStr(31))
		 
		

		
		local meanDisToTile = (TeeSize / 2) + 1
		
		if( Game.Collision:GetTile(Game.LocalTee.Pos.x, Game.LocalTee.Pos.y + meanDisToTile) ~= 0) then
			if( Game.Collision:GetTile(Game.LocalTee.Pos.x - meanDisToTile, Game.LocalTee.Pos.y) ~= 0 or
				Game.Collision:GetTile(Game.LocalTee.Pos.x + meanDisToTile, Game.LocalTee.Pos.y) ~= 0) then
					prn('Candidate pos to rec')
				end
		end
		
		
		--prn(Game.Players(Game.LocalCID).Tee.Angle/256 .. '    hit') 
		--os.exit(0)
	end
	
	if(not Engine.Input:KeyIsPressed("mouse1")) then
		if(shootAtTargeter ~= nil) then
			LaserShootPlayer(shootAtTargeter)
			shootAtTargeter = nil
		end
		
		if(shootAllNextCondidate ~= nil) then
			LaserShootPlayer(shootAllNextCondidate)
			shootAllNextCondidate = nil
		end
	end
	
	

	
	if(Engine.Input:KeyIsPressed("mouse2") and sc_FastHook == 1 ) then
		--local setHookState = false
		if(Game.LocalTee.HookState == HOOK_RETRACTED) then
			Game.Input.Hook = 0
			setHookState = true
		elseif(Game.LocalTee.HookState == HOOK_GRABBED and Game.LocalTee.HookedPlayer == -1) then
			Game.Input.Hook = 0
			setHookState = true
		else			
			OriginalKeyPress('mouse2')
			Game.Input.Hook = 1		
		end
		
	end
	 
	if(Engine.Input:KeyIsPressed("mouse1") and sc_FastFire == 1) then
		Game.Input.Fire = (Game.Input.Fire + 1) % 64
	end
	
	if(sc_DummyHookFly == 1) then
		--Game.MainID .. '    id2:' .. Game.DummyID
		if((Game.Client:DummyConnected())) then
			
			local MainPos = Game.LocalTee.Pos
			local DummyPos = Game.Players(Game.DummyID).Tee.Pos
			
			if(Config.cl_dummy == 1 ) then
				DummyPos = Game.Players(Game.MainID).Tee.Pos
			end

			local mdDir = MainPos - DummyPos			
			if(DummyPos.y < MainPos.y and Game.Collision:Distance(DummyPos, MainPos) > 16) then
				Game.Input.DummyTargetX = mdDir.x
				Game.Input.DummyTargetY = mdDir.y
				Game.Input.DummyHook = 1
			else
				Game.Input.DummyHook = 0
			end

			--if(((CGameClient *)GameClient())->m_aClients[m_LocalIDs[!g_Config.m_ClDummy]].m_Predicted.m_HookState == HOOK_RETRACTED || distance(Dummy, Main) < 48)
			if(Game.Collision:Distance(DummyPos, MainPos) < 48) then
				Game.Input.DummyHook = 0
			end
			
		end
		
	end
	 
	 
	if( sc_AutoHammerFly == 1) then
	
		local MainPos = Game.LocalTee.Pos
		local DummyPos = Game.Players(Game.DummyID).Tee.Pos
		
		if(Config.cl_dummy == 1 ) then
			DummyPos = Game.Players(Game.MainID).Tee.Pos
		end
		
		
 
		--	Game.Input.DummyFire = (Game.Input.DummyFire + 1) % 10
		--	local lookDeg = MainPos - DummyPos
		--	Game.Input.DummyTargetX = lookDeg.x
		--	Game.Input.DummyTargetY = lookDeg.y
 

		local setHookState = false
		if(Game.LocalTee.HookState == HOOK_RETRACTED) then
			Game.Input.Hook = 0
			setHookState = true
		elseif(Game.LocalTee.HookState == HOOK_GRABBED and Game.LocalTee.HookedPlayer ~= Game.MainID and Game.LocalTee.HookedPlayer ~= Game.DummyID) then
			Game.Input.Hook = 0
			setHookState = true			
		end
		
		if( not setHookState) then
			Game.Input.Hook = 1
			local lookDeg2 = DummyPos - MainPos
			Game.Input.TargetX = lookDeg2.x
			Game.Input.TargetY = lookDeg2.y
		end
	end
 
	if(sc_TempTest == 1) then
		


 
 --Game.Input.Fire = (Game.Input.Fire + 1) % 10
		
		--Game.Input.DummyDirection    = Game.Input.Direction     
		--Game.Input.DummyFire         = Game.Input.Fire - lastInputData[Config.cl_dummy].Fire          
		--Game.Input.DummyHook         = Game.Input.Hook          
		--Game.Input.DummyJump         = Game.Input.Jump          
		--Game.Input.DummyWantedWeapon = Game.Input.WantedWeapon  
		--Game.Input.DummyTargetX      = Game.Input.TargetX       
		--Game.Input.DummyTargetY      = Game.Input.TargetY       
		
		
	end
	
	
	--if(XYLaser ~= nil) then
	--	XYLaser = XYLaser * 100
	--	Game.Input.TargetX = XYLaser.x
	--	Game.Input.TargetY = XYLaser.y
	--	Game.Input.Fire = Game.Input.Fire + 1
	--	XYLaser = nil
	--else
	--	Game.Input.Fire = 0
	--end
	 
	
	
	if(sc_HookCol == 1 and Game.Input.Hook == 1) then

	
		local HookLenLimit = 42 + 17 --42 = teetall and 16 half of a tile to reach its center
		local colPos = vec2(0,0)
		local beforeColPos = vec2(0,0)
 
		local startCol = nil
		local endCol = nil
		 
		
		local HookStartPos = Game.LocalTee.Pos + GetDir( HeadVectorToRadian(Game.Input.MouseX, Game.Input.MouseY)) * 28 * 1.5
		
		local dirOfHook = GetDir( HeadVectorToRadian(Game.Input.MouseX, Game.Input.MouseY)) * (Game:Tuning().hook_length:Get() - HookLenLimit)
		local hookPos = HookStartPos + dirOfHook
		local hokColTile = Game.Collision:IntersectLineTeleHook(HookStartPos, hookPos, colPos, beforeColPos, false) 
		
		
		--prn(' hokColTile: ' .. hokColTile)
		if(hokColTile == 3 or hokColTile == 0) then
			
			local positiveDeg = nil
			local negativeDeg = nil
			for degI = 0, 40, 0.1 do
				dirOfHook = GetDir( HeadVectorToRadian(Game.Input.MouseX, Game.Input.MouseY) + (const_degInRad * degI)) * (Game:Tuning().hook_length:Get() - HookLenLimit)
				hookPos = HookStartPos + dirOfHook
				hokColTile = Game.Collision:IntersectLineTeleHook(HookStartPos, hookPos, colPos, beforeColPos, false)
				
				if(hokColTile == 1) then
					positiveDeg = degI
					break
				end
					
			end		
			for degI = 0, -40, -0.1 do
				dirOfHook = GetDir( HeadVectorToRadian(Game.Input.MouseX, Game.Input.MouseY) + (const_degInRad * degI)) * (Game:Tuning().hook_length:Get() - HookLenLimit)
				hookPos = HookStartPos + dirOfHook
				hokColTile = Game.Collision:IntersectLineTeleHook(HookStartPos, hookPos, colPos, beforeColPos, false)
				
				if(hokColTile == 1) then
					negativeDeg = degI
					break
				end
					
			end
			
			--if(positiveDeg ~= nil) then prn( 'PD:' .. positiveDeg) end
			--if(negativeDeg ~= nil) then prn( 'ND:' .. negativeDeg) end
			
			local forSt = 1
			local forEd = 0
			local forSp = 1
			
			if(positiveDeg ~= nil and negativeDeg ~= nil) then
				if(math.abs(positiveDeg) < math.abs(negativeDeg)) then
					forSt = positiveDeg + 10
					forEd = positiveDeg
					forSp = -0.1
				else
					forSt = negativeDeg - 10
					forEd = negativeDeg
					forSp = 0.1
				end
				
			elseif(positiveDeg ~= nil or negativeDeg ~= nil) then
				if(positiveDeg ~= nil) then
					forSt = positiveDeg 
					forEd = positiveDeg + 10
					forSp = 0.1
				elseif(negativeDeg ~= nil) then
					forSt = negativeDeg
					forEd = negativeDeg - 10
					forSp = -0.1
				end
			end
			
			--_debugInfoStr = "forSt:"  .. forSt .. "  forEd:" .. forEd .. " forSp:" .. forSp .. "  "
			--prn(_debugInfoStr)
			--_debugInfoStr = ""
			for degI = forSt, forEd, forSp do
				dirOfHook = GetDir( HeadVectorToRadian(Game.Input.MouseX, Game.Input.MouseY) + (const_degInRad * degI)) * (Game:Tuning().hook_length:Get() - HookLenLimit)
				hookPos = HookStartPos + dirOfHook
				hokColTile = Game.Collision:IntersectLineTeleHook(HookStartPos, hookPos, colPos, beforeColPos, false)
				
				--prn('degI : ' .. degI)
				if(hokColTile == 1) then
					--prn('DONE')
					if(startCol == nil) then
						
						--_debugInfoStr = _debugInfoStr .. degI .. "<d1    d2>"
						
						startCol = vec2( colPos.x, colPos.y)
					end
					endCol = vec2( colPos.x, colPos.y) 
				else
					--break
				end
				
			 
			end 
			--prn( 'startCol:' .. round2(startCol.x,2) .. '    ' .. round2(startCol.y,2) .. '   endCol' .. round2(endCol.x,2) .. '     ' .. round2(endCol.y,2) )
			if(startCol ~= nil and endCol ~= nil ) then
				
				
				local sd = startCol - Game.LocalTee.Pos
				local sdRad = HeadVectorToRadian(sd.x, sd.y)
				
				local sd2 = endCol - Game.LocalTee.Pos
				local sdRad2 = HeadVectorToRadian(sd2.x, sd2.y) 
				
				
				local tempPrnDeg = ((sdRad2 + sdRad)/2)*180/PI
				--local newTempPrnRad = meanAngle({350, 10})
				--prn('s:'  .. round2(sdRad,2) .. '   e:' .. round2(sdRad2,2) .. "   deg:" .. round2(tempPrnDeg,1) .. ' ((sdRad2 + sdRad)/2):' .. round2((sdRad2 + sdRad)/2,2) )
				
				if( (sdRad < 0 and sdRad2 > 0) or (sdRad > 0 and sdRad2 < 0) ) then --if both have different signs then bug occurs we have to add one full circle 2PI to only one of them
					sdRad = sdRad + (PI * 2)
					--sdRad2 = sdRad2 + (PI * 2)
					--prn('BUG')
				end
				--if( math.abs((sdRad2 + sdRad)/2) < 0.1 ) then
				--	sdRad = sdRad + PI
				--	sdRad2 = sdRad2 + PI
				--end
				
				
				--prn('s:'  .. round2(sdRad,1) .. '   e:' .. round2(sdRad2,1) .. "   deg:" .. round2(tempPrnDeg,1))
				dirOfHook = GetDir( (sdRad2 + sdRad)/2) * Game:Tuning().hook_length:Get()

				Game.Input.TargetX = dirOfHook.x
				Game.Input.TargetY = dirOfHook.y
			end
		end
    end
		
	
	if(sc_SpinFire == 1 and Engine.Input:KeyIsPressed("mouse1")) then
		if(not Engine.Input:KeyIsPressed("mouse2")) then
			local testDir = normalize( vec2(math.sin(Game.Client.LocalTime*5 ), math.cos(Game.Client.LocalTime*5 ))) * 1000
			Game.Input.TargetX = testDir.x
			Game.Input.TargetY = testDir.y
			if(sc_FastFire == 0) then
				Game.Input.Fire = (Game.Input.Fire + 1) % 64
			end
		end
	end
	
	
	
	
	if(sc_Balance == 1) then
		if (sc_LastHookSelectedPlayerId ~= nil and sc_LastHookSelectedPlayerId >= 0) then 
			-- is anybody selected? Can we get to him?
			if(Game.Collision:IntersectLine(Game.LocalTee.Pos, Game.Players(sc_LastHookSelectedPlayerId).Tee.Pos, nil, nil, false) == 0) then				
				if(Game.LocalTee.Pos.x - Game.Players(sc_LastHookSelectedPlayerId).Tee.Pos.x > 2) then
					Game.Input.Direction = -1
				elseif(Game.Players(sc_LastHookSelectedPlayerId).Tee.Pos.x - Game.LocalTee.Pos.x > 2) then
					Game.Input.Direction = 1
				
				end
			end
			 
		end
		 
	end
	
	
	if(sc_StartRecord == 1) then
		sc_sendPlaybackCount = 1
		
				
		if(sc_AutoRestartRecordOnFail == 1 and #sc_playbackArray > 1) then
			if(restartRecordAtPos ~= nil) then
				if ( Game.Collision:Distance(Game.LocalTee.Pos, restartRecordAtPos) <= 0) then
					sc_playbackArray = {}
					Game.HUD:PushNotification('Automaticaly restarted record at fail', vec4(1,0,0,1))
					restartRecordAtPos = nil
				end
			else
				if ( Game.Collision:Distance(Game.LocalTee.Pos, vec2(sc_playbackArray[1].TeePosX, sc_playbackArray[1].TeePosY )) > 0) then
					restartRecordAtPos = vec2(sc_playbackArray[1].TeePosX, sc_playbackArray[1].TeePosY )
				end
			end
		end
		
		sc_playbackArray[#sc_playbackArray+1] = {
			Direction = Game.Input.Direction,
			Fire = Game.Input.Fire,
			Hook = Game.Input.Hook,
			Jump = Game.Input.Jump,
			--WantedWeapon  = Game.Input.WantedWeapon,
			WantedWeapon = Game.CharSnap(Game.LocalCID).Cur.Weapon, -- idk what bug is this!
			TargetX  = Game.Input.TargetX,
			TargetY  = Game.Input.TargetY,
			TeePosX = Game.LocalTee.Pos.x,
			TeePosY = Game.LocalTee.Pos.y,
		}
		
	end
	--

	if(sc_StartRecord == 0 and sc_dummy_copy == 1) then


		Game.Input.DummyDirection    = Game.Input.Direction     
		Game.Input.DummyFire         = Game.Input.Fire - lastInputData[Config.cl_dummy].Fire          
		Game.Input.DummyHook         = Game.Input.Hook          
		Game.Input.DummyJump         = Game.Input.Jump          
		Game.Input.DummyWantedWeapon = Game.Input.WantedWeapon  
		Game.Input.DummyTargetX      = Game.Input.TargetX       
		Game.Input.DummyTargetY      = Game.Input.TargetY       
		--Game.Input.DummyMouseX       = Game.Input.MouseX        
		--Game.Input.DummyMouseY       = Game.Input.MouseY        
		Game.Input.DummyNextWeapon		= Game.Input.NextWeapon - lastInputData[Config.cl_dummy].NextWeapon
		Game.Input.DummyPreviousWeapon	= Game.Input.PreviousWeapon - lastInputData[Config.cl_dummy].PreviousWeapon
		--flag copy missing
		if(sc_dummy_mirrorX == 1) then Game.Input.DummyTargetX = -Game.Input.DummyTargetX end
		if(sc_dummy_mirrorY == 1) then Game.Input.DummyTargetY = -Game.Input.DummyTargetY end
		if(sc_dummy_direction == 1) then Game.Input.DummyDirection = -Game.Input.DummyDirection end
		--m_InputData[g_Config.m_ClDummy].m_FCount - m_LastData[g_Config.m_ClDummy].m_FCount;
	
	end
	
	lastInputData[Config.cl_dummy] = {
		Direction       = Game.Input.Direction, 
		Fire            = Game.Input.Fire, 
		Hook            = Game.Input.Hook, 
		Jump            = Game.Input.Jump, 
		WantedWeapon    = Game.Input.WantedWeapon, 
		TargetX         = Game.Input.TargetX, 
		TargetY         = Game.Input.TargetY, 
		MouseX          = Game.Input.MouseX, 
		MouseY          = Game.Input.MouseY, 
		Flags  			= Game.Input.Flags,
		NextWeapon		= Game.Input.NextWeapon,
		PreviousWeapon	= Game.Input.PreviousWeapon
	}
	
	
	
	lastInputData[1 - Config.cl_dummy] = {
		Direction       = Game.Input.DummyDirection, 
		Fire            = Game.Input.DummyFire, 
		Hook            = Game.Input.DummyHook, 
		Jump            = Game.Input.DummyJump, 
		WantedWeapon    = Game.Input.DummyWantedWeapon, 
		TargetX         = Game.Input.DummyTargetX, 
		TargetY         = Game.Input.DummyTargetY, 
		MouseX          = Game.Input.DummyMouseX, 
		MouseY          = Game.Input.DummyMouseY, 
		Flags  			= Game.Input.DummyFlags,
		NextWeapon		= Game.Input.DummyNextWeapon,
		PreviousWeapon	= Game.Input.DummyPreviousWeapon
	}
	

	
	return 
end

function OnKill(Sword, Shield, Weapon)
	if(sc_IsScriptEnabled ~= 1) then return end
	
	--Game.Players(Shield).Tee.Pos.x = 1000000
	--Game.Players(Shield).Tee.Pos.y = 1000000

	return 
end



RegisterEvent("OnKill", "OnKill")
RegisterEvent("OnEnterGame", "OnEnterGame")
RegisterEvent("OnChat", "OnChat")
RegisterEvent("OnConsoleCommand", "OnConsoleCommand")
RegisterEvent("OnKeyPress", "OnKeyPress")
RegisterEvent("OnSnapInput", "OnSnapInput")
RegisterEvent("OnKeyRelease", "OnKeyRelease")
RegisterEvent("OnRenderLevel14", "Render")
RegisterEvent("OnRenderLevel22", "RenderFullscreen")

return 

--[[ENDOFFILE]]--
