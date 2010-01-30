/*-------------------------------------------------------------------------------------------------------------------------
	Built-in prop protection
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Prop protection"
PLUGIN.Description = "Built-in prop protection."
PLUGIN.Author = "Overv"

function PLUGIN:PhysgunPickup( ply, ent )
	if ( !SPropProtection and !CPPI and !ent:IsPlayer() ) then return ply:IsAdmin() or ent:EV_GetOwner() == ply:UniqueID() end
end

function PLUGIN:GravGunPickupAllowed( ply, ent )
	if ( !SPropProtection and !CPPI ) then return ply:IsAdmin() or ent:EV_GetOwner() == ply:UniqueID() end
end

function PLUGIN:GravGunPunt( ply, ent )
	if ( !SPropProtection and !CPPI ) then return ply:IsAdmin() or ent:EV_GetOwner() == ply:UniqueID() end
end

function PLUGIN:CanTool( ply, tr )
	if ( tr.Entity:IsValid() and !SPropProtection and !CPPI ) then
		return ply:IsAdmin() or tr.Entity:EV_GetOwner() == ply:UniqueID()
	end
end

function PLUGIN:EntityTakeDamage( ent, inf, attacker, amount, dmg )
	if ( ( attacker:IsPlayer() and ent:EV_GetOwner() != attacker:UniqueID() ) or attacker:IsAdmin() ) then
		dmg:SetDamageForce( Vector( 0, 0, 0 ) )
		dmg:ScaleDamage( 0 )
	end
end

PLUGIN.Hydraulic = constraint.Hydraulic
function constraint.Hydraulic( ply, ent1, ent2, bone1, bone2, lpos1, lpos2, length1, length2, width, key, fixed, speed )
	if ( ent1:EV_GetOwner() == ent2:EV_GetOwner() or ply:IsAdmin() ) then
		return PLUGIN.Hydraulic( ply, ent1, ent2, bone1, bone2, lpos1, lpos2, length1, length2, width, key, fixed, speed )
	end
end

PLUGIN.Slider = constraint.Slider
function constraint.Slider( ent1, ent2, bone1, bone2, lpos1, lpos2, width )
	if ( ent1:EV_GetOwner() == ent2:EV_GetOwner() or ply:IsAdmin() ) then
		return PLUGIN.Slider( ent1, ent2, bone1, bone2, lpos1, lpos2, width )
	end
end

evolve:RegisterPlugin( PLUGIN )