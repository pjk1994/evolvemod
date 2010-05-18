/*-------------------------------------------------------------------------------------------------------------------------
	Mute a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Mute"
PLUGIN.Description = "Mute a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "mute"
PLUGIN.Usage = "[players] [1/0]"
PLUGIN.Privileges = { "Mute" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Mute" ) ) then
		local players = evolve:FindPlayer( args, ply, true )
		local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0
		
		for _, pl in ipairs( players ) do
			pl.EV_Muted = enabled
		end
		
		if ( #players > 0 ) then
			if ( enabled ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has muted ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has unmuted ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:PlayerCanHearPlayersVoice( ply1, ply2 )
	if ( ply1.EV_Muted or ply2.EV_Muted ) then return false end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "mute", unpack( players ) )
	else
		return "Mute", evolve.category.punishment, { { "Enable", 1 }, { "Disable", 0 } }
	end
end

evolve:RegisterPlugin( PLUGIN )