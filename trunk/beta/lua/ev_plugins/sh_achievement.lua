/*-------------------------------------------------------------------------------------------------------------------------
	Fake an achievement
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Achievement"
PLUGIN.Description = "Fake someone earning an achievement."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ach"
PLUGIN.Usage = "<player> <achievement>"
PLUGIN.Privileges = { "Achievement" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Achievement" ) ) then
		local players = evolve:FindPlayer( args[1] )
		
		if ( #players < 2 or !players[1] ) then			
			if ( #players > 0 ) then
				local achievement = table.concat( args, " ", 2 )
				
				if ( #achievement > 0 ) then
					evolve:Notify( team.GetColor( players[1]:Team() ), players[1]:Nick(), color_white, " earned the achievement ", Color( 255, 201, 0, 255 ), achievement )
				else
					evolve:Notify( ply, evolve.colors.red, "No achievement specified." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "No matching player found." )
			end
		else
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )