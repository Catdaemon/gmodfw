include('shared.lua')

function ENT:Initialize()

end

function ENT:Draw()
	if self:GetCoreHealth() > 0 then
  		
	end
	self.Entity:DrawModel()
end