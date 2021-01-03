AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
 	self.Entity:SetModel("models/props_phx/construct/glass/glass_curve360x2.mdl")

	self.Entity:SetMoveType( MOVETYPE_NONE )
 	self.Entity:SetSolid( SOLID_NONE )
 	self.Entity:DrawShadow( false )

 	-- Note that we need a physics object to make it call triggers
 	self.Entity:SetCollisionBounds( Vector( -64, -64, -32 ), Vector( 32, 32, 80 ) )
 	self.Entity:PhysicsInitBox( Vector( -64, -64, -32 ), Vector( 32, 32, 80 ) )

 	local phys = self.Entity:GetPhysicsObject()
 	if (phys:IsValid()) then
 		phys:EnableCollisions( false )
 	end

 	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
 	self.Entity:SetTrigger( true )
 	self.Entity:SetNotSolid( true )
end


function ENT:Touch( entity )
 	if (entity:IsPlayer()) then return end
	if GAMEMODE:GetRound() == 2 then return end

	timer.Simple( 1, function() if ( IsValid( entity ) ) then entity:Remove() end end )

	-- Make it non solid
	entity:SetNotSolid( true )
	entity:SetMoveType( MOVETYPE_NONE )
	entity:SetNoDraw( true )

	if entity:GetClass() == "prop_fortwars" then
		-- Credit the player with their prop back
		local owner = entity:GetOwner()
		owner:SetRemainingProps( owner:GetRemainingProps() + 1 )

	end

	-- Send Effect
	local ed = EffectData()
		ed:SetOrigin( entity:GetPos() )
		ed:SetEntity( entity )
	util.Effect( "entity_remove", ed, true, true )

end