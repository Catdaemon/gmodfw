include('shared.lua')

function ENT:Initialize()
  self.OrigPos = self.Entity:GetPos()
end

function ENT:Draw()
  local colour = self.Entity:GetColor()

  -- Use colour to sync state.. why not!
  if colour.r == 255 && colour.g == 0 then
    self.Entity:SetPos(self.OrigPos)
    self.Entity:DrawModel()
  else
    local bounce = math.sin(CurTime()) * 5
    self.Entity:SetAngles(Angle(0,360 * CurTime() / 10,0))
    self.Entity:SetPos(self.OrigPos + Vector(0,0,bounce))
    self.Entity:DrawModel()
  end
end