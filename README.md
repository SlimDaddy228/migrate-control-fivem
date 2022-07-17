# Fivem Migrate Control
Just a solution to take control of an entity

## Advantages
- Debug mod to track the work of intercepting control from an entity
- Solving the problem when an entity turns to stone and cannot be used
- Readable and editable code

## Why and who needs it
Need this for those who use OneSync, especially BigMode/Infinity.

I noticed some problem when writing car functionality and interacting with peds.

With cars, it was that control over it was not intercepted, or when you try to get into it, you seem to get stuck near the door.

With peds, a slightly different problem, they were not killed, and it was impossible to physically interact with them in any way.

I started doing a lot of checks, and came to the conclusion that at what point (either when the owner of the entity leaves and there are no players nearby, or when he moves too far from the entity, I never understood when) he can no longer intercept the owner of this essence, ask why? Will explain.

It cannot intercept control over the entity due to the fact that the interception works on the client side, and there is a certain scope in BigMode / Infinity, and for some reason if the entity and the current owner of the entity are far from each other, then the client does not return the owner on the client, and therefore it is impossible to take control of the entity.
## Usage

> I think those who have worked with promises may not read.
> By calling the requestNetworkControl method it will wait for execution before continuing with code execution.
> To make it easier to understand, this is something similar to Citizen.Wait
```Lua
local function repairCurrentVehicle(netId)
    local veh = NetworkGetEntityFromNetworkId(netId)
    local is_request = exports['migrate-control']:requestNetworkControl(netId)
    if IsEntityAVehicle(veh) and is_request then
        SetVehicleEngineHealth(veh, 1000)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleFixed(veh)
    end
end
```
### Enable Debug-Mode
> shared/config.lua
```Lua
CFG.debug_mode = true;
```
![image](https://user-images.githubusercontent.com/60612282/179425733-b50fed45-5b4a-468c-9abd-864527c186ac.png)
