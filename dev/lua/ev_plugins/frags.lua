/*-------------------------------------------------------------------------------------------------------------------------
	Set frags
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Frags"
PLUGIN.Description = "Set the amount of frags of players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "frags"
PLUGIN.Usage = "<player> [frags]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't set the amount of frags of a player with an equal or higher rank!"
			end
			
			// Is the health a number or nothing?
			local frags = 0
			if args[2] and tonumber(args[2]) then
				frags = tonumber( args[2] )
			elseif args[2] then
				return false, "The amount of frags must be numeric!"
			end
			
			ply:SetFrags( frags )
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s amount of frags to " .. frags
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )