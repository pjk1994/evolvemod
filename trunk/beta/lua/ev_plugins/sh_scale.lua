/*-------------------------------------------------------------------------------------------------------------------------
	Set the scale of a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = { }
PLUGIN.Title = "Scale"
PLUGIN.Description = "Set the scale of a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "scale"
PLUGIN.Usage = "<players> <x> <y> <z>"

function PLUGIN:Call( ply, args )
	if ( ply:EV_IsAdmin() ) then		
		if ( #args >= 3 ) then
			local x = tonumber( args[ #args - 2 ] )
			local y = tonumber( args[ #args - 1 ] )
			local z = tonumber( args[ #args ] )
			table.remove( args, #args )
			table.remove( args, #args )
			table.remove( args, #args )
			
			if ( x and y and z ) then
				local pls = evolve:FindPlayer( args, ply )
				local scale = Vector( x, y, z )
				
				if ( #pls > 0 ) then
					for _, pl in ipairs( pls ) do
						pl:SetNWVector( "EV_Scale", scale )
						pl:SetJumpPower( 200 + ( scale.z - 1 ) * 50 )
					end
					
					evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has set the scale of ", evolve.colors.red, evolve:CreatePlayerList( pls ), evolve.colors.white, " to " .. x .. ", " .. y .. ", " .. z .. "." )
				else
					evolve:Notify( ply, evolve.colors.red, "No matching players found." )
				end
			else
				evolve:Notify( ply, evolve.colors.red, "The X, Y and Z scale parameters need to be numeric!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify at least one player and three scale parameters!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:RenderScene()
	for _, v in ipairs( player.GetAll() ) do
		if ( v:GetModelScale() != v:GetNWVector( "EV_Scale", Vector( 1, 1, 1 ) ) ) then
			v:SetModelScale( v:GetNWVector( "EV_Scale", Vector( 1, 1, 1 ) ) )
		end
	end
end

function PLUGIN:CalcView( ply, origin, angles, fov )
	local onedist = ply:GetShootPos() - ply:GetPos()
	
	origin = origin + Vector( 0, 0, onedist.z * ( ply:GetNWVector( "EV_Scale", Vector( 1, 1, 1 ) ).z - 1 ) )
	
	return GAMEMODE.BaseClass:CalcView( ply, origin, angles, fov )
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.Add( players, arg )
		RunConsoleCommand( "ev", "scale", unpack( players ) )
	else
		return "Scale", evolve.category.actions, {
			{ "Default", { 1, 1, 1 } },
			{ "Giant", { 10, 10, 10 } },
			{ "Dwarf", { 0.7, 0.7, 0.7 } },
			{ "Ant", { 0.2, 0.2, 0.2 } },
			{ "Two dimensional", { 0.05, 1, 1 } }
		}
	end
end

evolve:RegisterPlugin( PLUGIN )