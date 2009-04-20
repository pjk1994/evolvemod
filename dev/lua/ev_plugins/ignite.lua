/*-------------------------------------------------------------------------------------------------------------------------
	Ignite
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Ignite"
PLUGIN.Description = "Ignite a player"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "ignite"
PLUGIN.Usage = "<player> [1/0] [duration]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't ignite a player with an equal or higher rank!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl:GetNWBool( "EV_Ignited", false )
			else
				enabled = tonumber(args[2]) > 0
			end
			
			local duration = 10
			if !tonumber(args[3]) and args[3] then
				return false, "The duration must be a number!"
			elseif args[3] then
				duration = tonumber(args[3])
			end
			
			pl:SetNWBool( "EV_Ignited", enabled )
			if enabled then
				pl:Ignite( duration, 0 )
				return true, ply:Nick() .. " has ignited " .. pl:Nick()
			else
				pl:Extinguish()
				return true, ply:Nick() .. " has extinguished " .. pl:Nick()
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ply:GetNWBool("EV_Ignited", false) then
		ply:Ignite()
	end
end

Evolve:RegisterPlugin( PLUGIN )