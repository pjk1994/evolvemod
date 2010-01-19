/*-------------------------------------------------------------------------------------------------------------------------
	Run a console command on the server
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "RCON"
PLUGIN.Description = "Run a console command on the server."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "rcon"
PLUGIN.Usage = "<command> [arg1] [arg2] ..."

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsOwner() ) then		
		if ( #args > 0 ) then
			RunConsoleCommand( unpack( args ) )
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " executed ", evolve.colors.red, table.concat( args, " " ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No command specified." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )