exports('requestNetworkControl', function(netId, duration)
    return Base:requestNetworkControl(netId, duration)
end)

exports('buildLabel', function(entity)
    return Debugger:buildLabel(entity)
end)