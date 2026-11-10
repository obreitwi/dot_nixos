hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("alacritty"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("rofi -show run -sort"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("rofi -show window"))
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("window-swap"))
hl.bind("SUPER + SHIFT + F4", hl.dsp.exit())
hl.bind("SUPER + SHIFT + C", hl.dsp.window.close())
hl.bind("SUPER + Y", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind("SUPER + SHIFT + P", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + W", hl.dsp.layout("movetoroot"))
hl.bind("SUPER + SHIFT + W", hl.dsp.layout("movetoroot active unstable"))
hl.bind("SUPER + H",
	-- move left window or next workspace
	function()
		local w_pre = hl.get_active_window()
		hl.dispatch(hl.dsp.focus({ direction = "left" }))
		local w_post = hl.get_active_window()

		if w_pre ~= nil and w_post ~= nil and w_pre.at.x > w_post.at.x then
			return
		end

		local ws_current = hl.get_active_workspace()
		if ws_current == nil then
			return
		end
		local workspaces_all = hl.get_workspaces()
		local workspaces = {}
		local num_workspaces = 0
		for _, w in ipairs(workspaces_all) do
			if w.monitor == ws_current.monitor then
				num_workspaces = num_workspaces + 1
				workspaces[num_workspaces] = w
			end
		end
		for i, w in ipairs(workspaces) do
			if w.id == ws_current.id then
				if i > 1 then
					hl.dispatch(hl.dsp.focus({ workspace = workspaces[i - 1].id }))
				else
					hl.dispatch(hl.dsp.focus({ workspace = workspaces[#workspaces].id }))
				end
			end
		end
	end
)
hl.bind("SUPER + L",
	-- move right window or next workspace
	function()
		local w_pre = hl.get_active_window()
		hl.dispatch(hl.dsp.focus({ direction = "right" }))
		local w_post = hl.get_active_window()
		if w_pre ~= nil and w_post ~= nil and w_pre.at.x < w_post.at.x then
			return
		end
		local ws_current = hl.get_active_workspace()
		if ws_current == nil then
			return
		end
		local workspaces_all = hl.get_workspaces()
		local workspaces = {}
		local num_workspaces = 0
		for _, w in ipairs(workspaces_all) do
			if w.monitor == ws_current.monitor then
				num_workspaces = num_workspaces + 1
				workspaces[num_workspaces] = w
			end
		end

		for i, w in ipairs(workspaces) do
			if w.id == ws_current.id then
				if i < #workspaces then
					hl.dispatch(hl.dsp.focus({ workspace = workspaces[i + 1].id }))
				else
					hl.dispatch(hl.dsp.focus({ workspace = workspaces[1].id }))
				end
			end
		end
	end
)
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind("SHIFT + SUPER + 1", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind("SHIFT + SUPER + 2", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind("SHIFT + SUPER + 3", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind("SHIFT + SUPER + 4", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind("SHIFT + SUPER + 5", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind("SHIFT + SUPER + 6", hl.dsp.window.move({ workspace = 6, follow = false }))
hl.bind("SHIFT + SUPER + 7", hl.dsp.window.move({ workspace = 7, follow = false }))
hl.bind("SHIFT + SUPER + 8", hl.dsp.window.move({ workspace = 8, follow = false }))
hl.bind("SHIFT + SUPER + 9", hl.dsp.window.move({ workspace = 9, follow = false }))
hl.bind("SHIFT + SUPER + 0", hl.dsp.window.move({ workspace = 10, follow = false }))
hl.bind("SUPER + semicolon", hl.dsp.exec_cmd("workspace-action focus"))
hl.bind("SUPER + SHIFT + semicolon", hl.dsp.exec_cmd("workspace-action move"))
hl.bind("SUPER + SHIFT + m", hl.dsp.exec_cmd("workspace-rename"))
hl.bind("SUPER + SHIFT + n", hl.dsp.group.toggle())
-- TODO: manual review on line 47 — changegroupactive: expected 'f', 'b', or an index (got "")
-- hl.bind("SUPER + N", hl.dsp.changegroupactive())
hl.bind("SUPER + T", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + ALT + H", hl.dsp.window.move({ workspace = "r-1", follow = false }))
hl.bind("SUPER + ALT + L", hl.dsp.window.move({ workspace = "r+1", follow = false }))
hl.bind("SUPER + E", hl.dsp.focus({ monitor = 0 }))
hl.bind("SUPER + R", hl.dsp.focus({ monitor = 1 }))
hl.bind("SUPER + SHIFT + E",
	function()
		local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({
			workspace = w
				.id,
			monitor = 0
		}))
	end)
hl.bind("SUPER + SHIFT + R",
	function()
		local w = hl.get_active_workspace(); if not w then return end; hl.dispatch(hl.dsp.workspace.move({
			workspace = w
				.id,
			monitor = 1
		}))
	end)
hl.bind("SUPER + S", hl.dsp.workspace.swap_monitors({ monitor1 = "0", monitor2 = "1" }))
hl.bind("SUPER + A", hl.dsp.focus({ workspace = "previous" }))
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("dunstctl close-all"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("dunstctl history-clear"))
hl.bind("SUPER + c", hl.dsp.workspace.toggle_special("audio"))
hl.bind("SUPER + slash", hl.dsp.workspace.toggle_special("journal"))
hl.bind("SUPER + SHIFT + slash", hl.dsp.workspace.toggle_special("btop"))
hl.bind("SUPER + CTRL + slash", hl.dsp.window.float({ action = "set" }))
hl.bind("SUPER + CTRL + slash",
	function()
		local m = hl.get_active_monitor(); if not m then return end; hl.dispatch(hl.dsp.window.move({
			x = math.floor(m
				.width * 44 / 100),
			y = math.floor(m.height * 15 / 100)
		}))
	end)
hl.bind("SUPER + CTRL + slash",
	function()
		local m = hl.get_active_monitor(); if not m then return end; hl.dispatch(hl.dsp.window.resize({
			x = math.floor(m
				.width * 55 / 100),
			y = math.floor(m.height * 70 / 100)
		}))
	end)
hl.bind("SUPER + apostrophe", hl.dsp.workspace.toggle_special("terminal"))
hl.bind("SUPER + SHIFT + T", hl.dsp.workspace.toggle_special("ptpython"))
hl.bind("SUPER + SHIFT + O", hl.dsp.workspace.toggle_special("numbat"))
hl.bind("SUPER + CONTROL + T", hl.dsp.workspace.toggle_special("bluetooth"))
hl.bind("SUPER + CONTROL + B", hl.dsp.exec_cmd("rofi-bluetooth"))
hl.bind("SUPER + CONTROL + V", hl.dsp.workspace.toggle_special("1pw"))
hl.bind("SUPER + SHIFT + D", hl.dsp.workspace.toggle_special("minimized"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("toggle-minimize"))
hl.bind("SUPER + F5", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + F5", hl.dsp.exec_cmd("hyprmoncfg-apply"))
hl.bind("SUPER + F9", hl.dsp.exec_cmd("toggle-bluetooth-audio"))
hl.bind("SUPER + z", hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + SHIFT + z", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + CTRL + o", hl.dsp.exec_cmd("rofimoji -a type"))
hl.bind("SUPER + o", hl.dsp.exec_cmd("rofimoji -a copy"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("sbacklight +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("sbacklight -5%"))

hl.bind("SUPER + SHIFT + F5", function()
	-- disable external monitor(s)
	local laptop_prefix = "eDP"
	for _, m in pairs(hl.get_monitors()) do
		if string.sub(m.name, 1, #laptop_prefix) ~= laptop_prefix then
			hl.monitor({ output = m.name, disabled = true })
		end
	end
end)

hl.bind("SUPER + mouse:272", hl.dsp.window.float({ action = "toggle" }), { release = true, click = true })

hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
hl.bind("SUPER + mouse:273", hl.dsp.window.resize())

hl.device({
	name = "logitech-mx-vertical-advanced-ergonomic-mouse",
	sensitivity = -0.500000,
})

hl.device({
	name = "keychron--keychron-link-",
	sensitivity = -0.700000,
})

hl.window_rule({
	match = {
		workspace = "name:special:minimized",
	},
	border_size = 2,
})

hl.window_rule({
	match = {
		workspace = "name:special:minimized",
		focus = true,
	},
	border_color = "rgb(fc0000)",
})

hl.window_rule({
	match = {
		workspace = "name:special:minimized",
		focus = false,
	},
	border_color = "rgb(8a0a0a)",
})

hl.workspace_rule({
	workspace = "2",
	default_name = "code",
})

hl.workspace_rule({
	workspace = "3",
	default_name = "debug",
})

hl.workspace_rule({
	workspace = "4",
	default_name = "fdc",
})

hl.workspace_rule({
	workspace = "5",
	default_name = "gchat",
})

hl.workspace_rule({
	workspace = "6",
	default_name = "private",
})

hl.workspace_rule({
	workspace = "7",
	default_name = "web",
})

hl.workspace_rule({
	workspace = "8",
	default_name = "meetings",
})

hl.workspace_rule({
	workspace = "9",
	default_name = "nix",
})

hl.workspace_rule({
	workspace = "10",
	default_name = "media",
})

hl.workspace_rule({
	workspace = "11",
	default_name = "recruiting",
})

hl.workspace_rule({
	workspace = "12",
	default_name = "rust",
})

hl.workspace_rule({
	workspace = "13",
	default_name = "root",
})

hl.workspace_rule({
	workspace = "14",
	default_name = "1pw",
})

hl.workspace_rule({
	workspace = "f[1]",
	no_border = true,
	gaps_in = 0,
	gaps_out = 0,
	no_rounding = true,
})

local layout_floating = "[float; move 44% 15%; size 55% 70%] "

hl.workspace_rule({
	workspace = "special:1pw",
	on_created_empty = layout_floating .. "1password",
})

hl.workspace_rule({
	workspace = "special:audio",
	on_created_empty = layout_floating .. "pavucontrol",
})

hl.workspace_rule({
	workspace = "special:bluetooth",
	on_created_empty = layout_floating .. "alacritty -e bluetuith",
})

hl.workspace_rule({
	workspace = "special:btop",
	on_created_empty = layout_floating .. "alacritty -e btop",
})

hl.workspace_rule({
	workspace = "special:journal",
	on_created_empty = layout_floating .. "scratchpad-journal",
})

hl.workspace_rule({
	workspace = "special:minimized",
	gaps_in = 10,
	gaps_out = 10,
})

hl.workspace_rule({
	workspace = "special:numbat",
	on_created_empty = layout_floating .. "alacritty -e numbat",
})

hl.workspace_rule({
	workspace = "special:ptpython",
	on_created_empty = layout_floating .. "alacritty -e ptpython",
})

hl.workspace_rule({
	workspace = "special:terminal",
	on_created_empty = layout_floating .. "alacritty",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

hl.config({
	binds = {
		allow_workspace_cycles = true,
		drag_threshold = 10,
		movefocus_cycles_fullscreen = true,
	},
	debug = {
		disable_logs = false,
	},
	decoration = {
		blur = {
			special = false,
		},
		dim_special = 0.400000,
		rounding = 5,
	},
	dwindle = {
		preserve_split = true,
	},
	general = {
		border_size = 1,
		gaps_in = 2,
		gaps_out = 2,
		layout = "dwindle",
		resize_on_border = true,
	},
	input = {
		kb_options = "caps:escape",
		follow_mouse = 2,
		kb_layout = "us",
		kb_model = "pc105",
		kb_variant = "altgr-intl",
	},
	misc = {
		disable_hyprland_logo = true,
	},
})
