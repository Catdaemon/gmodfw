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
        health = 500
    },
    {
        team = 2,
        pos = Vector(1647.729492, -5479.635742, 50),
        radius = 2000,
        health = 500
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
        health = 500
    },
    {
        team = 2,
        pos = Vector(-30.947739, -2330.658936, -320),
        radius = 2000,
        health = 500
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
        health = 500
    },
    {
        team = 2,
        pos = Vector(-518.655945, 405.931335, 80),
        radius = 1000,
        health = 500
    }
}
mapDefs["fw_mayan"]["pickups"] = {
    Vector(-753.435364, 1541.808838, 100),
    Vector(-514.460632, 1771.996338, 100),
    Vector(-289.013519, 1536.786499, 100),
    Vector(444.203674, 10.891154, 100),
    Vector(-510.695435, 1297.572021, 100),
}

mapDefs["fw_thebridge"] = {}
mapDefs["fw_thebridge"]["cores"] = {
    {
        team = 1,
        pos = Vector(452.194092, 3783.733643, 0),
        radius = 1000,
        health = 500
    },
    {
        team = 2,
        pos = Vector(493.697174, 1779.699341, 0),
        radius = 1000,
        health = 500
    }
}
mapDefs["fw_thebridge"]["pickups"] = {
    Vector(647.906250, 2109.687500, -283.030334),
    Vector(356.937500, 2097.718750, -283.030334),
    Vector(371.968750, 3603.187500, -281.264282),
    Vector(642.937500, 3616.031250, -281.340179),
    Vector(378.500000, 2836.343750, -179.030334),
    Vector(564.375000, 2837.750000, -179.030334),
}

mapDefs["fw_teleport"] = {}
mapDefs["fw_teleport"]["cores"] = {
    {
        team = 1,
        pos = Vector(-312.843750, -28.250000, 980.031250),
        radius = 3000,
        health = 500
    },
    {
        team = 2,
        pos = Vector(5439.750000, -48.781250, 980.031250),
        radius = 3000,
        health = 2000
    }
}
mapDefs["fw_teleport"]["pickups"] = {
    Vector(2550.156250, 1003.093750, 837.657593),
    Vector(2569.062500, 381.125000, 837.657593),
    Vector(2566.968750, -439.375000, 837.657593),
    Vector(2562.625000, -1234.343750, 835.312561),
    Vector(2466.125000, 28.937500, 1425.657593),
    Vector(2644.781250, 4.437500, 1425.657593),
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