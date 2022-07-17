Base = {}

function Base:isNetworkAndEntityCreated(netId)
    local entity = NetworkGetEntityFromNetworkId(netId)

    if not NetworkGetEntityIsNetworked(entity) then
        return false
    end

    if not DoesEntityExist(entity) then
        return false
    end

    return true
end

---comment
---@param netId integer
---@param radius number
function Base:setNetIdOwnerCullingRadius(netId, radius)
    TriggerServerEvent(CFG.events.server.setNetIdOwnerCullingRadius, netId, radius)
end

---comment
---@param netId integer
---@param duration number
---@return boolean
function Base:requestNetworkControl(netId, duration)
    duration = duration or self.default.timeout_request_control

    local Promise = promise.new()
    local startTimer = GetGameTimer()

    if not self:isNetworkAndEntityCreated(netId) then
        Promise:resolve(false)
        return false
    end

    self:setNetIdOwnerCullingRadius(netId, self.default.distace_culling.max)

    async(function()
        NetworkRequestControlOfNetworkId(netId)

        while not NetworkHasControlOfNetworkId(netId) and (GetGameTimer() - startTimer) <= duration do
            Wait(self.default.thread_delay)
            NetworkRequestControlOfNetworkId(netId)
        end

        local isRequested = NetworkRequestControlOfNetworkId(netId) == 1 and true or false
        Promise:resolve(isRequested)
    end)

    self:setNetIdOwnerCullingRadius(netId, self.default.distace_culling.reset)
    
    return Citizen.Await(Promise)
end

function Base:constructor()
    self.default = {
        timeout_request_control = 2000, -- ms
        thread_delay = 0, -- ms
        distace_culling = { reset = 0.0, max = 999999.0 },
    }
end

Base:constructor()
