/*-------------------------------------------------------------------------------------------------------------------------
	Kill a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Slay"
PLUGIN.Description = "Kill a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "slay"
PLUGIN.Usage = "[players]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local victims = evolve:FindPlayer( args, ply )
		if ( #victims > 0 and !victims[1]:IsValid() ) then victims = { } end
		
		for _, victim in ipairs( victims ) do
			victim:Kill()
		end
		
		if ( #victims > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has slayed ", evolve.colors.red, evolve:CreatePlayerList( victims ), evolve.colors.white, "." )
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