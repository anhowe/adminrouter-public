local common = require "common"

local state = common.mesos_get_state()
local hostname = ngx.var.slaveid:split(":")[1]

for _, slave in ipairs(state["slaves"]) do
    if slave["hostname"] == hostname then
        local split_pid = slave["pid"]:split("@")
        ngx.var.slaveaddr = split_pid[2]
        ngx.log(ngx.DEBUG, ngx.var.slaveaddr)
    end
end
