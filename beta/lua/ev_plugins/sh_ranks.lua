/*-------------------------------------------------------------------------------------------------------------------------
	Ranking
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ranking"
PLUGIN.Description = "Promote and demote people."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "rank"
PLUGIN.Usage = "<player> [rank]"
PLUGIN.Privileges = { "Ranking" }

function PLUGIN:Call( ply, args )
	if ( #args <= 1 or ply:EV_HasPrivilege( "Ranking" ) ) then
		local pl = evolve:FindPlayer( args[1], ply )
		if ( #pl <= 1 ) then
			pl = pl[1]
			if ( pl ) then
				if ( #args <= 1 ) then
					local rank = evolve.ranks[ pl:EV_GetRank() ].Title
					evolve:Notify( ply, evolve.colors.blue, pl:Nick(), evolve.colors.white, " is ranked as ", evolve.colors.red, rank, evolve.colors.white, "." )
				else					
					if ( evolve.ranks[ args[2] ] ) then
						pl:EV_SetRank( args[2] )
						evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the rank of ", evolve.colors.red, pl:Nick(), evolve.colors.white, " to " .. evolve.ranks[ args[2] ].Title .. "." )
					else
						evolve:Notify( ply, evolve.colors.red, "Unknown rank specified." )
					end
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

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "rank", players[1], arg )
	else
		return "Rank", evolve.category.administration, {
			{ "Owner", "owner" },
			{ "Super Admin", "superadmin" },
			{ "Admin", "admin" },
			{ "Respected", "respected" },
			{ "Guest", "guest" }
		}
	end
end

evolve:RegisterPlugin( PLUGIN )