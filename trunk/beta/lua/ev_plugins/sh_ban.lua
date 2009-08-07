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
			local treason = ""
			if ( #reason == 0 ) then reason = "No reason specified." else treason = " with the reason \"" .. reason .. "\"" end
			
			if ( tonumber( time ) ) then
				if ( time == "0" ) then
					evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has permabanned ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, treason .. "." )
					pl[1]:Ban( time, "Permabanned! (" .. reason .. ")" )
					pl[1]:Kick( "Permabanned! (" .. reason .. ")" )
				else
					evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has banned ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, " for " .. time .. " minutes" .. treason .. "." )
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

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "ban", players[1], arg )
	else
		return "Ban", evolve.category.administration, { { "5 minutes", "5" }, { "10 minutes", "10" }, { "15 minutes", "15" }, { "30 minutes", "30" }, { "1 hour", "60" }, { "2 hours", "120" }, { "4 hours", "240" }, { "12 hours", "720" }, { "One day", "1440" }, { "Two days", "2880" }, { "One week", "10080" }, { "Two weeks", "20160" }, { "One month", "43200" }, { "One year", "525600" }, { "Permanently", "0" } }
	end
end

evolve:registerPlugin( PLUGIN )