Config = {}

Config.Legacy = true -- Set this to true if you are using ESX Legacy or above. (Highly recommended to do so!)

Config.BlipSize = 0.8 -- Size of the blips.

-- Configure anything except: spawnedPlants, DrugPlantsA and DrugCoords. These shall never be touched!
Config.Fields = {
    A = {FieldCoords = vector3(-2146.8, 2686.72, 2.92), label = 'Heroin', itemName = 'heroin', amount = 5, jobRestricted = true, jobs = {'ballas','unicorn','police'}, neededCops = 1, DrugProp = 'prop_cs_plant_01', duration = 1000, animDict= 'random@domestic', anim = 'pickup_low', blip = true, blipSprite = 403, blipColour = 0, spawnedPlants = 0, DrugPlantsA = {}, DrugCoords},
	B = {FieldCoords = vector3(-2599.36, 2833.32, 2.92), label = 'Crack', itemName = 'crack', amount = 5, jobRestricted = false, jobs = {''}, neededCops = 0, DrugProp = 'ex_office_swag_drugbag2', duration = 1000, animDict= 'random@domestic', anim = 'pickup_low', blip = true, blipSprite = 497, blipColour = 1, spawnedPlants = 0, DrugPlantsA = {}, DrugCoords},
}

-- Configure anything to your liking.
Config.Labs = {
    A = {LabCoords = vector3(-2080.04, 2608.92, 3.08), neededLabel = 'Heroin', givenLabel = 'Crack', neededItem = 'heroin', neededAmount = 5, givenItem = 'crack', givenAmount = 1, jobRestricted = true, jobs = {'ballas','unicorn'}, neededCops = 1, duration = 6000, animDict= 'missmechanic', anim = 'work2_base', blip = true, blipSprite = 403, blipColour = 0},
    B = {LabCoords = vector3(-2082.28, 2614.32, 3.08), neededLabel = 'Crack', givenLabel = 'Heroin', neededItem = 'crack', neededAmount = 5, givenItem = 'heroin', givenAmount = 1, jobRestricted = false, jobs = {}, neededCops = 0, duration = 6000, animDict= 'missmechanic', anim = 'work2_base', blip = true, blipSprite = 497, blipColour = 0},
}
 



