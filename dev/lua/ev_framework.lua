/*-------------------------------------------------------------------------------------------------------------------------
	Useful functions used both serverside and clientside
-------------------------------------------------------------------------------------------------------------------------*/
Evolve.Plugins = {}

function Evolve:Message( Message )
	Msg( "[E] " .. Message .. "\n" )
end

function Evolve:LoadPlugins( Folder )
	local Files = file.FindInLua( Folder .. "/*.lua" )
	for _, f in pairs( Files ) do
		include( Folder .. "/" .. f )
		if SERVER then AddCSLuaFile( Folder .. "/" .. f ) end
	end
end

function Evolve:FindPlayer( Nick )
	if !Nick then return nil end
	
	for _, pl in pairs(player.GetAll()) do
		local n = string.lower( pl:Nick() )
		if n == Nick or string.find( n, Nick ) then return pl end
	end
end

function Evolve:SameOrBetter( ply, ply2 )
	if ply == ply2 then
		return false
	else
		if ply:IsUserGroup("superadmin") then r1 = 2 elseif ply:IsUserGroup("admin") then r1 = 1 else r1 = 0 end
		if ply2:IsUserGroup("superadmin") then r2 = 2 elseif ply2:IsUserGroup("admin") then r2 = 1 else r2 = 0 end
		
		if r1 > r2 then
			return false
		else
			return true
		end
	end
end

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
	local pos = string.find( msg, " " )
	
	while pos != nil do
		if string.find( msg, " ", pos + 1 ) then
			table.insert( args, string.sub( msg, pos + 1, string.find( msg, " ", pos + 1 ) - 1 ) )
		else
			table.insert( args, string.sub( msg, pos + 1, string.find( msg, " ", pos + 1 ) ) )
		end
		
		pos = string.find( msg, " ", pos + 2 )
	end
	
	return args
end

function Evolve:ChatPrintAll( msg )
	for _, v in pairs(player.GetAll()) do
		v:ChatPrint( msg )
	end
end

function Evolve:RegisterPlugin( PluginTable )
	PluginTable.Mounted = true
	table.insert( self.Plugins, PluginTable )
end

function Evolve:PluginHook( PLUGIN, Event, Name, Func )
	// First just register the hook like you normally would
	hook.Add( Event, Name, Func )
	
	// Add it to the plugin hook list
	table.insert( PLUGIN.Hooks, {Event = Event, Name = Name, Func = Func} )
end

Evolve.HookCall = hook.Call
hook.Call = function( name, gm, ... )
	for _, p in pairs( Evolve.Plugins ) do
		if p.Mounted and p[name] then
			res, ret = pcall( p[name], p, ... )
			if ret then return ret end
		end
	end
	
	return Evolve.HookCall( name, gm, ... )
end

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