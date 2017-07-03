ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Team" )
	self:NetworkVar( "Int", 1, "CoreHealth" )
	self:NetworkVar( "Int", 2, "BuildRadius" )
end