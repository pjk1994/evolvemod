/*-------------------------------------------------------------------------------------------------------------------------
	Clean up the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Cleanup"
PLUGIN.Description = "Clean up the map."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "cleanup"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has cleaned up the map." )
		game.CleanUpMap( )
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )