/*-------------------------------------------------------------------------------------------------------------------------
	Display all chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Chatcommands"
PLUGIN.Description = "Display all available chat commands."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "commands"
PLUGIN.Usage = nil

function PLUGIN:Call( ply, args )
	umsg.Start( "EV_CommandStart", ply ) umsg.End()
	local commands = table.Copy( evolve.plugins )
	table.SortByMember( commands, "ChatCommand", function( a, b ) return a > b end )
	
	for _, plug in ipairs( commands ) do
		if ( plug.ChatCommand ) then
			umsg.Start( "EV_Command", ply )
				umsg.String( plug.ChatCommand )
				umsg.String( tostring( plug.Usage ) )
				umsg.String( plug.Description )
			umsg.End()
		end
	end
	umsg.Start( "EV_CommandEnd", ply ) umsg.End()
	
	evolve:Notify( ply, evolve.colors.white, "All chat commands have been printed to your console." )
end

usermessage.Hook( "EV_CommandStart", function( um )
	print( "\n============ Available chat commands for Evolve ============\n" )
end )

usermessage.Hook( "EV_CommandEnd", function( um )
	print( "" )
end )

usermessage.Hook( "EV_Command", function( um )
	local com = um:ReadString()
	local usage = um:ReadString()
	local desc = um:ReadString()
	
	if ( usage != "nil" ) then
		print( "!" .. com .. " " .. usage .. " - " .. desc )
	else
		print( "!" .. com .. " - " .. desc )
	end
end )

evolve:RegisterPlugin( PLUGIN )