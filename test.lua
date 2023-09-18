local dump = require "dump_table"

local t = {
    1,
    false,
    [5] = "value of the 5th key",
    ["2b"] = {
        true,
        ['t["2b"][2]'] = 6,
        6
    },
    a = 2,
    {
        "\"\n\r\t\a\\",
        dump,
        [true] = 1
    }
}

print(dump(t))

dump.setConfig {
    assignment = "=",
    showNumberKey = false,
    abbrStringKey = true
}
print(dump(t))

dump.setConfig {
    indent = "",
    newline = "",
    separator = ";"
}
print(dump(t))
