/*-------------------------------------------------------------------------------------------------------------------------
	Current time
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Version"
PLUGIN.Description = "Returns the version of Evolve."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "version"

function PLUGIN:Call( ply, args )
	evolve:Notify( ply, evolve.colors.white, "This server is running ", evolve.colors.red, "revision 130", evolve.colors.white, " of Evolve." )
end

evolve:RegisterPlugin( PLUGIN )