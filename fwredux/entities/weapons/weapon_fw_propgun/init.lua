AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


local models = {
    'models/props_junk/MetalBucket01a.mdl',
    'models/props_junk/cardboard_box001a.mdl',
    'models/props_interiors/pot01a.mdl',
    'models/props_borealis/bluebarrel001.mdl',
    'models/props_junk/PlasticCrate01a.mdl',
    'models/props_c17/oildrum001.mdl',
    'models/props_interiors/Furniture_Couch02a.mdl',
    'models/props_junk/sawblade001a.mdl',
    'models/props_junk/TrashBin01a.mdl',
    'models/props_junk/metalgascan.mdl',
    'models/props_junk/plasticbucket001a.mdl',
    'models/props_lab/filecabinet02.mdl',
    'models/props_wasteland/controlroom_chair001a.mdl',
    'models/props_junk/propane_tank001a.mdl',
    'models/props_c17/cashregister01a.mdl',
    'models/props_junk/garbage_glassbottle001a.mdl',
    'models/props_junk/garbage_glassbottle002a.mdl',
    'models/props_junk/garbage_glassbottle003a.mdl',
    'models/props_wasteland/prison_padlock001a.mdl',
    'models/props_lab/monitor01a.mdl',
    'models/props_c17/oildrum001_explosive.mdl'
}


function SWEP:Throw(qty)
    for i=1, qty do
        local ent = ents.Create( "prop_physics" )
        ent:SetModel( models[ math.random( #models ) ] )

        ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 32 ) + (VectorRand() * 32) )
        ent:SetAngles( self.Owner:EyeAngles() )
        ent:Spawn()
        ent:SetHealth(1)
        ent:SetOwner( self.Owner )
        ent:SetPhysicsAttacker( self.Owner )

        local phys = ent:GetPhysicsObject()

        local velocity = self.Owner:GetAimVector()
        velocity = velocity * (phys:GetMass() * 5000)
        velocity = velocity + ( VectorRand() * (300 * qty) ) -- scale up randomness with quantity thrown
        phys:ApplyForceCenter( velocity )

        timer.Create( "pdel"..CurTime()..i, 15, 1, function()
            if ent:IsValid() then
                ent:Remove()
            end
        end )
    end

end