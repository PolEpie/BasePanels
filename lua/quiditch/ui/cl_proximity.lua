Quiditch.Proximity = {}

function Quiditch_Proximity( texte, self )
    if LocalPlayer():GetPos():DistToSqr(self:GetPos()) <= 10000 then
        local btn = input.LookupBinding( "+use", true )
        if btn == nil then return end

        local alpha
        if not Quiditch.Proximity[self:EntIndex()] then
            Quiditch.Proximity[self:EntIndex()] = 0
        else
            Quiditch.Proximity[self:EntIndex()] = Lerp(RealFrameTime() * 10, Quiditch.Proximity[self:EntIndex()], 255)
        end

        btn = string.upper(btn)

        local vect = self:GetPos() + self:OBBCenter()
        local pos = vect:ToScreen()

        surface.SetFont("Quiditch_Normal")
        local wtexte, _ = surface.GetTextSize(texte)



        surface.SetFont("Quiditch_Bold")
        local wtouche, _ = surface.GetTextSize(btn)

        local w, h = (ScrH() * 60 / 1080) + wtexte + wtouche, ScrH() * 50 / 1080

        cam.Start2D()
        surface.SetDrawColor( 255, 255, 255 )

        draw.RoundedBox(0, pos.x - w / 2, pos.y - h / 2, w, h, Color(30, 30, 30, Quiditch.Proximity[self:EntIndex()] - 25))
        draw.RoundedBox(h * 0.4,pos.x - w / 2 + (ScrH() * 10 / 1080), pos.y - h * 0.4, wtouche + (ScrH() * 25 / 1080), h * 0.8, Color(255,255,255, Quiditch.Proximity[self:EntIndex()]))


        draw.SimpleText(btn, "Quiditch_Bold", pos.x - w / 2 + h * 0.4 , pos.y, Color(0,0,0,Quiditch.Proximity[self:EntIndex()]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        draw.SimpleText(texte, "Quiditch_Normal", pos.x - w / 2 + h * 0.8 + wtouche + (ScrH() * 5 / 1080) , pos.y, Color(255,255,255,Quiditch.Proximity[self:EntIndex()]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        cam.End2D()
    elseif Quiditch.Proximity[self:EntIndex()] ~= nil and Quiditch.Proximity[self:EntIndex()] > 0.5 then
        local btn = input.LookupBinding( "+use", true )
        if btn == nil then return end


        Quiditch.Proximity[self:EntIndex()] = Lerp(RealFrameTime() * 18, Quiditch.Proximity[self:EntIndex()], 0)

        btn = string.upper(btn)

        local vect = self:GetPos() + self:OBBCenter()
        local pos = vect:ToScreen()

        local w, h = ScrH() * 300 / 1080, ScrH() * 50 / 1080

        cam.Start2D()
        surface.SetDrawColor( 255, 255, 255 )

        draw.RoundedBox(0, pos.x - w / 2, pos.y - h / 2, w, h, Color(30, 30, 30, Quiditch.Proximity[self:EntIndex()] - 25))
        draw.RoundedBox(h * 0.4,pos.x - w * 0.35 - h * 0.4 , pos.y - h * 0.4, h * 0.8, h * 0.8, Color(255,255,255, Quiditch.Proximity[self:EntIndex()]))


        draw.SimpleText(btn, "Quiditch_Bold", pos.x - w * 0.35 , pos.y, Color(0,0,0,Quiditch.Proximity[self:EntIndex()]), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText(texte, "Quiditch_Normal", pos.x - w * 0.2 , pos.y, Color(255,255,255,Quiditch.Proximity[self:EntIndex()]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        cam.End2D()
    end
end