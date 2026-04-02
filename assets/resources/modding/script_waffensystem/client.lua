--ANIM A--
local weaponsAll = {
	'WEAPON_KNIFE',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_GUSENBERG',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
}

--WEAPONS--
local weaponshinten = {
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_DOUBLEACTION',
}

--TRUNK--
local weaponsLarge = {
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_CARBINERIFLE",
	"WEAPON_SMG",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_GUSENBERG",
	"WEAPON_MG",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_COMBATPDW",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_MUSKET",
}

local SETTINGS = {
	hinten_bone = 24816,
	x = 0.2,
	y = -0.10,
	z = -0.15,
	x_rotation = 180.0,
	y_rotation = 145.0,
	z_rotation = 0.0,
	compatable_weapon_hashes = {
			["w_sg_pumpshotgunmk2"] = GetHashKey("WEAPON_PUMPSHOTGUN_MK2"),
			["w_ar_carbineriflemk2"] = GetHashKey("WEAPON_CARBINERIFLE_MK2"),
			["w_ar_assaultrifle"] = GetHashKey("WEAPON_ASSAULTRIFLE"),
			["w_sg_pumpshotgun"] = GetHashKey("WEAPON_PUMPSHOTGUN"),
			["w_ar_carbinerifle"] = GetHashKey("WEAPON_CARBINERIFLE"),
			["w_ar_assaultrifle_smg"] = GetHashKey("WEAPON_COMPACTRIFLE"),
			["w_sb_smg"] = GetHashKey("WEAPON_SMG"),
			["w_sb_pdw"] = GetHashKey("WEAPON_COMBATPDW"),
			["w_mg_mg"] = GetHashKey("WEAPON_MG"),
			["w_sb_gusenberg"] = GetHashKey("WEAPON_GUSENBERG"),
			["w_ar_advancedrifle"] = GetHashKey("WEAPON_ADVANCEDRIFLE"),
			["w_sr_sniperrifle"] = GetHashKey("WEAPON_SNIPERRIFLE"),
			["w_ar_assaultriflemk2"] = GetHashKey("WEAPON_ASSAULTRIFLE_MK2"),
			["w_mg_combatmgmk2"] = GetHashKey("WEAPON_COMBATMG_MK2"),
	}
}

local attached_weapons = {}

local Halterunged  = true
local PlayerData = {}
local qb        = nil

local hasWeapon 			= false
local currWeapon 	    = GetHashKey("WEAPON_UNARMED")
local animateTrunk 		= false
local hasWeaponH  		= false
local hasWeaponL      = false
local weaponL         = GetHashKey("WEAPON_UNARMED")
local has_weapon_on_hinten = false
local racking         = false
local Halterung 				= 0
local blocked 				= false
local sex 						= 0
local HalterungButton 	= 20
local handOnHalterung 	= false
local HalterungHold			= false
local ped							= nil
 
