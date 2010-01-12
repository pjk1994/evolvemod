/*-------------------------------------------------------------------------------------------------------------------------
	Imitate a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Imitate"
PLUGIN.Description = "Imitate a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "im"
PLUGIN.Usage = "<player> <message>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then	
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl < 2 or !pl[1] ) then			
			if ( #pl > 0 ) then
				local msg = table.concat( args, " ", 2 )
				
				if ( #msg > 0 ) then
					evolve:Notify( team.GetColor( pl[1]:Team() ), pl[1]:Nick(), evolve.colors.white, ": " .. msg )
				else
					evolve:Notify( ply, evolve.colors.red, "No message specified." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "No matching player found." )
			end
		else
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )