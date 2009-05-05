/*-------------------------------------------------------------------------------------------------------------------------
	Kick
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Kick"
PLUGIN.Description = "Kick players with an optional reason"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "kick"
PLUGIN.Usage = "<player> [reason]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't kick a player with an equal or higher rank!"
			end
			
			// Get the optional reason or choose the default N/A
			local Reason = "N/A"
			if #args > 1 then
				Reason = table.concat( args, " ", 2 )
			end
			
			pl:Kick( Reason )
			return true, ply:Nick() .. " has kicked " .. pl:Nick() .. ". (" .. Reason .. ")"
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )