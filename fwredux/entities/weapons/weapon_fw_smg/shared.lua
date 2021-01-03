 SWEP.Base			= "weapon_fw_base"
 SWEP.PrintName			= "SMG"
 SWEP.Slot			= 2
 SWEP.SlotPos			= 0
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true
 SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
 SWEP.WorldModel		= "models/weapons/w_smg1.mdl"


 function SWEP:Initialize()

 	self:SetWeaponHoldType( "smg" )

 end



 /*---------------------------------------------------------
    PRIMARY
    Semi Auto
 ---------------------------------------------------------*/

 SWEP.Primary.ClipSize		= 32
 SWEP.Primary.DefaultClip	= 128
 SWEP.Primary.Automatic		= true
 SWEP.Primary.Ammo		= "Pistol"

 function SWEP:PrimaryAttack()

 	self.Weapon:SetNextSecondaryFire( CurTime() + 0.05 )
 	self.Weapon:SetNextPrimaryFire( CurTime() + 0.05 )

 	if ( !self:CanPrimaryAttack() ) then return end
	 --self.Owner:LagCompensation( true )
 	self:GMDMShootBullet( 5, "Weapon_SMG1.Single", math.Rand( -1, 0 ), math.Rand( -2.0, 2.0 ) )
	 --self.Owner:LagCompensation( false )

 	self:TakePrimaryAmmo( 1 )

 end


 /*---------------------------------------------------------
    SECONDARY
    Automatic (Uses Primary Ammo)
 ---------------------------------------------------------*/

 SWEP.Secondary.ClipSize		= 1
 SWEP.Secondary.DefaultClip	= 0
 SWEP.Secondary.Automatic	= false
 SWEP.Secondary.Ammo		= "SMG1_Grenade"

 function SWEP:SecondaryAttack()
	if ( self:Ammo2() <= 0 ) then return end
 	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
	if SERVER then
		local MuzzlePos = self.Owner:GetShootPos()
		local ball = ents.Create("proj_ball")
		ball:SetPos(MuzzlePos)
		ball:SetOwner(self.Owner)
		ball:Spawn()
		ball:GetPhysicsObject():SetVelocity(self.Owner:GetAimVector()*2000)
	end
	 self:TakeSecondaryAmmo( 1 )
 end