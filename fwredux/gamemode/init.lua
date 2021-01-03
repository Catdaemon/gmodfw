AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_shared.lua" )
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_gmdm_view.lua" )
AddCSLuaFile( "cl_help.lua" )
AddCSLuaFile( "cl_ui.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )

include( "shared.lua" )
include( "spawnmenu/init.lua" )
include( "commands.lua" )
include( "create_ents.lua" )

-- Network
util.AddNetworkString( "RoundEnd" )

-- Files
resource.AddFile("materials/vgui/fw/infotopper.png")

GM.GivenSpawnables = 0


function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	
	ply:AddDeaths( 1 )
	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == ply ) then
			attacker:AddFrags( -1 )
		else
			attacker:AddFrags( 1 )
		end
	
	end

end

function GM:OnPhysgunFreeze( weapon, physobj, ent, ply )
	if !self:IsValidSpawnPos(ply, ent:GetPos()) then return false end
	
	-- Object is already frozen (!?)
	if ( !physobj:IsMoveable() ) then return false end
	if ( ent:GetUnFreezable() ) then return false end
	
	physobj:EnableMotion( false )
		
	return true

end


function GM:EntityTakeDamage( ent, info )
	if !info:GetAttacker():IsPlayer() && !info:GetAttacker():GetClass() == "fw_turret_ground" then return end
	if info:GetDamage() < 1 then return end
	if ent:GetClass() == "prop_fortwars" && info:GetAttacker():IsPlayer() && info:GetAttacker():Team() == ent:GetTeam() then return end
	local ed = EffectData()
		ed:SetOrigin( info:GetDamagePosition() )
		ed:SetEntity( ent )
		ed:SetMagnitude(info:GetDamage())
	util.Effect( "hitdmg", ed, true, true )
end

function GM:PlayerSpawn(ply)
	-- Give correct loadout according to round
	if self:GetRound() == 1 then
		if (self.GivenSpawnables <= GetConVar("fw_maxteamturrets"):GetInt()) then
			ply:Give("weapon_fw_turret")
			self.GivenSpawnables = self.GivenSpawnables + 1
		end
		ply:Give("weapon_physgun")
		ply:Give("weapon_fw_remover")
	elseif self:GetRound() == 2 then
		ply:Give("weapon_physcannon")
		ply:Give("weapon_stunstick")
		ply:Give("weapon_fw_pistol")
		ply:Give("weapon_fw_smg")
	end

	if ply:Team() == 2 then
		ply:SetModel("models/player/urban.mdl")
	else
		ply:SetModel("models/player/guerilla.mdl")
	end


	ply:SetRunSpeed(250)
end

function GM:PlayerInitialSpawn( ply )
    ply:SetupFW()
	self:AssignTeam(ply)
end

function GM:PlayerNoClip(ply, on)
	return self:GetRound() == 1
end

function GM:RoundEnd(winningTeam)
	if self.MatchEnded then return end
	self.MatchEnded = true
	self.WinningTeam = winningTeam

	-- Broadcast that the match is over and prepare to end
	net.Start( "RoundEnd" )
	net.WriteInt( self.WinningTeam, 8 )
	net.Broadcast()

	if MapVote != nil && MapVote.Start != nil then
		timer.Simple(5, function()
			MapVote.Start(30, false, 16, 'fw_')
		end)
	else
		timer.Simple(15, function()
			game.LoadNextMap()
		end)
	end
end

function GM:AssignTeam(pl)
	if team.NumPlayers(1) > team.NumPlayers(2) then
		pl:SetTeam(2)
	else
		if team.NumPlayers(1) == team.NumPlayers(2) then
			pl:SetTeam(math.random(1,2))
		else
			pl:SetTeam(1)
		end
	end
end

function GM:ShowHelp(ply)
	ply:SendLua("GAMEMODE:CreateUI()")
end