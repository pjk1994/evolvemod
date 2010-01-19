/*-------------------------------------------------------------------------------------------------------------------------
	Provides console commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Console Commands"
PLUGIN.Description = "Provides console commands to run plugins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

function PLUGIN:GetArguments( allargs )
	local newargs = {}
	for i = 2, #allargs do
		table.insert( newargs, allargs[i] )
	end
	return newargs
end

function PLUGIN:CCommand( ply, com, cargs )
	local command = cargs[1]
	local args = self:GetArguments( cargs )
	
	for _, plugin in ipairs( evolve.plugins ) do
		if ( plugin.ChatCommand == string.lower( command or "" ) ) then
			plugin:Call( ply, args )
			return ""
		end
	end
	
	evolve:Message( "Unknown command '" .. command .. "'" )
end
concommand.Add( "ev", function( ply, com, args ) PLUGIN:CCommand( ply, com, args ) end )

evolve:RegisterPlugin( PLUGIN )