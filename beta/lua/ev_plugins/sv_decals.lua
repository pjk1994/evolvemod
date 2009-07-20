/*-------------------------------------------------------------------------------------------------------------------------
	Clean up the decals
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Decals"
PLUGIN.Description = "Remove all decals from the map."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "decals"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has cleaned up the decals." )
		
		for _, pl in pairs( player.GetAll( ) ) do
			pl:ConCommand( "r_cleardecals" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )