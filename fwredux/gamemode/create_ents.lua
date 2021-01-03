--
-- Create entities for third-party maps
--

mapDefs = {}
mapDefs["fw_city_v2"] = {}
mapDefs["fw_city_v2"]["cores"] = {
    {
        team = 1,
        pos = Vector(5553.957031, -711.031250, 50),
        radius = 2000,
        health = 1000
    },
    {
        team = 2,
        pos = Vector(1647.729492, -5479.635742, 50),
        radius = 2000,
        health = 1000
    }
}
mapDefs["fw_city_v2"]["pickups"] = {
    Vector(3314.372559, -2298.472168, 92),
    Vector(2821.867676, -2302.248291, 92),
    Vector(2822.071533, -2801.301514, 92),
    Vector(3320.709961, -2817.073975, 92),
    Vector(3075.005859, -2563.834473, 92)
}

mapDefs["fw_concrete"] = {}
mapDefs["fw_concrete"]["cores"] = {
    {
        team = 1,
        pos = Vector( -2.742074, 2261.489502, -320),
        radius = 2000,
        health = 1000
    },
    {
        team = 2,
        pos = Vector(-30.947739, -2330.658936, -320),
        radius = 2000,
        health = 1000
    }
}
mapDefs["fw_concrete"]["pickups"] = {
    Vector(3.310322, 817.188477, 0),
    Vector(-13.902460, -846.906921, 0),
    Vector(2.162519, 1.145729, -170),
    Vector(444.203674, 10.891154, -190),
    Vector(-459.196411, -45.519318, -190),
}

mapDefs["fw_mayan"] = {}
mapDefs["fw_mayan"]["cores"] = {
    {
        team = 1,
        pos = Vector(-530.098938, 2704.490479, 80),
        radius = 1000,
        health = 1000
    },
    {
        team = 2,
        pos = Vector(-518.655945, 405.931335, 80),
        radius = 1000,
        health = 1000
    }
}
mapDefs["fw_mayan"]["pickups"] = {
    Vector(-753.435364, 1541.808838, 100),
    Vector(-514.460632, 1771.996338, 100),
    Vector(-289.013519, 1536.786499, 100),
    Vector(444.203674, 10.891154, 100),
    Vector(-510.695435, 1297.572021, 100),
}

function GM:CreateEnts()
    -- Create spawn areas
    for _, point in pairs(ents.FindByClass("info_player_red")) do
        local e = ents.Create("fw_spawn_zone")
        e:SetPos(point:GetPos())
        e:SetColor(Color(255,0,0,32))
        e:Spawn()
    end

    for _, point in pairs(ents.FindByClass("info_player_blue")) do
        local e = ents.Create("fw_spawn_zone")
        e:SetPos(point:GetPos())
        e:SetColor(Color(0,0,255,32))
        e:Spawn()
    end

    -- Create map-specific ents
    local mapName = game.GetMap()
    local defs = mapDefs[mapName]
    if defs != nil then
        for _, def in pairs(defs["cores"]) do
            local core = ents.Create("fw_core")
            core:SetPos(def["pos"])
            core:SetBuildRadius(def["radius"])
            core:SetCoreHealth(def["health"])
            core:SetTeam(def["team"])
            core:Spawn()
        end
        for _, def in pairs(defs["pickups"]) do
            local pickup = ents.Create("fw_pickup")
            pickup:SetPos(def)
            pickup:Spawn()
        end
    end
end