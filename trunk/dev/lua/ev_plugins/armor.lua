/*-------------------------------------------------------------------------------------------------------------------------
	Set armor
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Armor"
PLUGIN.Description = "Set the armor of players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "armor"
PLUGIN.Usage = "<player> [armor]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't set the armor of a player with an equal or higher rank!"
			end
			
			// Is the health a number or nothing?
			local HP = 100
			if args[2] and tonumber(args[2]) then
				HP = tonumber( args[2] )
			elseif args[2] then
				return false, "The armor must be numeric!"
			end
			
			ply:SetArmor( HP )
			
			return true, ply:Nick() .. " has set " .. pl:Nick() .. "'s armor to " .. HP
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )