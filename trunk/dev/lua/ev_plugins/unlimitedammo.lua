/*-------------------------------------------------------------------------------------------------------------------------
	Unlimited ammo
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Unlimited ammo"
PLUGIN.Description = "Enable and disable unlimited ammo for players"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "ammo"
PLUGIN.Usage = "<player> [1/0]"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsAdmin() then
	
		// Find the player to set unlimited ammo for
		local pl = Evolve:FindPlayer( args[1] )
		
		if pl then
			// Is the caller allowed to set unlimited ammo for this player?
			if !ply:BetterThan( pl ) then
				return false, "You can't give a player with a higher rank unlimited ammo!"
			end
			
			// Is the 'enabled' value a number? Otherwise toggle!
			local enabled = args[2]
			if !tonumber(args[2]) and args[2] then
				return false, "Parameter #2 must be a number!"
			elseif !args[2] then
				enabled = !pl:GetNWBool( "EV_Ammo", false )
			else
				enabled = tonumber(args[2]) > 0
			end
			
			pl:SetNWBool( "EV_Ammo", enabled )
			if enabled then
				return true, ply:Nick() .. " has given " .. pl:Nick() .. " unlimited ammo."
			else
				return true, ply:Nick() .. " has taken away " .. pl:Nick() .. "'s unlimited ammo."
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
		if v:GetNWBool( "EV_Ammo", false ) then
			local wep = v:GetActiveWeapon()
			if wep:Clip1() < 255 then wep:SetClip1( 250 ) end
			if wep:Clip2() < 255 then wep:SetClip2( 250 ) end
			
			// Handle secondary ammo
			if wep:GetPrimaryAmmoType() == 10 or wep:GetPrimaryAmmoType() == 8 then
				v:GiveAmmo( 250 - v:GetAmmoCount( wep:GetPrimaryAmmoType() ), wep:GetPrimaryAmmoType() )
			elseif wep:GetSecondaryAmmoType() == 9 or wep:GetSecondaryAmmoType() == 2 then
				v:GiveAmmo( 250 - v:GetAmmoCount( wep:GetSecondaryAmmoType() ), wep:GetSecondaryAmmoType() )
			end
		end
	end
end

Evolve:RegisterPlugin( PLUGIN )