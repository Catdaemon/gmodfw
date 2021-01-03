--GM.InfoPanel = false

function GenerateInfoPanel(parent, data)
    for _, row in pairs(data) do
        local infolabel = vgui.Create( "DLabel", parent )
        infolabel:SetTextColor( row[2] )
        infolabel:SetText( row[1] )
        infolabel:SizeToContents()
        infolabel:Dock(TOP)
        infolabel:DockMargin( row[3].x, row[3].y, 0, 0 )
    end
end

function GenerateTeamPanel(parent, teamid)
    local teamColor = GAMEMODE:GetTeamNumColor(teamid)
    
    local button = vgui.Create( "DButton", parent )
    button:Dock(LEFT)
    button:SetText("")
    button:SetWidth(574/2)
    button:SetDisabled( IsValid( LocalPlayer() ) && LocalPlayer():Team() == teamid )
    button.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, teamColor )
    end

    local icon = vgui.Create( "DModelPanel", button )
    icon:Dock(FILL)
    if teamid == 2 then icon:SetModel( "models/player/urban.mdl" ) end
    if teamid == 1 then icon:SetModel( "models/player/guerilla.mdl" ) end
    icon.LayoutEntity = function( Entity )   end
    local headpos = icon.Entity:GetBonePosition( icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
    icon:SetLookAt( headpos )
    icon:SetCamPos( headpos-Vector( -20, 0, 0 ) )
    icon.Entity:SetEyeTarget( headpos-Vector( -15, 0, 0 ) )
    icon.DoClick = function()
        RunConsoleCommand( "changeteam", teamid )
        GAMEMODE.InfoPanel:Remove()
    end    

    if IsValid( LocalPlayer() ) && LocalPlayer():Team() == teamid then
        label = vgui.Create ( "DLabel", icon )
        label:Dock(TOP)
        label:SetContentAlignment(5)
        label:SetText("Your Team")
        label.Paint = function( self, w, h )
            draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0, 0,200 ) )
        end
    end

    label = vgui.Create ( "DLabel", icon )
    label:Dock(BOTTOM)
    label:SetContentAlignment(5)
    label:SetText(team.GetName(teamid))
    label.Paint = function( self, w, h )
       draw.RoundedBox( 0, 0, 0, w, h, Color( 0,0,0,200 ) )
    end
end

function GM:CreateUI()
    if GAMEMODE.InfoPanel then
        GAMEMODE.InfoPanel:Remove()
    end

    local bg = vgui.Create( "EditablePanel" )
    bg:SetSize( ScrW(), 600  )
    bg:Center()
    bg.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 75,75,75,240 ) ) 
    end
    bg:MakePopup()

    GAMEMODE.InfoPanel = bg

    local frame = vgui.Create( "EditablePanel", bg )
    frame:SetSize( 600,400  )
    frame:Center()
    --frame:SetTitle( "FortWars!" )
    --frame:SetVisible( true )
    --frame:SetDraggable( false )
    --frame:ShowCloseButton( true )

    local close = vgui.Create( "DButton", bg )
    close:SetSize(100,32)
    close:SetPos(ScrW() / 2 + 200, 516)
    close:SetText("Close")
    close:SetImage("icon16/accept.png")
    close.DoClick = function() GAMEMODE.InfoPanel:Remove() end    

    local sheet = vgui.Create( "DPropertySheet", frame )
    sheet:Dock( FILL )

    local info = vgui.Create( "DPanel", sheet )
    info.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 64, 32, 32 ) ) end
    sheet:AddSheet( "Information", info, "icon16/information.png" )

        GenerateInfoPanel(info, {
            {
                "Welcome to FortWars!",
                Color( 255,255,255 ),
                Vector(8, 8)
            },
            {
                [[The objective of this game is to defend your core by building a fort and then battling the enemy team to destroy theirs.
Each team can have one or more cores, depending on the map!
]],
                Color( 200,200,200 ),
                Vector(16,0)
            },
            {
                "ROUNDS:",
                Color( 255,255,255 ),
                Vector(8, 8)
            },
            {
                [[BUILD - Construct your fort. Each player gets a limited number of props to use, so work together!
    You can only build within a specified distance of a core.
FIGHT - Fight! Weapon pickups are available in floating boxes - Find them and walk over them!]],
                Color( 200,200,200 ),
                Vector(16, 0)
            },
            {
                "TIPS:",
                Color( 255,255,255 ),
                Vector(8, 8)
            },
            {
                [[- Run over the floating crates to get ammunition or guns.
- Shooting enemy walls enough will cause them to unfreeze and fall, and eventually be destroyed.
- It is better to make a fort from lots of small props than few big props, as big props have less health.
- Standing very close to turrets (or on top!) makes them unable to hit you.
- Shoot SMG grenades into confined spaces.
- You have a gravity gun, use it!
- If you're given a turret, you are lucky! Think carefully about where you place it.]],
                Color( 200,200,200 ),
                Vector(16, 0)
            }
        })

    local teams = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "Teams", teams, "icon16/report_user.png" )
        
    GenerateTeamPanel(teams, 1)
    GenerateTeamPanel(teams, 2)

    local credits = vgui.Create( "DPanel", sheet )
    credits.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 32, 32, 43 ) ) end
    sheet:AddSheet( "Credits", credits, "icon16/award_star_gold_1.png" )

    local mapname = GetGlobalString("mapname")
    local author = GetGlobalString("mapauthor")
    if mapname == "" then mapname = game.GetMap() end
    if author == "" then author = "Unknown" end

    GenerateInfoPanel(credits, {
    {
        "About FortWars",
        Color( 255,255,255 ),
        Vector(8, 8)
    },
    {
        [[This gamemode was originally made by Catdaemon for a version of gmod which did not have Lua. It was then
made for a version of gmod which did have Lua, which then broke when the Lua was updated.
I then ported it to this version of Gmod Lua, which you are now playing!
This new gamemode still contains portions of that code that I liked before, but has mostly been rewritten.
Some portions like the head bob and ricochet effects are stolen from a very old gamemode called GMDM which came
with Gmod a long time ago.]],
        Color( 200,200,200 ),
        Vector(16,0)
    },
    {
        "Contributors",
        Color( 255,255,255 ),
        Vector(8, 8)
    },
    {
        [[ndo360 - Emailed me about the old gamemode, prompting me to make this one!]],
        Color( 200,200,200 ),
        Vector(16, 0)
    },
    {
        [[r0wan - Making the first map, fwc_?? and general help with debugging and ideas.]],
        Color( 200,200,200 ),
        Vector(16, 0)
    },
    {
        "About This Map",
        Color( 255,255,255 ),
        Vector(8, 8)
    },
    {
        "You are currently playing on "..mapname.." by "..author.."!",
        Color( 200,200,200 ),
        Vector(16, 0)
    }
    })

    local x,y = frame:GetPos()
    local topper = vgui.Create("DImage", bg)
    topper:SetSize(600,102)
    topper:SetPos(x, y-102)
    topper:SetImage("vgui/fw/infotopper.png")

end


function GM:ShowTeam()
    return
end