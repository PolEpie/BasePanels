util.AddNetworkString("Quiditch:GetHousesInfo")
util.AddNetworkString("Quiditch:GetTeamsInfo")
util.AddNetworkString("Quiditch:ApplyTeam")
util.AddNetworkString("Quiditch:Notification")
util.AddNetworkString("Quiditch:OpenPanel")
util.AddNetworkString("Quiditch:CreateTeam")
util.AddNetworkString("Quiditch:Sync")

net.Receive("Quiditch:GetHousesInfo", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    net.Start("Quiditch:GetHousesInfo")
    net.WriteTable(Quiditch.Houses)
    net.Send(ply)

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:CreateTeam", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    local teamName = net.ReadString()

    if ply:CanAfford(Quiditch.Config.TeamCreationPrice) then
        if Quiditch.Teams[teamName] then
            Quiditch.Notif(Quiditch.Lang.NameAlreadyExist, 1, ply)
            return
        end

        if Quiditch.Players[ply:SteamID64()] then
            Quiditch.Notif(Quiditch.Lang.PlayerAlreadyInTeam, 1, ply)
            return
        end

        ply:addMoney(-Quiditch.Config.TeamCreationPrice)
        Quiditch.CreateTeam(teamName, ply)
        Quiditch.Notif(Quiditch.Lang.TeamCreated, 0, ply)
    end

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:GetTeamsInfo", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    net.Start("Quiditch:GetTeamsInfo")
    net.WriteTable(Quiditch.Teams)
    net.Send(ply)

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:ApplyTeam", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    local teamName = net.ReadString()

    if Quiditch.Houses[teamName] then

        if Quiditch.Houses[teamName]["request"] ~= nil and Quiditch.Houses[teamName]["request"][ply:SteamID64()] ~= nil then
            Quiditch.Notif(Quiditch.Lang.ApplyAlreadyDoneNotification, 0, ply)
        else
            Quiditch.Notif(Quiditch.Lang.ApplyNotification, 0, ply)

            Quiditch.AddRequestToTeam(teamName, ply, true)
        end

    elseif Quiditch.Teams[teamName] then

        if Quiditch.Teams[teamName]["request"] ~= nil and Quiditch.Teams[teamName]["request"][ply:SteamID64()] ~= nil then
            Quiditch.Notif(Quiditch.Lang.ApplyAlreadyDoneNotification, 0, ply)
        else
            Quiditch.Notif(Quiditch.Lang.ApplyNotification, 0, ply)

            Quiditch.AddRequestToTeam(teamName, ply, false)
        end
    end

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:AcceptTeam", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    local uid = net.ReadString()
    local teamName = Quiditch.Players[ply:SteamID64()]

    if not teamName then
        return
    end

    if Quiditch.Houses[teamName] and team.GetName(ply:Team()) == Quiditch.Config.Houses[teamName].Job then

        Quiditch.AddPlayerToTeam(ply, teamName)

        for k, v in pairs(Quiditch.JobList) do
            if Quiditch.Houses[teamName][v] ~= nil then
                local p = player.GetBySteamID64(Quiditch.Houses[teamName][v])

                if p then
                    Quiditch.Notif(string.format(Quiditch.Lang.PlayerJoined, ply:Name(), 0, p)
                end
            end
        end

    elseif Quiditch.Teams[teamName] and Quiditch.Teams[teamName].captain == ply:SteamID64() then

        Quiditch.AddPlayerToTeam(ply, teamName)

         for k, v in pairs(Quiditch.JobList) do
            if Quiditch.Teams[teamName][v] ~= nil then
                local p = player.GetBySteamID64(Quiditch.Teams[teamName][v])

                if p then
                    Quiditch.Notif(string.format(Quiditch.Lang.PlayerJoined, ply:Name(), 0, p)
                end
            end
        end
    end

    Quiditch.Notif(string.format(Quiditch.Lang.PlayerJoinedTeam, teamName, 0, p)

    ply.LastQuiditchNet = os.time() + 1
end )

net.Receive("Quiditch:InviteTeam", function(_, ply)
    if not ply:Alive() then return end
    if ply.LastQuiditchNet ~= nil and ply.LastQuiditchNet > os.time() then return end

    local uid = net.ReadString()
    local teamName = Quiditch.Players[ply:SteamID64()]

    if not teamName then
        return
    end

    Quiditch.VerifyPlayerTeam(ply, function()

        if Quiditch.Houses[teamName] and team.GetName(ply:Team()) == Quiditch.Config.Houses[teamName].Job then

            Quiditch.AddPlayerToTeam(ply, teamName)

            for k, v in pairs(Quiditch.JobList) do
                if Quiditch.Houses[teamName][v] ~= nil then
                    local p = player.GetBySteamID64(Quiditch.Houses[teamName][v])

                    if p then
                        Quiditch.Notif(string.format(Quiditch.Lang.PlayerJoined, ply:Name(), 0, p)
                    end
                end
            end

        elseif Quiditch.Teams[teamName] and Quiditch.Teams[teamName].captain == ply:SteamID64() then

            Quiditch.AddPlayerToTeam(ply, teamName)

             for k, v in pairs(Quiditch.JobList) do
                if Quiditch.Teams[teamName][v] ~= nil then
                    local p = player.GetBySteamID64(Quiditch.Teams[teamName][v])

                    if p then
                        Quiditch.Notif(string.format(Quiditch.Lang.PlayerJoined, ply:Name(), 0, p)
                    end
                end
            end
        end

        local p = player.GetBySteamID64(uid)

        if p then
            Quiditch.Notif(string.format(Quiditch.Lang.PlayerInviteTeam, teamName, 0, p)
        end

    end, function()
        Quiditch.Notif(Quiditch.Lang.PlayerAlreadyInTeam, 1, ply)
    end)

    ply.LastQuiditchNet = os.time() + 1
end )



local meta = FindMetaTable("Player")
function meta:QuiditchSync()
    net.Start("Quiditch:Sync")
    net.WriteString(Quiditch.Players[self:SteamID64()] or "")
    net.Send(self)
end

hook.Add("PlayerInitialSpawn", "Quiditch:FirstSync",function(ply)
    ply:QuiditchSync()
end)