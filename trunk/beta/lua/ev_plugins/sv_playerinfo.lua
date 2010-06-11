/*-------------------------------------------------------------------------------------------------------------------------
	Player Info
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Player Info"
PLUGIN.Description = "When players join, show info about them."
PLUGIN.Author = "Overv and Alan Edwardes"
PLUGIN.ChatCommand = nil

function PLUGIN:ShowPlayerInfo( ply )
	local first = !ply:GetProperty( "Nick" )
	local lastjoin
	
	if ( first ) then		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		evolve:CommitProperties()
	else
		lastjoin = ply:GetProperty( "LastJoin" )
		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		evolve:CommitProperties()
	end
	
	http.Get("http://api.hostip.info/get_html.php?ip=" .. ply:IPAddress(), "", function ( contents, size )
		local country
		for line in contents:gmatch( "[^\r\n]+" ) do
			country = line:gsub( "Country:", "" )
			break
		end
		
		country = country:gsub( "%b()", "" )
		country = country:gsub( "(%a)([%w_']*)", function( first, rest ) return first:upper() .. rest:lower() end )
		country = country:gsub( "^%s*(.-)%s*$", "%1" )
		
		if ( country != '' ) then
			if ( first ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has joined for the first time from ", evolve.colors.red, country, evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " last joined ", evolve.colors.red, evolve:FormatTime( os.time() - lastjoin ) .. " ago", evolve.colors.white, " as ", evolve.colors.blue, ply:GetProperty( "Nick" ), evolve.colors.white, " from ", evolve.colors.red, country, evolve.colors.white, "." )
			end
		else
			if ( first ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has joined for the first time." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " last joined ", evolve.colors.red, evolve:FormatTime( os.time() - lastjoin ) .. " ago", evolve.colors.white, " as ", evolve.colors.blue, ply:GetProperty( "Nick" ), evolve.colors.white, "." )
			end
		end
	end )

end

function PLUGIN:PlayerInitialSpawn( ply )
	ply.EV_IntroductionPending = true
end

function PLUGIN:PlayerSpawn( ply )
	if ( ply.EV_IntroductionPending ) then
		self:ShowPlayerInfo( ply )
		ply.EV_IntroductionPending = false
	end
end

evolve:RegisterPlugin( PLUGIN )