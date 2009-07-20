/*-------------------------------------------------------------------------------------------------------------------------
	Kick a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Kick"
PLUGIN.Description = "Kick a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "kick"
PLUGIN.Usage = "<player> [reason]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pl = evolve:findPlayer( args )
		
		if ( #pl > 1 ) then
			evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local reason = table.concat( args, " ", 2 )
			
			if ( #reason == 0 ) then
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has kicked ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, "." )
				pl[1]:Kick( "No reason specified." )
			else
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has kicked ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, " with the reason \"" .. reason .."\"." )
				pl[1]:Kick( reason )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )