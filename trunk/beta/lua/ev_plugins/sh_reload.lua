/*-------------------------------------------------------------------------------------------------------------------------
	Reload the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Reload"
PLUGIN.Description = "Reload the map."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "reload"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has reloaded the map." )
		RunConsoleCommand( "changegamemode", game.GetMap(), GAMEMODE.FolderName )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )