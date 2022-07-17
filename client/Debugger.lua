Debugger = {}

local function initOwnerDebugThread(self)
    async(function()
        while true do
            Wait(0)

            for entity in Entitier:EnumerateVehicles() do
                if DoesEntityExist(entity) and NetworkGetEntityIsNetworked(entity) then
                    local entityCoords = GetEntityCoords(entity)
                    local label = self:buildLabel(entity)
                    drawText3D(entityCoords.x, entityCoords.y, entityCoords.z, label)
                end
            end

            for entity in Entitier:EnumeratePeds() do
                if DoesEntityExist(entity) and not IsPedAPlayer(entity) and NetworkGetEntityIsNetworked(entity) then
                    local entityCoords = GetEntityCoords(entity)
                    local label = self:buildLabel(entity)
                    drawText3D(entityCoords.x, entityCoords.y, entityCoords.z + 1.0, label)
                end
            end

        end
    end)
end

function Debugger:buildLabel(entity)
    local netId = NetworkGetNetworkIdFromEntity(entity)
    local ownerEntity = NetworkGetEntityOwner(entity)
    local ownerName = GetPlayerName(ownerEntity)
    local isOwnerColor = (ownerEntity == PlayerId()) and "~g~" or "~r~"
    local modelName = GetEntityArchetypeName(entity):upper()
    local entityTypeName = self:getEntityTypeName(entity)
    return ('%s_NET_ID: ~b~%s~w~ \n MODEL_NAME: ~b~%s~w~ \n OWNER_NAME: %s %s'):format(entityTypeName, netId, modelName, isOwnerColor, ownerName)
end

function Debugger:getEntityTypeName(entity)
    local entityType = GetEntityType(entity)
    return self.entity_type_name[entityType]
end

function Debugger:constructor()
    self.entity_type_name = {
        [0] = 'NO_ENTITY',
        [1] = 'PED',
        [2] = 'VEHICLE',
        [3] = 'OBJECT',
    }
    if CFG.debug_mode then
        -- /distance NET_ID
        RegisterCommand('distance', function (source, args)
            local netId = tonumber(args[1])
            Base:requestNetworkControl(netId)
        end)
        initOwnerDebugThread(self) 
    end
end

Debugger:constructor()
