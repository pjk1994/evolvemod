/*-------------------------------------------------------------------------------------------------------------------------
	Sets properties of a rank.
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Lua"
PLUGIN.Description = "Sets properties of a rank."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "setrankp"
PLUGIN.Usage = "<rank> <immunity> <usergroup>"

function PLUGIN:Call( ply, args )	
	if ( ply:EV_HasPrivilege( "Rank modification" ) ) then
		PrintTable( args )
		if ( #args == 6 and tonumber( args[2] ) and evolve.ranks[ args[1] ] and ( args[3] == "guest" or args[3] == "admin" or args[3] == "superadmin" ) and args[1] != "owner" and tonumber( args[4] ) and tonumber( args[5] ) and tonumber( args[6] ) ) then						
			evolve.ranks[ args[1] ].Immunity = args[2]
			evolve.ranks[ args[1] ].UserGroup = args[3]
			evolve.ranks[ args[1] ].Color = Color( args[4], args[5], args[6] )
			
			for _, pl in ipairs( player.GetAll() ) do
				if ( pl:GetNWString( "EV_UserGroup" ) == args[1] ) then
					pl:SetNWString( "UserGroup", args[3] )
				end
			end
			
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