/*-------------------------------------------------------------------------------------------------------------------------
	Give weapon
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Give"
PLUGIN.Description = "Give a player a weapon"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "give"
PLUGIN.Usage = "<player> <weapon>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't give a player with a higher rank a weapon!"
			end
			
			// Weapon specified?
			if !args[2] then
				return false, "No weapon specified!"
			end
			
			// Try to give the weapon
			pl:SetNWString( "EV_AllowedWeapon", args[2] )
			pl:Give( args[2] )
			
			// Check if the specified weapon is valid
			if pl:GetWeapon(args[2]) != NULL then
				return true, ply:Nick() .. " has given " .. pl:Nick() .. " a " .. args[2] .. "."
			else
				return false, "Unknown weapon specified!"
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )