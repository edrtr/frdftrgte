-- client.lua

ESX = exports["es_extended"]:getSharedObject()

local playerHoras = 0

-- Fetch player hours from the server
ESX.TriggerServerCallback("pekehoras:obtenerinfo", function(data)
    if data then
        playerHoras = data.playerHoras
    else
        print("Error: No se recibieron datos del servidor.")
    end
end)

-- Function to calculate distance between two points
local function calculateDistance(x1, y1, z1, x2, y2, z2)
    local dx = x1 - x2
    local dy = y1 - y2
    local dz = z1 - z2
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Function to draw the green area on the map
local function drawGreenArea()
    local center = Config.GreenArea.center
    local radius = Config.GreenArea.radius
    DrawMarker(1, center.x, center.y, center.z - 1.0, 0, 0, 0, 0, 0, 0, radius * 2.0, radius * 2.0, 1.0, 0, 255, 0, 100, false, false, 2, false, nil, nil, false)
end

-- Main thread to monitor player's position and draw the green area
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Continuously draw the area

        drawGreenArea()

        Citizen.Wait(1000) -- Check player's position every second

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local distance = calculateDistance(
            playerCoords.x, playerCoords.y, playerCoords.z,
            Config.GreenArea.center.x, Config.GreenArea.center.y, Config.GreenArea.center.z
        )

        if distance > Config.GreenArea.radius then
            if playerHoras < 5 then
                -- Trigger event to jail the player for 1 minute
                TriggerServerEvent("pekehoras:jailPlayer", 1)
            end
        end
    end
end)

-- Command to check player's hours
RegisterCommand('horas', function()
    ESX.TriggerServerCallback("pekehoras:obtenerhoras", function(horas)
        if horas then
            ESX.ShowNotification('Tienes ' .. horas .. " horas jugadas")
        else
            ESX.ShowNotification('No se pudo obtener la información de las horas.')
        end
    end)
end)
