net.Receive("Quiditch:OpenPanel", function()
    local panelName = net.ReadString()

    if panelName == "TeamList" then
        Quiditch.OpenTeamPanel()
    elseif panelName == "TeamCreation" then
        Quiditch.OpenTeamCreationPanel()
    end
end)

net.Receive("Quiditch:Notification", function()
    local txt = net.ReadString()
    local type = net.ReadUInt(3)

    notification.AddLegacy(txt, type, 5)
end)

function Quiditch.OpenTeamPanel()

    --Lua refresh support
    if Quiditch.TeamPanel then
        return
    end

    Quiditch.TeamPanel = {}

    Quiditch.TeamPanel.Frame = vgui.Create("DFrame")
    Quiditch.TeamPanel.Frame:SetSize(ScrH() * 0.33, ScrH() * 0.66)
    Quiditch.TeamPanel.Frame:MakePopup()
    Quiditch.TeamPanel.Frame:ParentToHUD()
    Quiditch.TeamPanel.Frame:SetTitle("")
    Quiditch.TeamPanel.Frame:Center()
    function Quiditch.TeamPanel.Frame:OnClose()
        Quiditch.TeamPanel = nil
    end

    function Quiditch.TeamPanel.Frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanel, "DermaDefault", w / 2, 30 * h / 1080, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TeamPanel.Frame:GetSize()

    Quiditch.TeamPanel.TournamentsHousesButton = vgui.Create("DButton", Quiditch.TeamPanel.Frame)
    Quiditch.TeamPanel.TournamentsHousesButton:SetSize(width * 0.8, height * 0.05)
    Quiditch.TeamPanel.TournamentsHousesButton:SetText(Quiditch.Lang.TournamentsHousesButton)
    Quiditch.TeamPanel.TournamentsHousesButton:CenterVertical(0.35)
    Quiditch.TeamPanel.TournamentsHousesButton:CenterHorizontal()

    function Quiditch.TeamPanel.TournamentsHousesButton:DoClick()
        Quiditch.TeamPanel.Frame:Close()

        net.Start("Quiditch:GetHousesInfo")
        net.SendToServer()

        Quiditch.OpenTournamentsHouses()

    end

    Quiditch.TeamPanel.TournamentsCustomButton = vgui.Create("DButton", Quiditch.TeamPanel.Frame)
    Quiditch.TeamPanel.TournamentsCustomButton:SetSize(width * 0.8, height * 0.05)
    Quiditch.TeamPanel.TournamentsCustomButton:SetText(Quiditch.Lang.TournamentsCustomButton)
    Quiditch.TeamPanel.TournamentsCustomButton:CenterVertical(0.65)
    Quiditch.TeamPanel.TournamentsCustomButton:CenterHorizontal()

    function Quiditch.TeamPanel.TournamentsCustomButton:DoClick()
        Quiditch.TeamPanel.Frame:Close()

        net.Start("Quiditch:GetTeamsInfo")
        net.SendToServer()

        Quiditch.OpenTournamentsTeams()

    end

end

function Quiditch.OpenTournamentsHouses()
    --Lua refresh support
    if Quiditch.TournamentsHouses then
        return
    end

    Quiditch.TournamentsHouses = {}

    Quiditch.TournamentsHouses.Frame = vgui.Create("DFrame")
    Quiditch.TournamentsHouses.Frame:SetSize(ScrH() * 0.66, ScrH() * 0.4)
    Quiditch.TournamentsHouses.Frame:MakePopup()
    Quiditch.TournamentsHouses.Frame:ParentToHUD()
    Quiditch.TournamentsHouses.Frame:SetTitle("")
    Quiditch.TournamentsHouses.Frame:Center()
    function Quiditch.TournamentsHouses.Frame:OnClose()
        Quiditch.TournamentsHouses = nil
    end

    function Quiditch.TournamentsHouses.Frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanel, "DermaDefault", w / 2, 30 * h / 1080, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TournamentsHouses.Frame:GetSize()

    Quiditch.TournamentsHouses.PanelHousesBtn = vgui.Create("DPanel", Quiditch.TournamentsHouses.Frame)
    Quiditch.TournamentsHouses.PanelHousesBtn:SetSize(width * 0.4, height * 0.8)
    Quiditch.TournamentsHouses.PanelHousesBtn:SetPos(width * 0.05, height * 0.1)
    function Quiditch.TournamentsHouses.PanelHousesBtn:Paint()

    end

    Quiditch.TournamentsHouses.PanelHousesInfo = vgui.Create("DPanel", Quiditch.TournamentsHouses.Frame)
    Quiditch.TournamentsHouses.PanelHousesInfo:SetSize(width * 0.4, height * 0.8)
    Quiditch.TournamentsHouses.PanelHousesInfo:SetPos(width * 0.55, height * 0.1)
    function Quiditch.TournamentsHouses.PanelHousesInfo:Paint()

    end


    Quiditch.TournamentsHouses.HousesButton = {}


