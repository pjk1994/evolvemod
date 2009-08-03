/*-------------------------------------------------------------------------------------------------------------------------
	Provides console commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Console Commands"
PLUGIN.Description = "Provides console commands to run plugins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

function PLUGIN:getArguments( allargs )
	local newargs = { }
	for i = 2, #allargs do
		table.insert( newargs, allargs[i] )
	end
	return newargs
end

function PLUGIN:cCommand( ply, com, cargs )
	local command = cargs[1]
	local args = self:getArguments( cargs )
	
	for _, plugin in pairs( evolve.plugins ) do
		if ( plugin.ChatCommand == string.lower( command or "" ) ) then
			plugin:Call( ply, args )
			return ""
		end
	end
	
	evolve:message( "Unknown command '" .. command .. "'" )
end
concommand.Add( "ev", function( ply, com, args ) PLUGIN:cCommand( ply, com, args ) end )

evolve:registerPlugin( PLUGIN )