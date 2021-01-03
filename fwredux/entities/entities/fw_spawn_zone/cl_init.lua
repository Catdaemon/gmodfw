include('shared.lua')

ENT.PersonSprite = Material( "icon16/user.png" )
ENT.ArrowSprite = Material( "icon16/arrow_down.png" )

function ENT:Initialize()
  --self.Entity:SetMaterial("models/wireframe")
end

function ENT:Draw()
  if GAMEMODE:GetRound() == 2 then return end

  self.Entity:DrawModel()
  
  local bounce = math.sin(CurTime()) * 10

  local prevColor = self:GetColor()
  self:SetColor(255,255,255,255)

  cam.Start3D()
    render.SetMaterial( self.PersonSprite )
    render.DrawSprite(self:GetPos()+Vector(0,0,100 - bounce), 16, 16, self:GetColor() )
    render.SetMaterial( self.ArrowSprite )
    render.DrawSprite(self:GetPos()+Vector(0,0,80 - bounce), 16, 16, self:GetColor() )
  cam.End3D()

  self:SetColor(prevColor)
end