end

net.Receive("Quiditch:GetHousesInfo", function(_, ply)

    local tbl = net.ReadTable()

    Quiditch.HousesInfo = tbl

    if Quiditch.TournamentsHouses == nil then return end

    local width, height = Quiditch.TournamentsHouses.Frame:GetSize()

    local function ShowInformations(tbl)
        function Quiditch.TournamentsHouses.PanelHousesInfo:Paint(w, h)
            draw.SimpleText( Quiditch.Lang.CaptainName .. " : " .. (tbl.captain_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.1, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.SeekerName .. " : " .. (tbl.seeker_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.2, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.BeaterName .. " :", "DermaDefault", w * 0.25, h * 0.3, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.beater1_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.35, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.beater2_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.4, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.ChaserName .. " :", "DermaDefault", w * 0.25, h * 0.5, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser1_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.55, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser2_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.6, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser3_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.65, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.KeeperName .. " : " .. (tbl.keeper_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.75, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    for k, v in pairs(tbl) do
        Quiditch.TournamentsHouses.HousesButton[k] = vgui.Create("DButton", Quiditch.TournamentsHouses.PanelHousesBtn)
        Quiditch.TournamentsHouses.HousesButton[k]:SetSize(1, height * 0.15)
        Quiditch.TournamentsHouses.HousesButton[k]:Dock(TOP)
        if table.Count(Quiditch.TournamentsHouses.HousesButton) == 1 then
            Quiditch.TournamentsHouses.HousesButton[k]:DockMargin(0,height * 0.025,0,height * 0.05)
        else
            Quiditch.TournamentsHouses.HousesButton[k]:DockMargin(0,0,0,height * 0.05)
        end

        Quiditch.TournamentsHouses.HousesButton[k]:SetText(k)

        Quiditch.TournamentsHouses.HousesButton[k].DoClick = function()

            Quiditch.HomeSelect = k
            ShowInformations(v)

        end
    end

    local firstvalue, firstrow = next(tbl)
    Quiditch.HomeSelect = firstvalue
    ShowInformations(firstrow)

    Quiditch.TournamentsHouses.ApplyButton = vgui.Create("DButton", Quiditch.TournamentsHouses.PanelHousesInfo)
    Quiditch.TournamentsHouses.ApplyButton:SetSize(1, height * 0.1)
    Quiditch.TournamentsHouses.ApplyButton:Dock(BOTTOM)
    Quiditch.TournamentsHouses.ApplyButton:SetText(Quiditch.Lang.ApplyButton)
    function Quiditch.TournamentsHouses.ApplyButton:DoClick()
        net.Start("Quiditch:ApplyTeam")
        net.WriteString(Quiditch.HomeSelect)
        net.SendToServer()

        Quiditch.TournamentsHouses.Frame:Close()
    end

end )


function Quiditch.OpenTournamentsTeams()
    --Lua refresh support
    if Quiditch.TournamentsTeams then
        return
    end

    Quiditch.TournamentsTeams = {}

    Quiditch.TournamentsTeams.Frame = vgui.Create("DFrame")
    Quiditch.TournamentsTeams.Frame:SetSize(ScrH() * 0.66, ScrH() * 0.4)
    Quiditch.TournamentsTeams.Frame:MakePopup()
    Quiditch.TournamentsTeams.Frame:ParentToHUD()
    Quiditch.TournamentsTeams.Frame:SetTitle("")
    Quiditch.TournamentsTeams.Frame:Center()
    function Quiditch.TournamentsTeams.Frame:OnClose()
        Quiditch.TournamentsTeams = nil
    end

    function Quiditch.TournamentsTeams.Frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanel, "DermaDefault", w / 2, 30 * h / 1080, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TournamentsTeams.Frame:GetSize()

    Quiditch.TournamentsTeams.PanelHousesBtn = vgui.Create("DScrollPanel", Quiditch.TournamentsTeams.Frame)
    Quiditch.TournamentsTeams.PanelHousesBtn:SetSize(width * 0.4, height * 0.8)
    Quiditch.TournamentsTeams.PanelHousesBtn:SetPos(width * 0.05, height * 0.1)
    function Quiditch.TournamentsTeams.PanelHousesBtn:Paint()

    end

    Quiditch.TournamentsTeams.PanelHousesInfo = vgui.Create("DPanel", Quiditch.TournamentsTeams.Frame)
    Quiditch.TournamentsTeams.PanelHousesInfo:SetSize(width * 0.4, height * 0.8)
    Quiditch.TournamentsTeams.PanelHousesInfo:SetPos(width * 0.55, height * 0.1)
    function Quiditch.TournamentsTeams.PanelHousesInfo:Paint()

    end


    Quiditch.TournamentsTeams.HousesButton = {}


end

net.Receive("Quiditch:GetTeamsInfo", function(_, ply)
    local tbl = net.ReadTable()

    Quiditch.TeamsInfo = tbl

    if Quiditch.TournamentsTeams == nil then return end

    local width, height = Quiditch.TournamentsTeams.Frame:GetSize()

    local function ShowInformations(tbl)
        function Quiditch.TournamentsTeams.PanelHousesInfo:Paint(w, h)
            draw.SimpleText( Quiditch.Lang.CaptainName .. " : " .. (tbl.captain_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.1, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.SeekerName .. " : " .. (tbl.seeker_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.2, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.BeaterName .. " :", "DermaDefault", w * 0.25, h * 0.3, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.beater1_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.35, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.beater2_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.4, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.ChaserName .. " :", "DermaDefault", w * 0.25, h * 0.5, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser1_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.55, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser2_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.6, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( (tbl.chaser3_name or "Place Libre"), "DermaDefault", w * 0.3, h * 0.65, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.KeeperName .. " : " .. (tbl.keeper_name or "Place Libre"), "DermaDefault", w * 0.25, h * 0.75, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end

    for k, v in pairs(tbl) do
        Quiditch.TournamentsTeams.HousesButton[k] = vgui.Create("DButton")
        Quiditch.TournamentsTeams.HousesButton[k]:SetSize(1, height * 0.15)
        Quiditch.TournamentsTeams.HousesButton[k]:Dock(TOP)
        if table.Count(Quiditch.TournamentsTeams.HousesButton) == 1 then
            Quiditch.TournamentsTeams.HousesButton[k]:DockMargin(0,height * 0.025,0,height * 0.05)
        else
            Quiditch.TournamentsTeams.HousesButton[k]:DockMargin(0,0,0,height * 0.05)
        end

        Quiditch.TournamentsTeams.HousesButton[k]:SetText(k)

        Quiditch.TournamentsTeams.HousesButton[k].DoClick = function()

            Quiditch.TeamSelect = k
            ShowInformations(v)

        end

        Quiditch.TournamentsTeams.PanelHousesBtn:Add(Quiditch.TournamentsTeams.HousesButton[k])
    end

    local firstvalue, firstrow = next(tbl)
    if firstrow ~= nil then
        Quiditch.TeamSelect = firstvalue
        ShowInformations(firstrow)
    else
        function Quiditch.TournamentsTeams.PanelHousesInfo:Paint(w, h)
            draw.SimpleText( Quiditch.Lang.NoTeam, "DermaDefault", w / 2, h / 2, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    Quiditch.TournamentsTeams.ApplyButton = vgui.Create("DButton", Quiditch.TournamentsTeams.PanelHousesInfo)
    Quiditch.TournamentsTeams.ApplyButton:SetSize(1, height * 0.1)
    Quiditch.TournamentsTeams.ApplyButton:Dock(BOTTOM)
    Quiditch.TournamentsTeams.ApplyButton:SetText(Quiditch.Lang.ApplyButton)
    function Quiditch.TournamentsTeams.ApplyButton:DoClick()
        net.Start("Quiditch:ApplyTeam")
        net.WriteString(Quiditch.TeamSelect)
        net.SendToServer()

        Quiditch.TournamentsTeams.Frame:Close()
    end

end )

function Quiditch.OpenTeamCreationPanel()

    --Lua refresh support
    if Quiditch.TeamCreationPanel then
        return
    end

    Quiditch.TeamCreationPanel = {}

    Quiditch.TeamCreationPanel.Frame = vgui.Create("DFrame")
    Quiditch.TeamCreationPanel.Frame:SetSize(ScrH() * 0.66, ScrH() * 0.33)
    Quiditch.TeamCreationPanel.Frame:MakePopup()
    Quiditch.TeamCreationPanel.Frame:ParentToHUD()
    Quiditch.TeamCreationPanel.Frame:SetTitle("")
    Quiditch.TeamCreationPanel.Frame:Center()
    function Quiditch.TeamCreationPanel.Frame:OnClose()
        Quiditch.TeamCreationPanel = nil
    end

    function Quiditch.TeamCreationPanel.Frame:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255))
        draw.SimpleText(Quiditch.Lang.HeaderTeamCreationPanel, "Quiditch_Bold", w / 2, 40 * h / 1080, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)


        draw.SimpleText(string.format(Quiditch.Lang.PriceCreation, Quiditch.Config.TeamCreationPrice), "Quiditch_Petit", w / 2, 550 * h / 1080, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TeamCreationPanel.Frame:GetSize()

    Quiditch.TeamCreationPanel.TeamName = vgui.Create("DTextEntry", Quiditch.TeamCreationPanel.Frame)
    Quiditch.TeamCreationPanel.TeamName:SetSize(width * 0.7, height * 0.1)
    Quiditch.TeamCreationPanel.TeamName:SetPlaceholderText(Quiditch.Lang.TeamName)
    Quiditch.TeamCreationPanel.TeamName:CenterVertical(0.35)
    Quiditch.TeamCreationPanel.TeamName:CenterHorizontal()


    Quiditch.TeamCreationPanel.ButtonSubmit = vgui.Create("DButton", Quiditch.TeamCreationPanel.Frame)
    Quiditch.TeamCreationPanel.ButtonSubmit:SetSize(width * 0.4, height * 0.1)
    Quiditch.TeamCreationPanel.ButtonSubmit:SetText(Quiditch.Lang.CreateTeamButton)
    Quiditch.TeamCreationPanel.ButtonSubmit:CenterVertical(0.8)
    Quiditch.TeamCreationPanel.ButtonSubmit:CenterHorizontal()

    function Quiditch.TeamCreationPanel.ButtonSubmit:DoClick()
        if LocalPlayer():CanAfford(Quiditch.Config.TeamCreationPrice) then
            local teamName = Quiditch.TeamCreationPanel.TeamName:GetValue()

            if teamName ~= nil and #teamName > 1 then
                Quiditch.TeamCreationPanel.Frame:Close()

                net.Start("Quiditch:CreateTeam")
                net.WriteString(teamName)
                net.SendToServer()
            else
                notification.AddLegacy(Quiditch.Lang.BadName, 1, 5)
            end
        else
            notification.AddLegacy(Quiditch.Lang.CantAfford, 1, 5)
        end
    end

end