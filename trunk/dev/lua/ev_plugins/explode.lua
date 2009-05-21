/*-------------------------------------------------------------------------------------------------------------------------
	Slaying
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Explode"
PLUGIN.Description = "Explode players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "explode"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to slay
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to slay this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't explode a player with a higher rank!"
			end
			
			local explosive = ents.Create( "env_explosion" )
			explosive:SetPos( pl:GetPos() )
			explosive:SetOwner( pl )
			explosive:Spawn()
			explosive:SetKeyValue( "iMagnitude", "1" )
			explosive:Fire( "Explode", 0, 0 )
			explosive:EmitSound( "ambient/explosions/explode_4.wav", 500, 500 )
			
			pl:Kill()
			pl:AddFrags( 1 )
			
			return true, ply:Nick() .. " exploded " .. pl:Nick() .. "."
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

Evolve:RegisterPlugin( PLUGIN )