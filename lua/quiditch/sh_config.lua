Quiditch.Config = {

    ["Houses"] = {
        ["Poufsouffle"] = {
            ["Job"] = "Capitaine de Quidditch de Poufsouffle",
            ["ButtonMaterial"] = "button_yellow",
            ["Color"] = Color(101,184,31)
        },
        ["Gryffondor"] = {
            ["Job"] = "Capitaine de Quidditch de Gryffondor",
            ["ButtonMaterial"] = "button_red",
            ["Color"] = Color(101,184,31)
        },
        ["Serpentard"] = {
            ["Job"] = "Capitaine de Quidditch de Serpentard",
            ["ButtonMaterial"] = "button_green",
            ["Color"] = Color(101,184,31)
        },
        ["Serdaible"] = {
            ["Job"] = "Capitaine de Quidditch de Serdaible",
            ["ButtonMaterial"] = "button_blueYellow",
            ["Color"] = Color(101,184,31)
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