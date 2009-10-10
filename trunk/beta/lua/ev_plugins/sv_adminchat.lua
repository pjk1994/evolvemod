/*-------------------------------------------------------------------------------------------------------------------------
	Display a message to online admins
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Admin Chat"
PLUGIN.Description = "Display a message to all online admins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "a"
PLUGIN.Usage = "<message>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local msg = table.concat( args, " " )
		
		for _, pl in pairs( player.GetAll() ) do
			if ( pl:EV_IsAdmin() ) then evolve:Notify( pl, evolve.colors.red, "(To admins) ", team.GetColor( ply:Team() ), ply:Nick(), evolve.colors.white, ": " .. msg ) end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )