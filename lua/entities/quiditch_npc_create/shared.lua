ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "NPC Creation Equipe"
ENT.Author = "Alx_Dela"
ENT.Category = "Quiditch"
ENT.Contact = "N/A"
ENT.Instructions = "N/A"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(byUsingAnim)
    self.AutomaticFrameAdvance = byUsingAnim
end