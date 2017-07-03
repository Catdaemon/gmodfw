 function EFFECT:Init( data ) 
 	 
 	local TargetEntity = data:GetEntity() 
 	if ( !TargetEntity || !TargetEntity:IsValid() ) then return end 
 	 
	self.Entity:SetModel(TargetEntity:GetModel())
	self.Entity:SetPos(TargetEntity:GetPos())
	self.Entity:SetAngles(TargetEntity:GetAngles())
	self.AV=255
 end 
   
   
 /*--------------------------------------------------------- 
    THINK 
 ---------------------------------------------------------*/ 
 function EFFECT:Think( )
	self.AV=self.AV-1
	self.Entity:SetColor(255,255,255,self.AV)
 	return self.AV>0
 end 
   
 /*--------------------------------------------------------- 
    Draw the effect 
 ---------------------------------------------------------*/ 
 function EFFECT:Render() 
	self.Entity:DrawModel()
 end