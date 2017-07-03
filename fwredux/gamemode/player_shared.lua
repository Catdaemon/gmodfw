local PLAYER = FindMetaTable( "Player" )

function PLAYER:SetRemainingProps(int)
    self:SetNWInt("props", int)
end

function PLAYER:GetRemainingProps()
    return self:GetNWInt("props")
end

function PLAYER:SetupFW()
    self:SetRemainingProps( GetConVar("fw_maxplayerprops"):GetInt() )
end

function PLAYER:Init()
    self:SetupFW()
end
