/*-------------------------------------------------------------------------------------------------------------------------
	Godmode
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Godmode"
PLUGIN.Description = "Enable and disable godmode for players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "god"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to god
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to god this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't god a player with an equal or higher rank!"
			end
			
			// Is the 'enabled' value a number?
			if !tonumber(args[2]) then
				return false, "Parameter #2 must be a number!"
			end
			
			if tonumber(args[2]) > 0 then
				pl:GodEnable()
				pl:SetNWBool( "Godded", true )
				return true, ply:Nick() .. " has godded " .. pl:Nick()
			else
				pl:GodDisable()
				pl:SetNWBool( "Godded", false )
				return true, ply:Nick() .. " has ungodded " .. pl:Nick()
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ply:GetNWBool("Godded", false) then
		ply:GodEnable()
	end
end

Evolve:RegisterPlugin( PLUGIN )