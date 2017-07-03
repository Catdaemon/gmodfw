AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Amount = 1
ENT.Item = false
ENT.ResetTime = 10

function ENT:Initialize()
 	self.Entity:SetModel("models/items/item_item_crate_dynamic.mdl")

	self.Entity:SetMoveType( MOVETYPE_NONE )
 	self.Entity:SetSolid( SOLID_NONE )
 	self.Entity:DrawShadow( false )

 	-- Make the bbox short so we can jump over it
 	-- Note that we need a physics object to make it call triggers
 	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
 	self.Entity:PhysicsInitBox( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )

 	local phys = self.Entity:GetPhysicsObject()
 	if (phys:IsValid()) then
 		phys:EnableCollisions( false )
 	end

 	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
 	self.Entity:SetTrigger( true )
 	self.Entity:SetNotSolid( true )

 	self.ActiveTime=0

	if !self.Item then
		self.RandItem=true
		local rand=math.random(1,3)
		if rand==1 then self.Item="item_ammo_smg1_grenade"
			self.Amount=5
		end
		if rand==2 then self.Item="weapon_fw_rifle" end
		if rand==3 then self.Item="item_ammo_pistol" end
	end
end

 function ENT:KeyValue( key, value )
 	if ( key == "item" ) then
 		self.Item=value
		self.RandItem=false
 	end
 	if ( key == "amount" ) then
 		self.Amount=tostring(value)
 	end
	if ( key == "resettime" ) then
 		self.ResetTime=tonumber(value)
 	end
	 if ( key == "model" ) then
 		self.Entity:SetModel(value)
 	end

	if ( string.Left( key, 2 ) == "On" ) then
		self:StoreOutput( key, value )
	end
 end

function ENT:Resetx()
	if GAMEMODE:GetRound() == 2 then
		self.Entity:SetColor( Color(255,255,255,255))
		local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		util.Effect( "item_respawn", effectdata )
		if self.RandItem==true then
			local randoms = {
				["item_ammo_smg1_grenade"] = 5,
				["weapon_fw_rifle"] = 1,
				["item_ammo_pistol"] = 1,
				["weapon_fw_rocketshotgun"] = 1,
				["weapon_fw_propgun"] = 1,
			}
			local amt, item = table.Random(randoms)
			self.Item = item
			self.Amount = amt
			local rand=math.random(1,4)
		end
	end

	local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		ed:SetEntity( self.Entity )
	util.Effect( "propspawn", ed, true, true )
	self.Entity:SetNoDraw(false)

	self:TriggerOutput("OnRespawn", self.Entity)
end

 function ENT:Touch( entity )

 	if ( self.ActiveTime > CurTime() ) then return end
 	if (!entity:IsPlayer()) then return end
	if GAMEMODE:GetRound() == 1 then return end

	for i=1,self.Amount do
		entity:Give(self.Item)
	end

	self:TriggerOutput("OnPickup", entity)

 	self.ActiveTime = CurTime() + self.ResetTime
 	self.Entity:SetNoDraw(true)
 	timer.Simple( 10, function() self:Resetx() end)

 end