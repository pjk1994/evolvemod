/*-------------------------------------------------------------------------------------------------------------------------
	GUI sandbox tab
-------------------------------------------------------------------------------------------------------------------------*/

if ( GAMEMODE.Name != "Sandbox" ) then return false end

local tab = { }
local convars = {
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
local convarsliders = { }

local function applySettings( )
	for _, v in pairs( convarsliders ) do
		if ( GetConVar( v.ConVar ):GetInt( ) != v:GetValue( ) ) then
			RunConsoleCommand( "ev", "setlimit", string.sub( v.ConVar, 9 ), v:GetValue( ) )
		end
	end
end

local function updateTab( )
	for _, v in pairs( convarsliders ) do
		v:SetValue( GetConVar( v.ConVar ):GetInt( ) )
	end
	
	tab.cmdApply:SetEnabled( LocalPlayer( ):EV_IsSuperAdmin( ) )
end

local function buildTab( )
	tab.container = vgui.Create( "DPanel", evolve.menuContainer )
	tab.container:SetSize( evolve.menuw - 10, evolve.menuh - 30 )
	tab.container.Paint = function( ) end
	evolve.menuContainer:AddSheet( "Sandbox", tab.container, "gui/silkicons/world", false, false, "Sandbox gamemode settings." )
	
	tab.limits = vgui.Create( "DPanelList", tab.container )
	tab.limits:SetPos( 0, 2 )
	tab.limits:SetSize( tab.container:GetWide( ) - 1, tab.container:GetTall( ) - 31 )
	tab.limits:SetSpacing( 10 )
	tab.limits:SetPadding( 10 )
	tab.limits:EnableVerticalScrollbar( true )
	
	for i, cv in pairs( convars ) do
		local cvSlider = vgui.Create( "DNumSlider", tab.container )
		cvSlider:SetText( cv[ 2 ] )
		cvSlider:SetMin( 0 )
		cvSlider:SetMax( 500 )
		cvSlider:SetDecimals( 0 )
		cvSlider:SetValue( GetConVar( cv[ 1 ] ):GetInt( ) )
		cvSlider.ConVar = cv[ 1 ]
		tab.limits:AddItem( cvSlider )
		
		table.insert( convarsliders, cvSlider )
	end
	
	tab.cmdApply = vgui.Create( "DButton", tab.container )
	tab.cmdApply:SetPos( 0, tab.container:GetTall( ) - 21 )
	tab.cmdApply:SetSize( 120, 20 )
	tab.cmdApply:SetText( "Apply settings" )
	tab.cmdApply.DoClick = function( )
		if ( LocalPlayer( ):EV_IsSuperAdmin( ) ) then
			applySettings( )
		end
	end
	tab.cmdApply:SetEnabled( LocalPlayer( ):EV_IsSuperAdmin( ) )
end

evolve:registerMenuTab( buildTab, updateTab )