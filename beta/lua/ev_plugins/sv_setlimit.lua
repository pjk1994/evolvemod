/*-------------------------------------------------------------------------------------------------------------------------
	Set a sandbox limit
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Sandbox limit"
PLUGIN.Description = "Set a sandbox limit."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "setlimit"
PLUGIN.Usage = "<limit, e.g. thrusters> <value>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsSuperAdmin( ) ) then
		if ( tonumber( args[ 2 ] ) ) then
			if ( !GetConVar( "sbox_max" .. args[ 1 ] ) ) then
				evolve:notify( ply, evolve.colors.red, "Unknown convar!" )
			else
				RunConsoleCommand( "sbox_max" .. args[ 1 ], args[ 2 ] )
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has set sbox_max" .. args[ 1 ] .. " to " .. math.Round( args[ 2 ] ) .. "." )
			end
		else
			evolve:notify( ply, evolve.colors.red, "The value must be a number!" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )