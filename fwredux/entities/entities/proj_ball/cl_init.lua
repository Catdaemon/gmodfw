include('shared.lua')

local matBall = Material( "sprites/sent_ball" )

function ENT:Initialize()
	self.Color=Color(255,255,0,255)
	
end

function ENT:Think()
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetStart( self.Entity:GetPos() )
	util.Effect( "balltrail", effectdata )
end

function ENT:Draw()
	local pos = self.Entity:GetPos()
	local vel = self.Entity:GetVelocity()
		
	render.SetMaterial( matBall )
	
	local lcolor = render.GetLightColor( pos ) * 2
	lcolor.x = self.Color.r * math.Clamp( lcolor.x, 0, 1 )
	lcolor.y = self.Color.g * math.Clamp( lcolor.y, 0, 1 )
	lcolor.z = self.Color.b * math.Clamp( lcolor.z, 0, 1 )
		
	// Fake motion blur
	for i = 1, 10 do
	
		local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
		render.DrawSprite( pos + vel*(i*-0.005), 32, 32, col )
		
	end
		
	render.DrawSprite( pos, 5, 5, lcolor )


end