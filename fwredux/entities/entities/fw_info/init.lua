AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel("models/items/item_item_crate_dynamic.mdl")
	self.Entity:SetMoveType( MOVETYPE_NONE ) 
 	self.Entity:SetSolid( SOLID_NONE ) 
 	self.Entity:DrawShadow( false ) 
 	 	 
 	local phys = self.Entity:GetPhysicsObject() 
 	if (phys:IsValid()) then 
 		phys:EnableCollisions( false )		 
 	end 
 	 
 	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )  
 	self.Entity:SetNotSolid( true ) 
end

function ENT:KeyValue( key, value )
	if ( key == "name" ) then 
		self.Name=value
	end 
	if ( key == "author" ) then 
		self.Authorx=value
	end
end 