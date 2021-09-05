include("shared.lua")

function ENT:Draw()

    self:DrawModel()

    Quiditch_Proximity( Quiditch.Lang.InteractWithTeamCreationNPC, self )
end
