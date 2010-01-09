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
	if ( ply:EV_IsAdmin() ) then
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has cleaned up the map." )
		game.CleanUpMap()
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )