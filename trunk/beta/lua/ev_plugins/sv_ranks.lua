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
	elseif ( rankname == "guest" ) then
		return "Guest"
	else
		return "Invalid"
	end
end

function PLUGIN:rankGroup( ply )
	if ( ply:EV_IsOwner( ) or ply:EV_IsSuperAdmin( ) ) then
		ply:SetUserGroup( "superadmin" )
	elseif ( ply:EV_IsAdmin( ) ) then
		ply:SetUserGroup( "admin" )
	else
		ply:SetUserGroup( "guest" )
	end
end

function PLUGIN:Call( ply, args )
	if ( #args <= 1 or ply:EV_IsOwner( ) ) then
		local pl = evolve:findPlayer( args[1], ply )
		if ( #pl <= 1 ) then
			pl = pl[1]
			if ( pl ) then
				if ( #args == 1 ) then
					local rank = self:getRealName( pl:EV_GetRank( ) )
					evolve:notify( ply, evolve.colors.blue, pl:Nick( ), evolve.colors.white, " is ranked ", evolve.colors.red, rank, evolve.colors.white, "." )
				else
					if ( self:getRealName( args[2] ) != "Invalid" ) then
						pl:SetNWString( "EV_UserGroup", args[2] )
						self:rankGroup( pl )
						evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has made ", evolve.colors.red, pl:Nick( ), evolve.colors.white, " a " .. self:getRealName( args[2] ) .. "." )
					else
						evolve:notify( ply, evolve.colors.red, "Unknown rank specified." )
					end
				end
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