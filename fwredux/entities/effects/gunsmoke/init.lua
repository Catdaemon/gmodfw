 /*---------------------------------------------------------
    Initializes the effect. The data is a table of data
    which was passed from the server.
 ---------------------------------------------------------*/
 function EFFECT:Init( data )

 	self.Position = data:GetStart()
 	self.WeaponEnt = data:GetEntity()
 	self.Attachment = data:GetAttachment()

 	// Keep the start and end pos - we're going to interpolate between them
 	local Pos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )

 	local Velocity 	= data:GetNormal()
 	Velocity.z = 0

 	Pos = Pos + data:GetNormal() * 8

 	local LightColor = render.GetLightColor( Pos ) * 255
 	LightColor.r = math.Clamp( LightColor.r, 90, 255 )
 	LightColor.g = math.Clamp( LightColor.g, 90, 255 )
 	LightColor.b = math.Clamp( LightColor.b, 90, 255 )

 	local emitter = ParticleEmitter( Pos )

 			local particle2 = emitter:Add( "particles/smokey", Pos )

 				particle2:SetVelocity( Velocity * math.Rand( 1, 10 ) )
 				particle2:SetDieTime( math.Rand( 1, 2 ) )
 				particle2:SetStartAlpha( math.Rand( 10, 50 ) )
 				particle2:SetStartSize( math.Rand( 10, 50 ) )
 				particle2:SetEndSize( math.Rand( 50, 60 ) )
 				particle2:SetRoll( math.Rand( -25, 25 ) )
 				particle2:SetRollDelta( math.Rand( -0.1, 0.1 ) )
 				particle2:SetColor( LightColor.r, LightColor.g, LightColor.b )
 	emitter:Finish()

 end


 /*---------------------------------------------------------
    THINK
    Returning false makes the entity die
 ---------------------------------------------------------*/
 function EFFECT:Think( )

 	// Die instantly
 	return false

 end


 /*---------------------------------------------------------
    Draw the effect
 ---------------------------------------------------------*/
 function EFFECT:Render()

 	// Do nothing - this effect is only used to spawn the particles in Init

 end