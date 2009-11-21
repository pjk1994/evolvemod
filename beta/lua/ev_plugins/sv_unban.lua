/*-------------------------------------------------------------------------------------------------------------------------
	Unban a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Unban"
PLUGIN.Description = "Unban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "unban"
PLUGIN.Usage = "<steamid>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsSuperAdmin() ) then
		if ( args[1] and string.match( args[1] or "", "^STEAM_[0-5]:[0-9]:[0-9]+$" ) ) then
			for i, item in ipairs( evolve:Plugin( "Ban" ).bans ) do
				if ( item.steamID == args[1] ) then
					local nick = " (" .. evolve:Plugin( "Player Info" ):NickBySteamID( args[1] ) .. ")" or ""
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has unbanned ", evolve.colors.red, args[1] .. nick, evolve.colors.white .. "." )
					
					table.remove( evolve:Plugin( "Ban" ).bans, i )
					
					return
				end
			end
			
			evolve:Notify( ply, evolve.colors.red, "No ban found with the specified SteamID!" )
		else
			evolve:Notify( ply, evolve.colors.red, "No SteamID specified!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end