{
  extraConfigLuaPre = /* lua */ ''
    local ac_file = io.open("/sys/class/power_supply/AC/online", "r")
    if (ac_file ~= nil) then
        vim.g.power_online = ac_file:read() == "1"
    else
        vim.g.power_online = true
    end
  '';
}
