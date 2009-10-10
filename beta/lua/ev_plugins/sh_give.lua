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
	if ( ply:EV_IsAdmin() ) then
		local pls = evolve:FindPlayer( args, ply )
		if ( #pls > 0 and !pls[1]:IsValid() ) then pls = { } end
		local wep = ""
		if ( #args < 2 ) then
			evolve:Notify( ply, evolve.colors.red, "No weapon specified!" )
		else
			wep = args[ #args ]
			
			if ( #pls > 0 ) then
				for _, pl in pairs( pls ) do
					pl:Give( wep )
				end
				
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has given ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, " a " .. wep .. "." )
			else
				evolve:Notify( ply, evolve.colors.red, "No matching players found." )
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "give", unpack( players ) )
	else
		return "Give", evolve.category.actions, {
			{ "Gravity gun", "weapon_physcannon" },
			{ "Physgun", "weapon_physgun" },
			{ "Crowbar", "weapon_crowbar" },
			{ "Stunstick", "weapon_stunstick" },
			{ "Pistol", "weapon_pistol" },
			{ ".357", "weapon_357" },
			{ "SMG", "weapon_smg1" },
			{ "Shotgun", "weapon_shotgun" },
			{ "Crossbow", "weapon_crossbow" },
			{ "AR2", "weapon_ar2" },
			{ "Bug bait", "weapon_bugbait" },
			{ "RPG", "weapon_rpg" },
			{ "Toolgun", "gmod_tool" },
			{ "Camera", "gmod_camera" }
		}
	end
end

evolve:RegisterPlugin( PLUGIN )