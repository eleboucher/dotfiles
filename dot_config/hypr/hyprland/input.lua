
hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = false,
        repeat_delay = 250,
        repeat_rate = 35,
        focus_on_close = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            scroll_factor = 0.3,
        },
    },
    binds = {
        scroll_event_delay = 120,
    },
    cursor = {
        hotspot_padding = 1,
        -- NVIDIA: documented cursor combo (use_cpu_buffer required on Nvidia for HW cursors)
        no_hardware_cursors = false,
        use_cpu_buffer = true,
    },
})

