/*-------------------------------------------------------------------------------------------------------------------------
	Imitation
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Group"
PLUGIN.Description = "Set the usergroup of someone"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "group"
PLUGIN.Usage = "<player> <groupname>"

function PLUGIN:Call( ply, args )
	// First check if the caller is a superadmin
	if ply:IsSuperAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if !ply:BetterThan( pl ) then
				return false, "You can't group a player with an equal or higher rank!"
			end
			
			// Get the group name
			local Group = ""
			if #args > 1 then
				Group = table.concat( args, " ", 2 )
			else
				return false, "No group specified!"
			end
			
			pl:SetUserGroup( Group )
			
			local DisplayGroup = string.upper( string.Left( Group, 1 ) ) .. string.lower( string.sub( Group, 2 ) )
			local firstChar = string.lower( string.Left( DisplayGroup, 1 ) )
			
			if firstChar == "a" or firstChar == "e" or firstChar == "i" or firstChar == "u" or firstChar == "h" or firstChar == "y" or firstChar == "o" then
				DisplayGroup = "an " .. DisplayGroup
			else
				DisplayGroup = "a " .. DisplayGroup
			end
			
			return true, ply:Nick() .. " has made " .. pl:Nick() .. " " .. DisplayGroup .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not a super administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )