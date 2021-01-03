include('shared.lua')  

SWEP.TurretSprite = Material( "icon16/arrow_down.png" )

function SWEP:PostDrawViewModel(viewmodel, weapon, ply)
    local hitPos = LocalPlayer():GetEyeTrace().HitPos
    render.DrawWireframeBox( hitPos, Angle(0,0,0), Vector(-50, -50, -10), Vector(50, 50, 5), Color(255,255,255,255), true )

    cam.Start3D()
        render.SetMaterial( self.TurretSprite )
        render.DrawSprite(hitPos+Vector(0,0,32), 16, 16, self:GetColor() )
    cam.End3D()
end