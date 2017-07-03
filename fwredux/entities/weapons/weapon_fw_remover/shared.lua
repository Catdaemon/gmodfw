 SWEP.Base			= "weapon_fw_base"
 SWEP.PrintName			= "Remover"
 SWEP.Slot			= 0
 SWEP.SlotPos			= 7
 SWEP.DrawAmmo			= false
 SWEP.DrawCrosshair		= true
 SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
 SWEP.WorldModel		= "models/weapons/w_toolgun.mdl"


 function SWEP:Initialize()

 	self:SetWeaponHoldType( "smg" )

 end



 /*---------------------------------------------------------
    PRIMARY
    Semi Auto
 ---------------------------------------------------------*/

 SWEP.Primary.ClipSize		= -1
 SWEP.Primary.DefaultClip	= -1
 SWEP.Primary.Automatic		= false
 SWEP.Primary.Ammo		= "none"

 function SWEP:PrimaryAttack()
	local pl=self.Owner
	local vStart = pl:GetShootPos()
	local vForward = pl:GetAimVector()
	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (vForward * 512)
	trace.filter = pl
	local tr = util.TraceLine( trace )

	if SERVER then
		if tr.Entity && tr.Entity:IsValid() && tr.Entity:GetClass() == "prop_fortwars" then
			if tr.Entity:GetPropOwner()==pl and tr.Entity:GetPropHealth()>10 then
					-- Remove it properly in 1 second
					timer.Simple( 1, function() if ( IsValid( tr.Entity ) ) then tr.Entity:Remove() end end )

					-- Make it non solid
					tr.Entity:SetNotSolid( true )
					tr.Entity:SetMoveType( MOVETYPE_NONE )
					tr.Entity:SetNoDraw( true )

					-- Send Effect
					local ed = EffectData()
						ed:SetOrigin( tr.Entity:GetPos() )
						ed:SetEntity( tr.Entity )
					util.Effect( "entity_remove", ed, true, true )
				pl:SetRemainingProps( pl:GetRemainingProps() + 1 )
			else
				pl:ChatPrint("Can't remove that!")
			end
		end
	end

	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self.Weapon )
	util.Effect( "ToolTracer", effectdata )

	self:FireBlank(false)
 end


 /*---------------------------------------------------------
    SECONDARY
    Automatic (Uses Primary Ammo)
 ---------------------------------------------------------*/

 SWEP.Secondary.ClipSize	= -1
 SWEP.Secondary.DefaultClip	= -1
 SWEP.Secondary.Automatic	= false
 SWEP.Secondary.Ammo		= "none"

 function SWEP:SecondaryAttack()

 end