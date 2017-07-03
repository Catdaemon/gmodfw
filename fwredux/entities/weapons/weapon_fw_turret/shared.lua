 SWEP.Base			= "weapon_fw_base"
 SWEP.PrintName			= "Turret placer"
 SWEP.Slot			= 1
 SWEP.SlotPos			= 6
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true
 SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
 SWEP.WorldModel		= "models/weapons/w_smg1.mdl"


 function SWEP:Initialize()
 	self:SetWeaponHoldType( "smg" )
 end

 SWEP.Primary.ClipSize		= -1
 SWEP.Primary.DefaultClip	= -1
 SWEP.Primary.Automatic		= false
 SWEP.Primary.Ammo		= "none"

 function SWEP:PrimaryAttack()
	if SERVER then
		local pl=self.Owner
		local vStart = pl:GetShootPos()
		local vForward = pl:GetAimVector()

		local trace = {}
		trace.start = vStart
		trace.endpos = vStart + (vForward * 4096)
		trace.filter = pl
		local tr = util.TraceLine( trace )
				
		if GAMEMODE:IsValidSpawnPos(pl ,tr.HitPos) then
			if tr.HitWorld then
				if tr.HitNormal:DotProduct(Vector(0,0,1))>0.98 then
					local turret = ents.Create("fw_turret_ground")
					turret:SetPos(tr.HitPos)
					turret:Spawn()
					turret:Activate()
					turret:SetTeam(pl:Team())
					pl:SelectWeapon("weapon_physgun")
					self.Weapon:Remove()
				else
					pl:ChatPrint("Turrets may only be created on flat surfaces.")
				end
			else
				pl:ChatPrint("Turrets may only be created on the ground.")
			end
		else
			pl:ChatPrint("Turrets may only be created in the build area.")
		end
	end 
 end

 SWEP.Secondary.ClipSize	= -1
 SWEP.Secondary.DefaultClip	= -1
 SWEP.Secondary.Automatic	= false
 SWEP.Secondary.Ammo		= "none"

 function SWEP:SecondaryAttack()

 end