/*-------------------------------------------------------------------------------------------------------------------------
	Player Info
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Player Info"
PLUGIN.Description = "When players join, show info about them."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil

function PLUGIN:load( )
	if ( file.Exists( "ev_playerinfo.txt" ) ) then
		self.playerInfo = glon.decode( file.Read( "ev_playerinfo.txt" ) ) or { }
	else
		self.playerInfo = { }
	end
end

function PLUGIN:save( )
	file.Write( "ev_playerinfo.txt", glon.encode( self.playerInfo ) )
end

function PLUGIN:nickBySteamID( steamID )
	for _, item in pairs( self.playerInfo ) do
		if ( steamID == item.steamID ) then
			return item.lastNick
		end
	end
end

function PLUGIN:showPlayerInfo( ply )	
	if ( !self.playerInfo ) then self:load( ) end
	
	for _, item in pairs( self.playerInfo ) do
		if ( item.steamID == ply:SteamID( ) ) then
			evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " last joined at ", evolve.colors.red, os.date( "%c", item.lastTime ), evolve.colors.white, " as " .. item.lastNick, evolve.colors.white, "." )
			item.lastNick = ply:Nick( )
			item.lastTime = os.time( )
			self:save( )
			
			return
		end
	end
	
	evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has joined for the first time." )
	local item = { }
	item.steamID = ply:SteamID( )
	item.lastNick = ply:Nick( )
	item.lastTime = os.time( )
	table.insert( self.playerInfo, item )
	self:save( )
end

function PLUGIN:PlayerSpawn( ply )
	if ( !ply.EV_Introduced ) then
		self:showPlayerInfo( ply )
		ply.EV_Introduced = true
	end
end

evolve:registerPlugin( PLUGIN )