/*-------------------------------------------------------------------------------------------------------------------------
	Gag a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Gag"
PLUGIN.Description = "Gag a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "gag"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			pl.EV_Gagged = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has gagged ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has ungagged ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSay( ply, msg )
	if ( ply.EV_Gagged and string.Left( msg, 1 ) != "!" ) then return "" end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "gag", unpack( players ) )
	else
		return "Gag", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )