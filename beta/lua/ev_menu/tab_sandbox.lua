/*-------------------------------------------------------------------------------------------------------------------------
	GUI sandbox tab
-------------------------------------------------------------------------------------------------------------------------*/

if ( GAMEMODE.Name != "Sandbox" and !GAMEMODE.IsSandboxDerived ) then return false end

local tab = { }
local limits = {
	{ "sbox_maxprops", "Max Props" },
	{ "sbox_maxragdolls", "Max Ragdolls" },
	{ "sbox_maxvehicles", "Max Vehicles" },
	{ "sbox_maxeffects", "Max Effects" },
	{ "sbox_maxballoons", "Max Balloons" },
	{ "sbox_maxnpcs", "Max NPCs" },
	{ "sbox_maxdynamite", "Max Dynamite" },
	{ "sbox_maxlamps", "Max Lamps" },
	{ "sbox_maxlights", "Max Lights" },
	{ "sbox_maxwheels", "Max Wheels" },
	{ "sbox_maxthrusters", "Max Thrusters" },
	{ "sbox_maxhoverballs", "Max Hoverballs" },
	{ "sbox_maxbuttons", "Max Buttons" },
	{ "sbox_maxemitters", "Max Emitters" },
	{ "sbox_maxspawners", "Max Spawners" },
	{ "sbox_maxturrets", "Max Turrets" }
}
local convars = {
	{ "sbox_godmode", "Godmode" },
	{ "sbox_noclip", "Noclip" },
	{ "sbox_plpldamage", "No player damage" },
	{ "sbox_weapons", "Weapons" }
}
local convarsliders = { }
local convarcheckboxes = { }

local function boolToInt( bool )
	if ( bool ) then
		return 1
	else
		return 0
	end
end

local function applySettings( )
	for _, v in pairs( convarsliders ) do
		if ( GetConVar( v.ConVar ):GetInt( ) != v:GetValue( ) ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, v:GetValue( ) )
		end
	end
	
	for _, v in pairs( convarcheckboxes ) do
		if ( GetConVar( v.ConVar ):GetInt( ) != boolToInt( v:GetChecked( ) ) ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, boolToInt( v:GetChecked( ) ) )
		end
	end
end

local function updateTab( )
	for _, v in pairs( convarsliders ) do
		v:SetValue( GetConVar( v.ConVar ):GetInt( ) )
	end
	
	for _, v in pairs( convarcheckboxes ) do
		v:SetValue( GetConVar( v.ConVar ):GetInt( ) )
	end
end

local function buildTab( )
	tab.container = vgui.Create( "DPanel", evolve.menuContainer )
	tab.container:SetSize( evolve.menuw - 10, evolve.menuh )
	tab.container.Paint = function( ) end
	evolve.menuContainer:AddSheet( "Sandbox", tab.container, "gui/silkicons/world", false, false, "Sandbox gamemode settings." )
	
	tab.limits = vgui.Create( "DPanelList", tab.container )
	tab.limits:SetPos( 0, 2 )
	tab.limits:SetSize( tab.container:GetWide( ) - 150, tab.container:GetTall( ) - 33 )
	tab.limits:SetSpacing( 9 )
	tab.limits:SetPadding( 10 )
	tab.limits:EnableHorizontal( true )
	tab.limits:EnableVerticalScrollbar( true )
	tab.limits.Think = function( self )
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			self.applySettings = true
		elseif ( !input.IsMouseDown( MOUSE_LEFT ) and self.applySettings and LocalPlayer( ):EV_IsSuperAdmin( ) ) then
			applySettings( )
			self.applySettings = false
		end
	end
	
	for i, cv in pairs( limits ) do
		local cvSlider = vgui.Create( "DNumSlider", tab.container )
		cvSlider:SetText( cv[ 2 ] )
		cvSlider:SetWide( tab.limits:GetWide( ) / 2 - 15 )
		cvSlider:SetMin( 0 )
		cvSlider:SetMax( 200 )
		cvSlider:SetDecimals( 0 )
		cvSlider:SetValue( GetConVar( cv[ 1 ] ):GetInt( ) )
		cvSlider.ConVar = cv[ 1 ]
		tab.limits:AddItem( cvSlider )
		
		table.insert( convarsliders, cvSlider )
	end
	
	tab.settings = vgui.Create( "DPanelList", tab.container )
	tab.settings:SetPos( tab.limits:GetPos( ) + tab.limits:GetWide( ) + 5, 2 )
	tab.settings:SetSize( 145, tab.container:GetTall( ) - 33 )
	tab.settings:SetSpacing( 9 )
	tab.settings:SetPadding( 10 )
	tab.settings:EnableHorizontal( true )
	tab.settings:EnableVerticalScrollbar( true )
	
	for i, cv in pairs( convars ) do
		local cvCheckbox = vgui.Create( "DCheckBoxLabel", tab.settings )
		cvCheckbox:SetText( cv[ 2 ] )
		cvCheckbox:SetWide( tab.settings:GetWide( ) - 15 )
		cvCheckbox:SetValue( GetConVar( cv[ 1 ] ):GetInt( ) )
		cvCheckbox.ConVar = cv[ 1 ]
		cvCheckbox.DoClick = function( )
			applySettings( )
		end
		tab.settings:AddItem( cvCheckbox )
		
		table.insert( convarcheckboxes, cvCheckbox )
	end
end

evolve:registerMenuTab( buildTab, updateTab )