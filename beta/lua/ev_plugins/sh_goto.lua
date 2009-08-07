/*-------------------------------------------------------------------------------------------------------------------------
	Goto a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Goto"
PLUGIN.Description = "Go to a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "goto"
PLUGIN.Usage = "[player]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin( ) and ply:IsValid( ) ) then	
		local pl = evolve:findPlayer( args, ply )
		
		if ( #pl < 2 ) then			
			if ( #pl > 0 ) then
				ply:SetPos( pl[1]:GetPos( ) + Vector( 0, 0, 128 ) )
				evolve:notify( evolve.colors.blue, ply:Nick( ), evolve.colors.white, " has gone to ", evolve.colors.red, evolve:createPlayerList( pl ), evolve.colors.white, "." )
			else
				evolve:notify( ply, evolve.colors.red, "No matching players found." )
			end
		else
			evolve:notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:createPlayerList( pl, true ), evolve.colors.white, "?" )
		end
	else
		evolve:notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "goto", unpack( players ) )
	else
		return "Goto", evolve.category.teleportation
	end
end

evolve:registerPlugin( PLUGIN )