/*-------------------------------------------------------------------------------------------------------------------------
	Evolve GUI clientside
-------------------------------------------------------------------------------------------------------------------------*/

evolve.menuw = 400
evolve.menuh = 300

function evolve:buildMenu( )
	self.menu = vgui.Create( "DFrame" )
	self.menu:SetSize( self.menuw, self.menuh )
	self.menu:SetPos( 100, ScrH( ) / 2 - self.menuh / 2 )
	self.menu:SetDraggable( false )
	self.menu:ShowCloseButton( false )
	self.menu:SetTitle( "" )
	self.menu.Paint = function( ) end
	self.menu:MakePopup( )
	
	self.menuContainer = vgui.Create( "DPropertySheet", self.menu )
	self.menuContainer:SetPos( 0, 0 )
	self.menuContainer:SetSize( self.menuw, self.menuh )
	
	self:buildMenuPlayers( )
	self:buildMenuServerSettings( )
end

function evolve:buildMenuPlayers( )
	local tabPlayer = vgui.Create( "DPanel", self.menuContainer )
	tabPlayer:SetSize( self.menuw - 10, self.menuh - 30 )
	tabPlayer.Paint = function( ) end
	self.menuContainer:AddSheet( "Players", tabPlayer, "gui/silkicons/group", false, false, "Player commands." )
	
	local listPlayers = vgui.Create( "DComboBox", tabPlayer )
	listPlayers:SetPos( 0, 0 )
	listPlayers:SetSize( 220, tabPlayer:GetTall( ) - 26 )
	listPlayers:SetMultiple( true )
	for _, ply in pairs( player.GetAll( ) ) do
		listPlayers:AddItem( ply:Nick( ) )
	end
	
	local selectAll = vgui.Create( "DButton", tabPlayer )
	selectAll:SetPos( 0, tabPlayer:GetTall( ) - 21 )
	selectAll:SetSize( 35, 20 )
	selectAll:SetText( "All" )
	local selectNone = vgui.Create( "DButton", tabPlayer )
	selectNone:SetPos( 40, tabPlayer:GetTall( ) - 21 )
	selectNone:SetSize( 40, 20 )
	selectNone:SetText( "None" )
	local selectAdmins = vgui.Create( "DButton", tabPlayer )
	selectAdmins:SetPos( 85, tabPlayer:GetTall( ) - 21 )
	selectAdmins:SetSize( 55, 20 )
	selectAdmins:SetText( "Admins" )
	local selectNonAdmins = vgui.Create( "DButton", tabPlayer )
	selectNonAdmins:SetPos( 145, tabPlayer:GetTall( ) - 21 )
	selectNonAdmins:SetSize( 75, 20 )
	selectNonAdmins:SetText( "Non-Admins" )
	
	local commandsContainer = vgui.Create( "DPanelList", tabPlayer )
	commandsContainer:SetPos( listPlayers:GetWide( ) + 5, 0 )
	commandsContainer:SetSize( self.menuw - 15 - listPlayers:GetWide( ), tabPlayer:GetTall( ) - 1 )
end

function evolve:buildMenuServerSettings( )
	local tabSettings = vgui.Create( "DPanel", self.menuContainer )
	tabSettings:SetSize( self.menuw - 10, self.menuh - 30 )
	tabSettings.Paint = function( ) end
	self.menuContainer:AddSheet( "Server Settings", tabSettings, "gui/silkicons/wrench", false, false, "Configure the server." )
	
	
end

function evolve:openMenu( )
	if ( !self.menu ) then self:buildMenu( ) end
	self.menu:SetVisible( true )
	gui.SetMousePos( 100 + self.menuw / 2, ScrH( ) / 2 )
end

function evolve:closeMenu( )
	self.menu:SetVisible( false )
end

concommand.Add( "+ev_menu", function( )
	evolve:openMenu( )
end )
concommand.Add( "-ev_menu", function( )
	evolve:closeMenu( )
end )