AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local FireSound = Sound( "NPC_FloorTurret.Shoot" )

function ENT:Initialize()
	self.Entity:SetModel("models/combine_turrets/ground_turret.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )

	self.Active = false
	self.Entity:StartMotionController()
	self.Entity:GetPhysicsObject():SetMass(10000)
	constraint.NoCollide( self.Entity, game.GetWorld(), 0, 0 )

	timer.Simple(0.05, function() 
		self.Entity:GetPhysicsObject():Wake()
		local tracedata = {}
		tracedata.start = self.Entity:GetPos()
		tracedata.endpos = self.Entity:GetPos()-Vector(0,0,50)
		tracedata.mask = MASK_NPCWORLDSTATIC
		local trace = util.TraceLine(tracedata)
		self.Entity:SetPos(trace.HitPos)

		self.OrigHeight=self.Entity:GetPos()
		self.OrigAngles=self.Entity:GetAngles()
		self.TargetHeight=self.Entity:GetPos()

		self.ShadowParams={}
		self.ShadowParams.secondstoarrive	= 1
		self.ShadowParams.targetposition	= self.OrigHeight
		self.ShadowParams.maxangular		= 5000
		self.ShadowParams.maxangulardamp	= 10000
		self.ShadowParams.maxspeed			= 1000000
		self.ShadowParams.maxspeeddamp		= 10000
		self.ShadowParams.dampfactor		= 0.8
		self.ShadowParams.teleportdistance	= 200
		self.ShadowParams.angle				= self.OrigAngles

		local prop = ents.Create("prop_physics")
			prop:SetPos( self.Entity:GetPos()+Vector(0,0,0) )
			prop:SetAngles( Angle(90,0,0) )
			prop:SetModel("models/props_trainstation/trainstation_clock001.mdl")
			prop:Spawn()
			prop:Activate()
			prop:PhysicsInit( SOLID_VPHYSICS )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetSolid( SOLID_VPHYSICS )
			prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
			prop:SetMaterial("models/dav0r/hoverball")
			prop:SetParent(self.Entity)
		self.KeepProp = prop
		local prop2 = ents.Create("prop_physics")
			prop2:SetPos( self.Entity:GetPos() - Vector(0,0,30) )
			prop2:SetAngles( Angle(0,0,0) )
			prop2:SetModel("models/props_junk/propane_tank001a.mdl")
			prop2:SetColor(50,50,50,255)
			prop2:Spawn()
			prop2:Activate()
			prop2:PhysicsInit( SOLID_NONE )
			prop2:SetMoveType( MOVETYPE_NONE )
			prop2:SetSolid( SOLID_NONE )
			prop2:SetMaterial("models/dav0r/hoverball")
			prop2:SetParent(self.Entity)
			prop2:SetHealth(99999) -- lol
		self.BulletFilters={self.Entity,prop,prop2}
		
		local ed = EffectData()
			ed:SetOrigin( prop:GetPos() )
			ed:SetEntity( prop )
		util.Effect( "propspawn", ed, true, true )
		local ed = EffectData()
			ed:SetOrigin( prop2:GetPos() )
			ed:SetEntity( prop2 )
		util.Effect( "propspawn", ed, true, true )
		local ed = EffectData()
			ed:SetOrigin( self.Entity:GetPos() )
			ed:SetEntity( self.Entity )
		util.Effect( "propspawn", ed, true, true )

		if self:GetPropHealth() < 100 then
			self:SetPropHealth(200)
		end
	end)
end

 function ENT:KeyValue( key, value )
 	if ( key == "health" ) then
 		self:SetPropHealth(tonumber(value))
 	end
 	if ( key == "team" ) then
 		self:SetTeam(tonumber(value))
 	end

	if ( string.Left( key, 2 ) == "On" ) then
		self:StoreOutput( key, value )
	end
 end


function ENT:PhysicsSimulate( phys, deltatime )
	self.ShadowParams.deltatime	= deltatime
	phys:ComputeShadowControl(self.ShadowParams)
end

function ENT:Think()
	self.Entity:GetPhysicsObject():Wake()

	self.Active = false
	self.ShadowParams.pos = self.OrigHeight
	local nearestplayer= false

	if GAMEMODE:GetRound() == 2 then
		local nearest=1025
		for _,ply in pairs(player.GetAll()) do
			local len=ply:GetPos():Distance(self.Entity:GetPos())
			if len<1024 and ply:Team() ~= self:GetTeam() then
				self.Active=true
				if len<nearest then
					nearest=len
					nearestplayer=ply
				end
			end
		end
	else
		self.ShadowParams.pos = self.OrigHeight+Vector(0,0,40)
		--self.ShadowParams.angle	= TimedSin(0.5, 0, 90, 0)
	end

	if self.Active then
		local ppos=nearestplayer:GetPos()
		self.ShadowParams.pos= self.OrigHeight+Vector(0,0,40)
		local ang=(Vector(ppos.x,ppos.y,self.Entity:GetPos().z) -self.Entity:GetPos()):Angle()
		ang.p=0
		ang.r=0
		self.ShadowParams.angle	= ang

		local eNrm = self.Entity:GetForward()
		local ViewNormal = self.Entity:GetPos() - Vector(ppos.x,ppos.y,self.Entity:GetPos().z)
		local Distance = ViewNormal:Length()
		ViewNormal:Normalize()
		local ViewDot = ViewNormal:Dot( eNrm )

		local vang = self.Entity:GetAngles() - (ppos - self.Entity:GetPos()):Angle()
		vang:Normalize()

		if vang.r < 1 && vang.y < 4 then
			local tracedata = {}
			tracedata.start = self.Entity:GetPos()
			tracedata.endpos = ppos+Vector(0,0,50)
			tracedata.filter= self.BulletFilters
			local trace = util.TraceLine(tracedata)
			if trace.Entity:IsValid() and trace.Entity:IsPlayer() then
				local src= self.Entity:GetPos() + (self.Entity:GetForward()*35) - Vector(0,0,15)

				local effectdata = EffectData()
				effectdata:SetStart( src )
				effectdata:SetOrigin( src )
				effectdata:SetScale( 1 )
				effectdata:SetAngles( self.Entity:GetForward():Angle() )
				effectdata:SetEntity( self.Entity )
				util.Effect( "MuzzleEffect", effectdata )

				bullet = {}
				bullet.Num=1
				bullet.Src=src
				local forward = (nearestplayer:GetShootPos() - self.Entity:GetPos()):Angle()--self.Entity:GetForward():Angle()
				dir = forward:Forward()
				bullet.Dir=dir
				bullet.Spread=Vector(0.05,0.05,0.05)
				bullet.Tracer=1
				bullet.Force=5
				bullet.Damage=5
				self.Entity:FireBullets(bullet)
				self.Entity:EmitSound( FireSound, 100, 100 )
			end
		end
	end
	if self.Active then -- these do a lot on think.. better slow it down a bit when not needed. This is also handy to control the fire rate.
		self.Entity:NextThink( CurTime() + 0.2 )
	else
		self.Entity:NextThink( CurTime() + 1 )
	end
	return true

end

function ENT:OnTakeDamage(dmg)
	if !self.Active then return end
		self:SetPropHealth(self:GetPropHealth()-dmg:GetDamage())
			if self:GetPropHealth() < 1 then

				umsg.Start( "EntDestruction" )
					
					umsg.String( tostring(team.GetName(self:GetTeam()) ).. " turret")
					umsg.String( dmg:GetInflictor():GetClass() )
					if dmg:GetAttacker():IsPlayer() then
						umsg.String( dmg:GetAttacker():Nick() )
					else
						umsg.String( dmg:GetAttacker():GetClass() )
					end
					if dmg:GetAttacker():IsPlayer() then
						umsg.Short( dmg:GetAttacker():Team() )
					else
						umsg.String( 0 )
					end
					
					umsg.Short( self:GetTeam() )

				umsg.End()

				self:TriggerOutput("OnDestroyed", dmg:GetAttacker())


				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos() )
				effectdata:SetOrigin( self.Entity:GetPos() )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,100) )
				effectdata:SetOrigin( self.Entity:GetPos()+Vector(0,0,100) )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,200) )
				effectdata:SetOrigin( self.Entity:GetPos()+Vector(0,0,200) )
				effectdata:SetScale( 50 )
				effectdata:SetMagnitude( 50 )
				util.Effect( "Explosion", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos() )
				util.Effect( "explodesmoke", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart( self.Entity:GetPos()+Vector(0,0,100) )
				util.Effect( "explodesmoke", effectdata )
				local effectdata = EffectData()
				effectdata:SetStart(self.Entity:GetPos()+Vector(0,0,200) )
				util.Effect( "explodesmoke", effectdata )

				self.KeepProp:SetParent(nil)
				self.KeepProp:PhysicsInit( SOLID_VPHYSICS )
				self.KeepProp:SetMoveType( MOVETYPE_VPHYSICS )
				self.KeepProp:SetSolid( SOLID_VPHYSICS )
				self.KeepProp:GetPhysicsObject():Wake()

				self.Entity:Remove()
			end
end