include("shared.lua")
local imgui = include("quiditch/ui/cl_imgui.lua")
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:DrawTranslucent()
    -- While you can of course use the imgui.Start3D2D function for entities, IMGUI has some special syntax
    -- This function automatically calls LocalToWorld and LocalToWorldAngles respectively on position and angles
    self.Panel = self.Panel or 1

    if imgui.Entity3D2D(self, Vector(0, 0, 0), Angle(0, 0, 0), 0.1) then
        -- render things
        if self.Panel == 1 then
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, 500, 500)
            if imgui.xTextButton("Commencer un match", "!Roboto@24", 150, 175, 200, 50, 1, Color(0,0,0)) then
                self.Panel = 2
            end
        elseif self.Panel == 2 then
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, 500, 500)
            if imgui.xTextButton("Commencer un match", "!Roboto@24", 150, 175, 200, 50, 1, Color(0,0,0)) then

            end
        end
    imgui.End3D2D()
    end
end