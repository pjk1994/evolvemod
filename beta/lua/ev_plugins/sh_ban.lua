/*-------------------------------------------------------------------------------------------------------------------------
	Ban a player
		To do: Clean up this piece of shit.
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ban"
PLUGIN.Description = "Ban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ban"
PLUGIN.Usage = "<player> [time=5] [reason]"
PLUGIN.Privileges = { "Ban", "Permaban" }

function PLUGIN:Call( ply, args )
	local time = math.Clamp( tonumber( args[2] ) or 5, 0, 10080 )
	
	if ( ( time > 0 and ply:EV_HasPrivilege( "Ban" ) ) or ( time == 0 and ply:EV_HasPrivilege( "Permaban" ) ) ) then
		/*-------------------------------------------------------------------------------------------------------------------------
			Check if a player name or SteamID was specified and gather data
		-------------------------------------------------------------------------------------------------------------------------*/
		
		local pl
		if ( string.match( args[1] or "", "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
			local unid = evolve:UniqueIDByProperty( "SteamID", args[1] )
			
			if ( unid ) then
				if ( player.GetByUniqueID( unid ) ) then
					pl = { player.GetByUniqueID( unid ) }
				else
					pl = { unid }
				end
			else
				pl = {}
			end
		else
			pl = evolve:FindPlayer( args[1] )
		end
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 0 ) then
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		else
			/*-------------------------------------------------------------------------------------------------------------------------
				Collect data
			-------------------------------------------------------------------------------------------------------------------------*/
			
			local uid, nick
			if ( type( pl[1] ) == "Player" ) then
				pl = pl[1]
				uid = pl:UniqueID()
				nick = pl:Nick()
			else
				uid = pl[1]
				pl = nil
				nick = evolve:GetProperty( uid, "Nick" )
			end
			
			local time = math.Clamp( tonumber( args[2] ) or 5, 0, 10080 )
			local endtime
			if ( time > 0 ) then endtime = os.time() + time * 60 else endtime = 0 end
			local reason = table.concat( args, " ", 3 )
			if ( #reason == 0 ) then reason = "No reason specified" end
			
			/*-------------------------------------------------------------------------------------------------------------------------
				Perform banning
			-------------------------------------------------------------------------------------------------------------------------*/
			
			if ( pl ) then
				for _, v in ipairs( ents.GetAll() ) do
					if ( v:EV_GetOwner() == pl:UniqueID() ) then v:Remove() end
				end
				
				pl:SetProperty( "BanEnd", endtime )
				pl:SetProperty( "BanReason", reason )
				pl:SetProperty( "BanAdmin", ply:UniqueID() )
				evolve:CommitProperties()
				
				local info = evolve.PlayerInfo[ pl:UniqueID() ]
				local time = info.BanEnd - os.time()
				if ( info.BanEnd == 0 ) then time = 0 end
				
				if ( ply:IsValid() ) then SendUserMessage( "EV_BanEntry", nil, tostring( pl:UniqueID() ), info.Nick, info.SteamID, info.BanReason, evolve:GetProperty( info.BanAdmin, "Nick" ), time ) end
			else
				evolve:SetProperty( uid, "BanEnd", endtime )
				evolve:SetProperty( uid, "BanReason", reason )
				evolve:SetProperty( uid, "BanAdmin", ply:UniqueID() )
				evolve:CommitProperties()
				
				local info = evolve.PlayerInfo[ uid ]
				local time = info.BanEnd - os.time()
				if ( info.BanEnd == 0 ) then time = 0 end
				if ( ply:IsValid() ) then SendUserMessage( "EV_BanEntry", nil, tostring( uid ), info.Nick, info.SteamID, info.BanReason, evolve:GetProperty( info.BanAdmin, "Nick" ), time ) end
			end
			
			if ( time == 0 ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " permanently (" .. reason .. ")." )
				
				if ( pl ) then
					if ( gatekeeper ) then
						gatekeeper.Drop( pl:UserID(), "Permanently banned (" .. reason .. ")" )
					else
						pl:Kick( "Permanently banned (" .. reason .. ")" )
					end
				end
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " for " .. time .. " minutes (" .. reason .. ")." )
				
				if ( pl ) then
					if ( gatekeeper ) then
						gatekeeper.Drop( pl:UserID(), "Banned for " .. time .. " minutes (" .. reason .. ")" )
					else
						pl:Kick( "Banned for " .. time .. " minutes (" .. reason .. ")" )
					end
				end
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerPasswordAuth( user, pass, steamid, ip )
	local uid = evolve:UniqueIDByProperty( "SteamID", steamid )
	if ( uid ) then
		local banend = tonumber( evolve:GetProperty( uid, "BanEnd" ) )
		local reason = evolve:GetProperty( uid, "BanReason" )
		
		if ( banend and ( banend > os.time() or banend == 0 ) ) then
			if ( banend == 0 ) then
				return "You have been permabanned (" .. reason .. ")."
			else
				return "You have been banned for " .. math.ceil( ( banend - os.time() ) / 60 ) .. " more minutes (" .. reason .. ")."
			end
		end
	end
end

function PLUGIN:PlayerAuthed( ply, steamid, uniqueid )
	if ( ply:GetProperty( "BanEnd", false ) ) then
		if ( ply:GetProperty( "BanEnd" ) > os.time() or tonumber( ply:GetProperty( "BanEnd" )  ) == 0 ) then
			ply:Kick( "Banned." )
		else
			ply:SetProperty( "BanEnd", nil )
			evolve:CommitProperties()
		end
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
		}, "Time"
	end
end

evolve:RegisterPlugin( PLUGIN )