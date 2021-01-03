SWEP.Base			    = "weapon_fw_base"
SWEP.PrintName			= "Blowtorch"
SWEP.Slot			    = 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		    = "models/weapons/w_pistol.mdl"

SWEP.Weight			        = 1
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

function SWEP:Initialize()

 	self:SetWeaponHoldType( "pistol" )

end

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

 function SWEP:PrimaryAttack()     
    local pl=self.Owner
	local vStart = pl:GetShootPos()
	local vForward = pl:GetAimVector()
	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 64)
	trace.filter = pl
    local tr = util.TraceLine( trace )
    
    if tr.Entity && tr.Entity:IsValid() && (tr.Entity:GetClass() == "prop_fortwars" || tr.Entity:GetClass() == "fw_core" || tr.Entity:GetClass() == "fw_turret_ground") then
        if SERVER then
            tr.Entity:TakeDamage(2, pl, self.Entity)
        end
        
        local effectdata = EffectData()
        effectdata:SetOrigin( tr.HitPos )
        effectdata:SetEntity( tr.Entity )
        effectdata:SetStart( tr.HitPos )
        effectdata:SetNormal( tr.HitNormal )
        util.Effect( "manhacksparks", effectdata, true, true )
    end

    local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )

    self.Weapon:SetNextPrimaryFire( CurTime() + 0.1 )

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

 end