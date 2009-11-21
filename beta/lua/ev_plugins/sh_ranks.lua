/*-------------------------------------------------------------------------------------------------------------------------
	Ranking
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Ranking"
PLUGIN.Description = "Promote and demote people."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "rank"
PLUGIN.Usage = "<player> [rank]"

function PLUGIN:RankGroup( ply, rank )
	if ( rank == "owner" or rank == "superadmin" ) then
		ply:SetUserGroup( "superadmin" )
	elseif ( rank == "admin" ) then
		ply:SetUserGroup( "admin" )
	else
		ply:SetUserGroup( "guest" )
	end
end

function PLUGIN:Load()
	if ( file.Exists( "ev_ranks.txt" ) ) then
		self.playerRanks = glon.decode( file.Read( "ev_ranks.txt" ) )
	else
		self.playerRanks = { }
	end
end

function PLUGIN:Save()
	file.Write( "ev_ranks.txt", glon.encode( self.playerRanks ) )
end

function PLUGIN:Rank( ply )
	if ( !self.playerRanks ) then self:Load() end
	
	for _, rank in ipairs( self.playerRanks ) do
		if ( rank.steamID == ply:SteamID() ) then
			self:SetRank( ply, rank.rank )
			
			return
		end
	end
	
	local usergroup = ply:GetNWString( "UserGroup", "guest" )
	if ( usergroup == "user" ) then usergroup = "guest" end
	
	ply:SetNWString( "EV_UserGroup", usergroup )
	self:RankGroup( ply, usergroup )
	
	hook.Call( "EV_PlayerRankChanged", GAMEMODE, ply )
end

function PLUGIN:SetRank( ply, newrank )
	for _, rank in ipairs( self.playerRanks ) do
		if ( rank.steamID == ply:SteamID() ) then
			rank.rank = newrank
			self:Save()
			
			ply:SetNWString( "EV_UserGroup", rank.rank )
			self:RankGroup( ply, rank.rank )
			
			hook.Call( "EV_PlayerRankChanged", GAMEMODE, ply )
			
			return
		end
	end
	
	local ranki = { }
	ranki.steamID = ply:SteamID()
	ranki.rank = newrank
	table.insert( self.playerRanks, ranki )
	self:Save()
	
	ply:SetNWString( "EV_UserGroup", newrank )
	self:RankGroup( ply, newrank )
	
	hook.Call( "EV_PlayerRankChanged", GAMEMODE, ply )
end

function PLUGIN:Call( ply, args )
	if ( #args <= 1 or ply:EV_IsSuperAdmin() ) then
		local pl = evolve:FindPlayer( args[1], ply )
		if ( #pl <= 1 ) then
			pl = pl[1]
			if ( pl ) then
				if ( #args <= 1 ) then
					local rank, prefix = evolve:GetRankName( pl:EV_GetRank() )
					evolve:Notify( ply, evolve.colors.blue, pl:Nick(), evolve.colors.white, " is ranked as " .. prefix .. " ", evolve.colors.red, rank, evolve.colors.white, "." )
				else
					local realName = evolve:GetRankName( args[2] )
					
					if ( realName != "invalid" ) then
						if ( !pl:EV_IsOwner() or ( pl:EV_IsOwner() and ( ply == NULL or ply:IsListenServerHost() ) ) ) then
							if ( ( ( realName == "Respected" or realName == "Guest" ) and !pl:EV_IsAdmin() ) or ply:EV_IsOwner() ) then
								self:SetRank( pl, args[2] )
								local rank, prefix = evolve:GetRankName( args[2] )
								evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has made ", evolve.colors.red, pl:Nick(), evolve.colors.white, " " .. prefix .. " " .. rank .. "." )
							else
								evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
							end
						else
							evolve:Notify( ply, evolve.colors.red, "An owner can only be ranked by the server console." )
						end
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

function PLUGIN:PlayerSpawn( ply )
	if ( !ply.EV_Ranked ) then
		self:Rank( ply )		
		ply.EV_Ranked = true
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