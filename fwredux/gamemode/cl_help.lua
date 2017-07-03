local MAPINFO = false

local INFOTEXT =[[
You're playing Fort Wars Redux!
This is an updated and reduxed port of an old gamemode by Catdaemon. This gamemode is also by Catdaemon.
The idea of this game mode is to build a superior base to the other team.
In the gamemode Fort Wars Teamplay, (fwt_ maps), you simply try to massacre the other team.
In the gamemode Fort Wars Core, (fwc_ maps), you have to destroy all of the enemy's cores to win.
Keep in mind that cores can take quite a beating before being destroyed.
Each team can have one or more cores, depending on the map!

There are two rounds:
BUILD - Construct your fort. Each player gets a limited number of spawns, so work together!
        Going out of your core's build radius will do damage to you, so stay close!
FIGHT - Fight! Weapon pickups are available.

TIPS:
- Run over weapon crates to get ammunition or guns.
- Shooting enemy walls enough will cause them to unfreeze and fall. After this, if shot more they will
     be destroyed.
- Pressing F1 gets rid of this screen.
- It is better to make a fort from lots of small props than few big props.
- Standing very close to turrets (or on top!) makes them unable to hit you.
- Shoot SMG grenades into confined spaces.
- The Item Ejector will annoy your enemy more if your teammates use their gravity guns...
- If you're given a turret, think about where you place it.
]]

GM.ShowInfo = true

function GM:ShowHelp()
 	self.ShowInfo = !self.ShowInfo
end

function GM:DrawHelp()
    if !MAPINFO then
		local infoent=ents.FindByClass("fw_info")
		if table.getn(infoent)>0 then
			MAPINFO=infoent[1]
		end
	end

    if MAPINFO then
		surface.SetTextColor(255,255,0,255)
		surface.SetFont("DefaultBold")
		local str="Map author: "..FW_INFOENT:GetAuthor() .. " Map name: "..FW_INFOENT:GetName()
		surface.SetTextPos(ScrW()-surface.GetTextSize(str)-10,ScrH()-20)
		surface.DrawText(str)
	end

    if self.ShowInfo then
		draw.RoundedBox(8, 10, 10, ScrW()-100, ScrH()-100, Color(50,50,75,200) )
		draw.DrawText(INFOTEXT,"ChatFont",25,25,Color(255,255,255,255),TEXT_ALIGN_LEFT)
	end
end

function GM:DrawEndMsg()
    if self.MatchEnded then
		local message=""
		local time=math.Round(self.MatchEndTime-CurTime())
		if self.WinningTeam==LocalPlayer():Team() then
			message=[[
Congratulations!
Your team has won the round by destroying all of the enemy cores.
Next match in in ]]..tostring(time)..[[ seconds!
			]]
        elseif self.WinningTeam != 0 then
			message=[[
You have failed!
Your team has lost the round, all your cores were destroyed.
Next match in in ]]..tostring(time)..[[ seconds!
			]]
        else
            message=[[
You all suck!
Both teams have lost the round, as none could do a simple job and
destroy your enemy's core. What a sorry state of affairs.
Next match in in ]]..tostring(time)..[[ seconds.
			]]
		end
		surface.SetDrawColor(50,50,75,255)
		surface.DrawRect(0,0,ScrW(), ScrH())
		draw.DrawText(message,"ChatFont",ScrW()/2,ScrH()/2,Color(255,255,255,255),TEXT_ALIGN_CENTER)
    end
end

-- Receive a round end message
net.Receive( "RoundEnd", function( len, ply )
	 GAMEMODE.MatchEnded = true
     GAMEMODE.MatchEndTime = CurTime() + 15
     GAMEMODE.WinningTeam = net.ReadInt(8)
end )