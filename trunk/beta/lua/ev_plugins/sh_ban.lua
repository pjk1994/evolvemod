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
	if ( ply:EV_IsSuperAdmin() ) then
		local pl = evolve:FindPlayer( args[1] )
		if ( !pl[1] and string.match( args[1] or "", "^STEAM_[0-5]:[0-9]:[0-9]+$" ) ) then
			pl[1] = args[1]
		end
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local time = tonumber( args[2] ) or 5
			local steamid = string.match( args[1], "^STEAM_[0-5]:[0-9]:[0-9]+$" )
			local reason = args[3] or ""
			local treason = ""
			if ( #reason == 0 ) then reason = "No reason specified." else treason = " with the reason \"" .. reason .. "\"" end
			
			if ( time ) then
				local it = { }
				if ( steamid ) then it.steamID = args[1] else it.steamID = pl[1]:SteamID() end
				if ( time == 0 ) then it.banEnd = 0 else it.banEnd = os.time() + tonumber( time ) * 60 end
				it.banReason = reason
				table.insert( self.bans, it )
				self:Save()
				
				for _, v in pairs( ents.GetAll() ) do
					if ( !steamid and v:GetNWString( "Owner" ) == pl[1]:Nick() ) then v:Remove() end
				end
				
				local msg = ""
				local msg2 = ""
				local nick = ""
				
				if ( time == 0 ) then
					msg = "Permabanned"
					msg2 = ""
				else
					msg = "Banned"
					msg2 = " for " .. time .. " minutes"
				end
				
				if ( evolve:Plugin( "Player Info" ):NickBySteamID( steamid ) ) then
					nick = " (" .. evolve:Plugin( "Player Info" ):NickBySteamID( steamid ) .. ")"
				end
				
				if ( steamid ) then
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has " .. string.lower( msg ) .. " ", evolve.colors.red, steamid .. nick, evolve.colors.white, msg2 .. treason .. "." )
					
					for _, ply in pairs( player.GetAll() ) do
						if ( ply:SteamID() == steamid ) then
							ply:Kick( msg .. msg2 .. " (" .. reason .. ")" )
							break
						end
					end
				else
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has " .. string.lower( msg ) .. " ", evolve.colors.red, evolve:CreatePlayerList( pl ), evolve.colors.white, msg2 .. treason .. "." )
					pl[1]:Kick( msg .. msg2 .. " (" .. reason .. ")" )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "No valid time specified!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "ban", players[1], arg )
	else
		return "Ban", evolve.category.administration, {
			{ "5 minutes", "5" },
			{ "10 minutes", "10" },
			{ "15 minutes", "15" },
			{ "30 minutes", "30" },
			{ "1 hour", "60" },
			{ "2 hours", "120" },
			{ "4 hours", "240" },
			{ "12 hours", "720" },
			{ "One day", "1440" },
			{ "Two days", "2880" },
			{ "One week", "10080" },
			{ "Two weeks", "20160" },
			{ "One month", "43200" },
			{ "One year", "525600" },
			{ "Permanently", "0" }
		}
	end
end

function PLUGIN:Load()
	if ( file.Exists( "ev_bans.txt" ) ) then
		self.bans = glon.decode( file.Read( "ev_bans.txt" ) )
	else
		self.bans = { }
	end
end

function PLUGIN:Save()
	file.Write( "ev_bans.txt", glon.encode( self.bans ) )
end

function PLUGIN:CheckBan( ply )
	if ( !self.bans ) then self:Load() end
	
	for i, item in pairs( self.bans ) do
		if ( item.steamID == ply:SteamID() and ( item.banEnd > os.time() or item.banEnd == 0 ) ) then
			if ( item.banEnd == 0 ) then
				ply:Kick( "Banned forever." )
			else
				ply:Kick( "Banned for " .. math.Round( ( item.banEnd - os.time() ) / 60 ) .. " more minutes" )
			end
			return
		else
			table.remove( self.bans, i )
		end
	end
	
	self:Save()
end

function PLUGIN:PlayerAuthed( ply )
	if ( !ply.EV_CheckedBan ) then
		self:CheckBan( ply )
		ply.EV_CheckedBan = true
	end
end

evolve:RegisterPlugin( PLUGIN )