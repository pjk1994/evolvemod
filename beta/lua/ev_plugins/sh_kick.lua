/*-------------------------------------------------------------------------------------------------------------------------
	Kick a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Kick"
PLUGIN.Description = "Kick a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "kick"
PLUGIN.Usage = "<player> [reason]"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then
		local pl = evolve:FindPlayer( args[1] )
		
		if ( #pl > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		elseif ( #pl == 1 ) then
			local reason = table.concat( args, " ", 2 ) or ""
			
			for _, v in ipairs( ents.GetAll() ) do
				if ( v:EV_GetOwner() == pl[1]:UniqueID() ) then v:Remove() end
			end
			
			if ( #reason == 0 || reason == "No reason" ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has kicked ", evolve.colors.red, evolve:CreatePlayerList( pl ), evolve.colors.white, "." )
				pl[1]:Kick( "No reason specified." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has kicked ", evolve.colors.red, evolve:CreatePlayerList( pl ), evolve.colors.white, " with the reason \"" .. reason .."\"." )
				pl[1]:Kick( reason )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "kick", players[1], arg )
	else
		return "Kick", evolve.category.administration, { { "No reason" }, { "Spammer" }, { "Asshole" }, { "Mingebag" }, { "Retard" }, { "Continued despite warning" } }
	end
end

evolve:RegisterPlugin( PLUGIN )