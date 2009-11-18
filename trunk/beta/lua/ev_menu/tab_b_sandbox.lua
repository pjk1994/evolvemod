/*-------------------------------------------------------------------------------------------------------------------------
	Sandbox tab
-------------------------------------------------------------------------------------------------------------------------*/

local TAB = {}
TAB.Title = "Sandbox"
TAB.Description = "Sandbox gamemode settings."
TAB.Author = "Overv"

TAB.Limits = {
	{ "sbox_maxprops", "Props" },
	{ "sbox_maxragdolls", "Ragdolls" },
	{ "sbox_maxvehicles", "Vehicles" },
	{ "sbox_maxeffects", "Effects" },
	{ "sbox_maxballoons", "Balloons" },
	{ "sbox_maxnpcs", "NPCs" },
	{ "sbox_maxdynamite", "Dynamite" },
	{ "sbox_maxlamps", "Lamps" },
	{ "sbox_maxlights", "Lights" },
	{ "sbox_maxwheels", "Wheels" },
	{ "sbox_maxthrusters", "Thrusters" },
	{ "sbox_maxhoverballs", "Hoverballs" },
	{ "sbox_maxbuttons", "Buttons" },
	{ "sbox_maxemitters", "Emitters" },
	{ "sbox_maxspawners", "Spawners" },
	{ "sbox_maxturrets", "Turrets" }
}
TAB.ConVars = {
	{ "sbox_godmode", "Godmode" },
	{ "sbox_noclip", "Noclip" },
	{ "sbox_plpldamage", "No player damage" },
	{ "sbox_weapons", "Weapons" },
	{ "g_ragdoll_maxcount", "Keep NPC bodies", 8 }
}
TAB.ConVarSliders = {}
TAB.ConVarCheckboxes = { }

function TAB:ApplySettings()
	for _, v in pairs( self.ConVarSliders ) do
		if ( GetConVar( v.ConVar ):GetInt() != v:GetValue() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, v:GetValue() )
		end
	end
	
	for _, v in pairs( self.ConVarCheckboxes ) do
		if ( GetConVar( v.ConVar ):GetBool() != v:GetChecked() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, evolve:BoolToInt( v:GetChecked() ) * ( v.OnValue or 1 ) )
		end
	end
end

function TAB:Update()
	for _, v in pairs( self.ConVarSliders ) do
		v:SetValue( GetConVar( v.ConVar ):GetInt() )
	end
	
	for _, v in pairs( self.ConVarCheckboxes ) do
		v:SetChecked( GetConVar( v.ConVar ):GetInt() > 0 )
	end
	
	if ( LocalPlayer():EV_IsSuperAdmin() ) then
		self.Block:SetPos( self.Block:GetWide(), 0 )
	else
		self.Block:SetPos( 0, 0 )
	end
end

function TAB:Initialize()
	self.Container = vgui.Create( "DPanel", evolve.menuContainer )
	self.Container:SetSize( evolve.menuw - 10, evolve.menuh )
	self.Container.Paint = function() end
	evolve.menuContainer:AddSheet( self.Title, self.Container, "gui/silkicons/world", false, false, self.Description )
	
	self.LimitsContainer = vgui.Create( "DPanelList", self.Container )
	self.LimitsContainer:SetPos( 0, 2 )
	self.LimitsContainer:SetSize( self.Container:GetWide() - 150, self.Container:GetTall() - 33 )
	self.LimitsContainer:SetSpacing( 9 )
	self.LimitsContainer:SetPadding( 10 )
	self.LimitsContainer:EnableHorizontal( true )
	self.LimitsContainer:EnableVerticalScrollbar( true )
	self.LimitsContainer.Think = function( self )
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			self.applySettings = true
		elseif ( !input.IsMouseDown( MOUSE_LEFT ) and self.applySettings ) then
			TAB:ApplySettings()
			self.applySettings = false
		end
	end
	
	for i, cv in pairs( self.Limits ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvSlider = vgui.Create( "DNumSlider", self.Container )
			cvSlider:SetText( cv[2] )
			cvSlider:SetWide( self.LimitsContainer:GetWide() / 2 - 15 )
			cvSlider:SetMin( 0 )
			cvSlider:SetMax( 200 )
			cvSlider:SetDecimals( 0 )
			cvSlider:SetValue( GetConVar( cv[1] ):GetInt() )
			cvSlider.ConVar = cv[1]
			self.LimitsContainer:AddItem( cvSlider )
		
			table.insert( self.ConVarSliders, cvSlider )
		end
	end
	
	self.Settings = vgui.Create( "DPanelList", self.Container )
	self.Settings:SetPos( self.LimitsContainer:GetPos() + self.LimitsContainer:GetWide() + 5, 2 )
	self.Settings:SetSize( 145, self.Container:GetTall() - 33 )
	self.Settings:SetSpacing( 9 )
	self.Settings:SetPadding( 10 )
	self.Settings:EnableHorizontal( true )
	self.Settings:EnableVerticalScrollbar( true )
	
	for i, cv in pairs( self.ConVars ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvCheckbox = vgui.Create( "DCheckBoxLabel", self.Settings )
			cvCheckbox:SetText( cv[2] )
			cvCheckbox:SetWide( self.Settings:GetWide() - 15 )
			cvCheckbox:SetValue( GetConVar( cv[1] ):GetInt() > 0 )
			cvCheckbox.ConVar = cv[1]
			cvCheckbox.OnValue = cv[3]
			cvCheckbox.DoClick = function( self )
				TAB:ApplySettings()
			end
			self.Settings:AddItem( cvCheckbox )
			
			table.insert( self.ConVarCheckboxes, cvCheckbox )
		end
	end
	
	self.Block = vgui.Create( "DFrame", self.Container )
	self.Block:SetDraggable( false )
	self.Block:SetTitle( "" )
	self.Block:ShowCloseButton( false )
	self.Block:SetPos( 0, 0 )
	self.Block:SetSize( self.Container:GetWide(), self.Container:GetTall() )
	self.Block.Paint = function()
		surface.SetDrawColor( 46, 46, 46, 255 )
		surface.DrawRect( 0, 0, self.Block:GetWide(), self.Block:GetTall() )
		
		draw.SimpleText( "You need to be a super administrator to access this tab!", "ScoreboardText", self.Block:GetWide() / 2, self.Block:GetTall() / 2 - 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	end
	if ( LocalPlayer():EV_IsSuperAdmin() ) then self.Block:SetPos( self.Block:GetWide(), 0 ) end
end

evolve:RegisterMenuTab( TAB )