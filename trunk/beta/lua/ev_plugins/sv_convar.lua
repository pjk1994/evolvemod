/*-------------------------------------------------------------------------------------------------------------------------
	Set a convar
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Cconvar"
PLUGIN.Description = "Set a convar."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "convar"
PLUGIN.Usage = "<limit, e.g. sbox_maxthrusters or ai_disabled> <value>"
PLUGIN.AllowedCommands = {
	"sbox_",
}

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsSuperAdmin( ) ) then
		if ( tonumber( args[ 2 ] ) ) then
			if ( !GetConVar( args[ 1 ] ) ) then
				evolve:notify( ply, evolve.colors.red, "Unknown convar!" )
			elseif ( GetConVar( args[ 1 ] ):GetInt( ) == tonumber( args[ 2 ] ) ) then
				evolve:notify( ply, evolve.colors.red, "That convar is already set to that value." )
			else
				local allowed = false
				for _, v in pairs( self.AllowedCommands ) do
					if ( string.Left( args[ 1 ], #v ) == v ) then
						allowed = true
						break
					end
				end
				
				if ( allowed ) then
					RunConsoleCommand( args[ 1 ], args[ 2 ] )
					evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has changed ", evolve.colors.red, args[ 1 ], evolve.colors.white, " to " .. math.Round( args[ 2 ] ) .. "." )
				else
					evolve:notify( ply, evolve.colors.red, "You are not allowed to change that convar!" )
				end
			end
		else
			evolve:notify( ply, evolve.colors.red, "The value must be a number!" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )