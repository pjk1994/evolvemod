/*-------------------------------------------------------------------------------------------------------------------------
	Ragdolling
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Ragdolling"
PLUGIN.Description = "Turn players into ragdolls or revive them."
PLUGIN.Author = "Overv"
PLUGIN.Chat = "ragdoll"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to ragdoll
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to ragdoll this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't ragdoll a player with a higher rank!"
			end
			
			// Toggle enabled
			local enabled = args[2]
			enabled = !pl:GetNWBool( "EV_Ragdolled", false )
			
			pl:SetNWBool( "EV_Ragdolled", enabled )
			if enabled then
				// Make player invisible
				pl:DrawViewModel( false )
				pl:Freeze( true )
				pl:StripWeapons( )
				
				// Spawn ragdoll entity
				local doll = ents.Create( "prop_ragdoll" )
				doll:SetModel( pl:GetModel( ) )
				doll:SetPos( pl:GetPos( ) )
				doll:SetAngles( pl:GetAngles( ) )
				doll:Spawn( )
				doll:Activate( )
				
				pl.EV_Ragdoll = doll
				pl:Spectate( OBS_MODE_CHASE )
				pl:SpectateEntity( pl.EV_Ragdoll )
				pl:SetParent( pl.EV_Ragdoll )
				
				return true, ply:Nick() .. " has ragdolled " .. pl:Nick() .. "."
			else
				// Resetting the player and ragdoll entity will be taken care of in the PlayerSpawn hook
				if !pl.EV_Ragdoll then
					// The ragdoll got bugged, someone removed it or something
					pl.EV_Ragdoll = "Bugged"
				end
				
				pl:SetNoTarget( false )
				pl:SetParent( )
				pl:Freeze( false )
				pl:Spawn( )
				
				return true, ply:Nick() .. " has unragdolled " .. pl:Nick() .. "."
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:PlayerDisconnect( ply )
	if ply.EV_Ragdoll then ply.EV_Ragdoll:Remove( ) end
end

function PLUGIN:PlayerDeath( ply )
	ply:SetNWBool( "EV_Ragdolled", false )
end

function PLUGIN:PlayerSpawn( ply )
	if !ply:GetNWBool( "EV_Ragdolled", false ) and ply.EV_Ragdoll then
		ply:SetPos( ply.EV_Ragdoll:GetPos( ) + Vector( 0, 0, 10 ) )
		
		ply.EV_Ragdoll:Remove( )
		ply.EV_Ragdoll = nil
	end
end

Evolve:RegisterPlugin( PLUGIN )