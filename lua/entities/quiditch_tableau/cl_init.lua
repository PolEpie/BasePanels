include("shared.lua")
local imgui = include("quiditch/ui/cl_imgui.lua")
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
    -- While you can of course use the imgui.Start3D2D function for entities, IMGUI has some special syntax
    -- This function automatically calls LocalToWorld and LocalToWorldAngles respectively on position and angles
    self.Panel = self.Panel or 1

    if Quiditch.PlayerTeam then
        if imgui.Entity3D2D(self, Vector(0, 0, 0), Angle(0, 0, 0), 0.1) then
            -- render things

            if self.Panel == 1 then
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(-250, -250, 1000, 1000)
                if imgui.xTextButton("Commencer un match", "Quiditch_Bold", -100, 175,700, 100, 1, Color(0,0,0)) then
                    if Quiditch.PlayerTeam_IsHouse then
                        self.Panel = 2
                        net.Start("Quiditch:GetHousesInfo")
                        net.SendToServer()
                    else
                        self.Panel = 3
                        net.Start("Quiditch:GetTeamsInfo")
                        net.SendToServer()
                    end
                end
            elseif self.Panel == 2 then
                if Quiditch.HousesInfo ~= nil then
                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawRect(-500, -250, 1500, 1000)
                    if imgui.xTextButton(Quiditch.Config.Houses[1].Name, "Quiditch_Bold", 400, -100, 500, 100, 1, Color(0,0,0)) then
                        Quiditch.HousesSelected = Quiditch.Config.Houses[1].Name
                    end
                    if imgui.xTextButton(Quiditch.Config.Houses[2].Name, "Quiditch_Bold", 400, 100, 500, 100, 1, Color(0,0,0)) then
                        Quiditch.HousesSelected = Quiditch.Config.Houses[2].Name
                    end
                    if imgui.xTextButton(Quiditch.Config.Houses[3].Name, "Quiditch_Bold", 400, 300, 500, 100, 1, Color(0,0,0)) then
                        Quiditch.HousesSelected = Quiditch.Config.Houses[3].Name
                    end
                    if imgui.xTextButton(Quiditch.Config.Houses[4].Name, "Quiditch_Bold", 400, 500, 500, 100, 1, Color(0,0,0)) then
                        Quiditch.HousesSelected = Quiditch.Config.Houses[4].Name
                    end
                else
                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawRect(0, 0, 500, 500)

                    draw.SimpleText("Chargement...", "Quiditch_Bold", 250,250,Color(0,0,0), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

                end
            elseif self.Panel == 3 then
                if Quiditch.TeamsInfo ~= nil then
                    if not Quiditch.TeamsSelected or not Quiditch.TeamsInfo[Quiditch.TeamsSelected] then
                        Quiditch.TeamsSelected, _ = next(Quiditch.TeamsInfo)
                    end

                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawRect(-500, -600, 3000, 1600)

                    surface.SetDrawColor(0, 0, 0)
                    surface.DrawRect(500, -400, 800, 1350)
--[[
                    if imgui.xTextButton(Quiditch.Config.Houses[1].Name, "Quiditch_Bold", 400, -100, 500, 100, 1, Color(0,0,0)) then
                        Quiditch.TeamsSelected = Quiditch.Config.Houses[1].Name
                    end]]

                    local tbl = Quiditch.TeamsInfo[Quiditch.TeamsSelected]

                    draw.SimpleText( "Votre Equipe", "Quiditch_Normal", 0, -550, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.CaptainName .. " : " .. (tbl.captain_name or "Place Libre"), "Quiditch_Normal", -400, -400, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( Quiditch.Lang.SeekerName .. " : " .. (tbl.seeker_name or "Place Libre"), "Quiditch_Normal", -400, -200, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.BeaterName .. " :", "Quiditch_Normal", -400, 0, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.beater1_name or "Place Libre"), "Quiditch_Normal", -350, 100, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.beater2_name or "Place Libre"), "Quiditch_Normal", -350, 200, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.ChaserName .. " :", "Quiditch_Normal", -400, 400, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser1_name or "Place Libre"), "Quiditch_Normal", -350, 500, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser2_name or "Place Libre"), "Quiditch_Normal", -350, 600, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser3_name or "Place Libre"), "Quiditch_Normal", -350, 700, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.KeeperName .. " : " .. (tbl.keeper_name or "Place Libre"), "Quiditch_Normal", -400, 900, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    surface.DrawRect(450, -500, 5, 1480)
                    draw.SimpleText( "Liste des équipes", "Quiditch_Normal", 900, -550, Color(0,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    -------------------
                    surface.DrawRect(1350, -500, 5, 1480)

                    draw.SimpleText( Quiditch.Lang.CaptainName .. " : " .. (tbl.captain_name or "Place Libre"), "Quiditch_Normal", 1500, -400, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( Quiditch.Lang.SeekerName .. " : " .. (tbl.seeker_name or "Place Libre"), "Quiditch_Normal", 1500, -200, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.BeaterName .. " :", "Quiditch_Normal", 1500, 0, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.beater1_name or "Place Libre"), "Quiditch_Normal", 1550, 100, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.beater2_name or "Place Libre"), "Quiditch_Normal", 1550, 200, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.ChaserName .. " :", "Quiditch_Normal", 1500, 400, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser1_name or "Place Libre"), "Quiditch_Normal", 1550, 500, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser2_name or "Place Libre"), "Quiditch_Normal", 1550, 600, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    draw.SimpleText( (tbl.chaser3_name or "Place Libre"), "Quiditch_Normal", 1550, 700, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    draw.SimpleText( Quiditch.Lang.KeeperName .. " : " .. (tbl.keeper_name or "Place Libre"), "Quiditch_Normal", 1500, 900, Color(0,0,0), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

                    if not Quiditch.PosX then
                        Quiditch.PosX = 150
                    end

                    if not Quiditch.PosY then
                        Quiditch.PosY = 150
                    end

                    if imgui.xTextButton("RTfdgg", "Quiditch_Bold", Quiditch.PosX, Quiditch.PosY, 500, 100, 1, Color(255,0,0)) then
                        Quiditch.PosX,Quiditch.PosY = imgui.CursorPos()
                        Quiditch.PosX = Quiditch.PosX - 250
                        Quiditch.PosY = Quiditch.PosY - 50
                    end



                else
                    surface.SetDrawColor(255, 255, 255)
                    surface.DrawRect(0, 0, 500, 500)

                    draw.SimpleText("Chargement...", "Quiditch_Bold", 250,250,Color(0,0,0), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

                end
            end
            imgui.End3D2D()
        else
            self.Panel = nil
        end
    end
end