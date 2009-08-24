/*-------------------------------------------------------------------------------------------------------------------------
	Send a private message to someone
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "PM"
PLUGIN.Description = "Send someone a private message."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "pm"
PLUGIN.Usage = "<player> <message>"

function PLUGIN:Call( ply, args )
	local pl = evolve:findPlayer( args[1] )
	
	if ( #pl < 2 or !pl[1] ) then			
		if ( #pl > 0 ) then
			local msg = table.concat( args, " ", 2 )
			
			if ( #msg > 0 ) then
				evolve:notify( ply, evolve.colors.white, "To ", team.GetColor( pl[1]:Team( ) ), pl[1]:Nick( ), evolve.colors.white, ": " .. msg )
				evolve:notify( pl[1], evolve.colors.white, "From ", team.GetColor( pl[1]:Team( ) ), ply:Nick( ), evolve.colors.white, ": " .. msg )
			else
				evolve:notify( ply, evolve.colors.red, "No message specified." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching player found." )
		end
	else
		evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
	end
end

evolve:registerPlugin( PLUGIN )