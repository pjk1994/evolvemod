/*-------------------------------------------------------------------------------------------------------------------------
	Kill a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Slay"
PLUGIN.Description = "Kill a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "slay"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local victims = evolve:findPlayer( args, ply )
		if ( #victims > 0 and !victims[1]:IsValid( ) ) then victims = { } end
		
		for _, victim in pairs( victims ) do
			victim:Kill( )
		end
		
		if ( #victims > 0 ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has slayed ", evolve.colors.red, evolve:createPlayerList( victims ), evolve.colors.white, "." )
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )