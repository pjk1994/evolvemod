/*-------------------------------------------------------------------------------------------------------------------------
	Remove a rank.
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Lua"
PLUGIN.Description = "Removes a rank."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "removerank"
PLUGIN.Usage = "<rank>"

function PLUGIN:Call( ply, args )	
	if ( ply:EV_HasPrivilege( "Rank modification" ) ) then
		if ( #args == 1 and evolve.ranks[ args[1] ] and args[1] != "owner" ) then			
			evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has removed ", evolve.colors.blue, evolve.ranks[ args[1] ].Title, evolve.colors.white, "." )
			
			evolve:RemoveRank( args[1] )
		else
			evolve:Notify( ply, evolve.colors.red, "Not enough or invalid arguments specified!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )