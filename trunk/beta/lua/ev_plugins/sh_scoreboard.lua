/*-------------------------------------------------------------------------------------------------------------------------
	Default custom scoreboard
-------------------------------------------------------------------------------------------------------------------------*/

resource.AddFile( "materials/gui/scoreboard_header.vtf" )
resource.AddFile( "materials/gui/scoreboard_header.vmt" )
resource.AddFile( "materials/gui/scoreboard_middle.vtf" )
resource.AddFile( "materials/gui/scoreboard_middle.vmt" )
resource.AddFile( "materials/gui/scoreboard_bottom.vtf" )
resource.AddFile( "materials/gui/scoreboard_bottom.vmt" )
resource.AddFile( "materials/gui/scoreboard_ping.vtf" )
resource.AddFile( "materials/gui/scoreboard_ping.vmt" )
resource.AddFile( "materials/gui/scoreboard_frags.vtf" )
resource.AddFile( "materials/gui/scoreboard_frags.vmt" )
resource.AddFile( "materials/gui/scoreboard_skull.vtf" )
resource.AddFile( "materials/gui/scoreboard_skull.vmt" )
resource.AddFile( "materials/gui/scoreboard_playtime.vtf" )
resource.AddFile( "materials/gui/scoreboard_playtime.vmt" )

local PLUGIN = {}
PLUGIN.Title = "Scoreboard"
PLUGIN.Description = "Default custom scoreboard."
PLUGIN.Author = "Overv"

if ( CLIENT ) then
	PLUGIN.TexHeader = surface.GetTextureID( "gui/scoreboard_header" )
	PLUGIN.TexMiddle = surface.GetTextureID( "gui/scoreboard_middle" )
	PLUGIN.TexBottom = surface.GetTextureID( "gui/scoreboard_bottom" )
	PLUGIN.TexPing = surface.GetTextureID( "gui/scoreboard_ping" )
	PLUGIN.TexFrags = surface.GetTextureID( "gui/scoreboard_frags" )
	PLUGIN.TexDeaths = surface.GetTextureID( "gui/scoreboard_skull" )
	PLUGIN.TexPlaytime = surface.GetTextureID( "gui/scoreboard_playtime" )
	
	PLUGIN.TexOwner = surface.GetTextureID( "gui/silkicons/key" )
	PLUGIN.TexSuperAdmin = surface.GetTextureID( "gui/silkicons/shield_add" )
	PLUGIN.TexAdmin = surface.GetTextureID( "gui/silkicons/shield" )
	PLUGIN.TexRespected = surface.GetTextureID( "gui/silkicons/user_add" )
	PLUGIN.TexGuest = surface.GetTextureID( "gui/silkicons/user" )
	PLUGIN.Width = 687
	
	surface.CreateFont( "coolvetica", 22, 400, true, false, "EvolveScoreboardHeader" )
end

function PLUGIN:ScoreboardShow()
	if ( GAMEMODE.Name == "Sandbox" ) then
		self.DrawScoreboard = true
		return true
	end
end

function PLUGIN:ScoreboardHide()
	self.DrawScoreboard = false
end

function PLUGIN:DrawTexturedRect( tex, x, y, w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex )
	surface.DrawTexturedRect( x, y, w, h )
end

function PLUGIN:QuickTextSize( font, text )
	surface.SetFont( font )
	return surface.GetTextSize( text )
end

function PLUGIN:FormatTime( raw )
	if ( raw >= 3600 ) then
		if ( math.floor( raw / 3600 ) == 1 ) then return "1 hour" else return math.floor( raw / 3600 ) .. " hours" end
	elseif ( raw >= 60 ) then
		if ( math.floor( raw / 60 ) == 1 ) then return "1 minute" else return math.floor( raw / 60 ) .. " minutes" end
	else
		if ( raw == 1 ) then return "1 second" else return raw .. " seconds" end
	end
end

