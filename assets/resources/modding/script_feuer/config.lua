Config = {}

Config.Feuer = {
    feuerSpreadChance = 2,
    maximumSpreads = 5,
    difficulty = 2,
    spawner = {
        enableOnStartup = true,
        interval = 180000,
        chance = 40,
        players = 3,
        feuerwehrJobs = {
            ["feuerwehr"] = true
        }
    }
}

Config.Dispatch = {
    enabled = true,
    timeout = 50000,
    storeLast = 5,
    clearGpsRadius = 20.0,
    removeBlipTimeout = 500000,
    playSound = true,
    enableFramework = nil,
    jobs = {
        "feuerwehr"
    },
    toneSources = {
        -- Unten
        vector3(1202.2, -1462.37, 26),
        vector3(1185, -1462, 26),
        vector3(1193, -1481, 26),
        vector3(1202.2, -1482, 26),
        -- Oben
        vector3(1691, 3586, 17)
        vector3(1695, 3556, 17)
        vector3(1692, 3584, 17)
        vector3(1391, 3526, 17)
        vector3(1398, 3528, 17)
    }
}
