local wezterm = require("wezterm")
local act = wezterm.action

local github = wezterm.get_builtin_color_schemes()["Github"]
github.ansi[4] = "#ff9300"
github.brights[3] = "#8ccba5"
github.brights[6] = "#ffa29f"

-- See https://wezfurlong.org/wezterm/config/lua/config/index.html
return {
  default_prog = wezterm.target_triple:find("win") and { "pwsh.exe" },
  skip_close_confirmation_for_processes_named = {},

  window_decorations = "RESIZE",
  show_update_window = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 30,
  tab_and_split_indices_are_zero_based = true,
  switch_to_last_active_tab_when_closing_tab = true,
  -- See https://github.com/wez/wezterm/issues/1598 for renaming tabs

  color_scheme = "Github",
  font = wezterm.font("FiraCode NFM"),
  font_size = 9.5,
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  default_cursor_style = "BlinkingUnderline",
  cursor_blink_rate = 600,
  cursor_blink_ease_in = "Constant",
  cursor_blink_ease_out = "Constant",

  audible_bell = "Disabled",
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  },
  colors = {
    visual_bell = "#202020",
  },
  color_schemes = {
    ["Github"] = github,
  },

  leader = { key = "b", mods = "CTRL", timeout_milliseconds = 3000 },
  disable_default_key_bindings = true,
  -- See https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html
  keys = {
    { key = "b", mods = "LEADER|CTRL",
      action = act.SendString("\x02") },
    { key = ":", mods = "LEADER|SHIFT",
      action = act.ShowLauncherArgs({ flags = "FUZZY|COMMANDS|LAUNCH_MENU_ITEMS" }) },
    { key = "Space", mods = "LEADER",
      action = act.QuickSelect },

    -- panes
    { key = "%", mods = "LEADER|SHIFT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = '"', mods = "LEADER|SHIFT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "o", mods = "LEADER",
      action = act.ActivatePaneDirection("Next") },
    { key = "q", mods = "LEADER",
      action = act.PaneSelect({ mode = "Activate", alphabet = "0123456789" }) },
    { key = "x", mods = "LEADER",
      action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER",
      action = act.TogglePaneZoomState },

    -- windows
    { key = "c", mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain") },
    { key = "p", mods = "LEADER",
      action = act.ActivateTabRelative(-1) },
    { key = "n", mods = "LEADER",
      action = act.ActivateTabRelative(1) },
    { key = "&", mods = "LEADER|SHIFT",
      action = act.CloseCurrentTab({ confirm = true }) },
    { key = "0", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "1", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(8) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(9) },

    -- copy mode
    { key = "[", mods = "LEADER",
      action = act.ActivateCopyMode },
    { key = "]", mods = "LEADER",
      action = act.PasteFrom("Clipboard") },

    -- copy_mode = {
    --   append-selection-and-cancel      A
    --   back-to-indentation              ^
    --   begin-selection                  Space
    --   bottom-line                      L
    --   cancel                           q
    --   clear-selection                  Escape
    --   copy-pipe-end-of-line-and-cancel D
    --   copy-selection-and-cancel        Enter
    --   cursor-down                      j
    --   cursor-left                      h
    --   cursor-right                     l
    --   cursor-up                        k
    --   end-of-line                      $
    --   goto-line                        :
    --   halfpage-down                    C-d
    --   halfpage-up                      C-u
    --   history-bottom                   G
    --   history-top                      g
    --   jump-again                       ;
    --   jump-backward                    F
    --   jump-forward                     f
    --   jump-reverse                     ,
    --   jump-to-backward                 T
    --   jump-to-forward                  t
    --   jump-to-mark                     M-x
    --   middle-line                      M
    --   next-matching-bracket            %
    --   next-paragraph                   }
    --   next-space                       W
    --   next-space-end                   E
    --   next-word                        w
    --   next-word-end                    e
    --   other-end                        o
    --   page-down                        C-f
    --   page-up                          C-b
    --   previous-paragraph               {
    --   previous-space                   B
    --   previous-word                    b
    --   rectangle-toggle                 v
    --   refresh-from-pane                r
    --   scroll-down                      C-e
    --   scroll-up                        C-y
    --   search-again                     n
    --   search-backward                  ?
    --   search-forward                   /
    --   scroll-middle                    z
    --   search-reverse                   N
    --   select-line                      V
    --   set-mark                         X
    --   start-of-line                    0
    --   toggle-position                  P
    --   top-line                         H
    -- }
  },
}
