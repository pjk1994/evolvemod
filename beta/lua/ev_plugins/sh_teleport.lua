/*-------------------------------------------------------------------------------------------------------------------------
	Teleport a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Teleport"
PLUGIN.Description = "Teleport a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "tp"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Teleport" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Teleport" ) and ply:IsValid() ) then	
		local players = evolve:FindPlayer( args, ply )
		local tr = ply:GetEyeTraceNoCursor()
		
		if ( #players > 0 ) then
			for i, pl in ipairs( players ) do
				pl:SetPos( tr.HitPos + i * tr.HitNormal * 128 )
			end
			
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has teleported ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "tp", unpack( players ) )
	else
		return "Teleport", evolve.category.teleportation
	end
end

evolve:RegisterPlugin( PLUGIN )