/*-------------------------------------------------------------------------------------------------------------------------
	Go to a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Goto"
PLUGIN.Description = "Teleport to a player"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "goto"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to go to this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't go to a player with a higher rank!"
			end
			
			ply:SetPos( pl:GetPos() + Vector( 0, 0, 128 ) )
			return true, ply:Nick() .. " has gone to " .. pl:Nick() .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )