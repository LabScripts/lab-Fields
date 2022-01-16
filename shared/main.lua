Config = {}

Config.BlipSize = 0.8 -- Size of the blips.

Config.PropOutline = true -- Enable if you want field props to be outlined when close.
Config.OutlineColor = {r = 42, g = 191, b = 171}

-- Configure anything except: spawnedPlants, DrugPlantsA and DrugCoords. These shall never be touched!
Config.Fields = {
    {
        FieldCoords = vector3(3522.56, 2569.64, 7.76),
        label = 'Poppy', 
        itemName = 'poppyresin', 
        amount = {Min = 1, Max = 5},
        jobs = { -- if dont want make that jobs = false,
            ["ballas"] = 0, -- [JobName] = MinRank,
            ["unicorn"] = 0, -- [JobName] = MinRank,
            ["police"] = 0, -- [JobName] = MinRank,
        }, 
        neededJobs = { -- if dont want make that jobs = false,
            ["police"] = 0, -- [JobName] = MinCount,
            ["sherrif"] = 0, -- [JobName] = MinCount,
        }, 
        DrugProp = 'prop_cs_plant_01',
        duration = 1000,
        animDict= 'random@domestic',
        anim = 'pickup_low',
        blip = true,
        blipSprite = 403,
        blipColour = 0,
        blipRadius = true,
        spawnedPlants = 0, DrugPlantsA = {}, DrugCoords = nil
    },
	{
        FieldCoords = vector3(2351.28, 3070.52, 48.16),
        label = 'Crack',
        itemName = 'crack',
        amount = {Min = 1, Max = 5},
        jobs = false,
        neededJobs = false,
        DrugProp = 'ex_office_swag_drugbag2',
        duration = 1000,
        animDict= 'random@domestic',
        anim = 'pickup_low',
        blip = true,
        blipSprite = 497,
        blipColour = 1,
        blipRadius = true,
        spawnedPlants = 0, DrugPlantsA = {}, DrugCoords = nil
    },
}

-- Configure anything to your liking.
Config.Labs = {
    {
        LabCoords = vector3(1391.84, 3605.88, 38.96),
        neededLabel = 'Poppy',
        givenLabel = 'Heroin',
        neededItem = 'poppyresin',
        neededAmount = 5,
        givenItem = 'heroin',
        givenAmount = {Min = 1, Max = 5},
        jobs = { -- if dont want make that jobs = false,
            ["ballas"] = 0, -- [JobName] = MinRank,
            ["unicorn"] = 0, -- [JobName] = MinRank,
            ["police"] = 0, -- [JobName] = MinRank,
        }, 
        neededJobs = { -- if dont want make that jobs = false,
            ["police"] = 0, -- [JobName] = MinCount,
            ["sherrif"] = 0, -- [JobName] = MinCount,
        }, 
        duration = 6000, 
        animDict= 'missmechanic',
        anim = 'work2_base',
        blip = true,
        blipSprite = 403,
        blipColour = 0,
        blipRadius = true
    },
    {
        LabCoords = vector3(2433.88, 4969.2, 42.36),
        neededLabel = 'Crack',
        givenLabel = 'Crack Brick',
        neededItem = 'crack',
        neededAmount = 5,
        givenItem = 'drug_box',
        givenAmount = {Min = 1, Max = 5},
        jobs = false,
        neededJobs = false,
        duration = 6000,
        animDict= 'missmechanic',
        anim = 'work2_base',
        blip = true,
        blipSprite = 497,
        blipColour = 0,
        blipRadius = true
    },
}