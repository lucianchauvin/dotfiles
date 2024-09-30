local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string
local type    = type

-- PulseAudio volume
-- lain.widget.pulse

local function factory(args)
    args           = args or {}

    local pulse    = { widget = args.widget or wibox.widget.textbox(), device = "N/A" }
    local timeout  = .2
    local settings = args.settings or function() end

    -- Command to get the default sink volume and mute status
    pulse.cmd = "pactl get-sink-volume `pactl get-default-sink`; pactl get-sink-mute `pactl get-default-sink`"

    function pulse.update()
        helpers.async({ shell, "-c", type(pulse.cmd) == "string" and pulse.cmd or pulse.cmd() },
        function(s)
            -- Parsing volume for front-left and front-right channels
            local left_volume  = string.match(s, "front%-left:.-(%d+)%%") or "N/A"
            local right_volume = string.match(s, "front%-right:.-(%d+)%%") or "N/A"
            local muted        = string.match(s, "Mute: (%S+)") or "N/A"

            volume_now = {
                left  = left_volume,
                right = right_volume,
                muted = muted
            }

            -- Update the widget
            widget = pulse.widget
            settings()
        end)
    end

    helpers.newtimer("pulse", timeout, pulse.update)

    return pulse
end

return factory
