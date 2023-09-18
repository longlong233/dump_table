local M = {}

M.indent = "  "
M.newline = "\n"
M.separator = ","
M.assignment = " = "
M.showNumberKey = true
M.abbrStringKey = false
M.varNameRegex = "^[a-zA-Z_][a-zA-Z0-9_]*$"
M.toSafeString = function(str)
    return ("%q"):format(str):gsub("\\\n", "\\n")
end
M.canBeVarName = function(str)
    return str:match(M.varNameRegex) ~= nil
end
M.setConfig = function(config)
    for k, v in pairs(config) do
        M[k] = v
    end
end

M.dump = function(t, i)
    i = i or 0
    local t_len = #t
    local indent = M.indent
    local newline = M.newline
    local separator = M.separator
    local assignment = M.assignment
    local toSafeString = M.toSafeString
    local ret = {"{"}
    for k, v in ipairs(t) do
        local v_type = type(v)
        if v_type == "table" then
            v = M.dump(v, i + 1)
        elseif v_type == "string" then
            v = toSafeString(v)
        else
            v = tostring(v)
        end
        if M.showNumberKey then
            k = "[" .. k .. "]" .. assignment
        else
            k = ""
        end
        ret[#ret + 1] = indent .. k .. v .. separator
    end
    for k, v in pairs(t) do
        local k_type, v_type = type(k), type(v)
        if k_type == "number" and k <= t_len then
            goto cont
        end
        if v_type == "table" then
            v = M.dump(v, i + 1)
        elseif v_type == "string" then
            v = toSafeString(v)
        else
            v = tostring(v)
        end
        if k_type == "string" then
            if not M.abbrStringKey or not M.canBeVarName(k) then
                k = "[" .. toSafeString(k) .. "]"
            end
        else
            k = "[" .. tostring(k) .. "]"
        end
        ret[#ret + 1] = indent .. k .. assignment .. v .. separator
        ::cont::
    end
    table.insert(ret, "}")
    return table.concat(ret, newline .. indent:rep(i))
end

setmetatable(M, {
    __call = function(_, ...)
        return M.dump(...)
    end
})

return M
