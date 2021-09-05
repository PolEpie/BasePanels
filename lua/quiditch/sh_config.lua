Quiditch.Config = {

    ["Houses"] = {
        {
            ["Name"] ="Poufsouffle",
            ["Job"] = "Capitaine de Quidditch de Poufsouffle"
        },
        {
            ["Name"] ="Gryffondor",
            ["Job"] = "Capitaine de Quidditch de Gryffondor"
        },
        {
            ["Name"] ="Serpentard",
            ["Job"] = "Capitaine de Quidditch de Serpentard"
        },
        {
            ["Name"] ="Serdaible",
            ["Job"] = "Capitaine de Quidditch de Serdaible"
        }
    },

    ["NPC"] = {
        ["TeamCreation"] = "models/Humans/Group01/Female_01.mdl",
        ["TeamList"] = "models/Humans/Group01/Female_01.mdl",

    },

    ["TeamCreationPrice"] = 10

}


local meta = FindMetaTable("Player")
function meta:CanAfford(amount)
    return true
end

function meta:addMoney(amount)
end