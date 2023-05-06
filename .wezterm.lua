local wezterm = require("wezterm")
local act = wezterm.action

local github = wezterm.get_builtin_color_schemes()["Github"]
github.ansi[4] = "#ff9300"
github.brights[3] = "#8ccba5"
github.brights[6] = "#ffa29f"

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane

    function basename(s)
      return string.gsub(s, "(.*[/\\])(.*)", "%2")
    end

    local process = basename(pane.foreground_process_name)
    local title = tab.tab_index .. ":"

    if pane.title and pane.title ~= process then
      title = title .. pane.title
    else
      local manually_set = tab.tab_title
      if manually_set and #manually_set > 0 then
        title = title .. "\x1b[4m" .. manually_set .. "\x1b[0m"
      else
        local cwd = string.gsub(pane.current_working_dir, os.getenv("HOME"), "~")
        title = title .. basename(cwd)
      end

      title = title .. "|" .. process
    end

    return " " .. title .. " "
  end
)

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
    fade_in_duration_ms = 50,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 50,
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
    { key = "b", mods = "LEADER|CTRL", action = act.SendString("\x02") },
    { key = ":", mods = "LEADER|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|COMMANDS|LAUNCH_MENU_ITEMS" }) },
    -- TODO: Should keep e.g. vim's cursor position (rn always bottom instead).
    { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "]", mods = "LEADER", action = act.PasteFrom("Clipboard") },
    { key = "{", mods = "LEADER|SHIFT", action = act.Multiple({
        { RotatePanes = "CounterClockwise" },
        { ActivatePaneDirection = "Prev" },
      }),
    },
    { key = "}", mods = "LEADER|SHIFT", action = act.Multiple({
        { RotatePanes = "Clockwise" },
        { ActivatePaneDirection = "Next" },
      }),
    },
    { key = "Space", mods = "LEADER", action = act.QuickSelect },

    -- panes
    { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
    { key = "q", mods = "LEADER", action = act.PaneSelect({ mode = "Activate", alphabet = "0123456789" }) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "!", mods = "LEADER|SHIFT", action = wezterm.action_callback(function(win, pane)
      local tab, window = pane:move_to_new_tab()
      tab:activate()
    end) },

    -- tabs
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    { key = ",", mods = "LEADER",
      action = act.PromptInputLine({
        description = "Rename tab:",
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
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
  },

  key_tables = {
    copy_mode = {
      { key = "q", mods = "NONE", action = act.CopyMode("Close") },
      { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
      { key = "Escape", mods = "NONE", action = act.CopyMode("ClearSelectionMode") },

      { key = "Enter", mods = "NONE", action = act.Multiple({
          { CopyTo = "ClipboardAndPrimarySelection" },
          { CopyMode = "Close" },
        }),
      },
      { key = "Space", mods = "NONE", action = act.Multiple({
          { CopyMode = "ClearSelectionMode" },
          { CopyMode = { SetSelectionMode = "Cell" } },
        }),
      },
      { key = "v", mods = "SHIFT", action = act.Multiple({
          { CopyMode = "ClearSelectionMode" },
          { CopyMode = { SetSelectionMode = "Line" } },
        }),
      },
      -- TODO: Should be a toggle on top of Cell/Line.
      { key = "v", mods = "NONE", action = act.Multiple({
          { CopyMode = "ClearSelectionMode" },
          { CopyMode = { SetSelectionMode = "Block" } },
        }),
      },
      { key = "v", mods = "CTRL", action = act.Multiple({
          { CopyMode = "ClearSelectionMode" },
          { CopyMode = { SetSelectionMode = "Block" } },
        }),
      },

      { key = "o", mods = "NONE",  action = act.CopyMode("MoveToSelectionOtherEnd") },

      { key = "j", mods = "NONE",  action = act.CopyMode("MoveDown") },
      { key = "h", mods = "NONE",  action = act.CopyMode("MoveLeft") },
      { key = "l", mods = "NONE",  action = act.CopyMode("MoveRight") },
      { key = "k", mods = "NONE",  action = act.CopyMode("MoveUp") },

      { key = "d", mods = "CTRL",  action = act.CopyMode({ MoveByPage = 0.5 }) },
      { key = "u", mods = "CTRL",  action = act.CopyMode({ MoveByPage = -0.5 }) },
      { key = "f", mods = "CTRL",  action = act.CopyMode("PageDown") },
      { key = "b", mods = "CTRL",  action = act.CopyMode("PageUp") },
      { key = "e", mods = "CTRL",  action = act.Multiple({ { ScrollByLine = 1 }, { CopyMode = "MoveDown" } }) },
      { key = "y", mods = "CTRL",  action = act.Multiple({ { ScrollByLine = -1 }, { CopyMode = "MoveUp" } }) },

      { key = "g", mods = "NONE",  action = act.CopyMode("MoveToScrollbackTop") },
      { key = "g", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },

      { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
      { key = "0", mods = "NONE",  action = act.CopyMode("MoveToStartOfLine") },
      { key = "^", mods = "NONE",  action = act.CopyMode("MoveToStartOfLineContent") },

      { key = "m", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
      { key = "h", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
      { key = "l", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },

      { key = "b", mods = "NONE",  action = act.CopyMode("MoveBackwardWord") },
      { key = "w", mods = "NONE",  action = act.CopyMode("MoveForwardWord") },
      { key = "e", mods = "NONE",  action = act.CopyMode("MoveForwardWordEnd") },

      { key = "f", mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = false } }) },
      { key = "t", mods = "NONE",  action = act.CopyMode({ JumpForward = { prev_char = true  } }) },
      { key = "f", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
      { key = "t", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true  } }) },
      { key = ";", mods = "NONE",  action = act.CopyMode("JumpAgain") },
      { key = ",", mods = "NONE",  action = act.CopyMode("JumpReverse") },

      { key = "/", mods="SHIFT", action = act.Multiple({
          { Search = { CaseSensitiveString = "" } },
          { CopyMode = "ClearPattern" },
        }),
      },
      { key = "n", mods = "NONE", action = act.Multiple({
          { CopyMode = "NextMatch" },
          { CopyMode = "MoveToSelectionOtherEnd" },
          { CopyMode = "ClearSelectionMode" },
        }),
      },
      { key = "n", mods = "SHIFT", action = act.Multiple({
          { CopyMode = "PriorMatch" },
          { CopyMode = "MoveToSelectionOtherEnd" },
          { CopyMode = "ClearSelectionMode" },
        }),
      },
    },
    search_mode = {
      { key = "Escape", mods = "NONE", action = act.Multiple({
          "ActivateCopyMode",
          { CopyMode = "ClearPattern" },
        }),
      },
      { key = "Enter", mods = "NONE", action = act.Multiple({
          "ActivateCopyMode",
          { CopyMode = "MoveToSelectionOtherEnd" },
          { CopyMode = "ClearSelectionMode" },
        }),
      },
    },
  },
}
