/*-------------------------------------------------------------------------------------------------------------------------
	Framework providing the main Evolve functions
-------------------------------------------------------------------------------------------------------------------------*/

// Constants for comfort
evolve.constants = { }
evolve.colors = { }
evolve.ranks = { }
evolve.constants.notallowed = "You are not allowed to do that!"
evolve.colors.yellow = Color( 236, 227, 203, 255 )
evolve.colors.blue = Color( 98, 176, 255, 255 )
evolve.colors.red = Color( 255, 62, 62, 255 )
evolve.colors.white = color_white
evolve.category = { }
evolve.category.administration = 1
evolve.category.actions = 2
evolve.category.punishment = 3
evolve.category.teleportation = 4
evolve.ranks.guest = 0
evolve.ranks.respected = 1
evolve.ranks.admin = 2
evolve.ranks.superadmin = 3
evolve.ranks.owner = 4

// Prints a message to the console
function evolve:Message( msg )
	print( "[EV] " .. msg )
end

// Display a notification
if ( SERVER ) then
	function evolve:Notify( ... )
		local ply = nil
		if ( type( arg[1] ) == "Player" or arg[1] == NULL ) then ply = arg[1] end
		if ( ply != NULL ) then
			umsg.Start( "EV_Notification", ply )
				umsg.Short( #arg )
				for _, v in ipairs( arg ) do
					if ( type( v ) == "string" ) then
						umsg.String( v )
					elseif ( type ( v ) == "table" ) then
						umsg.Short( v.r )
						umsg.Short( v.g )
						umsg.Short( v.b )
						umsg.Short( v.a )
					end
				end
			umsg.End()
		end
		
		// Display in server console
		local str = ""
		for _, v in ipairs( arg ) do
			if ( type( v ) == "string" ) then str = str .. v end
		end
		if ( ply ) then evolve:Message( ply:Nick() .. " -> " .. str ) else evolve:Message( str ) end
	end
else
	function evolve:Notify( ... )
		args = { }
		for _, v in ipairs( arg ) do
			if ( type( v ) == "string" or type( v ) == "table" ) then table.insert( args, v ) end
		end
		
		chat.AddText( unpack( args ) )
	end
	
	usermessage.Hook( "EV_Notification", function( um )
		local argc = um:ReadShort()
		local args = { }
		for i = 1, argc / 2, 1 do
			table.insert( args, Color( um:ReadShort(), um:ReadShort(), um:ReadShort(), um:ReadShort() ) )
			table.insert( args, um:ReadString() )
		end
		
		chat.AddText( unpack( args ) )
	end )
end

// Convert bool to int
function evolve:BoolToInt( bool )
	if ( bool ) then return 1 else return 0 end
end

// Load plugins from the plugin directory and distribute shared and clientside plugins on the server
function evolve:LoadPlugins()
	evolve.plugins = {}
	
	local plugins = file.FindInLua( "ev_plugins/*.lua" )
	for _, plugin in ipairs( plugins ) do
		local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
		
		if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
			include( "ev_plugins/" .. plugin )
		elseif ( SERVER ) then
			if ( prefix == "sh" or prefix == "sv" ) then include( "ev_plugins/" .. plugin ) end
			if ( prefix == "sh" or prefix == "cl" ) then AddCSLuaFile( "ev_plugins/" .. plugin ) end
		end
	end
end

// Register a plugin
function evolve:RegisterPlugin( plugin )
	table.insert( self.plugins, plugin )
end

// Take care of plugin hooks
evolve.HookCall = hook.Call
hook.Call = function( name, gm, ... )
	for _, plugin in ipairs( evolve.plugins ) do
		if ( plugin[ name ] ) then
			res, ret = pcall( plugin[name], plugin, ... )
			if ( res and ret != nil ) then
				return ret
			elseif ( !res ) then
				evolve:Notify( evolve.colors.red, "Hook '" .. name .. "' in plugin '" .. plugin.Title .. "' failed with error:" )
				evolve:Notify( evolve.colors.red, ret )
			end
		end
	end
	
	for _, tab in ipairs( evolve.menutabs ) do
		if ( name != "Initialize" and tab[ name ] ) then
			res, ret = pcall( tab[name], tab, ... )
			if ( res and ret != nil ) then
				return ret
			elseif ( !res ) then
				evolve:Notify( evolve.colors.red, "Hook '" .. name .. "' in tab '" .. tab.Title .. "' failed with error:" )
				evolve:Notify( evolve.colors.red, ret )
			end
		end
	end
	
	return evolve.HookCall( name, gm, ... )
end

// Match player and string
function evolve:IsNameMatch( ply, str )
	if ( str == "*" ) then
		return true
	elseif ( str == "@" and ply:IsAdmin() ) then
		return true
	elseif ( str == "!@" and !ply:IsAdmin() ) then
		return true
	elseif ( string.Left( str, 1 ) == "\"" and string.Right( str, 1 ) == "\"" ) then
		return ( ply:Nick() == string.sub( str, 2, #str - 1 ) )
	else
		return ( string.lower( ply:Nick() ) == string.lower( str ) or string.find( string.lower( ply:Nick() ), string.lower( str ) ) )
	end
end

// Find a player by name
function evolve:FindPlayer( name, def, nonum )
	local matches = {}
	
	if ( !name or #name == 0 ) then
		matches[1] = def
	else
		if ( type( name ) != "table" ) then name = { name } end
		name2 = table.Copy( name )
		if ( nonum ) then
			if ( #name2 > 1 and tonumber( name2[ #name2 ] ) ) then table.remove( name2, #name2 ) end
		end
		
		for _, ply in ipairs( player.GetAll() ) do
			for _, pm in ipairs( name2 ) do
				if ( self:IsNameMatch( ply, pm ) and !table.HasValue( matches, ply ) ) then table.insert( matches, ply ) end
			end
		end
	end
	
	return matches
end

// Turn a table with items into a string
function evolve:CreatePlayerList( tbl, notall )
	local lst = ""
	local lword = "and"
	if ( notall ) then lword = "or" end
	
	if ( #tbl == 1 ) then
		lst = tbl[1]:Nick()
	elseif ( #tbl == #player.GetAll() ) then
		lst = "everyone"
	else
		for i = 1, #tbl do
			if ( i == #tbl ) then lst = lst .. " " .. lword .. " " .. tbl[i]:Nick() elseif ( i == 1 ) then lst = tbl[i]:Nick() else lst = lst .. ", " .. tbl[i]:Nick() end
		end
	end
	
	return lst
end

function evolve:GetRankName( rankname )
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

// Group checking functions
function _R.Player:EV_IsRespected()
	return self:GetNWString( "EV_UserGroup" ) == "respected" or self:EV_IsAdmin()
end

function _R.Player:EV_IsAdmin()
	return self:GetNWString( "EV_UserGroup" ) == "admin" or self:IsAdmin() or self:EV_IsSuperAdmin()
end

function _R.Player:EV_IsSuperAdmin()
	return self:GetNWString( "EV_UserGroup" ) == "superadmin" or self:IsSuperAdmin() or self:EV_IsOwner()
end

function _R.Player:EV_IsOwner()
	if ( SERVER ) then
		return self:GetNWString( "EV_UserGroup" ) == "owner" or self:IsListenServerHost()
	else
		return self:GetNWString( "EV_UserGroup" ) == "owner"
	end
end

function _R.Player:EV_IsRank( rank )
	return ( rank == evolve.ranks.guest or ( rank == evolve.ranks.admin and self:EV_IsAdmin() ) or ( rank == evolve.ranks.superadmin and self:EV_IsSuperAdmin() ) or ( rank == evolve.ranks.owner and self:EV_IsOwner() ) )
end

function _R.Player:EV_GetRank()
	if ( self:EV_IsOwner() ) then return "owner"
	elseif ( self:EV_IsSuperAdmin() ) then return "superadmin"
	elseif ( self:EV_IsAdmin() ) then return "admin"
	elseif ( self:EV_IsRespected() ) then return "respected" end
	return "guest"
end

// Console wrapper functions
function _R.Entity:Nick() if ( !self:IsValid() ) then return "Console" end end
function _R.Entity:EV_IsRespected() if ( !self:IsValid() ) then return true end end
function _R.Entity:EV_IsAdmin() if ( !self:IsValid() ) then return true end end
function _R.Entity:EV_IsSuperAdmin() if ( !self:IsValid() ) then return true end end
function _R.Entity:EV_IsOwner() if ( !self:IsValid() ) then return true end end
function _R.Entity:EV_GetRank() if ( !self:IsValid() ) then return "owner" end end

// Player info module
function evolve:LoadPlayerInfo()
	if ( file.Exists( "ev_playerinfo.txt" ) ) then
		self.PlayerInfo = glon.decode( file.Read( "ev_playerinfo.txt" ) )
	else
		self.PlayerInfo = {}
	end
end

function evolve:SavePlayerInfo()
	file.Write( "ev_playerinfo.txt", glon.encode( self.PlayerInfo ) )
end

function _R.Player:GetProperty( id, defaultvalue )
	if ( !evolve.PlayerInfo ) then evolve:LoadPlayerInfo() end
	
	if ( evolve.PlayerInfo[ self:UniqueID() ] ) then
		return evolve.PlayerInfo[ self:UniqueID() ][ id ]
	else
		return defaultvalue
	end
end

function _R.Player:SetProperty( id, value )
	if ( !evolve.PlayerInfo ) then evolve:LoadPlayerInfo() end
	if ( !evolve.PlayerInfo[ self:UniqueID() ] ) then evolve.PlayerInfo[ self:UniqueID() ] = {} end
	
	evolve.PlayerInfo[ self:UniqueID() ][ id ] = value
end

function _R.Player:CommitProperties()
	evolve:SavePlayerInfo()
end