Citizen.CreateThread(function()
    while qb == nil do
        TriggerEvent('qb:getSharedObject', function(obj) qb = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('qb:playerLoaded')
AddEventHandler('qb:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('qb:setJob')
AddEventHandler('qb:setJob', function(job)
  PlayerData.job = job
end)

RegisterCommand("sex", function(source, args, raw)
    if args[1] == 'm' then
		sex = 0
		qb.ShowNotification('Halterung set to Male')
    elseif args[1] == 'f' then
		sex = 1
		qb.ShowNotification('Halterung set to Female')
	else
        qb.ShowNotification('Incorrect use: /sex m,f')
    end
end, false)

 Citizen.CreateThread(function()
	local newWeapon = GetHashKey("WEAPON_UNARMED")
	while true do
		Citizen.Wait(1)
		ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(ped, true) then
			newWeapon = GetSelectedPedWeapon(ped)
			if newWeapon ~= currWeapon then
				if checkWeaponLarge(ped, newWeapon) then
					if hasWeaponL then
						HalterungWeaponL(ped, currWeapon)
					elseif Halterung >= 1 and Halterung <= 4 then
						if hasWeapon then
							if hasWeaponH then
								HalterungWeaponH(ped, currWeapon)
							else
								HalterungWeapon(ped, currWeapon)
							end
						end
					else
						if hasWeapon then
							HalterungWeapon(ped, currWeapon)
						end
					end
					drawWeaponLarge(ped, newWeapon)
				elseif Halterung >= 1 and Halterung <= 4 then
					if hasWeaponL then
						HalterungWeaponL()
					elseif hasWeaponH then
						HalterungWeaponH(ped, currWeapon)
					elseif hasWeapon then
						HalterungWeapon(ped, currWeapon)
					end
					if checkWeaponHalterung(ped, newWeapon) then
						drawWeaponH(ped, newWeapon)
					else
						drawWeapon(ped, newWeapon)
					end
				else
					if hasWeaponL then
						HalterungWeaponL()
					elseif hasWeapon then
						HalterungWeapon(ped, currWeapon)
					end
					drawWeapon(ped, newWeapon)
				end
				currWeapon = newWeapon
			end
		else
			hasWeapon = false
			hasWeaponH = false
		end
		if racking then
			rackWeapon()
		end
	end
end)

function drawWeaponLarge(ped, newWeapon)
	if has_weapon_on_hinten and newWeapon == weaponL then
		drawWeaponOnhinten()
		has_weapon_on_hinten = false
		return
	end

	local door = isNearDoor()
	if PlayerData.job.name == 'police' and (door == 'driver' or door == 'passenger') then
		blocked = true
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnhinten()
		startAnim("mini@repair", "fixing_a_ped")
		SetCurrentPedWeapon(ped, newWeapon, true)
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		weaponL = newWeapon
		hasWeaponL = true
	elseif not isNearTrunk() then
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		qb.ShowNotification('Du trägst keine Langwaffe bei dir')
	else
		blocked = true
		removeWeaponOnhinten()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		weaponL = newWeapon
		hasWeaponL = true
	end
end


function checkWeaponLarge(ped, newWeapon)
	for i = 1, #weaponsLarge do
		if GetHashKey(weaponsLarge[i]) == newWeapon then
			return true
		end
	end
	return false
end

--- Starts animation for trunk
function startAnim(lib, anim)
	RequestAnimDict(lib)
	while not HasAnimDictLoaded( lib) do
		Citizen.Wait(1)
	end

	TaskPlayAnim(ped, lib ,anim ,8.0, -8.0, -1, 0, 0, false, false, false )
	if PlayerData.job.name == 'police' then
		Citizen.Wait(2000)
	else
		Citizen.Wait(4000)
	end
	ClearPedTasksImmediately(ped)
end

function HalterungWeaponL()
	SetCurrentPedWeapon(ped, weaponL, true)
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
	Citizen.Wait(500)
	SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
	placeWeaponOnhinten()
	Citizen.Wait(1500)
	ClearPedTasks(ped)
	blocked = false
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
	hasWeaponL = false
end

function drawWeaponOnhinten()
	pos = GetEntityCoords(ped, true)
	rot = GetEntityHeading(ped)
	blocked = true
	loadAnimDict( "reaction@intimidation@1h" )
	TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", pos, 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
	removeWeaponOnhinten()
	SetCurrentPedWeapon(ped, weaponL, true)
	Citizen.Wait(2000)
	ClearPedTasks(ped)
	blocked = false
	hasWeaponL = true
end

function removeWeaponOnhinten()
	print("REMOVING WEAPON MODEL FROM hinten")
	has_weapon_on_hinten = false
end

function placeWeaponOnhinten()
	print("PLACING WEAPON MODEL ON hinten")
	has_weapon_on_hinten = true
end

RegisterCommand('rein', function()
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
	racking = true
end, false)

function rackWeapon()
	local door = isNearDoor()
	if PlayerData.job.name == 'police' and (door == 'driver' or door == 'passenger') then
		blocked = true
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorOpen(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorOpen(vehicle, 1, false, false)
			end
		end
		removeWeaponOnhinten()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			if door == 'driver' then
				SetVehicleDoorShut(vehicle, 0, false, false)
			elseif door == 'passenger' then
				SetVehicleDoorShut(vehicle, 1, false, false)
			end
		end
		WeaponL = GetHashKey("WEAPON_UNARMED")
		
	elseif isNearTrunk() then
		blocked = true
		removeWeaponOnhinten()
		startAnim("mini@repair", "fixing_a_ped")
		blocked = false
		local coordA = GetEntityCoords(ped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
			SetVehicleDoorShut(vehicle, 5, false, false)
		end
		WeaponL = GetHashKey("WEAPON_UNARMED")
		hasWeaponL = false
	else
		qb.ShowNotification('Du musst zu einem Kofferraum, sodass du deine reintun kannst!')
	end
	racking = false
end

Citizen.CreateThread(function()
  while true do
			local me = GetPlayerPed(-1)
			Citizen.Wait(10)
      for wep_name, wep_hash in pairs(SETTINGS.compatable_weapon_hashes) do
          if weaponL == wep_hash and has_weapon_on_hinten and HasPedGotWeapon(me, wep_hash, false) then
              if not attached_weapons[wep_name] then
                  AttachWeapon(wep_name, wep_hash, SETTINGS.hinten_bone, SETTINGS.x, SETTINGS.y, SETTINGS.z, SETTINGS.x_rotation, SETTINGS.y_rotation, SETTINGS.z_rotation, isMeleeWeapon(wep_name))
              end
          end
      end
      for name, attached_object in pairs(attached_weapons) do
          if not has_weapon_on_hinten then
            DeleteObject(attached_object.handle)
            attached_weapons[name] = nil
          end
      end
  Wait(0)
  end
end)

function AttachWeapon(attachModel,modelHash,boneNumber,x,y,z,xR,yR,zR, isMelee)
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumber)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Wait(100)
	end

  attached_weapons[attachModel] = {
    hash = modelHash,
    handle = CreateObject(GetHashKey(attachModel), 1.0, 1.0, 1.0, true, true, false)
  }

  if isMelee then x = 0.11 y = -0.14 z = 0.0 xR = -75.0 yR = 185.0 zR = 92.0 end -- reposition for melee items
  if attachModel == "prop_ld_jerrycan_01" then x = x + 0.3 end
	AttachEntityToEntity(attached_weapons[attachModel].handle, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function isMeleeWeapon(wep_name)
    if wep_name == "prop_golf_iron_01" then
        return true
    elseif wep_name == "w_me_bat" then
        return true
    elseif wep_name == "prop_ld_jerrycan_01" then
      return true
    else
        return false
    end
end

function isNearTrunk()
	local coordA = GetEntityCoords(ped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
		local lTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_l"))
		local rTail = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "taillight_r"))
		local playerpos = GetEntityCoords(ped, 1)
		local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, 1)
		local distanceToLeftT = GetDistanceBetweenCoords(lTail, playerpos, 1)
		local distanceToRightT = GetDistanceBetweenCoords(rTail, playerpos, 1)
		if distanceToTrunk < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		elseif distanceToLeftT < 1.5 and distanceToRightT < 1.5 then
			SetVehicleDoorOpen(vehicle, 5, false, false)
			return true
		else
			return
		end
	end
end

function isNearDoor()
	local coordA = GetEntityCoords(ped, 1)
	local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.0, 0.0)
	local vehicle = getVehicleInDirection(coordA, coordB)
	if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
		local dDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_f"))
		local pDoor = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_pside_f"))
		local playerpos = GetEntityCoords(ped, 1)
		local distanceToDriverDoor = GetDistanceBetweenCoords(dDoor, playerpos, 1)
		local distanceToPassengerDoor = GetDistanceBetweenCoords(pDoor, playerpos, 1)
		if distanceToDriverDoor < 2.0 then
			return 'driver'
		elseif distanceToPassengerDoor < 2.0 then
			return 'passenger'
		else
			return
		end
	end
end

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, ped, 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function checkWeaponHalterung(ped, newWeapon)
	for i = 1, #weaponsHalterung do
		if GetHashKey(weaponsHalterung[i]) == newWeapon then
			return true
		end
	end
	return false
end

function HalterungWeaponH(ped, currentWeapon)
	blocked = true
	SetCurrentPedWeapon(ped, currentWeapon, true)
	loadAnimDict("reaction@intimidation@cop@unarmed")
	TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
	addWeaponHalterung()
	Citizen.Wait(200)
	SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
	Citizen.Wait(1000)
	ClearPedTasks(ped)
	hasWeapon = false
	hasWeaponH = false
	blocked = false
end

function drawWeaponH(ped, newWeapon)
	blocked = true
	loadAnimDict("rcmjosh4")
  loadAnimDict("weapons@pistol@")
	loadAnimDict("reaction@intimidation@cop@unarmed")
	if not handOnHalterung then
		SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
		TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
		Citizen.Wait(300)
	end
	while HalterungHold do
		Citizen.Wait(1)
	end
	TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
	SetCurrentPedWeapon(ped, newWeapon, true)
	removeWeaponHalterung()
	if not handOnHalterung then
		Citizen.Wait(300)
	end
  ClearPedTasks(ped)
	hasWeaponH = true
	hasWeapon = true
	handOnHalterung = false
	blocked = false
end

function removeWeaponHalterung()
	if Halterung == 1 then
		SetPedComponentVariation(ped, 7, 2, 0, 0)
	elseif Halterung == 2 then
		SetPedComponentVariation(ped, 7, 5, 0, 0)
	elseif Halterung == 3 then
		if sex == 0 then
			SetPedComponentVariation(ped, 8, 18, 0, 1)
		else
			SetPedComponentVariation(ped, 8, 10, 0, 1)
		end
	elseif Halterung == 4 then
		SetPedComponentVariation(ped, 7, 3, 0, 0)
	end
end

function addWeaponHalterung()
	if Halterung == 1 then
		SetPedComponentVariation(ped, 7, 8, 0, 0)
	elseif Halterung == 2 then
		SetPedComponentVariation(ped, 7, 6, 0, 0)
	elseif Halterung == 3 then
		if sex == 0 then
			SetPedComponentVariation(ped, 8, 16, 0, 1)
		else
			SetPedComponentVariation(ped, 8, 9, 0, 1)
		end
	elseif Halterung == 4 then
		SetPedComponentVariation(ped, 7, 1, 0, 0)
	end
end

function HalterungWeapon(ped, currentWeapon)
	if checkWeaponLarge(ped, currentWeapon) then
		placeWeaponOnhinten()
	elseif checkWeapon(ped, currentWeapon) then
		SetCurrentPedWeapon(ped, currentWeapon, true)
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
		Citizen.Wait(500)
		SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
		Citizen.Wait(1500)
		ClearPedTasks(ped)
		blocked = false
	end
	hasWeapon = false
end

function drawWeapon(ped, newWeapon)
	if newWeapon == GetHashKey("WEAPON_UNARMED") then
		return
	end
	if checkWeapon(ped, newWeapon) then
		pos = GetEntityCoords(ped, true)
		rot = GetEntityHeading(ped)
		blocked = true
		loadAnimDict( "reaction@intimidation@1h" )
		TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
		SetCurrentPedWeapon(ped, newWeapon, true)
		Citizen.Wait(600)
		ClearPedTasks(ped)
		blocked = false
	else
		SetCurrentPedWeapon(ped, newWeapon, true)
	end
	handOnHalterung = false
	hasWeapon = true

end

function checkWeapon(ped, newWeapon)
	for i = 1, #weaponsFull do
		if GetHashKey(weaponsFull[i]) == newWeapon then
			return true
		end
	end
	return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
            if blocked then
                DisableControlAction(1, 25, true )
                DisableControlAction(1, 140, true)
                DisableControlAction(1, 141, true)
                DisableControlAction(1, 142, true)
                DisableControlAction(1, 23, true)
				DisableControlAction(1, 37, true)
				DisableControlAction(1, 182, true)
				DisablePlayerFiring(ped, true)
            end
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end
