/*-------------------------------------------------------------------------------------------------------------------------
	Kill a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Slay"
PLUGIN.Description = "Kill a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "slay"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local players = evolve:FindPlayer( args, ply )
		
		for _, pl in ipairs( players ) do
			pl:Kill()
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has slayed ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "slay", unpack( players ) )
	else
		return "Slay", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )