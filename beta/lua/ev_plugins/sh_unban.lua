/*-------------------------------------------------------------------------------------------------------------------------
	Unban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Unban"
PLUGIN.Description = "Unban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "unban"
PLUGIN.Usage = "<steamid|nick>"
PLUGIN.Privileges = { "Unban" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Unban" ) ) then
		if ( args[1] ) then
			local uniqueID
			
			if ( string.match( args[1], "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
				uniqueID = evolve:UniqueIDByProperty( "SteamID", args[1], true )
			else
				uniqueID = evolve:UniqueIDByProperty( "Nick", args[1], false )
			end
			
			if ( uniqueID and evolve:GetProperty( uniqueID, "BanEnd" ) and ( evolve:GetProperty( uniqueID, "BanEnd" ) > os.time() or evolve:GetProperty( uniqueID, "BanEnd" ) == 0 ) ) then
				evolve:SetProperty( uniqueID, "BanEnd", nil )
				evolve:CommitProperties()
				
				evolve:Notify( evolve.colors.red, ply:Nick() .. " has unbanned " .. evolve:GetProperty( uniqueID, "Nick" ) .. "." )
			elseif ( uniqueID ) then
				evolve:Notify( ply, evolve.colors.red, evolve:GetProperty( uniqueID, "Nick" ) .. " is not currently banned." )
			else
				evolve:Notify( ply, evolve.colors.red, "No matching players found!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify a SteamID or nickname!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )