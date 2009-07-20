/*-------------------------------------------------------------------------------------------------------------------------
	/me command
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Me"
PLUGIN.Description = "Represent an action."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "me"
PLUGIN.Usage = "<action>"

function PLUGIN:Call( ply, args )
	local action = table.concat( args, " " )
	
	if ( #action > 0 ) then
		evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " " .. tostring( action ) )
	else
		evolve:notify( ply, evolve.colors.red, "No action specified." )
	end
end

evolve:registerPlugin( PLUGIN )