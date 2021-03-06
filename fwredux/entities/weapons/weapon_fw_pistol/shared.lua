SWEP.Base			= "weapon_fw_base"
 SWEP.PrintName			= "Pistol"
 SWEP.Slot			= 1
 SWEP.SlotPos			= 0
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true
 SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
 SWEP.WorldModel		= "models/weapons/w_pistol.mdl"

SWEP.Weight			        = 1
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = true

 function SWEP:Initialize()

 	self:SetWeaponHoldType( "pistol" )

 end



 /*---------------------------------------------------------
    PRIMARY
    Semi Auto
 ---------------------------------------------------------*/

 SWEP.Primary.ClipSize		= 8
 SWEP.Primary.DefaultClip	= 32
 SWEP.Primary.Automatic		= false
 SWEP.Primary.Ammo		= "Pistol"

 function SWEP:PrimaryAttack()

 	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )

 	if ( !self:CanPrimaryAttack() ) then return end

 	self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )

 	self:TakePrimaryAmmo( 1 )

 end


 /*---------------------------------------------------------
    SECONDARY
    Automatic (Uses Primary Ammo)
 ---------------------------------------------------------*/

 SWEP.Secondary.ClipSize	= -1
 SWEP.Secondary.DefaultClip	= -1
 SWEP.Secondary.Automatic	= true
 SWEP.Secondary.Ammo		= "none"

 function SWEP:SecondaryAttack()

 	self.Weapon:SetNextSecondaryFire( CurTime() + 0.9 )
 	self.Weapon:SetNextPrimaryFire( CurTime() + 0.9 )

 	if ( !self:CanPrimaryAttack() ) then return end
	 --self.Owner:LagCompensation( true )
	 self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )
	 self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )
	 self:GMDMShootBullet( 14, "Weapon_Pistol.Single", math.Rand( -1, -0.5 ), math.Rand( -1, 1 ) )
	 --self.Owner:LagCompensation( false )
 	self:TakePrimaryAmmo( 1 )

 end