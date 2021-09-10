--[[
    Database Setup
]]

require("mysqloo")

Quiditch.DB = mysqloo.connect("51.89.128.245", "u33715_2O8346HaHl", "n2hOmZTN56bt2BCR", "s33715_test", 3306)

function Quiditch.DB:onConnected()

    print("[QUIDITCH] Database has connected!")

    --[[
       Select charset for accent
    ]]

    local q = self:prepare([[SET NAMES 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';]])
    function q:onSuccess(data)
        print("[QUIDITCH] Database Charset successfully set !")
    end

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q:start()

    --[[
        Create teams table and add row for each default houses
     ]]

    local q2 = self:prepare([[create table if not exists `quiditch-teams`
    (
        name varchar(120) not null primary key,
        is_house tinyint default 0 null,
        captain varchar(64) null,
        constraint `quiditch-houses_name_uindex`
            unique (name)
    );]])

    function q2:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-teams` created !")

        for _, v in ipairs(Quiditch.Config.Houses) do

            local q = Quiditch.DB:prepare([[INSERT INTO `quiditch-teams` (name, is_house)
            SELECT "]] .. v.Name .. [[", 1
            WHERE NOT EXISTS (SELECT * FROM `quiditch-teams` where name = "]] .. v.Name .. [[")]])

            function q:onSuccess(data)
                print("[QUIDITCH] Row " .. v.Name .. " added successfully!")
            end

            function q:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q:start()
        end
    end

    function q2:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q2:start()

    --[[
        Table of players
      ]]

    local q3 = self:prepare([[create table if not exists `quiditch-players`
    (
        team varchar(120) not null,
        uid varchar(64) null,
        name varchar(120) null,
        job varchar(50) null
    );
    ]])

    function q3:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-players` created !")
    end

    function q3:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q3:start()

    --[[
        Table of requests
      ]]

    local q4 = self:prepare([[create table if not exists `quiditch-request`
    (
        name varchar(120) null,
        uid varchar(64) null,
        team varchar(120) null
    );
    ]])

    function q4:onSuccess(data)
        print("[QUIDITCH] Table `quiditch-request` created !")
    end

    function q4:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q4:start()

    timer.Simple(3, function()
        Quiditch.Houses = {}
        Quiditch.Players = {}
        Quiditch.Teams = {}
        local q = Quiditch.DB:prepare("select * from `quiditch-teams`;")

        function q:onSuccess(data)
            for _, v in ipairs(data) do
                if v.is_house == 1 then
                    Quiditch.Houses[v.name] = {  }
                else
                    Quiditch.Teams[v.name] = {  }
                end
            end

            local q2 = Quiditch.DB:prepare("select * from `quiditch-players`;")

            function q2:onSuccess(data)
                for _, v in ipairs(data) do
                    if Quiditch.Houses[v.team] then
                        if v.job then
                            Quiditch.Houses[v.team][v.job .. "_uid"] = v.uid
                            Quiditch.Houses[v.team][v.job .. "_name"] = v.name
                        else
                            Quiditch.Houses[v.team]["noteam"] = Quiditch.Houses[v.team]["noteam"] or {}

                            Quiditch.Houses[v.team]["noteam"][#Quiditch.Houses[v.team]["noteam"] + 1] = {
                                ["name"] = v.name,
                                ["uid"] = v.uid
                            }
                        end
                        Quiditch.Players[v.uid] = v.team
                    elseif Quiditch.Teams[v.team] then
                        if v.job then
                            Quiditch.Teams[v.team][v.job .. "_uid"] = v.uid
                            Quiditch.Teams[v.team][v.job .. "_name"] = v.name
                        else
                            Quiditch.Teams[v.team]["noteam"] = Quiditch.Teams[v.team]["noteam"] or {}

                            Quiditch.Teams[v.team]["noteam"][#Quiditch.Teams[v.team]["noteam"] + 1] = {
                                ["name"] = v.name,
                                ["uid"] = v.uid
                            }
                        end
                        Quiditch.Players[v.uid] = v.team
                    end
                end
            end

            function q2:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q2:start()

            --[[
                Collect requests to teams
             ]]

            local q3 = Quiditch.DB:prepare("select * from `quiditch-request`;")

            function q3:onSuccess(data)
                for _, v in ipairs(data) do
                    if Quiditch.Houses[v.team] then
                        Quiditch.Houses[v.team]["request"] = Quiditch.Houses[v.team]["request"] or {}

                        Quiditch.Houses[v.team]["request"][v.uid] = v.name
                    elseif Quiditch.Teams[v.team] then
                        Quiditch.Teams[v.team]["request"] = Quiditch.Teams[v.team]["request"] or {}

                        Quiditch.Teams[v.team]["request"][v.uid] = v.name
                    end
                end
            end

            function q3:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q3:start()
        end

        function q:onError(err, sql)
            print("[QUIDITCH] Query errored!")
            print("[QUIDITCH] Query:", sql)
            print("[QUIDITCH] Error:", err)
            print("[QUIDITCH] " .. debug.traceback())
        end

        q:start()
    end)
end

function Quiditch.DB:onConnectionFailed(err)

    print("[QUIDITCH] Error Database Connexion")
    print(err)

end

Quiditch.DB:connect()





--[[
    Database functions
]]

Quiditch.JobList = {
    "captain", "seeker", "beater1", "beater2", "chaser1", "chaser2", "chaser3", "keeper"
}



function Quiditch.AddRequestToTeam(teamName, ply, is_house)

    if is_house then
        Quiditch.Houses[teamName]["request"] = Quiditch.Houses[teamName]["request"] or {}

        Quiditch.Houses[teamName]["request"][ply:SteamID64()] = ply:Name()
    else
        Quiditch.Teams[teamName]["request"] = Quiditch.Teams[teamName]["request"] or {}

        Quiditch.Teams[teamName]["request"][ply:SteamID64()] = ply:Name()
    end

    local q = Quiditch.DB:prepare("insert into `quiditch-request` (name, uid, team) values (?,?,?);")

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q:setString(1,ply:Name())
    q:setString(2,ply:SteamID64())
    q:setString(3, teamName)
    q:start()

end

function Quiditch.AddPlayerToTeam(ply, teamName)

    for k, v in pairs(Quiditch.JobList) do
        if Quiditch.Teams[teamName][v] == nil then
             Quiditch.Teams[teamName][v] = ply:SteamID64()

             local q = Quiditch.DB:prepare("delete from `quiditch-request` where uid=?;")

            function q:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q:setString(1, ply:SteamID64())
            q:start()

            Quiditch.Players[ply:SteamID64()] = teamName

             local q2 = Quiditch.DB:prepare("insert into `quiditch-players` (team,uid,name, job) values (?,?,?,?);")

            function q2:onError(err, sql)
                print("[QUIDITCH] Query errored!")
                print("[QUIDITCH] Query:", sql)
                print("[QUIDITCH] Error:", err)
                print("[QUIDITCH] " .. debug.traceback())
            end

            q2:setString(1, teamName)
            q2:setString(2, ply:SteamID64())
            q2:setString(3, ply:Name())
            q2:setString(4, k)
            q2:start()

            break

        end
    end
￿
    ply:QuiditchSync()
end

function Quiditch.CreateTeam(teamName, ply)

    local q = Quiditch.DB:prepare("insert into `quiditch-teams` (name, is_house, captain) values (?,0,?);")

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    q:setString(1, teamName)
    q:setString(2, ply:SteamID64())
    q:start()

    Quiditch.Teams[teamName] = {
        ['captain'] = ply:SteamID64(),
    }

    Quiditch.AddPlayerToTeam(ply, teamName)
end

function Quiditch.VerifyPlayerTeam(ply, cb1, cb2)
    local q = Quiditch.DB:prepare("select * from `quiditch-players` where uid=?;")

    function q:onError(err, sql)
        print("[QUIDITCH] Query errored!")
        print("[QUIDITCH] Query:", sql)
        print("[QUIDITCH] Error:", err)
        print("[QUIDITCH] " .. debug.traceback())
    end

    function q:onSuccess(data)
        if data[1] then
            cb1()
        else
            cb2()
        end
    end

    q:setString(1, ply:SteamID64())
    q:start()
end