function PLUGIN:DrawInfoBar()
	// Background
	surface.SetDrawColor( 192, 218, 160, 255 )
	surface.DrawRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawOutlinedRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	// Content
	local x = self.X + 24
	draw.SimpleText( "Currently playing in the map ", "Default", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", "Currently playing in the map " )
	draw.SimpleText( game.GetMap(), "DefaultBold", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", game.GetMap() )
	draw.SimpleText( " with the gamemode ", "Default", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", " with the gamemode " )
	draw.SimpleText( GAMEMODE.Name, "DefaultBold", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", GAMEMODE.Name )
	draw.SimpleText( " with ", "Default", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "Default", " with " )
	draw.SimpleText( #player.GetAll(), "DefaultBold", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "DefaultBold", #player.GetAll() )
	local s = ""
	if ( #player.GetAll() > 1 ) then s = "s" end
	draw.SimpleText( " player" .. s .. ".", "Default", x, self.Y + 117, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function PLUGIN:DrawUsergroup( playerinfo, usergroup, title, icon, y )
	local playersFound = false
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			playersFound = true
			break
		end
	end
	if ( !playersFound ) then return y end
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawRect( self.X + 0.5, y, self.Width - 2, 22 )
	surface.SetTexture( icon )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( self.X + 15, y + 4, 14, 14 )
	draw.SimpleText( title, "DefaultBold", self.X + 40, y + 4, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	self:DrawTexturedRect( self.TexPing, self.X + self.Width - 50, y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexDeaths, self.X + self.Width - 101, y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexFrags, self.X + self.Width - 141,  y + 4, 14, 14 )
	
	y = y + 26
	
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			draw.SimpleText( pl.Nick, "ScoreboardText", self.X + 40, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Frags, "ScoreboardText", self.X + self.Width - 137, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Deaths, "ScoreboardText", self.X + self.Width - 97, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Ping, "ScoreboardText", self.X + self.Width - 50, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			
			y = y + 20
		end
	end
	
	return y + 10
end

function PLUGIN:DrawPlayers()
	local playerInfo = {}
	for _, v in pairs( player.GetAll() ) do
		table.insert( playerInfo, { Nick = v:Nick(), Usergroup = v:GetNWString( "EV_Usergroup" ), Frags = v:Frags(), Deaths = v:Deaths(), JoinTime = v.EV_JoinTime, Ping = v:Ping() } )
	end
	table.SortByMember( playerInfo, "Frags" )
	
	local y = self:DrawUsergroup( playerInfo, "owner", "Owners", self.TexOwner, self.Y + 155 )
	y = self:DrawUsergroup( playerInfo, "superadmin", "Super Admins", self.TexSuperAdmin, y )
	y = self:DrawUsergroup( playerInfo, "admin", "Admins", self.TexAdmin, y )
	y = self:DrawUsergroup( playerInfo, "respected", "Respected", self.TexRespected, y )
	y = self:DrawUsergroup( playerInfo, "guest", "Guests", self.TexGuest, y )
	
	return y
end

function PLUGIN:HUDDrawScoreBoard()
	if ( !self.DrawScoreboard ) then return end
	if ( !self.Height ) then self.Height = 139 end
	
	// Update position
	self.X = ScrW() / 2 - self.Width / 2
	self.Y = ScrH() / 2 - ( self.Height ) / 2
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetTexture( self.TexHeader )
	surface.DrawTexturedRect( self.X, self.Y, self.Width, 122 )
	draw.SimpleText( GetHostName(), "EvolveScoreboardHeader", self.X + 133, self.Y + 51, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( GetHostName(), "EvolveScoreboardHeader", self.X + 132, self.Y + 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( self.TexMiddle )
	surface.DrawTexturedRect( self.X, self.Y + 122, self.Width, self.Height - 122 - 37 )
	surface.SetTexture( self.TexBottom )
	surface.DrawTexturedRect( self.X, self.Y + self.Height - 37, self.Width, 37 )
	
	self:DrawInfoBar()
	
	local y = self:DrawPlayers()
	
	self.Height = y - self.Y
end

function PLUGIN:PlayerInitialSpawn( ply )
	ply.EV_JoinTime = os.time()
	
	timer.Simple( 1, function()
		umsg.Start( "EV_JoinTime" )
			umsg.Short( ply:EntIndex() )
			umsg.Long( ply.EV_JoinTime )
		umsg.End()
		
		for _, pl in pairs( player.GetAll() ) do
			umsg.Start( "EV_JoinTime", ply )
				umsg.Short( pl:EntIndex() )
				umsg.Long( pl.EV_JoinTime )
			umsg.End()
		end
	end )
end

usermessage.Hook( "EV_JoinTime", function( um )
	local ply, jointime = player.GetByID( um:ReadShort() ), um:ReadLong()
	ply.EV_JoinTime = jointime
end )

evolve:RegisterPlugin( PLUGIN )