/*-------------------------------------------------------------------------------------------------------------------------
	Change the name of a rank.
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Lua"
PLUGIN.Description = "Changes the name of a rank."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "renamerank"
PLUGIN.Usage = "<rank> <name>"

function PLUGIN:Call( ply, args )	
	if ( ply:EV_HasPrivilege( "Rank modification" ) ) then
		if ( #args > 1 and evolve.ranks[ args[1] ] ) then			
			evolve:Notify( evolve.colors.red, ply:Nick(), evolve.colors.white, " has renamed ", evolve.colors.blue, evolve.ranks[ args[1] ].Title, evolve.colors.white, " to ", evolve.colors.blue, table.concat( args, " ", 2 ), evolve.colors.white, "." )
			
			evolve.ranks[ args[1] ].Title = table.concat( args, " ", 2 )
			
			evolve:SaveRanks()
			evolve:SyncRanks()
		else
			evolve:Notify( ply, evolve.colors.red, "Not enough or invalid arguments specified!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )