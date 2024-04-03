local VORPcore = exports.vorp_core:GetCore()

local active = false




--- UTILS ---

local function CrouchAnim()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    TaskPlayAnim(ped, dict, "inspectfloor_player", 0.5, 8.0, -1, 1, 0, false, false, false)
end
local function GoldShake()
    local dict = "script_re@gold_panner@gold_success"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
    TaskPlayAnim(PlayerPedId(), dict, "SEARCH02", 1.0, 8.0, -1, 1, 0, false, false, false)
end

local function Reward()
    local reward = math.random(1,100)
    if reward <= Config.RewardChance then
        TriggerServerEvent('mms-goldpfanne:server:addreward')
    else
        VORPcore.NotifyTip(Config.NothingFound , 5000)
    end
end


local function Goldpan()
    local playerPed = PlayerPedId()
    local goldpan = CreateObject(GetHashKey('p_cs_miningpan01x'), GetEntityCoords(playerPed), true, true, true)
    local righthand = GetEntityBoneIndexByName(playerPed, "SKEL_R_HAND")
    AttachEntityToEntity(goldpan, playerPed, righthand, 0.2, 0.0, -0.20, -100.0, -50.0, 0.0, false, false, false, true, 2, true)
    VORPcore.NotifyTip(Config.YouAreGoldpaning , Config.GoldPanTime)
    Wait(1000)
    CrouchAnim()
    Wait(5000)
    GoldShake()
    Wait(Config.GoldPanTime - 5000)
    ClearPedTasks(playerPed)
    DeleteObject(goldpan)
    Reward()
    active = false
end

RegisterNetEvent('mms-goldpfanne:client:startgoldpfanne')
AddEventHandler('mms-goldpfanne:client:startgoldpfanne',function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z) -- GetWaterMapZoneAtCoords
    if active == false then
        for k, _ in pairs(Config.locations) do
            if water == Config.locations[k].hash and IsPedOnFoot(playerPed) and IsEntityInWater(playerPed) then
                active = true
                Goldpan()
                
            end        
        end
    end
end)



