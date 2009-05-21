/*-------------------------------------------------------------------------------------------------------------------------
	Slaying
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Slay"
PLUGIN.Description = "Slay players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "slay"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't slay a player with a higher rank!"
			end
			
			pl:Kill()
			return true, ply:Nick() .. " slayed " .. pl:Nick() .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )