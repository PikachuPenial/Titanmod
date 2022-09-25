AddCSLuaFile()

VManip:RegisterAnim("Flashlight_In", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"] = 0.85,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.3,
    ["lerp_curve"] = 1.5,
    ["speed"] = 0.85,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = false,
    ["sounds"] = {},
    ["segmented"] = true,
    ["preventquit"] = false,
    ["locktoply"] = false
})

VManip:RegisterAnim("Flashlight_Loop", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"] = 0.25,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 1.5,
    ["speed"] = 1,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = true,
    ["sounds"] = {},
    ["segmented"] = true,
    ["preventquit"] = false,
    ["locktoply"] = false
})


VManip:RegisterAnim("Flashlight_Run", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"] = 0.25,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 1.5,
    ["speed"] = 1,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = true,
    ["sounds"] = {},
    ["segmented"] = false,
    ["preventquit"] = false,
    ["locktoply"] = false
})



VManip:RegisterAnim("Flashlight_Out", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"]=0.95,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 1.5,
    ["speed"] = 0.85,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = false,
    ["sounds"] = {},
    ["segmented"] = true,
    ["preventquit"] = false,
    ["locktoply"] = false
})



VManip:RegisterAnim("Flashlight_Shoulder_Put", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"]=0.75,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 0.5,
    ["speed"] = 1,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = false,
    ["sounds"] = {},
    ["segmented"] = true,
    ["preventquit"] = false,
    ["locktoply"] = false
})

VManip:RegisterAnim("Flashlight_Shoulder_Take", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"]=0.85,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 1.5,
    ["speed"] = 1,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = false,
    ["sounds"] = {},
    ["segmented"] = true,
    ["preventquit"] = false,
    ["locktoply"] = false
})


VManip:RegisterAnim("Flashlight_EnableDisable", {
    ["model"] = "weapons/c_slog_vm_flashlight.mdl",
    ["lerp_peak"]=0.75,
    ["lerp_speed_in"] = 0.65,
    ["lerp_speed_out"] = 0.5,
    ["lerp_curve"] = 1.5,
    ["speed"] = 1,
    ["startcycle"] = 0,
    ["cam_angint"] = {0, 0, 0},
    ["loop"] = false,
    ["sounds"] = {},
    ["segmented"] = false,
    ["preventquit"] = false,
    ["locktoply"] = false
})


--["holdtime"]=nil