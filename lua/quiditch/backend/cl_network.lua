Quiditch.PlayerTeam = nil
net.Receive("Quiditch:Sync", function()
    local team = net.ReadString()

    if team == "" then
        Quiditch.PlayerTeam = nil
    else
        Quiditch.PlayerTeam = team

        local is_house = false
        for k,v in pairs(Quiditch.Config.Houses) do
            if v.Name == team then
                is_house = true
            end
        end

        Quiditch.PlayerTeam_IsHouse = is_house
    end
end)