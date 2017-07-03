/*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	// Keep the start and end pos - were going to interpolate between them 
 	local NumParticles = 0 
 	local Pos = data:GetOrigin()
 	 
	EmitSound( "weapons/slam/mine_mode.wav", Pos, 1, CHAN_WEAPON, 1, 75, 0, 100 ) 
   
 	local emitter = ParticleEmitter( Pos ) 
 	 
 		for i= 0, 100 do 
 		 
 			local particle = emitter:Add( "sprites/gmdm_pickups/light", Pos + VectorRand()*16 ) 
 				particle:SetVelocity( (VectorRand()) * math.Rand( 50, 300 ) ) 
 				particle:SetDieTime( math.Rand( 1, 5 ) ) 
 				particle:SetStartAlpha( 250 ) 
 				particle:SetEndAlpha( 250 ) 
 				particle:SetStartSize( 16 ) 
 				particle:SetEndSize( 0 ) 
 				particle:SetRoll( math.Rand( 0, 360 ) ) 
 				particle:SetRollDelta( math.Rand( -5.5, 5.5 ) ) 
 				particle:SetColor( 255, 255, 255 ) 
 				 
 		end 
 				 
 	emitter:Finish() 
 	 
 end 
   
   
 /*--------------------------------------------------------- 
    THINK 
    Returning false makes the entity die 
 ---------------------------------------------------------*/ 
 function EFFECT:Think( ) 
 	return false 
 end 
   
   
 /*--------------------------------------------------------- 
    Draw the effect 
 ---------------------------------------------------------*/ 
 function EFFECT:Render()	 
 end  