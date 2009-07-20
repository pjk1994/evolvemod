/*-------------------------------------------------------------------------------------------------------------------------
	Reload the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Reload"
PLUGIN.Description = "Reload the map."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "reload"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has reloaded the map." )
		RunConsoleCommand( "changelevel", game.GetMap( ) )
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )