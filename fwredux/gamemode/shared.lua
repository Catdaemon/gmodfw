include("player_shared.lua")

GM.Name = "FortWars Redux"
GM.Author = "Catdaemon"
GM.Email = "catdaemon@gmail.com"
GM.Website = "N/A"
GM.TeamBased = true

GM.MatchEnded = false
GM.MatchEndTime = 0
GM.WinningTeam = 0

GM.Rounds = {
	"Build",
	"Fight",
	"Afterparty"
}

-- Cache
GM.Cores = {}
GM.TeamMaxCoreHealth = 0

--
-- Setup
--
function GM:Initialize()
	
end

function GM:InitPostEntity()
	self:SetupFW()

	if CLIENT then self:CreateUI() end
end

function GM:SetupFW()
	-- Set to round 1
	self:SetRound(1)

	-- Reset all players
	for k, v in pairs( player.GetAll() ) do
		v:SetupFW()
	end

	local info = ents.FindByClass("fw_info")
	if IsValid(info) then
		SetGlobalString("mapname", info[1].Name)
		SetGlobalString("mapauthor", info[1].Authorx)
	end

	timer.Simple(0.1, function()
		-- Cache stuff
		self.Cores = ents.FindByClass("fw_core")

		for _, core in pairs(self.Cores) do
			if core:GetTeam() == 1 then
				self.TeamMaxCoreHealth = self.TeamMaxCoreHealth + core:GetCoreHealth()
			end
		end
	end)
end

--
-- Returns the id of the current round
--
function GM:GetRound()
	return GetGlobalInt("round")
end

--
-- Returns the string name of the current round
--
function GM:GetRoundName()
	return self.Rounds[ self:GetRound() ]
end

--
-- Returns how long the current round should last in seconds
--
function GM:GetRoundTime()
	local round = self:GetRoundName()
	local time = 0;

	if round == "Build" then
		time = GetConVar("fw_buildtime"):GetInt()
	elseif round == "Fight" then
		time = GetConVar("fw_fighttime"):GetInt()
	end

	if time == 0 then
		return 99999999 -- "infinite" time
	end

	return time;
end

-- Overall core health as a percentage
function GM:GetCoreHealthPercent(team)
	if self.TeamMaxCoreHealth < 1 then return 100 end -- Return 100% if there are no cores on the map 
	local currentHealth = 0
	for _, core in pairs(self.Cores) do
		if core:GetTeam() == team then
			currentHealth = currentHealth + core:GetCoreHealth()
		end
	end
	
	return math.Round(currentHealth / self.TeamMaxCoreHealth * 100)
end



--
-- Returns time left in seconds
--
function GM:GetTimeLeft()
	local timeLeft = GetGlobalInt( "roundEndTime" ) - CurTime()
	
	if timeLeft > 0 then
		return timeLeft
	else
		return 0
	end
end

--
-- Sets the current round by ID
--
function GM:SetRound(round)
	SetGlobalInt( "round", round )
	SetGlobalInt( "roundEndTime", CurTime() + self:GetRoundTime() )

	if SERVER then
		-- Respawn players
		for _,ply in pairs(player.GetAll()) do
			ply:KillSilent()
		end
	end
end

--
-- Returns how far away a player is allowed to build
--
function GM:GetBuildRadius()
	return 2048 -- todo
end

function GM:CreateTeams()
	TEAM_REBELS = 1
	team.SetUp( TEAM_REBELS, "Red", Color( 64, 32, 32 ) )
	team.SetSpawnPoint( TEAM_REBELS, "info_player_rebel" )

	TEAM_POLICE = 2
	team.SetUp( TEAM_POLICE, "Blue", Color( 0, 0, 200 ) )
	team.SetSpawnPoint( TEAM_POLICE, "info_player_combine" )
end

function GM:IsValidSpawnPos(ply, position)
	local cores=self.Cores

	if #cores>0 then
		for _,core in pairs(cores) do
			if core:GetTeam()==ply:Team() then
				if core:GetPos():Distance(position) <= core:GetBuildRadius() then return true end
			end
		end

		return false
	else
		return true
	end
end

function GM:Think()
	-- Increment round if time is up
	if self:GetTimeLeft() == 0 then
		self:SetRound( self:GetRound() + 1)
	end

	if CLIENT then return end -- The rest is server-only

	-- End the round if a team has won
	if self:GetCoreHealthPercent(1) < 1 then
		self:RoundEnd(2)
	end
	if self:GetCoreHealthPercent(2) < 1 then
		self:RoundEnd(1)
	end
	-- End the round if time is up
	if self:GetRound() > 2 then
		self:RoundEnd(0)
	end
end

function GM:ShouldCollide( Ent1, Ent2 )
	-- No collisions with players in round 1
	if self:GetRound() == 1 && Ent2:IsPlayer() then return false end
	
	return true
end

function GM:PhysgunPickup( ply, ent )
	-- Don't pick up players
	if ( ent:GetClass() == "player" ) then return false end
	if ent:GetClass() == "prop_fortwars" and ent:GetPropOwner() == ply then return true end

	return false
end

function GM:PlayerShouldTakeDamage( ply, attacker )
	if attacker:IsPlayer() then
		if ply:Team()==attacker:Team() then
			return false
		else
			return true
		end
	else
		if attacker:GetClass()=="proj_ball" || attacker:GetClass()=="proj_shotgunrocket" then
			return false
		else
			return true
		end
	end
end