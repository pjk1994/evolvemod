/*-------------------------------------------------------------------------------------------------------------------------
	Framework providing the main Evolve functions
-------------------------------------------------------------------------------------------------------------------------*/

// Locals
local entmeta = FindMetaTable( "Entity" )
local playermeta = FindMetaTable( "Player" )

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
function evolve:message( msg )
	print( "[EV] " .. msg )
end

// Display a notification
if ( SERVER ) then
	function evolve:notify( ... )
		local ply = nil
		if ( type( arg[1] ) == "Player" or arg[1] == NULL ) then ply = arg[1] end
		if ( ply != NULL ) then
			umsg.Start( "EV_Notification", ply )
				umsg.Short( #arg )
				for _, v in pairs( arg ) do
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
		for _, v in pairs( arg ) do
			if ( type( v ) == "string" ) then str = str .. v end
		end
		if ( ply ) then evolve:message( ply:Nick() .. " -> " .. str ) else evolve:message( str ) end
	end
else
	function evolve:notify( ... )
		args = { }
		for _, v in pairs( arg ) do
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

// Load plugins from the plugin directory and distribute shared and clientside plugins on the server
function evolve:loadPlugins()
	evolve.plugins = { }
	
	local plugins = file.FindInLua( "ev_plugins/*.lua" )
	for _, plugin in pairs( plugins ) do
		local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
		
		if ( CLIENT and ( prefix == "sh" or prefix == "cl" ) ) then
			include( "ev_plugins/" .. plugin )
		elseif ( SERVER ) then
			if ( prefix == "sh" or prefix == "sv" ) then include( "ev_plugins/" .. plugin ) end
			if ( prefix == "sh" or prefix == "cl" ) then AddCSLuaFile( "ev_plugins/" .. plugin ) end
		end
	end
end

// Get a plugin
function evolve:getPlugin( title )
	for _, plugin in pairs( self.plugins ) do
		if ( plugin.Title == title ) then return plugin end
	end
end

// Register a plugin
function evolve:registerPlugin( plugin )
	table.insert( self.plugins, plugin )
end

// Take care of plugin hooks
evolve.hookcall = hook.Call
hook.Call = function( name, gm, ... )
	for _, plugin in pairs( evolve.plugins ) do
		if ( plugin[ name ] ) then
			res, ret = pcall( plugin[name], plugin, ... )
			if ( res and ret != nil ) then
				return ret
			elseif ( !res ) then
				evolve:notify( evolve.colors.red, "Hook '" .. name .. "' in plugin '" .. plugin.Title .. "' failed with error:" )
				evolve:notify( evolve.colors.red, ret )
			end
		end
	end
	
	return evolve.hookcall( name, gm, ... )
end

// Match player and string
function evolve:nameMatch( ply, str )
	if ( str == "*" ) then
		return true
	elseif ( str == "@" and ply:IsAdmin() ) then
		return true
	elseif ( str == "!@" and !ply:IsAdmin() ) then
		return true
	else
		return ( string.lower( ply:Nick() ) == string.lower( str ) or string.find( string.lower( ply:Nick() ), string.lower( str ) ) )
	end
end

// Find a player by name
function evolve:findPlayer( name, def, nonum )
	local matches = { }
	
	if ( !name or #name == 0 ) then
		matches[1] = def
	else
		if ( type( name ) != "table" ) then name = { name } end
		name2 = table.Copy( name )
		if ( nonum ) then
			if ( #name2 > 1 and tonumber( name2[ #name2 ] ) ) then table.remove( name2, #name2 ) end
		end
		
		for _, ply in pairs( player.GetAll() ) do
			for _, pm in pairs( name2 ) do
				if ( self:nameMatch( ply, pm ) and !table.HasValue( matches, ply ) ) then table.insert( matches, ply ) end
			end
		end
	end
	
	return matches
end

// Turn a table with items into a string
function evolve:createPlayerList( tbl, notall )
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

// Custom group checking functions
function playermeta:EV_IsRespected()
	return self:GetNWString( "EV_UserGroup" ) == "respected" or self:EV_IsAdmin()
end

function playermeta:EV_IsAdmin()
	return self:GetNWString( "EV_UserGroup" ) == "admin" or self:IsAdmin() or self:EV_IsSuperAdmin()
end

function playermeta:EV_IsSuperAdmin()
	return self:GetNWString( "EV_UserGroup" ) == "superadmin" or self:IsSuperAdmin() or self:EV_IsOwner()
end

function playermeta:EV_IsOwner()
	if ( SERVER ) then
		return self:GetNWString( "EV_UserGroup" ) == "owner" or self:IsListenServerHost()
	else
		return self:GetNWString( "EV_UserGroup" ) == "owner"
	end
end

function playermeta:EV_IsRank( rank )
	return ( rank == evolve.ranks.guest or ( rank == evolve.ranks.admin and self:EV_IsAdmin() ) or ( rank == evolve.ranks.superadmin and self:EV_IsSuperAdmin() ) or ( rank == evolve.ranks.owner and self:EV_IsOwner() ) )
end

function playermeta:EV_GetRank()
	if ( self:EV_IsOwner() ) then return "owner"
	elseif ( self:EV_IsSuperAdmin() ) then return "superadmin"
	elseif ( self:EV_IsAdmin() ) then return "admin"
	elseif ( self:EV_IsRespected() ) then return "respected" end
	return "guest"
end

// Console functions
function entmeta:Nick() if ( !self:IsValid() ) then return "Console" end end
function entmeta:EV_IsRespected() if ( !self:IsValid() ) then return true end end
function entmeta:EV_IsAdmin() if ( !self:IsValid() ) then return true end end
function entmeta:EV_IsSuperAdmin() if ( !self:IsValid() ) then return true end end
function entmeta:EV_IsOwner() if ( !self:IsValid() ) then return true end end
function entmeta:EV_GetRank() if ( !self:IsValid() ) then return "owner" end end