OnKeyList = {}
ActiveOoKey = nil

function addOnkey(obj)
    table.insert(OnKeyList, {
        label = obj.label,
        func = obj.func
    })
    ActiveOoKey = obj.func
end

function activateOnkey(label)
    if not label then
        ActiveOoKey = nil
        return true
    end

    local i
    for i = 1, table.getn(OnKeyList) do
        if OnKeyList[i].label == label then
            ActiveOoKey = OnKeyList[i].func
            return true
        end
    end
    ActiveOoKey = nil
    return false
end

function OnKey(kc, shift, ctrl, alt)
    if ActiveOoKey then
        if ActiveOoKey(kc, shift, ctrl, alt) then
            return true
        end
        return false
    end

    local i
    for i = 1, table.getn(OnKeyList) do
        if OnKeyList[i].func(kc, shift, ctrl, alt) then
            return true
        end
    end

    return false
end