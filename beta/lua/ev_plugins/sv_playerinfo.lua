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
	local lastnick
	
	if ( first ) then		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		evolve:CommitProperties()
	else
		lastjoin = ply:GetProperty( "LastJoin" )
		lastnick = ply:GetProperty( "Nick" )
		
		ply:SetProperty( "Nick", ply:Nick() )
		ply:SetProperty( "LastJoin", os.time() )
		ply:SetProperty( "SteamID", ply:SteamID() )
		ply:SetProperty( "IPAddress", ply:IPAddress() )
		evolve:CommitProperties()
	end
	
	http.Get("http://api.hostip.info/get_html.php?ip=" .. ply:IPAddress(), "", function ( contents, size )
		if ( !ply:IsValid() ) then return end
		
		local country
		for line in contents:gmatch( "[^\r\n]+" ) do
			country = line:gsub( "Country:", "" )
			break
		end
		
		country = country:gsub( "%b()", "" )
		country = country:gsub( "(%a)([%w_']*)", function( first, rest ) return first:upper() .. rest:lower() end )
		country = country:gsub( "^%s*(.-)%s*$", "%1" )
		
		local message = { evolve.colors.blue, ply:Nick(), evolve.colors.white }
		
		/*-------------------------------------------------------------------------------------------------------------------------
			Here for the first time or joined earlier?
		-------------------------------------------------------------------------------------------------------------------------*/

		if ( first ) then
			table.insert( message, " has joined for the first time" )
		else
			table.Add( message, { " last joined ", evolve.colors.red, evolve:FormatTime( os.time() - lastjoin ) .. " ago", evolve.colors.white } )
		end
		
		/*-------------------------------------------------------------------------------------------------------------------------
			Did you pick a new name?
		-------------------------------------------------------------------------------------------------------------------------*/
		
		if ( !first and lastnick != ply:Nick() ) then
			table.insert( message, " as " .. lastnick )
		end
		
		/*-------------------------------------------------------------------------------------------------------------------------
			Where are you from?
		-------------------------------------------------------------------------------------------------------------------------*/
		
		if ( #country > 0 ) then
			table.Add( message, { " from ", evolve.colors.red, country, evolve.colors.white } )
		end
		
		table.insert( message, "." )
		
		evolve:Notify( unpack( message ) )
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

function PLUGIN:PlayerDisconnected( ply )
	ply:SetProperty( "LastJoin", os.time() )
	evolve:CommitProperties()
end

evolve:RegisterPlugin( PLUGIN )