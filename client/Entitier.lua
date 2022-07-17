Entitier = {}

function Entitier:EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()

        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
        setmetatable(enum, self.entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function Entitier:EnumeratePeds()
    return self:EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function Entitier:EnumerateVehicles()
    return self:EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function Entitier:constructor()
    self.entityEnumerator = {
        __gc = function(enum)
            if enum.destructor and enum.handle then
                enum.destructor(enum.handle)
            end
            enum.destructor = nil
            enum.handle = nil
        end
    }
end

Entitier:constructor()
