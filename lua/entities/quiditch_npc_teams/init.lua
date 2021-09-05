AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel(Quiditch.Config.NPC.TeamList)
    self:SetHullType(HULL_HUMAN) --< NE PAS TOUCHER
    self:SetHullSizeNormal() --< NE PAS TOUCHER
    self:SetNPCState(NPC_STATE_SCRIPT) --< NE PAS TOUCHER
    self:SetSolid(SOLID_BBOX) --< NE PAS TOUCHER
    self:CapabilitiesAdd(CAP_ANIMATEDFACE) --< NE PAS TOUCHER
    self:SetUseType(SIMPLE_USE) --< NE PAS TOOUCHER
    self:DropToFloor() --< NE PAS TOUCHER
    self:SetMaxYawSpeed(90) --< NE PAS TOUCHER
end

function ENT:OnTakeDamage()
    return false
end

function ENT:Use(ply)
    if ply:IsPlayer() then
        net.Start("Quiditch:OpenPanel")
        net.WriteString("TeamList")
        net.Send(ply)
    end
end
