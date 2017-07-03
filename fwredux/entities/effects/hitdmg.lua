
function EFFECT:Init( data )
	self.TargetEntity = data:GetEntity()
    self.Damage = math.Round(data:GetMagnitude())
	if ( !IsValid( self.TargetEntity ) ) then return false end
    local angle = (self:GetPos() - (self.TargetEntity:GetPos() + self.TargetEntity:OBBCenter())):Angle()
    self:SetPos(self:GetPos() + angle:Forward() * 10)
    self:SetPos(self:GetPos() + Vector(0,0,10))

    self.Speed = 5
    self.Progress = 0.001
    self.Seed = math.random(1,5000)

    self.Size = 1
    self.Alpha = 1
    self.orig = self:GetPos()
end

function EFFECT:Think()
    if self.Progress == nil then return false end
    self.Progress = self.Progress + 0.008
    self:SetPos(self:GetPos() + Vector(TimedSin(1, 0, 0.08, self.Seed),TimedSin(1, 0, 0.05, self.Seed/2), 0.2,1))
    if self.Progress > 1 then return false else return true end
end

function EFFECT:Render()
     if self.Progress == nil then return false end
    local ang = (LocalPlayer():GetShootPos() - self:GetPos()):Angle()
    
    cam.Start3D2D( self:GetPos(), ang:Right():Angle() + Angle(0,180,90), (1 - self.Progress) * 0.8)
        
		draw.SimpleTextOutlined("-"..self.Damage, "DermaDefault", 0,0, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,98))
	cam.End3D2D()
end
