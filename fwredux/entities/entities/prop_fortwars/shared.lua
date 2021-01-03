ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:GetHealthScalar()
    return math.abs(self:GetPropHealth() / self.Entity:GetMaxHealth()) 
end

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 1, "PropHealth" )
    self:NetworkVar( "Int", 2, "MaxHealth" )
	self:NetworkVar( "Int", 3, "Team" )
    self:NetworkVar( "Entity", 4, "PropOwner" )
    self:NetworkVar( "Int", 5, "OOB" )
end

function ENT:PhysicsSimulate( phys, deltatime )
    phys:EnableGravity(true)
    self:SetOOB(0)
	if GAMEMODE:GetRound() ~= 1 then return end
    
    if GAMEMODE:IsValidSpawnPos(self:GetPropOwner(), self:GetPos()) then return end

    -- Find nearest core
    local nearestCore = false
    local shortestDistance = 1000000000
    local myTeam = self:GetTeam()
    for _,core in pairs(GAMEMODE.Cores) do
        if core:GetTeam() == myTeam then
            local thisDistance = (phys:GetPos() - core:GetPos()):Length()
            if thisDistance < shortestDistance then
                nearestCore = core
                shortestDistance = thisDistance
            end
        end
    end

    phys:EnableMotion(true)
    phys:EnableGravity(false)
    self.Entity:ForcePlayerDrop()
    self:SetOOB(1)

    return Vector(0,0,0), (phys:GetPos() - nearestCore:GetPos()):Angle():Forward() * -2000, SIM_GLOBAL_ACCELERATION
end