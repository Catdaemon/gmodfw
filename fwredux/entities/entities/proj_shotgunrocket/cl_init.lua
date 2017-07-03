include('shared.lua')


function ENT:Initialize()

end

function ENT:Think()
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( self.Entity:GetPos() )
	util.Effect( "rockettrail", effectdata )
end

function ENT:Draw()
	self.Entity:DrawModel()
end