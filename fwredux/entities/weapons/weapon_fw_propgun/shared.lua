SWEP.Base			    = "weapon_fw_base"
SWEP.PrintName			= "Item Ejector"

SWEP.Primary.ClipSize		= 5
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "357"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "357"

SWEP.Weight			        = 2
SWEP.AutoSwitchTo		    = true
SWEP.AutoSwitchFrom		    = true

SWEP.Slot			        = 1
SWEP.SlotPos			    = 2
SWEP.DrawAmmo			    = true
SWEP.DrawCrosshair		    = false

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

local ShootSound = Sound( "Metal.SawbladeStick" )


function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
    self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
    self:TakePrimaryAmmo( 1 )

	self:EmitSound( ShootSound )


    if SERVER then self:Throw(1) end

    self:FireBlank(true)
end

function SWEP:SecondaryAttack()
    if ( !self:CanPrimaryAttack() ) then return end
    self:TakePrimaryAmmo(3)
    if SERVER then self:Throw(3) end

    self:FireBlank(true)
end