ConfigDarknet = {
    -- La commande pour ouvrir le darknet
    Command = "darknet",
    Touche = "F9",

    -- Le nom du darknet
    name = "Darknet",

    -- La déscription du darknet
    description = "Darknet de la ville! Pss .. tiens",

    -- True = pouvoir acheter les articles dans le menu sans appeler le vendeur
    Buy_In = true,

    -- Le message afficher quand-t-on a pas accès
    AccesDeniedNotif = "~r~Vous fouiner un peu trop",

    -- Les mots interdit dans les messages darknet
    Words_Blacklist = {
        "discord.gg",
        "https://",
        "discord."
    },

    -- Les jobs qui ne peuvent pas accéder au darknet
    Job_Blacklist = {
        "police",
        "ambulance"
    },

    -- Les armes et objets a vendre
    Armes = {
        {name = "Berreta 92", label = "weapon_pistol", prix = 15000, informations = "ABCEFGHIJKLMNOPQRSTUVWXYZ", vendeur = "El Chapo", tel = "555-1234"},
        {name = "AK-47", label = "weapon_assaultrifle", prix = 245689, informations = "A", vendeur = "A Chapo", tel = "555-1231"},
        {name = "M4A1", label = "weapon_carbinerifle", prix = 1256487, informations = "B", vendeur = "B Chapo", tel = "555-1212"}
    },

    Objets = {
        {name = "Bombe thermite", label = "thermite_bomb", prix = 2500, informations = "C", vendeur = "C Chapo", tel = "555-4567"},
        {name = "C4", label = "c4_bomb", prix = 25684, informations = "D", vendeur = "D Chapo", tel = "555-1597"},
        {name = "Clé USB de piratage", label = "hack_usb", prix = 4580, informations = "E", vendeur = "E Chapo", tel = "555-2637"}
    },
}