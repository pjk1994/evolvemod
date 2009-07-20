/*-------------------------------------------------------------------------------------------------------------------------
	Ranking
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ranking"
PLUGIN.Description = "Promote and demote people."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "rank"
PLUGIN.Usage = "<player> [rank]"

function PLUGIN:getRealName( rankname )
	if ( rankname == "owner" ) then
		return "Owner"
	elseif ( rankname == "superadmin" ) then
		return "Super Admin"
	elseif ( rankname == "admin" ) then
		return "Admin"
	elseif ( rankname == "respected" ) then
		return "Respected"
	else
		return "Guest"
	end
end

function PLUGIN:Call( ply, args )
	if ( #args <= 1 ) then
		local pl = evolve:findPlayer( args[1], ply )
		if ( #pl <= 1 ) then
			pl = pl[1]
			if ( pl ) then
				local rank = self:getRealName( pl:EV_GetRank( ) )
				evolve:notify( ply, evolve.colors.blue, pl:Nick( ), evolve.colors.white, " is ranked ", evolve.colors.red, rank, evolve.colors.white, "." )
			else
				evolve:notify( ply, evolve.colors.red, "No matching player found." )
			end
		else
			evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerSpawn( ply )
	if ( !ply.EV_Ranked ) then
		ply:SetNWString( "EV_UserGroup", ply:GetNWString( "UserGroup", "guest" ) )
		ply.EV_Ranked = true
	end
end

evolve:registerPlugin( PLUGIN )