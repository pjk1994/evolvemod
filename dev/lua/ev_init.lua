/*-------------------------------------------------------------------------------------------------------------------------
	Serverside main file
-------------------------------------------------------------------------------------------------------------------------*/

function Evolve:Initialize( )
	Msg( "\n================================================================\n" )
		Msg( "Evolve 1.0 by Overv\n\n" )
		self:LoadPlugins( "ev_plugins" )
		Msg( "-> Loaded " .. #self.Plugins .. " plugins.\n" )
	Msg( "================================================================\n\n" )
end
Evolve:Initialize()

function ChatCommand( ply, msg )
	if string.Left( msg, 1 ) == "!" then
		// Get the command and arguments
		local com = Evolve:GetCommand( msg )
		local args = Evolve:GetArguments( msg )
		
		// Look for the command
		for _, v in pairs( Evolve.Plugins ) do
			if v.Chat == string.lower(com) and v.Mounted then
				local s, r = v:Call( ply, args )
				
				if s then
					Evolve:ChatPrintAll( "[Evolve] " .. r )
				else
					ply:ChatPrint( "[Evolve] " .. r )
				end
				
				// Remove command from chat
				return ""
			end
		end
		
		ply:ChatPrint( "[Evolve] Unknown command '" .. com .. "'" )
	end
end
hook.Add( "PlayerSay", "CheckCommands", ChatCommand )

function MountPlugin( ply, com, args )
	// From the console?
	if ply == NULL and args[1] then
		for _, v in pairs(Evolve.Plugins) do
			if v.Title == args[1] then
				Evolve:MountPlugin( v )
				Evolve:Message( "The plugin '" .. v.Title .. "' has been mounted successfully!" )
				return true
			end
		end
		
		Evolve:Message( "The plugin '" .. args[1] .. "' could not be found!" )
	end
end
concommand.Add( "EV_Mount", MountPlugin )

function UnMountPlugin( ply, com, args )
	// From the console?
	if ply == NULL and args[1] then
		for _, v in pairs(Evolve.Plugins) do
			if v.Title == args[1] then
				Evolve:UnMountPlugin( v )
				Evolve:Message( "The plugin '" .. v.Title .. "' has been unmounted successfully!" )
				return true
			end
		end
		
		Evolve:Message( "The plugin '" .. args[1] .. "' could not be found!" )
	else
		Msg( type(ply) .. "\n" )
	end
end
concommand.Add( "EV_UnMount", UnMountPlugin )