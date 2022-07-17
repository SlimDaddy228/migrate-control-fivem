local Base = {}

local function initEvents(self)
    RegisterNetEvent(CFG.events.server.setNetIdOwnerCullingRadius)
    AddEventHandler(CFG.events.server.setNetIdOwnerCullingRadius, function(netId, radius)
        self:setNetIdOwnerCullingRadius(netId, radius)
    end)
end

function Base:setNetIdOwnerCullingRadius(netId, radius)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local source = NetworkGetEntityOwner(entity)
    SetPlayerCullingRadius(source, radius)
    SetEntityDistanceCullingRadius(entity, radius)
end

function Base:constructor()
    initEvents(self)
end

Base:constructor()
