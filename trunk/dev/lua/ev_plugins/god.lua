/*-------------------------------------------------------------------------------------------------------------------------
	Godmode
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Godmode"
PLUGIN.Description = "Enable and disable godmode for players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "god"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't god a player with a higher rank!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl.EV_Godded
			else
				enabled = tonumber(args[2]) > 0
			end
			
			pl.EV_Godded = enabled
			if enabled then
				pl:GodEnable()
				return true, ply:Nick() .. " has godded " .. pl:Nick() .. "."
			else
				pl:GodDisable()
				return true, ply:Nick() .. " has ungodded " .. pl:Nick() .. "."
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ply.EV_Godded then
		ply:GodEnable()
	end
end

Evolve:RegisterPlugin( PLUGIN )