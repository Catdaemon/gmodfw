AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	self.Entity:StartMotionController()

	local minx,maxx = self.Entity:WorldSpaceAABB()
	local xsize = minx:Distance(maxx)
	local calchealth = math.Clamp(800 - xsize,250,1000)
	self.Entity:SetPropHealth(calchealth)
	self.Entity:SetMaxHealth(calchealth)

	self.Entity:StartMotionController()
	self.Entity:AddToMotionController(self.Entity:GetPhysicsObject())
end

function ENT:Think()
end

function ENT:OnTakeDamage(dmg)
	if dmg:GetAttacker():IsPlayer() then
		--if self:GetTeam() == dmg:GetAttacker():Team() then return end
		self:SetPropHealth(self:GetPropHealth()-dmg:GetDamage())
			if self:GetPropHealth() < 200 then
				local prev=self.Entity:GetPos()
				self.Entity:GetPhysicsObject():EnableGravity( true )
				self.Entity:GetPhysicsObject():Wake()
				self.Entity:GetPhysicsObject():EnableMotion(true)
				self.Entity:SetPos(prev)
			end
			if self:GetPropHealth() < 1 then
				-- Remove it properly in 1 second
				timer.Simple( 1, function() if ( IsValid( self.Entity ) ) then self.Entity:Remove() end end )

				-- Make it non solid
				self.Entity:SetNotSolid( true )
				self.Entity:SetMoveType( MOVETYPE_NONE )
				self.Entity:SetNoDraw( true )

				-- Send Effect
				local ed = EffectData()
					ed:SetOrigin( self.Entity:GetPos() )
					ed:SetEntity( self.Entity )
				util.Effect( "entity_remove", ed, true, true )
			end
	end
end