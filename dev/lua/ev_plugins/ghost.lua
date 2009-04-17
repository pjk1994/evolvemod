/*-------------------------------------------------------------------------------------------------------------------------
	Ghosting
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Ghosting"
PLUGIN.Description = "Enable and disable ghosting for players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "ghost"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to ghost
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to ghost this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't ghost a player with an equal or higher rank!"
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
				pl:SetRenderMode( RENDERMODE_NONE )
				pl:SetColor( 255, 255, 255, 0 )
				
				return true, ply:Nick() .. " has ghosted " .. pl:Nick()
			else
				pl:SetRenderMode( RENDERMODE_NORMAL )
				pl:SetColor( 255, 255, 255, 255 )
				
				return true, ply:Nick() .. " has unghosted " .. pl:Nick()
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

function PLUGIN:Think()
	for _, v in pairs(player.GetAll()) do
		if v:GetNWBool("EV_Ghosted", false) then
			v:GetActiveWeapon():SetRenderMode( RENDERMODE_NONE )
			v:GetActiveWeapon():SetColor( 255, 255, 255, 0 )
		else
			v:GetActiveWeapon():SetRenderMode( RENDERMODE_NORMAL )
			v:GetActiveWeapon():SetColor( 255, 255, 255, 255 )
		end
	end
end

Evolve:RegisterPlugin( PLUGIN )