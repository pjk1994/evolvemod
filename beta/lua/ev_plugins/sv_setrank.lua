/*-------------------------------------------------------------------------------------------------------------------------
	Gives or takes a privilege of a rank.
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Lua"
PLUGIN.Description = "Gives or takes a privilege of a rank."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "setrank"
PLUGIN.Usage = "<rank> <privilege> <1/0>"

function PLUGIN:Call( ply, args )	
	if ( ply:EV_HasPrivilege( "Rank modification" ) ) then
		PrintTable( args )
		
		if ( #args == 3 and tonumber( args[3] ) and evolve.ranks[ args[1] ] and table.HasValue( evolve.privileges, args[2] ) and args[1] != "owner" ) then
			local rank = args[1]
			local privilege = args[2]
			
			if ( tonumber( args[3] ) == 1 ) then
				if ( !table.HasValue( evolve.ranks[ rank ].Privileges, privilege ) ) then
					table.insert( evolve.ranks[ rank ].Privileges, privilege )
					
					evolve:SaveRanks()
					evolve:SyncRanks()
				end
			else
				if ( table.HasValue( evolve.ranks[ rank ].Privileges, privilege ) ) then
					for i = 1, #evolve.ranks[ rank ].Privileges do
						if ( evolve.ranks[ rank ].Privileges[i] == privilege ) then
							table.remove( evolve.ranks[ rank ].Privileges, i )
							
							evolve:SaveRanks()
							evolve:SyncRanks()
							
							return
						end
					end
				end
			end
		else
			evolve:Notify( ply, evolve.colors.red, "Not enough or invalid arguments specified!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )