ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Range = 1024

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Team" )
    self:NetworkVar( "Int", 1, "PropHealth" )
end