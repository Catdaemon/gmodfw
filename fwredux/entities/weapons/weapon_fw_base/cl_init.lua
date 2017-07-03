 SWEP.PrintName			= "Something broke"			 
 SWEP.Slot				= 3
 SWEP.SlotPos			= 6
 SWEP.DrawAmmo			= true
 SWEP.DrawCrosshair		= true

 SWEP.Spawnable			= false
 SWEP.AdminSpawnable		= false

 SWEP.WepSelectIcon			= surface.GetTextureID( "weapons/swep" )

 function SWEP:SetWeaponHoldType( t ) 

 end 

 function SWEP:DrawHUD() 
 end 

 function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha ) 
 end 

 function SWEP:PrintWeaponInfo( x, y, alpha ) 
 end 

 function SWEP:FreezeMovement() 
	return false 
 end 

 function SWEP:ViewModelDrawn() 
 end 

 function SWEP:OnRestore() 
 end 

 function SWEP:OnRemove() 
 end 

 include('shared.lua')