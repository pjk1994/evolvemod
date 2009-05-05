/*-------------------------------------------------------------------------------------------------------------------------
	Stripping weapons
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Strip weapons"
PLUGIN.Description = "Strip the weapons of a player"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "strip"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't strip a player with an equal or higher rank!"
			end
			
			pl:StripWeapons()
			return true, ply:Nick() .. " stripped " .. pl:Nick() .. "'s weapons."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )