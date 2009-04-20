/*-------------------------------------------------------------------------------------------------------------------------
	Freezing
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Freeze"
PLUGIN.Description = "Freeze and unfreeze a player"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "freeze"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't freeze a player with an equal or higher rank!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl:GetNWBool( "EV_Frozen", false )
			else
				enabled = tonumber(args[2]) > 0
			end
			
			pl:SetNWBool( "EV_Frozen", enabled )
			if enabled then
				pl:Freeze( true )
				return true, ply:Nick() .. " has frozen " .. pl:Nick()
			else
				pl:Freeze( false )
				return true, ply:Nick() .. " has unfrozen " .. pl:Nick()
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ply:GetNWBool("EV_Godded", false) then
		ply:GodEnable()
	end
end

Evolve:RegisterPlugin( PLUGIN )