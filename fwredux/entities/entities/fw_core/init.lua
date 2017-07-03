AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.AmbientSound	= Sound("d1_canals.diesel_generator")
ENT.Model 			= "models/props_c17/canister_propane01a.mdl"

function ENT:Initialize()
	self.Entity:SetModel(self.Model)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:GetPhysicsObject():EnableMotion(false)

 	self.Sound = CreateSound( self.Entity, self.AmbientSound ) -- generator loop
	self.Sound:Play()
end

function ENT:KeyValue( key, value )
	Msg(key.."="..value.."\n")
 	if ( key == "team" ) then
		self.Entity:SetTeam(tonumber(value))
 	end
 	if ( key == "health" ) then
 		self:SetCoreHealth(tonumber(value))
 	end
	if ( key == "model" ) then
 		self.Model = value
 	end
	if ( key == "sound" ) then
 		self.AmbientSound = value
 	end

	 if ( key == "buildradius" ) then
 		self:SetBuildRadius(tonumber(value))
 	end

	if ( string.Left( key, 2 ) == "On" ) then
		self:StoreOutput( key, value )
	end
end

function ENT:Think()
	self.Entity:GetPhysicsObject():Sleep()
end

function ENT:OnTakeDamage(dmg)

	if dmg:GetAttacker():IsPlayer() then
		if self:GetCoreHealth() < 1 then return end
		if self:GetTeam() == dmg:GetAttacker():Team() then return end
		self:SetCoreHealth(self:GetCoreHealth()-dmg:GetDamage())
			if self:GetCoreHealth() < 1 then

				umsg.Start( "EntDestruction" )

					umsg.String( tostring(team.GetName(self:GetTeam()) ).. " core")
					umsg.String( dmg:GetInflictor():GetClass() )
					umsg.String( dmg:GetAttacker():Nick() )
					umsg.Short( dmg:GetAttacker():Team() )
					umsg.Short( self:GetTeam())

				umsg.End()

				self:TriggerOutput("OnDestroyed", dmg:GetAttacker())

				self.Sound:Stop()

				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos() )
				effectdata:SetOrigin( self.Entity:GetPos() )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,100) )
				effectdata:SetOrigin( self.Entity:GetPos()+Vector(0,0,100) )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,200) )
				effectdata:SetOrigin( self.Entity:GetPos()+Vector(0,0,200) )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos() )
				util.Effect( "explodesmoke", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,100) )
				util.Effect( "explodesmoke", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart(self.Entity:GetPos()+Vector(0,0,200) )
				util.Effect( "explodesmoke", effectdata )
			end
	end
end