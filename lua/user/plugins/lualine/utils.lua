local M = {}

function M.env_cleanup(venv)
    if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
            final_venv = w
        end
        venv = final_venv
    end
    return venv
end

--- @param trunc_len number truncates component to trunc_len number of chars
--- return function that can format the component accordingly
function M.trunc(trunc_len)
    return function(str)
        if str:len() < trunc_len then
            return str
        end

        if str:match("%d$") ~= nil then
            -- could be a stacked pr, lets show the last chars
            local lastChars = 3
            local len = string.len(str)
            return str:sub(1, trunc_len - lastChars) .. "..." .. str:sub(len - lastChars + 1)
        else
            return str:sub(1, trunc_len) .. "..."
        end
    end
end

return M
