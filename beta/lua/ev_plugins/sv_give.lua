/*-------------------------------------------------------------------------------------------------------------------------
	Give a weapon to a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Give weapon"
PLUGIN.Description = "Give a weapon to a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "give"
PLUGIN.Usage = "<players> <weapon>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) ) then
		local pls = evolve:findPlayer( args, ply )
		if ( #pls > 0 and !pls[1]:IsValid( ) ) then pls = { } end
		local wep = ""
		if ( #args < 2 ) then
			evolve:notify( ply, evolve.colors.red, "No weapon specified!" )
		else
			wep = args[ #args ]
			
			if ( #pls > 0 ) then
				for _, pl in pairs( pls ) do
					pl:Give( wep )
				end
				
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has given ", evolve.colors.red, evolve:createPlayerList( pls ), evolve.colors.white, " a " .. wep .. "." )
			else
				evolve:notify( ply, evolve.colors.red, "No matching players found." )
			end
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:registerPlugin( PLUGIN )