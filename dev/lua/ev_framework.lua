/*-------------------------------------------------------------------------------------------------------------------------
	Useful functions used both serverside and clientside
-------------------------------------------------------------------------------------------------------------------------*/
Evolve.Plugins = {}

/*-------------------------------------------------------------------------------------------------------------------------
	Messaging functions
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:Message( Message )
	Msg( "[E] " .. Message .. "\n" )
end

function Evolve:Notify( Message )
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
	chat.AddText( Color( 255, 255, 100 ), "[EV] ", color_white, um:ReadString() )
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
	Functions to check immunity
-------------------------------------------------------------------------------------------------------------------------*/

function meta:GetGroupRating( )
	if self:IsUserGroup( "owner" ) then
		return 4
	elseif self:IsUserGroup( "superadmin" ) then
		return 3
	elseif self:IsUserGroup( "admin" ) then
		return 2
	elseif self:IsUserGroup( "respected" ) then
		return 1
	else
		return 0
	end
end

function meta:SameOrBetterThan( ply )
	if self == ply then
		return true
	else
		if self:GetGroupRating( ) >= ply:GetGroupRating( ) then
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
		if self:GetGroupRating( ) > ply:GetGroupRating( ) then
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
	local pos = string.find( msg, " " )
	if pos then
		return string.sub( msg, 2, pos-1 )
	else
		return string.sub( msg, 2 )
	end
end

function Evolve:GetArguments( msg )
	local args = {}
	local i = 1
	
	for v in string.gmatch( msg, "[%w^_]+" ) do
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
			
			if res then
				if ret then return ret end
			else
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