/*-------------------------------------------------------------------------------------------------------------------------
	Use chat commands to interact with plugins
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Chatcommands"
PLUGIN.Description = "Use chatcommands to make use of plugins"
PLUGIN.Author = "Overv"

function PLUGIN:PlayerSay( ply, msg )
	if string.Left( msg, 1 ) == "!" then
		// Get the command and arguments
		local com = Evolve:GetCommand( msg )
		local args = Evolve:GetArguments( msg )
		
		// Look for the command
		for _, v in pairs( Evolve.Plugins ) do
			if v.Chat == string.lower(com) and v.Mounted then
				if #args > 0 or !v.Usage then
					local s, r = v:Call( ply, args )
					
					if s and r then
						Evolve:Notify( r )
					elseif r then
						ply:Notify( r )
					end
				else
					ply:Notify( "Usage: !" .. v.Chat .. " " .. v.Usage )
				end
				
				// Remove command from chat
				return ""
			end
		end
		
		ply:Notify( "Unknown command '" .. com .. "'" )
	end
end

Evolve:RegisterPlugin( PLUGIN )