include("shared.lua")
include("cl_spawnmenu.lua")
include('cl_deathnotice.lua')
include('cl_gmdm_view.lua')
include('cl_help.lua')
include( "cl_ui.lua" )
include( "cl_scoreboard.lua" )

local ICON_BLOCKS = Material("icon16/box.png")
local ICON_TIME = Material("icon16/time.png")
local ICON_ROUND = Material("icon16/control_play.png")
local ICON_CORE = Material("icon16/wrench.png")

function GM:HUDPaint()
    local middle = ScrW() / 2
    local boxWidth = 256

	-- Box
	draw.RoundedBox( 4, middle - boxWidth / 2, 8, boxWidth, 32, Color(100,200,128,255) )

	surface.SetDrawColor(255,255,255,255)

	-- Round
	local leftPos = middle - boxWidth / 2 + 4
    surface.SetMaterial(ICON_ROUND)
	surface.DrawTexturedRect(leftPos,16,16,16)
    draw.SimpleText( self:GetRoundName(), "DermaDefault", leftPos + 20, 17, Color( 255, 255, 255, 255 ))

	-- Timer
	local middlePos = middle - 16
	surface.SetMaterial(ICON_TIME)
	surface.DrawTexturedRect(middlePos,16,16,16)
	local flash = 255
	if self:GetTimeLeft() < 60 && CurTime() % 2 > 1 then
		flash = 0
	end
    draw.SimpleText( string.FormattedTime( self:GetTimeLeft(), "%02i:%02i"), "DermaDefault", middlePos + 20, 17, Color( 255, flash, flash, 255 ))

	-- Props
	local rightPos = middle + 86
    surface.SetMaterial(ICON_BLOCKS)
	surface.DrawTexturedRect(rightPos,16,16,16)
	local noprops = 255
	if LocalPlayer():GetRemainingProps() < 1 then
		noprops = 0
	end
    draw.SimpleText( LocalPlayer():GetRemainingProps().."", "DermaDefault", rightPos + 20, 17, Color( 255, noprops, noprops, 255 ))

	-- Cores
	-- Red
	draw.RoundedBox( 4, middle - boxWidth / 2, 44, boxWidth/4, 32, Color(128,0,0,220) )
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(ICON_CORE)
	surface.DrawTexturedRect(middle - boxWidth / 2 + 4,52,16,16)
	draw.SimpleText( GAMEMODE:GetCoreHealthPercent(1).."%", "DermaDefault", middle - boxWidth / 2 + 26, 53, Color( 255, 255, 255, 255 ))

	-- Blue
	draw.RoundedBox( 4, middle + boxWidth / 2 - boxWidth / 4, 44, boxWidth/4, 32, Color(0,0,128,220) )
	surface.SetDrawColor(255,255,255,255)
	surface.SetMaterial(ICON_CORE)
	surface.DrawTexturedRect(middle + boxWidth / 2 - boxWidth / 4 + 4,52,16,16)
	draw.SimpleText( GAMEMODE:GetCoreHealthPercent(2).."%", "DermaDefault", middle + boxWidth / 2 - boxWidth / 4 + 26, 53, Color( 255, 255, 255, 255 ))

	-- Other bits
	self:DrawDeathNotice( 0.85, 0.04 )
	self:HUDDrawTargetID()
 	self:HUDDrawPickupHistory()

	 self:DrawEndMsg()
end

function GM:HUDDrawTargetID()

 	local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
 	local trace = util.TraceLine( tr )
 	if (!trace.Hit) then return end
 	if (!trace.HitNonWorld) then return end

 	local text = "ERROR"
 	local font = "TargetID"

 	if (trace.Entity:IsPlayer()) then
 		text = trace.Entity:Nick()
 	elseif  trace.Entity:GetClass()=="fw_core" then
	 	text=team.GetName(trace.Entity:GetTeam()).." Power Core"
	elseif trace.Entity:GetClass()=="prop_fortwars" then
		local own=trace.Entity:GetPropOwner()
		if own~=trace.Entity and own.IsPlayer and own:IsPlayer() and own~=NULL then
			text=own:Nick().."'s prop"
		end
	elseif trace.Entity:GetClass() == "fw_turret_ground" then
		text=team.GetName(trace.Entity:GetTeam()).." Turret"
	else
 		return
 		//text = trace.Entity:GetClass()
 	end

 	surface.SetFont( font )
 	local w, h = surface.GetTextSize( text )

 	local x = ScrW()/2
	local y = ScrH()/2

 	x = x - w / 2
 	y = y + 30

	local tcol=Color(255,255,255,255)

 	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
 	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
 	draw.SimpleText( text, font, x, y, tcol )

 	y = y + h + 5
 	 local text=""
	if trace.Entity:IsPlayer() then
 		text = trace.Entity:Health() .. "%"
	elseif  trace.Entity:GetClass()=="fw_core" then
		text="Health: "..tostring(trace.Entity:GetCoreHealth())
	elseif trace.Entity:GetClass() == "fw_turret_ground" then
		text = trace.Entity:GetPropHealth().."hp"
	elseif trace.Entity:GetClass() == "prop_fortwars" && trace.Entity:GetTeam() == LocalPlayer():Team() then
		text = trace.Entity:GetPropHealth().."hp"
	end
 	local font = "TargetIDSmall"

 	surface.SetFont( font )
 	local w, h = surface.GetTextSize( text )
 	local x = x

 	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
 	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
 	draw.SimpleText( text, font, x, y, tcol )

 end

function GM:SpawnMenuOpen()
    return self:GetRound() == 1
end

local domemat = Material("models/props_combine/com_shield001a")
local whitemat = Material("models/shiny")

function GM:PostDrawOpaqueRenderables(depth, skybox)
	--if skybox then return end
	if self.GetRound() ~= 1 then return end
	
	for _,core in pairs(self.Cores) do
		local distance = (core:GetPos()-LocalPlayer():GetPos()):Length()
		if core:GetTeam() == LocalPlayer():Team() then
 			render.DrawWireframeSphere( core:GetPos(), core:GetBuildRadius(), 32, 32, Color(255,255,255,255), true )
		else
			render.SetMaterial(domemat)
			render.DrawSphere( core:GetPos(), core:GetBuildRadius(), 32, 32, GAMEMODE:GetTeamNumColor(core:GetTeam()) )
		end		
	end
	
end
