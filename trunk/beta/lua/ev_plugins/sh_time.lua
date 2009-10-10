/*-------------------------------------------------------------------------------------------------------------------------
	Current time
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Time"
PLUGIN.Description = "Returns the current time."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "thetime"

function PLUGIN:Call( ply, args )
	umsg.Start( "EV_ShowTime", ply )
	umsg.End()
end

usermessage.Hook( "EV_ShowTime", function()
	evolve:Notify( evolve.colors.white, "It is now ", evolve.colors.blue, os.date( "%H:%M" ), evolve.colors.white, "." )
end )

evolve:RegisterPlugin( PLUGIN )