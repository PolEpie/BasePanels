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

    Quiditch.TeamPanel.Frame = vgui.Create("DHttpImageFrame")
    Quiditch.TeamPanel.Frame:SetSize(RespH(559), RespH(368))
    Quiditch.TeamPanel.Frame:MakePopup()
    Quiditch.TeamPanel.Frame:SetImage("background_equipe.png", RespH(559), RespH(368),0,0)
    Quiditch.TeamPanel.Frame:ParentToHUD()
    Quiditch.TeamPanel.Frame:SetTitle("")
    Quiditch.TeamPanel.Frame:Center()
    function Quiditch.TeamPanel.Frame:OnClose()
        Quiditch.TeamPanel = nil
    end

    function Quiditch.TeamPanel.Frame:PostPaint(w,h)
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanel, "Quiditch_Bold", w / 2, 130 * h / 1080, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TeamPanel.Frame:GetSize()

    Quiditch.TeamPanel.TournamentsHousesButton = vgui.Create("DHttpImageButtonHover", Quiditch.TeamPanel.Frame)
    Quiditch.TeamPanel.TournamentsHousesButton:SetSize(RespH(453), RespH(84))
    Quiditch.TeamPanel.TournamentsHousesButton:SetText(Quiditch.Lang.TournamentsHousesButton)
    Quiditch.TeamPanel.TournamentsHousesButton:CenterVertical(0.41)
    Quiditch.TeamPanel.TournamentsHousesButton:SetFont("Quiditch_Normal")
    Quiditch.TeamPanel.TournamentsHousesButton:CenterHorizontal()
    Quiditch.TeamPanel.TournamentsHousesButton:SetImage("button_blue.png", RespH(436), RespH(66),RespH(8.5),RespH(9), false)
    Quiditch.TeamPanel.TournamentsHousesButton:SetImage("button_blue_selected.png", RespH(453), RespH(84),0,0, true)
    function Quiditch.TeamPanel.TournamentsHousesButton:DoClick()
        Quiditch.TeamPanel.Frame:Close()

        net.Start("Quiditch:GetHousesInfo")
        net.SendToServer()

        Quiditch.OpenTournamentsHouses()

    end

    DownloadImage("trophee.png", function(img)
        if IsValid(Quiditch.TeamPanel.TournamentsHousesButton) then
            Quiditch.TeamPanel.TournamentsHousesButton.ImageTrophee = img
            Quiditch.TeamPanel.TournamentsHousesButton.ImageTropheeMat = Material(Quiditch.TeamPanel.TournamentsHousesButton.ImageTrophee)
        end
    end)

    surface.SetFont("Quiditch_Normal")
    local wtrophee, _ = surface.GetTextSize(Quiditch.Lang.TournamentsHousesButton)

    function Quiditch.TeamPanel.TournamentsHousesButton:PostPaint(w,h)
        if not self.ImageTropheeMat then return end
        surface.SetDrawColor(Color(255, 255, 255))
        surface.SetMaterial(self.ImageTropheeMat)

        surface.DrawTexturedRect(w / 2 - wtrophee / 2 - RespH(39), h / 2 - RespH(21), RespH(29), RespH(42))
    end

    function Quiditch.TeamPanel.TournamentsHousesButton:Think()
        if self:IsHovered() then
            self:SetTextColor(Color(255,255,255))
        else
            self:SetTextColor(Color(131,169,171))
        end
    end


    Quiditch.TeamPanel.TournamentsCustomButton = vgui.Create("DHttpImageButtonHover", Quiditch.TeamPanel.Frame)
    Quiditch.TeamPanel.TournamentsCustomButton:SetSize(RespH(453), RespH(84))
    Quiditch.TeamPanel.TournamentsCustomButton:SetText(Quiditch.Lang.TournamentsCustomButton)
    Quiditch.TeamPanel.TournamentsCustomButton:CenterVertical(0.65)
    Quiditch.TeamPanel.TournamentsCustomButton:CenterHorizontal()
    Quiditch.TeamPanel.TournamentsCustomButton:SetFont("Quiditch_Normal")
    Quiditch.TeamPanel.TournamentsCustomButton:SetImage("button_blue.png", RespH(436), RespH(66),RespH(8.5),RespH(9), false)
    Quiditch.TeamPanel.TournamentsCustomButton:SetImage("button_blue_selected.png", RespH(453), RespH(84),0,0, true)

    function Quiditch.TeamPanel.TournamentsCustomButton:DoClick()
        Quiditch.TeamPanel.Frame:Close()

        net.Start("Quiditch:GetTeamsInfo")
        net.SendToServer()

        Quiditch.OpenTournamentsTeams()

    end

    function Quiditch.TeamPanel.TournamentsCustomButton:Think()
        if self:IsHovered() then
            self:SetTextColor(Color(255,255,255))
        else
            self:SetTextColor(Color(131,169,171))
        end
    end

    DownloadImage("persoteam.png", function(img)
        if IsValid(Quiditch.TeamPanel.TournamentsCustomButton) then
            Quiditch.TeamPanel.TournamentsCustomButton.ImagePerso = img
            Quiditch.TeamPanel.TournamentsCustomButton.ImagePersoMat = Material(Quiditch.TeamPanel.TournamentsCustomButton.ImagePerso)
        end
    end)

    local wperso, _ = surface.GetTextSize(Quiditch.Lang.TournamentsCustomButton)

    function Quiditch.TeamPanel.TournamentsCustomButton:PostPaint(w,h)
        if not self.ImagePersoMat then return end
        surface.SetDrawColor(Color(255, 255, 255))
        surface.SetMaterial(self.ImagePersoMat)

        surface.DrawTexturedRect(w / 2 - wperso / 2 - RespH(37), h / 2 - RespH(27), RespH(27), RespH(34))
    end

