/*-------------------------------------------------------------------------------------------------------------------------
	Ghosting
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Ghosting"
PLUGIN.Description = "Enable and disable ghosting for players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "ghost"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to ghost
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to ghost this player?
			if !ply:SameOrBetterThan( pl ) then
				return false, "You can't ghost a player with a higher rank!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl:GetNWBool( "EV_Ghosted", false )
			else
				enabled = tonumber(args[2]) > 0
			end
			
			pl:SetNWBool( "EV_Ghosted", enabled )
			if enabled then
				// Make player invisible
				pl:SetRenderMode( RENDERMODE_NONE )
				pl:SetColor( 255, 255, 255, 0 )
				pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				
				// And their weapons
				for _, w in pairs(pl:GetWeapons()) do
					w:SetRenderMode( RENDERMODE_NONE )
					w:SetColor( 255, 255, 255, 0 )
				end
				
				return true, ply:Nick() .. " has ghosted " .. pl:Nick() .. "."
			else
				// Make the player visible
				pl:SetRenderMode( RENDERMODE_NORMAL )
				pl:SetColor( 255, 255, 255, 255 )
				pl:SetCollisionGroup( COLLISION_GROUP_PLAYER )
				
				// And their weapons
				for _, w in pairs(pl:GetWeapons()) do
					w:SetRenderMode( RENDERMODE_NORMAL )
					w:SetColor( 255, 255, 255, 255 )
				end
				
				return true, ply:Nick() .. " has unghosted " .. pl:Nick() .. "."
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

// Make guns that are picked up invisible too
function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if ply:GetNWBool( "EV_Ghosted", false ) then
		wep:SetRenderMode( RENDERMODE_NONE )
		wep:SetColor( 255, 255, 255, 0 )
	end
end

Evolve:RegisterPlugin( PLUGIN )