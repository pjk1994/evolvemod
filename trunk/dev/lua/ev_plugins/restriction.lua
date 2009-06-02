/*-------------------------------------------------------------------------------------------------------------------------
	View commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Hooks = {}
PLUGIN.Title = "Restriction"
PLUGIN.Description = "Restrict weapons and entities"
PLUGIN.Author = "Overv"
PLUGIN.Chat = "restrict"

function PLUGIN:Call( ply, args )
	// First check if the caller is an admin
	if ply:IsSuperAdmin() then
		
		if args[1] then
			if tonumber( args[1] ) then
				if tonumber( args[1] ) > 0 then
					Evolve:SetSetting( "WeaponEntityRestriction", true )
				else
					Evolve:SetSetting( "WeaponEntityRestriction", false )
				end
			else
				return false, "The enabled argument must be numeric!"
			end
		else
			Evolve:SetSetting( "WeaponEntityRestriction", !Evolve:GetSetting( "WeaponEntityRestriction" ) )
		end
		
		if Evolve:GetSetting( "WeaponEntityRestriction" ) then
			return true, ply:Nick() .. " has restricted weapons and entities for guests."
		else
			return true, ply:Nick() .. " has allowed weapons and entities for guests."
		end
		
	else
		
		return false, "You are not a super administrator!"
		
	end
end

function PLUGIN:PlayerLoadout( ply )
	if Evolve:GetSetting( "WeaponEntityRestriction" ) and !ply:GetGroup( ).immunity > Evolve:GetGroup( "Guest" ).immunity then
		ply:Give( "weapon_physgun" )
		ply:Give( "weapon_physcannon" )
		ply:Give( "gmod_camera" )
		ply:Give( "gmod_tool" )
		
		return true
	end
end

function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if Evolve:GetSetting( "WeaponEntityRestriction" ) then
		local class = wep:GetClass()
		if class == "weapon_physgun" or class == "weapon_physcannon" or class == "gmod_camera" or class == "gmod_tool" or class == ply:GetNWString( "EV_AllowedWeapon", "" ) then
			if ply:GetNWString( "EV_AllowedWeapon", "" ) != "" then ply:SetNWString( "EV_AllowedWeapon", "" ) end
			return true
		elseif !ply:GetGroup( ).immunity > Evolve:GetGroup( "Guest" ).immunity then
			wep:Remove()
			return false
		end
	end
end

function PLUGIN:PlayerSpawnSENT( ply )
	if Evolve:GetSetting( "WeaponEntityRestriction" ) and !ply:GetGroup( ).immunity > Evolve:GetGroup( "Guest" ).immunity then
		return false
	end
end

Evolve:RegisterPlugin( PLUGIN )