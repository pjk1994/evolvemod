/*-------------------------------------------------------------------------------------------------------------------------
	Bring
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Bring"
PLUGIN.Description = "Bring a player to you"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "bring"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't bring a player with an equal or higher rank!"
			end
			
			pl:SetPos( ply:GetPos() + Vector( 0, 0, 128 ) )
			return true, ply:Nick() .. " has brought " .. pl:Nick() .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )