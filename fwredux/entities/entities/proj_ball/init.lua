AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local soundx=Sound("Canals.d1_canals_01_chargeloop")

function ENT:Initialize()
	self.Entity:SetModel("models/Items/combine_rifle_ammo01.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	timer.Simple(3, function() self:Explode() end)

	self.Die=false

	if (!self.Sound) then
 		self.Sound = CreateSound( self.Entity, soundx )
 	end

 	self.Sound:Play()

end

function ENT:Think()
	if self.Die then
		self.Entity:Remove()
	end
end

function ENT:OnRemove()
 	if (self.Sound) then
 		self.Sound:Stop()
 	end
end

function ENT:Explode()
		local effectdata = EffectData()
		effectdata:SetStart( self.Entity:GetPos() )
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetScale( 100 )
		effectdata:SetMagnitude( 100 )
		util.Effect( "Explosion", effectdata )
		local effectdata = EffectData()
		effectdata:SetStart( self.Entity:GetPos() )
		util.Effect( "explodesmoke", effectdata )
	util.BlastDamage(self.Entity,self.Entity:GetOwner(),self.Entity:GetPos(),200, 100)
	self.Die=true
end