-- Utility Functions
local function PlayHitSound(isHeadshot)
    if not Config.HitMarker then return end
    
    if isHeadshot then
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = 'headshot_55800',
            transactionVolume = 0.8
        })
    else
        SendNUIMessage({
            transactionType = 'playSound',
            transactionFile = 'hit_marker',
            transactionVolume = 0.8
        })
    end
end

local function DrawText3D(coords, text, r, g, b, yOffset)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + yOffset)
    if onScreen then
        SetTextOutline()
        SetTextScale(0.50, 0.50)
        SetTextFont(4)
        SetTextColour(r, g, b, 255)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(tostring(text))
        DrawText(x, y)
    end
end

local function ScaleHealthTo100(currentHealth, maxHealth)
    return math.floor((currentHealth / maxHealth) * 100)
end

local function DisplayRemainingForFrames(sourceEntity, remainingHealth, remainingArmor, frameCount)
    if not Config.EnableDamageText then return end  

    local frames = 0
    local maxHealth = GetEntityMaxHealth(sourceEntity)
    local entityCoords = GetEntityCoords(sourceEntity)

    remainingHealth = ScaleHealthTo100(remainingHealth, maxHealth)

    local healthText = "Health: " .. remainingHealth
    local armorText = "Armor: " .. remainingArmor

    local healthOffset = 0.1
    local armorOffset = 0.15

    while frames < frameCount do
        if remainingArmor > 0 then
            DrawText3D(entityCoords, armorText, Config.ArmorHitColor.r, Config.ArmorHitColor.g, Config.ArmorHitColor.b, armorOffset)
        else
            DrawText3D(entityCoords, healthText, Config.NormalHitColor.r, Config.NormalHitColor.g, Config.NormalHitColor.b, healthOffset)
        end
        frames = frames + 1
        Wait(0)
    end
end

-- Variables
local isDamageDisplayEnabled = true
local playerNPCHitRepeatLimit = Config.NPCHitRepeatLimit 
local playerPlayerHitRepeatLimit = Config.PlayerHitRepeatLimit  
local lastHealth = {}
local lastArmor = {}

-- Event Handlers
AddEventHandler('gameEventTriggered', function(name, data)
    if not isDamageDisplayEnabled then return end
    if name == "CEventNetworkEntityDamage" then
        local sourceEntity = data[1]
        local player = data[2]
        
        if not sourceEntity or not DoesEntityExist(sourceEntity) or GetEntityType(sourceEntity) ~= 1 then
            return
        end
        
        if player == PlayerPedId() or (Config.ShowNPCDamages and player == -1) then
            local currentHealth = GetEntityHealth(sourceEntity)
            local currentArmor = GetPedArmour(sourceEntity)
            local bone = GetPedLastDamageBone(sourceEntity)
            local isHeadshot = (bone == 31086)
            
            if not isHeadshot and currentHealth <= 0 then
                isHeadshot = true
            end
            
            PlayHitSound(isHeadshot)
            local repeatLimit = IsPedAPlayer(sourceEntity) and playerPlayerHitRepeatLimit or playerNPCHitRepeatLimit
            DisplayRemainingForFrames(sourceEntity, currentHealth, currentArmor, repeatLimit)
        end
    end
end)

-- Commands
RegisterCommand("toggledamages", function()
    isDamageDisplayEnabled = not isDamageDisplayEnabled
    if isDamageDisplayEnabled then
        TriggerEvent('chat:addMessage', { args = { '[System]', 'Damage display enabled.' } })
    else
        TriggerEvent('chat:addMessage', { args = { '[System]', 'Damage display disabled.' } })
    end
end, false)

RegisterCommand("setnpclimit", function(source, args)
    local newLimit = tonumber(args[1])
    if newLimit and newLimit > 0 then
        playerNPCHitRepeatLimit = newLimit
        TriggerEvent('chat:addMessage', { args = { '[System]', 'NPC hit repeat limit set to ' .. newLimit } })
    else
        TriggerEvent('chat:addMessage', { args = { '[System]', 'Invalid value for NPC hit repeat limit. Must be a number greater than 0.' } })
    end
end, false)

RegisterCommand("setplayerlimit", function(source, args)
    local newLimit = tonumber(args[1])
    if newLimit and newLimit > 0 then
        playerPlayerHitRepeatLimit = newLimit
        TriggerEvent('chat:addMessage', { args = { '[System]', 'Player hit repeat limit set to ' .. newLimit } })
    else
        TriggerEvent('chat:addMessage', { args = { '[System]', 'Invalid value for Player hit repeat limit. Must be a number greater than 0.' } })
    end
end, false)
