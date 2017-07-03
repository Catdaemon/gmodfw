 local WalkTimer = 0
 local VelSmooth = 0

local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:GetEyeTrace()

    if ( self:GetTable().LastPlayertTrace == CurTime() ) then
        return self:GetTable().PlayerTrace
    end

    self:GetTable().PlayerTrace = util.TraceLine( util.GetPlayerTrace( self, self:GetAimVector() ) )
    self:GetTable().LastPlayertTrace = CurTime()

    return self:GetTable().PlayerTrace

end

function meta:HeadshotAngles()
 	self:GetTable().HeadShotStart = self:GetTable().HeadShotStart or 0
 	self:GetTable().HeadShotRoll = self:GetTable().HeadShotRoll or 0
 	self:GetTable().HeadShotRoll = math.Approach( self:GetTable().HeadShotRoll, 0.0, 40.0 * FrameTime() )
 	local roll = self:GetTable().HeadShotRoll
 	local Time = (CurTime() - self:GetTable().HeadShotStart) * 10
 	return Angle( math.sin( Time ) * roll * 0.5, 0, math.sin( Time * 2 ) * roll * -1 )
 end

function GM:CalcView( ply, origin, angle, fov )
 	local vel = ply:GetVelocity()
 	local ang = ply:EyeAngles()

 	VelSmooth = VelSmooth * 0.8 + vel:Length() * 0.1

 	// Roll on strafe
 	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01

 	angle = angle + ply:HeadshotAngles()
 	return self.BaseClass:CalcView( ply, origin, angle, fov )
end