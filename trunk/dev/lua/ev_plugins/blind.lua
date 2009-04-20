/*-------------------------------------------------------------------------------------------------------------------------
	Blinding
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Blinding"
PLUGIN.Description = "Blind and unblind players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "blind"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to ghost
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to ghost this player?
			if Evolve:SameOrBetter(ply, pl) then
				return false, "You can't blind a player with an equal or higher rank!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl:GetNWBool( "EV_Blinded", false )
			else
				enabled = tonumber(args[2]) > 0
			end
			
			pl:SetNWBool( "EV_Blinded", enabled )
			if enabled then				
				return true, ply:Nick() .. " has blinded " .. pl:Nick()
			else
				return true, ply:Nick() .. " has unblinded " .. pl:Nick()
			end
		else
			return false, "Player not found!"
		end
		
	else
		return false, "You are not an administrator!"
	end
end

// Blind people clientside
function PLUGIN:HUDPaint()
	if LocalPlayer():GetNWBool( "EV_Blinded", false ) then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end
end

Evolve:RegisterPlugin( PLUGIN )