/*-------------------------------------------------------------------------------------------------------------------------
	Restriction
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Restriction"
PLUGIN.Description = "Restricts weapons."
PLUGIN.Author = "Overv"

function PLUGIN:PlayerSpawnSWEP( ply, name, tbl )
	if ( table.HasValue( evolve.privileges, "@" .. name ) and !ply:EV_HasPrivilege( "@" .. name ) ) then
		return false
	end
end

function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if ( table.HasValue( evolve.privileges, "@" .. wep:GetClass() ) and !ply:EV_HasPrivilege( "@" .. wep:GetClass() ) ) then
		return false
	end
end

function PLUGIN:PlayerInitialSpawn( ply )
	ply:StripWeapons()
	timer.Simple( 2, function()
		GAMEMODE:PlayerLoadout( ply )
	end )
end

hook.Add( "Initialize", "WeaponPrivs", function()
	local weps = {}
	
	for _, wep in pairs( weapons.GetList() ) do
		table.insert( weps, "@" .. wep.ClassName )
	end
	
	table.Add( weps, {
		"@weapon_crowbar",
		"@weapon_pistol",
		"@weapon_smg1",
		"@weapon_frag",
		"@weapon_physcannon",
		"@weapon_crossbow",
		"@weapon_shotgun",
		"@weapon_357",
		"@weapon_rpg",
		"@weapon_ar2",
		"@weapon_physgun",
	} )
	
	table.Add( evolve.privileges, weps )
	
	// If this is the first time the restriction plugin runs, add all weapon privileges to all ranks so it doesn't break anything
	if ( !evolve:GetGlobalVar( "RestrictionSetUp", false ) ) then		
		for id, rank in pairs( evolve.ranks ) do
			if ( id != "owner" ) then
				table.Add( rank.Privileges, weps )
			end
		end
		
		evolve:SetGlobalVar( "RestrictionSetUp", true )
		evolve:SaveRanks()
	end
end )

evolve:RegisterPlugin( PLUGIN )