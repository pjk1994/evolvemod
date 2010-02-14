/*-------------------------------------------------------------------------------------------------------------------------
	Imitate a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Imitate"
PLUGIN.Description = "Imitate a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "im"
PLUGIN.Usage = "<player> <message>"
PLUGIN.Privileges = { "Imitate" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Imitate" ) ) then	
		local players = evolve:FindPlayer( args[1] )
		local msg = table.concat( args, " ", 2 )
		
		if ( #players == 1 ) then
			if ( #msg > 0 ) then
				evolve:Notify( team.GetColor( players[1]:Team() ), players[1]:Nick(), evolve.colors.white, ": " .. msg )
			else
				evolve:Notify( ply, evolve.colors.red, "No message specified." )
			end
		elseif ( #players > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?" )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching player found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )