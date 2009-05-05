/*-------------------------------------------------------------------------------------------------------------------------
	Clean up the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Cleanup Map"
PLUGIN.Description = "Clean up the current map"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "cleanup"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
		game.CleanUpMap()
		return true, ply:Nick() .. " has cleaned up the map."
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )