/*-------------------------------------------------------------------------------------------------------------------------
	Ban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ban"
PLUGIN.Description = "Ban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ban"
PLUGIN.Usage = "<player> <time> [reason]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pl = evolve:findPlayer( args )
		
		if ( #pl > 1 ) then
			evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local time = args[2]
			local reason = table.concat( args, " ", 3 )
			if ( #reason == 0 ) then reason = "No reason specified." end
			
			if ( tonumber( time ) ) then
				if ( time == "0" ) then
					evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has permabanned ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, "." )
					pl[1]:Ban( time, "Permabanned! (" .. reason .. ")" )
					pl[1]:Kick( "Permabanned! (" .. reason .. ")" )
				else
					evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has banned ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, " for " .. time .. " minutes." )
					pl[1]:Ban( time, "Banned for " .. time .. " minutes! (" .. reason .. ")" )
					pl[1]:Kick( "Banned for " .. time .. " minutes! (" .. reason .. ")" )
				end
			else
				evolve:notify( ply, evolve.colors.red, "No valid time specified!" )
			end
		else
			evolve:notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )