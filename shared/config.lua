CFG = {}

CFG.event_name = 'migrate:control:%s';

CFG.debug_mode = false;

CFG.events = {
    server = {
        setNetIdOwnerCullingRadius = CFG.event_name:format(setNetIdOwnerCullingRadius)
    }
}

return CFG
