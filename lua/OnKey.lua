OnKeyList = {}

function addOnkey(func)
    table.insert(OnKeyList, func)
end

function OnKey(kc, shift, ctrl, alt)
    local i

    for i = 1, table.getn(OnKeyList) do
        if OnKeyList[i](kc, shift, ctrl, alt) then
            return true
        end
    end

    return false
end