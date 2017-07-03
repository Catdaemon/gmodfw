 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	self.Position = data:GetStart() 
 	 
 	local LightColor = Color(128,128,128,128)
 	 
 	local emitter = ParticleEmitter(self.Position ) 
 		 
 			local particle2 = emitter:Add( "particles/smokey", self.Position ) 
   
 				particle2:SetVelocity( Vector(0,0,0) ) 
 				particle2:SetDieTime( math.Rand( 5, 10 ) ) 
 				particle2:SetStartAlpha( math.Rand( 10, 50 ) ) 
 				particle2:SetStartSize( math.Rand( 5, 10 ) ) 
 				particle2:SetEndSize( math.Rand( 10, 20 ) ) 
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