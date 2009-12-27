/*-------------------------------------------------------------------------------------------------------------------------
	Provides chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Chat Commands"
PLUGIN.Description = "Provides chat commands to run plugins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

// Thank you http://lua-users.org/lists/lua-l/2009-07/msg00461.html
function PLUGIN:Levenshtein( s, t )
	local d, sn, tn = {}, #s, #t
	local byte, min = string.byte, math.min
	for i = 0, sn do d[i * tn] = i end
	for j = 0, tn do d[j] = j end
	for i = 1, sn do
		local si = byte(s, i)
		for j = 1, tn do
d[i*tn+j] = min(d[(i-1)*tn+j]+1, d[i*tn+j-1]+1, d[(i-1)*tn+j-1]+(si == byte(t,j) and 0 or 1))
		end
	end
	return d[#d]
end

function PLUGIN:GetCommand( msg )
	return string.match( msg, "%w+" )
end

function PLUGIN:GetArguments( msg )
	local args = {}
	local first = true
	
	for match in string.gmatch( msg, "%S+" ) do
		if ( first ) then first = false else
			table.insert( args, match )
		end
	end
	
	return args
end

function PLUGIN:PlayerSay( ply, msg )
	if ( string.Left( msg, 1 ) == "!" ) then
		local command = self:GetCommand( msg )
		local args = self:GetArguments( msg )
		local closest = { dist = 99, plugin = "" }
		
		for _, plugin in ipairs( evolve.plugins ) do
			if ( plugin.ChatCommand == string.lower( command or "" ) ) then
				res, ret = pcall( plugin.Call, plugin, ply, args )
				
				if ( !res ) then
					evolve:Notify( evolve.colors.red, "Plugin '" .. plugin.Title .. "' failed with error:" )
					evolve:Notify( evolve.colors.red, ret )
				end
				
				return ""
			elseif ( plugin.ChatCommand ) then
				local dist = self:Levenshtein( string.lower( command or "" ), plugin.ChatCommand )
				if ( dist < closest.dist ) then
					closest.dist = dist
					closest.plugin = plugin
				end
			end
		end
		
		if ( ply.EV_Gagged ) then
			return ""
		else
			if ( closest.dist <= 0.25 * #closest.plugin.ChatCommand ) then
				res, ret = pcall( closest.plugin.Call, closest.plugin, ply, args )
				
				if ( !res ) then
					evolve:Notify( evolve.colors.red, "Plugin '" .. closest.plugin.Title .. "' failed with error:" )
					evolve:Notify( evolve.colors.red, ret )
				end
				
				return ""
			else
				evolve:Notify( ply, evolve.colors.red, "Command '" .. ( command or "" ) .. "' not found!" )
			end
		end
	end
end

evolve:RegisterPlugin( PLUGIN )