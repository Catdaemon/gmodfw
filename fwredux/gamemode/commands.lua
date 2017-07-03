function SpawnProp(pl, command, args)
	if GAMEMODE:GetRound() == 1 then
		if util.IsValidProp(args[1]) and !string.find(string.lower(args[1]),"cargo") then
			if pl:GetRemainingProps() == 0 then
				pl:ChatPrint("You do not have any props left.")
				return false
			end

			local vStart = pl:GetShootPos()
			local vForward = pl:GetAimVector()

			local trace = {}
			trace.start = vStart
			trace.endpos = vStart + (vForward * 2048)
			trace.filter = pl
			local tr = util.TraceLine( trace )

			local prop = ents.Create("prop_fortwars")
			if ( !prop:IsValid() ) then return end

			ang = pl:EyeAngles()
			ang.yaw = ang.yaw + 180
			ang.roll = 0
			ang.pitch = 0

			prop:SetPos( tr.HitPos )
			prop:SetAngles( ang )
			prop:SetModel(args[1])
			prop:Spawn()
			prop:Activate()
			prop:GetPhysicsObject():Wake()

			local ed = EffectData()
				ed:SetOrigin( prop:GetPos() )
				ed:SetEntity( prop )
			util.Effect( "propspawn", ed, true, true )

			local minx,maxx = prop:WorldSpaceAABB()
			local xsize = minx:Distance(maxx)
			if xsize>512 then
				pl:ChatPrint("That prop is too big.")
				prop:Remove()
				return
			end

			local vFlushPoint = tr.HitPos - ( tr.HitNormal * 512 )
			vFlushPoint = prop:NearestPoint( vFlushPoint )
			vFlushPoint = prop:GetPos() - vFlushPoint
			vFlushPoint = tr.HitPos + vFlushPoint
			prop:SetPos(vFlushPoint)

			local valid=GAMEMODE:IsValidSpawnPos(pl,prop:GetPos())
			if valid == false then
				pl:ChatPrint("Too far away from a core.")
				prop:Remove()
				return
			end

			prop:SetTeam(pl:Team())
			prop:SetPropOwner(pl)

			pl:SetRemainingProps( pl:GetRemainingProps() - 1 )
		else
			pl:ChatPrint("That is not a valid prop.")
		end
	else
		pl:ChatPrint("You may only make props in the build round.")
	end
end
concommand.Add("gm_spawn",SpawnProp)

concommand.Add("fw_makecores", function()
	local core = ents.Create("fw_core")
	core:SetPos(Vector(369.766907,-793.759521,-12287.968750))
	core:SetBuildRadius(512)
	core:SetCoreHealth(1000)
	core:SetTeam(1)
	core:Spawn()
	
	core = ents.Create("fw_core")
	core:SetPos(Vector(36.548717,815.501221,-12287.968750))
	core:SetBuildRadius(1024)
	core:SetCoreHealth(1000)
	core:SetTeam(2)
	core:Spawn()

	GAMEMODE:SetupFW()
	BroadcastLua("GAMEMODE:SetupFW()")
end)