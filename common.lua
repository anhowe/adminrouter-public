local common = {}

local cjson = require "cjson"

function common.mesos_get_state()
    -- explicitly clear the header.  Both rewrite_by_lua_file and
    -- more_clear_input_headers happen in phase "rewrite tail"
    -- and nginx offers no guaranteed ordering within a phase
    ngx.req.clear_header("Accept-Encoding")
    local res = ngx.location.capture("/mesos/master/state-summary")
    local state = cjson.decode(res.body)
    return state
end

function common.mesos_dns_get_srv(framework_name)
    -- explicitly clear the header.  Both rewrite_by_lua_file and
    -- more_clear_input_headers happen in phase "rewrite tail"
    -- and nginx offers no guaranteed ordering within a phase
    ngx.req.clear_header("Accept-Encoding")
    local res = ngx.location.capture("/mesos_dns/v1/services/_" .. framework_name .. "._tcp.marathon.mesos")
    local records = cjson.decode(res.body)
    return records
end

function string:split(sep)
    local sep, fields = sep or " ", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function string.startswith(str, prefix)
   return string.sub(str, 1, string.len(prefix)) == prefix
end

return common
