/*-------------------------------------------------------------------------------------------------------------------------
	Reload the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Reload Map"
PLUGIN.Description = "Reload the current map"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "reload"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
		RunConsoleCommand( "changelevel", game.GetMap() )
		return true, ply:Nick() .. " has reloaded the map."
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )