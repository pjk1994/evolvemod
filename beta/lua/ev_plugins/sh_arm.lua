/*-------------------------------------------------------------------------------------------------------------------------
	Arm a player with the default loadout
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Arm"
PLUGIN.Description = "Arm players with the default loadout."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "arm"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		
		for _, pl in pairs( pls ) do
			GAMEMODE:PlayerLoadout( pl )
		end
		
		if ( #pls > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has armed ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "arm", unpack( players ) )
	else
		return "Arm", evolve.category.actions
	end
end

evolve:RegisterPlugin( PLUGIN )