end

function Quiditch.OpenTournamentsHouses()
    --Lua refresh support
    if Quiditch.TournamentsHouses then
        return
    end

    Quiditch.TournamentsHouses = {}

    Quiditch.TournamentsHouses.Frame = vgui.Create("DHttpImageFrame")
    Quiditch.TournamentsHouses.Frame:SetSize(RespH(1140), RespH(868))
    Quiditch.TournamentsHouses.Frame:MakePopup()
    Quiditch.TournamentsHouses.Frame:SetImage("background_houses.png", RespH(1140), RespH(868),0,0)
    Quiditch.TournamentsHouses.Frame:ParentToHUD()
    Quiditch.TournamentsHouses.Frame:SetTitle("")
    Quiditch.TournamentsHouses.Frame:Center()
    function Quiditch.TournamentsHouses.Frame:OnClose()
        Quiditch.TournamentsHouses = nil
    end

    function Quiditch.TournamentsHouses.Frame:PostPaint(w,h)
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanelSelectHouse, "Quiditch_Medium", w * 0.245, 60 * h / 1080, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanelViewTeam, "Quiditch_Medium", w * 0.75, 60 * h / 1080, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TournamentsHouses.Frame:GetSize()

    Quiditch.TournamentsHouses.PanelHousesBtn = vgui.Create("DPanel", Quiditch.TournamentsHouses.Frame)
    Quiditch.TournamentsHouses.PanelHousesBtn:SetSize(width * 0.4, height * 0.8)
    Quiditch.TournamentsHouses.PanelHousesBtn:SetPos(width * 0.05, height * 0.1)
    function Quiditch.TournamentsHouses.PanelHousesBtn:Paint()

    end

    Quiditch.TournamentsHouses.PanelHousesInfo = vgui.Create("DPanel", Quiditch.TournamentsHouses.Frame)
    Quiditch.TournamentsHouses.PanelHousesInfo:SetSize(width * 0.4, height * 0.9)
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

    DownloadImage("logo_houses.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageHouses = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageHousesMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageHouses)
        end
    end)

    DownloadImage("logo_captain.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageCaptain = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageCaptainMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageCaptain)
        end
    end)

    DownloadImage("logo_seeker.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageSeeker = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageSeekerMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageSeeker)
        end
    end)

    DownloadImage("logo_beater.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageBeater = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageBeaterMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageBeater)
        end
    end)

    DownloadImage("logo_chaser.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageChaser = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageChaserMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageChaser)
        end
    end)

    DownloadImage("persoteam.png", function(img)
        if IsValid(Quiditch.TournamentsHouses.PanelHousesInfo) then
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageGoal = img
            Quiditch.TournamentsHouses.PanelHousesInfo.ImageGoalMat = Material(Quiditch.TournamentsHouses.PanelHousesInfo.ImageGoal)
        end
    end)

    local function ShowInformations(tbl, name)
        PrintTable(tbl)
        function Quiditch.TournamentsHouses.PanelHousesInfo:Paint(w, h)

            if self.ImageHousesMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageHousesMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 12 / 1080, h * 0.07, ScrH() * 24 / 1080, ScrH() * 27 / 1080)
            end

            if self.ImageCaptainMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageCaptainMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 20 / 1080, h * 0.16, ScrH() * 40 / 1080, ScrH() * 31 / 1080)
            end

            if self.ImageSeekerMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageSeekerMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 21.5 / 1080, h * 0.26, ScrH() * 43 / 1080, ScrH() * 21 / 1080)
            end

            if self.ImageBeaterMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageBeaterMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 17.5 / 1080, h * 0.34, ScrH() * 35 / 1080, ScrH() * 30 / 1080)

                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageBeaterMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 17.5 / 1080, h * 0.41, ScrH() * 35 / 1080, ScrH() * 30 / 1080)
            end

            if self.ImageChaserMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageChaserMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 16.5 / 1080, h * 0.49, ScrH() * 33 / 1080, ScrH() * 33 / 1080)

                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageChaserMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 16.5 / 1080, h * 0.56, ScrH() * 33 / 1080, ScrH() * 33 / 1080)

                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageChaserMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 16.5 / 1080, h * 0.63, ScrH() * 33 / 1080, ScrH() * 33 / 1080)
            end

            if self.ImageGoalMat then
                surface.SetDrawColor(Color(255, 255, 255))
                surface.SetMaterial(self.ImageGoalMat)
                surface.DrawTexturedRect(w * 0.08 - ScrH() * 13.5 / 1080, h * 0.715, ScrH() * 27 / 1080, ScrH() * 34 / 1080)
            end

            draw.SimpleText( Quiditch.Lang.HouseName, "Quiditch_Normal", w * 0.2, h * 0.075, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.CaptainName, "Quiditch_Normal", w * 0.2, h * 0.17, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.SeekerName, "Quiditch_Normal", w * 0.2, h * 0.26, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.BeaterName .. " n°1", "Quiditch_Normal", w * 0.2, h * 0.35, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.BeaterName .. " n°2", "Quiditch_Normal", w * 0.2, h * 0.415, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°1", "Quiditch_Normal", w * 0.2, h * 0.5, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°2", "Quiditch_Normal", w * 0.2, h * 0.57, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°3", "Quiditch_Normal", w * 0.2, h * 0.64, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.KeeperName, "Quiditch_Normal", w * 0.2, h * 0.72, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)


            draw.SimpleText( name, "Quiditch_Normal", w, h * 0.075, Quiditch.Config.Houses[name].Color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

            if (tbl.captain_name) then
                draw.SimpleText( tbl.captain_name, "Quiditch_Normal", w, h * 0.17, Color(244,209,108), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.17, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.seeker_name) then
                draw.SimpleText( tbl.seeker_name, "Quiditch_Normal", w, h * 0.26, Color(255,179,0), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.26, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.beater1_name) then
                draw.SimpleText( tbl.beater1_name, "Quiditch_Normal", w, h * 0.35, Color(169,113,90), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.35, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.beater2_name) then
                draw.SimpleText( tbl.beater2_name, "Quiditch_Normal", w, h * 0.415, Color(169,113,90), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.415, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.chaser1_name) then
                draw.SimpleText( tbl.chaser1_name, "Quiditch_Normal", w, h * 0.5, Color(141,82,40), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.5, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.chaser2_name) then
                draw.SimpleText( tbl.chaser2_name, "Quiditch_Normal", w, h * 0.57, Color(141,82,40), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.57, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.chaser3_name) then
                draw.SimpleText( tbl.chaser3_name, "Quiditch_Normal", w, h * 0.64, Color(141,82,40), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.64, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            if (tbl.keeper_name) then
                draw.SimpleText( tbl.keeper_name, "Quiditch_Normal", w, h * 0.72, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            else
                draw.SimpleText( "Place Libre", "Quiditch_Normal", w, h * 0.72, Color(52,80,87), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
            end

            draw.SimpleText( Quiditch.Lang.CaptainName, "Quiditch_Normal", w * 0.2, h * 0.17, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.SeekerName, "Quiditch_Normal", w * 0.2, h * 0.26, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.BeaterName .. " n°1", "Quiditch_Normal", w * 0.2, h * 0.35, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.BeaterName .. " n°2", "Quiditch_Normal", w * 0.2, h * 0.415, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°1", "Quiditch_Normal", w * 0.2, h * 0.5, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°2", "Quiditch_Normal", w * 0.2, h * 0.57, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText( Quiditch.Lang.ChaserName  .. " n°3", "Quiditch_Normal", w * 0.2, h * 0.64, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            draw.SimpleText( Quiditch.Lang.KeeperName, "Quiditch_Normal", w * 0.2, h * 0.72, Color(52,80,87), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        end
    end

    for k, v in pairs(tbl) do
        Quiditch.TournamentsHouses.HousesButton[k] = vgui.Create("DHttpImageButtonHover", Quiditch.TournamentsHouses.PanelHousesBtn)
        Quiditch.TournamentsHouses.HousesButton[k]:SetSize(1, ScrH() * 84 / 1080)
        Quiditch.TournamentsHouses.HousesButton[k]:Dock(TOP)
        Quiditch.TournamentsHouses.HousesButton[k]:SetFont("Quiditch_Normal")
        Quiditch.TournamentsHouses.HousesButton[k]:SetImage(Quiditch.Config.Houses[k].ButtonMaterial .. ".png", ScrH() * 436 / 1080, ScrH() * 66 / 1080,ScrH() * 8.5 / 1080,ScrH() * 9 / 1080, false)
        Quiditch.TournamentsHouses.HousesButton[k]:SetImage(Quiditch.Config.Houses[k].ButtonMaterial .. "_selected.png", ScrH() * 453 / 1080, ScrH() * 84 / 1080,0,0, true)
        if table.Count(Quiditch.TournamentsHouses.HousesButton) == 1 then
            Quiditch.TournamentsHouses.HousesButton[k]:DockMargin(0,height * 0.015,0,height * 0.006)
        else
            Quiditch.TournamentsHouses.HousesButton[k]:DockMargin(0,0,0,height * 0.006)
        end

        Quiditch.TournamentsHouses.HousesButton[k]:SetText(k)

        Quiditch.TournamentsHouses.HousesButton[k].Think = function(self)
            if self:IsHovered() then
                self:SetTextColor(Color(255,255,255))
            else
                self:SetTextColor(Color(244,209,108))
            end
        end

        Quiditch.TournamentsHouses.HousesButton[k].DoClick = function()

            Quiditch.HomeSelect = k
            ShowInformations(v, k)

        end
    end

    local firstvalue, firstrow = next(tbl)
    Quiditch.HomeSelect = firstvalue
    ShowInformations(firstrow, firstvalue)


    Quiditch.TournamentsHouses.ApplyButton = vgui.Create("DHttpImageButtonHover", Quiditch.TournamentsHouses.PanelHousesInfo)
    Quiditch.TournamentsHouses.ApplyButton:SetSize(ScrH() * 453 / 1080, ScrH() * 84 / 1080)
    Quiditch.TournamentsHouses.ApplyButton:CenterVertical(0.86)
    Quiditch.TournamentsHouses.ApplyButton:CenterHorizontal()
    Quiditch.TournamentsHouses.ApplyButton:SetFont("Quiditch_Normal")
    Quiditch.TournamentsHouses.ApplyButton:SetText(Quiditch.Lang.ApplyButton)
    Quiditch.TournamentsHouses.ApplyButton:SetImage("button_blue.png", ScrH() * 436 / 1080, ScrH() * 66 / 1080,ScrH() * 8.5 / 1080,ScrH() * 9 / 1080, false)
    Quiditch.TournamentsHouses.ApplyButton:SetImage("button_blue_selected.png", ScrH() * 453 / 1080, ScrH() * 84 / 1080,0,0, true)
    function Quiditch.TournamentsHouses.ApplyButton:DoClick()
        net.Start("Quiditch:ApplyTeam")
        net.WriteString(Quiditch.HomeSelect)
        net.SendToServer()

        Quiditch.TournamentsHouses.Frame:Close()
    end

    function Quiditch.TournamentsHouses.ApplyButton:Think()
        if self:IsHovered() then
            self:SetTextColor(Color(255,255,255))
        else
            self:SetTextColor(Color(131,169,171))
        end
    end


end )


function Quiditch.OpenTournamentsTeams()
    --Lua refresh support
    if Quiditch.TournamentsTeams then
        return
    end

    Quiditch.TournamentsTeams = {}

    Quiditch.TournamentsTeams.Frame = vgui.Create("DHttpImageFrame")
    Quiditch.TournamentsTeams.Frame:SetSize(RespH(1139), RespH(866))
    Quiditch.TournamentsTeams.Frame:MakePopup()
    Quiditch.TournamentsTeams.Frame:SetImage("background_teams.png", RespH(1139), RespH(866),0,0)
    Quiditch.TournamentsTeams.Frame:ParentToHUD()
    Quiditch.TournamentsTeams.Frame:SetTitle("")
    Quiditch.TournamentsTeams.Frame:Center()
    function Quiditch.TournamentsTeams.Frame:OnClose()
        Quiditch.TournamentsTeams = nil
    end

    function Quiditch.TournamentsTeams.Frame:PostPaint(w,h)
        draw.SimpleText(Quiditch.Lang.HeaderTeamPanel, "DermaDefault", w / 2, RespH(20), Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local width, height = Quiditch.TournamentsTeams.Frame:GetSize()

    Quiditch.TournamentsTeams.PanelHousesBtn = vgui.Create("DScrollPanel", Quiditch.TournamentsTeams.Frame)
    Quiditch.TournamentsTeams.PanelHousesBtn:SetSize(RespH(470), RespH(579))
    Quiditch.TournamentsTeams.PanelHousesBtn:SetPos(RespH(38), RespH(109))
--[[    function Quiditch.TournamentsTeams.PanelHousesBtn:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    end]]




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


    local i = 1
    for k, v in pairs(tbl) do
        for ii=1, 40 do
            Quiditch.TournamentsTeams.HousesButton[k] = vgui.Create("DButton", Quiditch.TournamentsTeams.PanelHousesBtn)
            Quiditch.TournamentsTeams.HousesButton[k]:SetSize(1, ScrH() * 44 / 1080)
            Quiditch.TournamentsTeams.HousesButton[k]:Dock(TOP)
            Quiditch.TournamentsTeams.HousesButton[k]:SetFont("Quiditch_Normal")

            Quiditch.TournamentsTeams.HousesButton[k]:SetText(k)

            Quiditch.TournamentsTeams.HousesButton[k].Think = function(self)
                if self:IsHovered() then
                    self:SetTextColor(Color(255,255,255))
                else
                    self:SetTextColor(Color(63,84,88))
                end
            end

            if i % 2 == 0 then
                Quiditch.TournamentsTeams.HousesButton[k].Paint = function(self,w,h)

                    draw.RoundedBox(0,0,0,w,h,Color(7,30,36))

                    if Quiditch.HomeSelect == k then

                    end
                end
            else
                Quiditch.TournamentsTeams.HousesButton[k].Paint = function(self,w,h)

                    draw.RoundedBox(0,0,0,w,h,Color(17,39,44))

                    if Quiditch.HomeSelect == k then


                    end
                end
            end
            Quiditch.TournamentsTeams.HousesButton[k].DoClick = function()

                Quiditch.HomeSelect = k
                ShowInformations(v, k)

            end

            Quiditch.TournamentsTeams.PanelHousesBtn:Add(Quiditch.TournamentsTeams.HousesButton[k])

            i = i + 1
        end
    end

    if i > 13 then
        local sbar = Quiditch.TournamentsTeams.PanelHousesBtn:GetVBar()
        function sbar:Paint(w, h)
            draw.RoundedBox(0, RespH(2), RespH(20), w - RespH(4), h - RespH(130), Color(19,59,66))
        end
        function sbar.btnUp:Paint(w, h)
        end
        function sbar.btnDown:Paint(w, h)
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(w / 2, 0, 0, w, w, Color(100, 200, 0))
        end

        Quiditch.TournamentsTeams.PanelHousesBtn:SetWide(RespH(515))--RespH(470)
        Quiditch.TournamentsTeams.PanelHousesBtn:GetCanvas():DockPadding(0,0,RespH(30),0)
        Quiditch.TournamentsTeams.PanelHousesBtn.VBar:Dock(0)
        Quiditch.TournamentsTeams.PanelHousesBtn.VBar:SetPos(RespH(490),1)
        Quiditch.TournamentsTeams.PanelHousesBtn.VBar:CenterVertical(0.7)
        Quiditch.TournamentsTeams.PanelHousesBtn.VBar:SetSize(RespH(15),RespH(600))
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