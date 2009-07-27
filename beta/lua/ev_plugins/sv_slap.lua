/*-------------------------------------------------------------------------------------------------------------------------
	Slap a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Slap"
PLUGIN.Description = "Slap a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "slap"
PLUGIN.Usage = "[players] [damage]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply, true )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local dmg = 10
		if ( tonumber( args[ #args ] ) ) then dmg = tonumber( args[ #args ] ) end
		
		for _, pl in pairs( pls ) do
			pl:SetHealth( pl:Health( ) - dmg )
			pl:ViewPunch( Angle( -10, 0, 0 ) )
			
			if ( pl:Health( ) < 1 ) then pl:Kill( ) end
		end
		
		if ( #pls > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has slapped ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " with " .. dmg .. " damage." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )