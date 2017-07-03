ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "Name" )
	self:NetworkVar( "String", 1, "Author" )
end