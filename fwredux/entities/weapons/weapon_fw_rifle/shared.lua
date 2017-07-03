SWEP.Base			= "weapon_fw_base"
 SWEP.PrintName			= "Rifle"
 SWEP.Slot			= 1
 SWEP.SlotPos			= 0
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true
SWEP.ViewModel      = "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel     = "models/weapons/w_snip_g3sg1.mdl"

   if CLIENT then
	SWEP.ViewModelFlip	    = true
   end

 function SWEP:Initialize()
 	self:SetWeaponHoldType( "pistol" )
 	util.PrecacheSound("NPC_Sniper.FireBullet")
 end


function SWEP:Reload()
	if SERVER then
		if self.Weapon:GetNetworkedBool( "Scoped")==true then
			self.Weapon:SetNetworkedBool( "Scoped", false )
			self.Owner:SetFOV(90,0.3)
		end
	end
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
end

 /*---------------------------------------------------------
    PRIMARY
    Semi Auto
 ---------------------------------------------------------*/

 SWEP.Primary.ClipSize		= 4
 SWEP.Primary.DefaultClip	= 10
 SWEP.Primary.Automatic		= true
 SWEP.Primary.Ammo		= "XBowBolt"

 function SWEP:PrimaryAttack()

 --self.Owner:LagCompensation( true )
local MuzzlePos = self.Owner:GetShootPos()
if self.Weapon:Clip1() == 0 then return end

local trace = self.Owner:GetEyeTrace()
local hit = trace.HitPos

bullet = {}
	bullet.Num    = 1
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0,0,0)
	bullet.Tracer = 1
	bullet.Force  = 10
	bullet.Damage = 20
self.Owner:FireBullets( bullet )

 --self.Owner:LagCompensation( false )
local effectdata = EffectData()
	effectdata:SetOrigin( hit )
	effectdata:SetStart( self.Owner:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
util.Effect( "ToolTracer", effectdata )

local effectdata = EffectData()
	effectdata:SetOrigin( hit )
	effectdata:SetStart( self.Owner:GetShootPos() )
	effectdata:SetAttachment( 1 )
	effectdata:SetEntity( self.Weapon )
util.Effect( "LaserTracer", effectdata )

 	local effectdata = EffectData()
 		effectdata:SetOrigin( hit )
 		effectdata:SetNormal( Vector(0,0,0) )
 		effectdata:SetMagnitude( 8 )
 		effectdata:SetScale( 1 )
 		effectdata:SetRadius( 16 )
 	util.Effect( "Sparks", effectdata, true, true )

self.Owner:ViewPunch( Angle( -4,0,0 ) )

self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
self.Weapon:EmitSound( "NPC_Sniper.FireBullet", 1, 1 )
self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
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
self.Weapon:SetNextSecondaryFire(CurTime() + .2)
if CLIENT then return end
if SERVER then
	if self.Owner:GetFOV() == 90 then
		self.Owner:SetFOV(30,.8)
		self.Weapon:SetNetworkedBool( "Scoped", true )
	elseif self.Owner:GetFOV() == 30 then
		self.Owner:SetFOV(10,.8)
		self.Weapon:SetNetworkedBool( "Scoped", true )
	elseif self.Owner:GetFOV() == 10 then
		self.Owner:SetFOV(90,.8)
		self.Weapon:SetNetworkedBool( "Scoped", false )
	end
end
end