/*-------------------------------------------------------------------------------------------------------------------------
	Display a public message as an admin
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Public Admin Message"
PLUGIN.Description = "Display a message to all online players as an admin."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "pa"
PLUGIN.Usage = "<message>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local msg = table.concat( args, " " )
		evolve:notify( pl, evolve.colors.red, "(ADMIN)", evolve.colors.white, " " .. msg )
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )