AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local soundx=Sound("PhysicsCannister.ThrusterLoop")

function ENT:Initialize()
	self.Entity:SetModel("models/Items/AR2_Grenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:GetPhysicsObject():EnableGravity(true)

	self.Die=false

	if (!self.Sound) then
 		self.Sound = CreateSound( self.Entity, soundx )
 	end

 	self.Sound:Play()
end

function ENT:Think()
	if self.Entity:WaterLevel()>0 then
		self.Entity:Explode()
	end
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
	if self then
	if self.Entity:IsValid() and self.Die==false then
		local effectdata = EffectData()
		effectdata:SetStart( self.Entity:GetPos() )
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetScale( 10 )
		effectdata:SetMagnitude( 10 )
		util.Effect( "Explosion", effectdata )
		local effectdata = EffectData()
		effectdata:SetStart( self.Entity:GetPos() )
		util.Effect( "explodesmoke", effectdata )
		util.BlastDamage(self.Entity,self.Entity:GetOwner(),self.Entity:GetPos(), 200, 20)
		self.Die=true
	end
	end
end

function ENT:PhysicsCollide( data, physobj )
	local ent=data.HitEntity
	if ent:GetClass()~="proj_shotgunrocket" and ent~=self.Entity:GetOwner() and !ent:IsWeapon() then
		self.Entity:Explode()
	end
end