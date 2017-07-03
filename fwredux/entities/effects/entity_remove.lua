
function EFFECT:Init( data )
	local TargetEntity = data:GetEntity()
	if ( !IsValid( TargetEntity ) ) then return end

	local vOffset = TargetEntity:GetPos()
	local Low, High = TargetEntity:WorldSpaceAABB()

	local NumParticles = TargetEntity:BoundingRadius()
	NumParticles = NumParticles * 10

	NumParticles = math.Clamp( NumParticles, 32, 512 )

	local emitter = ParticleEmitter( vOffset )

	for i = 0, NumParticles do

		local vPos = Vector( math.Rand( Low.x, High.x ), math.Rand( Low.y, High.y ), math.Rand( Low.z, High.z ) )
		local particle = emitter:Add( "effects/spark", vPos )
		if ( particle ) then

			particle:SetVelocity( ( vPos - vOffset ) * 2 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 2, 7 ) )
			particle:SetStartAlpha( math.Rand( 100, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 2 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( 0 )

			particle:SetAirResistance( 100 )
			particle:SetGravity( Vector( 0, 0, -600 ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.3 )

		end

	end

	emitter:Finish()

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
