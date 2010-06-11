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
		local pl
		if ( string.match( args[1], "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
			local uid = evolve:UniqueIDByProperty( "SteamID", args[1] )
			if ( uid ) then
				local p = player.GetByUniqueID( uid )
				if ( p ) then
					pl = { { UniqueID = p:UniqueID(), Nick = p:Nick(), Rank = p:EV_GetRank(), Ply = p } }
				else
					pl = { { UniqueID = uid, Nick = evolve:GetProperty( uid, "Nick" ), Rank = evolve:GetProperty( uid, "Rank" ) } }
				end
			end
		else
			pl = {}
			for _, p in ipairs( evolve:FindPlayer( args[1], ply ) ) do
				table.insert( pl, { UniqueID = p:UniqueID(), Nick = p:Nick(), Rank = p:EV_GetRank(), Ply = p } )
			end
		end
		
		if ( #pl <= 1 ) then
			pl = pl[1]
			
			if ( pl ) then
				if ( #args <= 1 ) then
					evolve:Notify( ply, evolve.colors.blue, pl.Nick, evolve.colors.white, " is ranked as ", evolve.colors.red, pl.Rank, evolve.colors.white, "." )
				else					
					if ( evolve.ranks[ args[2] ] ) then
						if ( pl.Ply ) then
							pl.Ply:EV_SetRank( args[2] )
						else
							evolve:SetProperty( pl.UniqueID, "Rank", args[2] )
							evolve:CommitProperties()
						end
						
						evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the rank of ", evolve.colors.red, pl.Nick, evolve.colors.white, " to " .. evolve.ranks[ args[2] ].Title .. "." )
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