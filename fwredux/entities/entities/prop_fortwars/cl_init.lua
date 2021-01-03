include('shared.lua')

ENT.OrigMat = ""


function ENT:Initialize()
		self.Entity:StartMotionController()
		self.Entity:AddToMotionController(self.Entity:GetPhysicsObject())
		
end

function ENT:Think()
	if !self.OrigMat then
		self.OrigMat = self.Entity:GetMaterial()
	end
end

function ENT:Draw()
	local myteam = self:GetTeam()
	local fraction = self:GetHealthScalar()

	self.Entity:SetMaterial(self.OrigMat)
	if self:GetOOB() == 1 then
		self.Entity:SetMaterial("models/wireframe")
	end
	
	self:DrawModel()
end

function ENT:OnRemove()
end