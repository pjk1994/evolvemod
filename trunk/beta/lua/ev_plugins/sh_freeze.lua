/*-------------------------------------------------------------------------------------------------------------------------
	Freeze a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Freeze"
PLUGIN.Description = "Freeze a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "freeze"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			pl:SetNWBool( "EV_Frozen", enabled )
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has frozen ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has unfrozen ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Move( ply, data )
	return ply:GetNWBool( "EV_Frozen", false )
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "freeze", unpack( players ) )
	else
		return "Freeze", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )