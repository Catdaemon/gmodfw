 SWEP.Base				= "weapon_fw_base"
 SWEP.PrintName			= "Rocket shotgun"
 SWEP.Slot				= 2
 SWEP.SlotPos			= 1
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true
 SWEP.ViewModel			= "models/weapons/v_shotgun.mdl"
 SWEP.WorldModel		= "models/weapons/w_shotgun.mdl"
 
SWEP.Weight			        = 10
SWEP.AutoSwitchTo		    = true
SWEP.AutoSwitchFrom		    = true

 function SWEP:NeedsPump()
 	return self.Weapon:GetNetworkedBool( "NeedsPump" )
 end

 function SWEP:SetNeedsPump( b )
 	self.Weapon:SetNetworkedBool( "NeedsPump", b )
 end

 function SWEP:Initialize()

 	self:SetWeaponHoldType( "smg" )
 	self:SetNeedsPump( false )

 	self.LastTime = 0;
 end


 /*---------------------------------------------------------
    PRIMARY
    Semi Auto
 ---------------------------------------------------------*/

 SWEP.Primary.ClipSize		= -1
 SWEP.Primary.DefaultClip	= 10
 SWEP.Primary.Automatic		= false
 SWEP.Primary.Ammo		= "buckshot"

 function SWEP:PrimaryAttack()

 	if ( self.LastTime >= CurTime() ) then return end
 	self.LastTime = CurTime()

 	self.Weapon:SetNextSecondaryFire( CurTime() + 0.2 )
 	self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )

 	if ( self:Ammo1() <= 0 ) then return end

 	if ( self:NeedsPump() ) then

 		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
 		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
 		self:SetNeedsPump( false )
 		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
 		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

 	return end

	if SERVER then
		local MuzzlePos = self.Owner:GetShootPos()
		local ball = ents.Create("proj_shotgunrocket")
		ball:SetPos(MuzzlePos)
		ball:SetOwner(self.Owner)
		ball:SetAngles(self.Owner:GetAimVector():Angle())
		ball:Spawn()
		ball:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*3000)
	end

 	self:TakePrimaryAmmo(1)
 	self:SetNeedsPump( true )

	self:FireBlank(true)
 end


 /*---------------------------------------------------------
    SECONDARY
    Automatic (Uses Primary Ammo)
 ---------------------------------------------------------*/

 SWEP.Secondary.ClipSize	= -1
 SWEP.Secondary.DefaultClip	= -1
 SWEP.Secondary.Automatic	= false
 SWEP.Secondary.Ammo		= "none"

 local sndDblShoot = Sound( "Town.d1_town_01a_shotgun_dbl_fire" )

 function SWEP:SecondaryAttack()

 	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
 	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

 	if ( self:Ammo1() <= 4 ) then return end

 	if ( self:NeedsPump() ) then

 		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
 		self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )
 		if (SERVER) then self:SetNeedsPump( false ) end
 		self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
 		self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

 	return end

	if SERVER then
		for i=1,4 do
			local MuzzlePos = self.Owner:GetShootPos()
			local ball = ents.Create("proj_shotgunrocket")
			ball:SetPos(MuzzlePos)
			ball:SetOwner(self.Owner)
			ball:SetAngles(self.Owner:GetAimVector():Angle())
			ball:Spawn()
			local ang=self.Owner:GetAimVector()*2000
			ang=ang+Vector(math.random(0,200),math.random(0,200),math.random(0,200))
			ball:GetPhysicsObject():SetVelocity(ang)
		end
	end


 	self:TakePrimaryAmmo(4)
 	self:SetNeedsPump(true)

	self:FireBlank(true)

 end