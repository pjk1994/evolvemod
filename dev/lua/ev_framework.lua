/*-------------------------------------------------------------------------------------------------------------------------
	Useful functions used both serverside and clientside
-------------------------------------------------------------------------------------------------------------------------*/
Evolve.Plugins = { }
Evolve.UserGroups = { }

/*-------------------------------------------------------------------------------------------------------------------------
	Messaging functions
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:Message( Message )
	Msg( "[E] " .. Message .. "\n" )
end

function Evolve:Notify( Message )
	if CLIENT then return  end
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	
	umsg.Start( "EV_Notification", rf )
		umsg.String( Message )
	umsg.End( )
end

local meta = FindMetaTable( "Player" )
function meta:Notify( Message )
	umsg.Start( "EV_Notification", self )
		umsg.String( Message )
	umsg.End( )
end

function Evolve:ShowNotify( um )
	chat.AddText( Color( 195 * 0.9, 255 * 0.9, 100 ), "[EV] ", color_white, um:ReadString() )
end
usermessage.Hook( "EV_Notification", function( um ) Evolve:ShowNotify( um ) end )

function Evolve:LoadPlugins( Folder )
	local Files = file.FindInLua( Folder .. "/*.lua" )
	for _, f in pairs( Files ) do
		include( Folder .. "/" .. f )
		if SERVER then AddCSLuaFile( Folder .. "/" .. f ) end
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Find a player using a (part of a) nickname
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:FindPlayer( Nick )
	if !Nick then return nil end
	Nick = string.lower( Nick )
	
	local Exact = false
	if string.Left( Nick, 1 ) == "\"" and string.Right( Nick, 1 ) == "\"" then
		Exact = true
		Nick = string.sub( Nick, 2, string.len(Nick) - 1 )
	end
	
	for _, pl in pairs(player.GetAll()) do
		local n = string.lower( pl:Nick() )
		
		if n == Nick then
			return pl
		elseif string.find( n, Nick ) and !Exact then
			return pl
		end
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	User group functions
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:CreateUserGroups( )
	table.insert( Evolve.UserGroups, { name = "Owner", group = "superadmin", immunity = 4 } )
	table.insert( Evolve.UserGroups, { name = "Super Admin", group = "superadmin", immunity = 3 } )
	table.insert( Evolve.UserGroups, { name = "Admin", group = "admin", immunity = 2 } )
	table.insert( Evolve.UserGroups, { name = "Respected", group = "unknown", immunity = 1 } )
	table.insert( Evolve.UserGroups, { name = "Guest", group = "unknown", immunity = 0 } )
	table.SortByMember( Evolve.UserGroups, "immunity", function( a, b ) return a > b end )
end
Evolve:CreateUserGroups( )

function Evolve:GetGroup( name )
	for _, g in pairs( Evolve.UserGroups ) do
		if string.lower( g.name ) == string.lower( name ) then return g end
	end
end

function meta:GetGroup( )
	return Evolve:GetGroup( self:GetNWString( "EV_UserGroup" ) )
end

function meta:SameOrBetterThan( ply )
	if self == ply then
		return true
	else
		if self:GetGroup( ).immunity >= ply:GetGroup( ).immunity then
			return true
		else
			return false
		end
	end
end

function meta:BetterThan( ply )
	if self == ply then
		return true
	else
		if self:GetGroup( ).immunity > ply:GetGroup( ).immunity then
			return true
		else
			return false
		end
	end
end

/*-------------------------------------------------------------------------------------------------------------------------
	Functions used by the chat commands plugin
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:GetCommand( msg )
	return string.match( msg, "%w+" )
end

function Evolve:GetArguments( msg )
	local args = {}
	local i = 1
	
	for v in string.gmatch( msg, "%S+" ) do
		if i > 1 then table.insert( args, v ) end
		i = i + 1
	end
	
	return args
end

/*-------------------------------------------------------------------------------------------------------------------------
	Plugin register function
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:RegisterPlugin( PluginTable )
	PluginTable.Mounted = true
	table.insert( self.Plugins, PluginTable )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Custom hook system
-------------------------------------------------------------------------------------------------------------------------*/

Evolve.HookCall = hook.Call
hook.Call = function( name, gm, ... )
	for _, p in pairs( Evolve.Plugins ) do
		if p.Mounted and p[name] then
			res, ret = pcall( p[name], p, ... )
			
			if res and ret then
				return ret
			elseif !res then
				Evolve:Notify( "Something went wrong D:" )
				Evolve:Notify( ret )
			end
		end
	end
	
	return Evolve.HookCall( name, gm, ... )
end

/*-------------------------------------------------------------------------------------------------------------------------
	Mounting and unmounting
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:MountPlugin( PLUGIN )
	for _, v in pairs(PLUGIN.Hooks) do
		hook.Add( v.Event, v.Name, v.Func )
	end
	PLUGIN.Mounted = true
end

function Evolve:UnMountPlugin( PLUGIN )
	for _, v in pairs(PLUGIN.Hooks) do
		hook.Remove( v.Event, v.Name )
	end
	PLUGIN.Mounted = false
end

/*-------------------------------------------------------------------------------------------------------------------------
	Settings saving
-------------------------------------------------------------------------------------------------------------------------*/

Evolve.Settings = { }

function Evolve.Settings:Load( )
	if file.Exists( "Evolve/settings.txt" ) then
		Evolve.Settings.Settings = glon.decode( file.Read( "Evolve/settings.txt" ) )
	else
		Evolve.Settings.Settings = { }
	end
end
Evolve.Settings:Load( )

function Evolve.Settings:Save( )
	file.Write( "Evolve/settings.txt", glon.encode( Evolve.Settings.Settings ) )
end

function Evolve:GetSetting( id )
	return self.Settings.Settings[ id ]
end

function Evolve:SetSetting( id, value )
	self.Settings.Settings[ id ] = value
	self.Settings:Save( )
end