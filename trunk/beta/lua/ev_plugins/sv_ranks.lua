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
		return "Owner", "an"
	elseif ( rankname == "superadmin" ) then
		return "Super Admin", "a"
	elseif ( rankname == "admin" ) then
		return "Admin", "an"
	elseif ( rankname == "respected" ) then
		return "Respected", "a"
	elseif ( rankname == "guest" ) then
		return "Guest", "a"
	else
		return "invalid"
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

function PLUGIN:load( )
	if ( file.Exists( "ev_ranks.txt" ) ) then
		self.playerRanks = glon.decode( file.Read( "ev_ranks.txt" ) )
	else
		self.playerRanks = { }
	end
end

function PLUGIN:save( )
	file.Write( "ev_ranks.txt", glon.encode( self.playerRanks ) )
end

function PLUGIN:rank( ply )
	if ( !self.playerRanks ) then self:load( ) end
	
	for _, rank in pairs( self.playerRanks ) do
		if ( rank.steamID == ply:SteamID( ) ) then
			self:setRank( ply, rank.rank )
			
			return
		end
	end
	
	ply:SetNWString( "EV_UserGroup", ply:GetNWString( "UserGroup", "guest" ) )
	self:rankGroup( ply )
end

function PLUGIN:setRank( ply, newrank )
	for _, rank in pairs( self.playerRanks ) do
		if ( rank.steamID == ply:SteamID( ) ) then
			rank.rank = newrank
			self:save( )
			
			ply:SetNWString( "EV_UserGroup", rank.rank )
			self:rankGroup( ply )
			
			return
		end
	end
	
	local ranki = { }
	ranki.steamID = ply:SteamID( )
	ranki.rank = newrank
	table.insert( self.playerRanks, ranki )
	self:save( )
	
	ply:SetNWString( "EV_UserGroup", newrank )
	self:rankGroup( ply )
end

function PLUGIN:Call( ply, args )
	if ( #args <= 1 or ply:EV_IsOwner( ) ) then
		local pl = evolve:findPlayer( args[1], ply )
		if ( #pl <= 1 ) then
			pl = pl[1]
			if ( pl ) then
				if ( #args <= 1 ) then
					local rank, prefix = self:getRealName( pl:EV_GetRank( ) )
					evolve:notify( ply, evolve.colors.blue, pl:Nick( ), evolve.colors.white, " is ranked " .. prefix .. " ", evolve.colors.red, rank, evolve.colors.white, "." )
				else
					if ( self:getRealName( args[2] ) != "invalid" ) then
						self:setRank( pl, args[2] )
						local rank, prefix = self:getRealName( args[2] )
						evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has made ", evolve.colors.red, pl:Nick( ), evolve.colors.white, " " .. prefix .. " " .. rank .. "." )
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
		self:rank( ply )		
		ply.EV_Ranked = true
	end
end

evolve:registerPlugin( PLUGIN )