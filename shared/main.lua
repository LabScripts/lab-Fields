Config = {}

Config.Legacy = true -- Set this to true if you are using ESX Legacy or above. (Highly recommended to do so!)

Config.BlipSize = 0.8 -- Size of the blips.

-- Configure anything except: spawnedPlants, DrugPlantsA and DrugCoords. These shall never be touched!
Config.Fields = {
    Heroin = {
        FieldCoords = vector3(3522.56, 2569.64, 7.76), 
        label = 'Poppy', 
        itemName = 'poppyresin', 
        amount = 5, 
        jobRestricted = true, 
        jobs = {'ballas','unicorn','police'}, 
        neededCops = 1, 
        DrugProp = 'prop_cs_plant_01', 
        duration = 1000, 
        animDict= 'random@domestic', 
        anim = 'pickup_low', 
        blip = true, 
        blipSprite = 403, 
        blipColour = 0, 
        blipRadius = true,
        spawnedPlants = 0, DrugPlantsA = {}, DrugCoords
    },
	Crack = {
        FieldCoords = vector3(2351.28, 3070.52, 48.16), 
        label = 'Crack', 
        itemName = 'crack', 
        amount = 5, 
        jobRestricted = false, 
        jobs = {''}, neededCops = 0, 
        DrugProp = 'ex_office_swag_drugbag2', 
        duration = 1000, 
        animDict= 'random@domestic', 
        anim = 'pickup_low', 
        blip = true, 
        blipSprite = 497, 
        blipColour = 1,
        blipRadius = true, 
        spawnedPlants = 0, DrugPlantsA = {}, DrugCoords
    },
}

-- Configure anything to your liking.
Config.Labs = {
    A = {
        LabCoords = vector3(1391.84, 3605.88, 38.96), 
        neededLabel = 'Poppy', 
        givenLabel = 'Heroin', 
        neededItem = 'poppyresin', 
        neededAmount = 5, 
        givenItem = 'heroin', 
        givenAmount = 1, 
        jobRestricted = true, 
        jobs = {'ballas','unicorn'}, 
        neededCops = 1, 
        duration = 6000, 
        animDict= 'missmechanic', 
        anim = 'work2_base', 
        blip = true, 
        blipSprite = 403, 
        blipColour = 0,
        blipRadius = true
    },
    B = {
        LabCoords = vector3(2433.88, 4969.2, 42.36), 
        neededLabel = 'Crack', 
        givenLabel = 'Crack Brick', 
        neededItem = 'crack', 
        neededAmount = 5, 
        givenItem = 'drug_box', 
        givenAmount = 1, 
        jobRestricted = false, 
        jobs = {}, 
        neededCops = 0, 
        duration = 6000, 
        animDict= 'missmechanic', 
        anim = 'work2_base', 
        blip = true, 
        blipSprite = 497, 
        blipColour = 0,
        blipRadius = true
    },
}
 



