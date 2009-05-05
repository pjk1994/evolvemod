/*-------------------------------------------------------------------------------------------------------------------------
	Remove only the decals
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Decal Cleanup"
PLUGIN.Description = "Clean up the decals"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "decals"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
		for _, v in pairs(player.GetAll()) do
			v:ConCommand( "r_cleardecals\n" )
		end
		
		return true, ply:Nick() .. " has cleaned up the decals."
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )