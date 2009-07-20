/*-------------------------------------------------------------------------------------------------------------------------
	Enable unlimited ammo for a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Unlimited ammo"
PLUGIN.Description = "Enable unlimited ammo for a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "uammo"
PLUGIN.Usage = "[players] [1/0]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( evolve:filterNumber( args ), ply )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local enabled = true
		if ( tonumber( args[ #args ] ) ) then enabled = tonumber( args[ #args ] ) > 0 end
		
		for _, pl in pairs( pls ) do
			pl.EV_UnlimitedAmmo = enabled
		end
		
		if ( #pls > 0 ) then
			if ( enabled ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has enabled unlimited ammo for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has disabled unlimited ammo for ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Tick( )
	for _, ply in pairs( player.GetAll( ) ) do
		if ( ply.EV_UnlimitedAmmo and ply:Alive( ) and ply:GetActiveWeapon( ) != NULL ) then
			local wep = ply:GetActiveWeapon( )
			if wep:Clip1( ) < 255 then wep:SetClip1( 250 ) end
			if wep:Clip2( ) < 255 then wep:SetClip2( 250 ) end
			
			if wep:GetPrimaryAmmoType( ) == 10 or wep:GetPrimaryAmmoType( ) == 8 then
				ply:GiveAmmo( 9 - ply:GetAmmoCount( wep:GetPrimaryAmmoType( ) ), wep:GetPrimaryAmmoType( ) )
			elseif wep:GetSecondaryAmmoType() == 9 or wep:GetSecondaryAmmoType( ) == 2 then
				ply:GiveAmmo( 9 - ply:GetAmmoCount( wep:GetSecondaryAmmoType( ) ), wep:GetSecondaryAmmoType( ) )
			end
		end
	end
end

evolve:registerPlugin( PLUGIN )