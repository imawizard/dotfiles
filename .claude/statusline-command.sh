#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# # Extract values from JSON
# cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
# total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
# total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
# used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
# model=$(echo "$input" | jq -r '.model.display_name')
# total_cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd' | xargs printf '%.2f')
# output_style=$(echo "$input" | jq -r '.output_style.name')
#
# # Get current directory basename
# dir_name=$(basename "$cwd")
#
# # Check if we're in a git repository and get branch name
# git_branch=""
# if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
#     git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
#     if [ -n "$git_branch" ]; then
#         git_branch=" ($git_branch)"
#     fi
# fi
#
# # Build status line
# status="$output_style: $dir_name$git_branch @ $model ($total_cost_usd$)"
#
# # Add context window info if available
# if [ -n "$used_pct" ]; then
#     status="$status | in: ${total_input}t | out: ${total_output}t | used: ${used_pct}%"
# fi
#
# echo "$status"
#
# see https://code.claude.com/docs/en/statusline

model=$(echo "$input" | jq -r '.model.display_name // "unknown model"')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
branch=$(echo "$input" | jq -r '.worktree.branch // empty')
wt_name=$(echo "$input" | jq -r '.worktree.name // empty')
wt_orig_branch=$(echo "$input" | jq -r '.worktree.original_branch // empty')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

dim="\033[90m"
reset="\033[0m"

# Compute rounded time-until-reset label from unix timestamp
# Usage: time_label <resets_at> <fallback_label>
time_label() {
  local resets_at=$1 fallback=$2
  if [ -z "$resets_at" ]; then echo "$fallback"; return; fi
  local now_s=$(date +%s)
  local diff=$(( resets_at - now_s ))

  if [ "$diff" -le 0 ]; then echo "0m"; return; fi

  if [ "$diff" -lt 3600 ]; then
    echo "$(( (diff + 30) / 60 ))m"
  elif [ "$diff" -lt 86400 ]; then
    echo "$(( (diff + 1800) / 3600 ))h"
  else
    echo "$(( (diff + 43200) / 86400 ))d"
  fi
}

# Render a labeled bar
# Usage: make_bar <label> <percentage> <color_code>
make_bar() {
  local label=$1 pct=${2:-0} color=$3 width=8
  local filled=$(echo "$pct $width" | awk '{printf "%.0f", $1/100*$2}')
  local empty=$((width - filled))
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="━"; done
  for ((i=0; i<empty; i++)); do bar+="─"; done
  printf "${dim}%s ${reset}\033[%sm%s${dim}%s %.0f%%${reset}" "$label" "$color" "${bar:0:$filled}" "${bar:$filled}" "$pct"
}

# Line 1: Model, stats (branch shown here only when not in a worktree)
printf "🤖 \033[1;36m%s${reset}" "$model"
if [ -n "$branch" ] && [ -z "$wt_name" ]; then
  printf " ${dim}on${reset} \033[35m%s${reset}" "$branch"
fi

stats=""
if [ -n "$duration_ms" ]; then
  duration_s=$(echo "$duration_ms" | awk '{printf "%.0f", $1/1000}')
  if [ "$duration_s" -ge 60 ] 2>/dev/null; then
    duration_fmt=$(echo "$duration_s" | awk '{m=int($1/60); s=$1%60; printf "%dm%02ds", m, s}')
  else
    duration_fmt="${duration_s}s"
  fi
  #stats=$(printf "⏱ %s${reset}" "$duration_fmt")
fi
if [ -n "$cost_usd" ]; then
  [ -n "$stats" ] && stats="$stats $(printf " ${dim}·${reset} ") "
  stats="$stats$(printf "💰 \033[32m\$%.2f${reset}" "$cost_usd")"
fi
if [ -n "$lines_added" ] || [ -n "$lines_removed" ]; then
  [ -n "$stats" ] && stats="$stats $(printf " ${dim}·${reset} ") "
  stats="$stats$(printf "✏️  \033[32m+%s${reset} \033[31m-%s${reset}" "${lines_added:-0}" "${lines_removed:-0}")"
fi
if [ -n "$stats" ]; then
  printf "  ${dim}·${reset}  %s" "$stats"
fi
printf "\n"

# Line 2: Percentage bars
line2=""
if [ -n "$ctx_used" ]; then
  line2="📊 $(make_bar "ctx" "$ctx_used" "32")"
fi
if [ -n "$five_hour" ]; then
  [ -n "$line2" ] && line2="$line2 $(printf "${dim}·${reset}") "
  five_hour_label=$(time_label "$five_hour_resets" "5h")
  line2="$line2$(make_bar "$five_hour_label" "$five_hour" "33")"
fi
if [ -n "$seven_day" ]; then
  [ -n "$line2" ] && line2="$line2 $(printf "${dim}·${reset}") "
  seven_day_label=$(time_label "$seven_day_resets" "7d")
  line2="$line2$(make_bar "$seven_day_label" "$seven_day" "33")"
fi
if [ -n "$line2" ]; then
  printf "%s\n" "$line2"
fi

# Line 3: Worktree branch or CWD
if [ -n "$wt_name" ]; then
  #printf "🌿 \033[35m%s${reset}" "$branch"
  printf "🌿 \033[35m%s${reset}" "$wt_name"
  if [ -n "$wt_orig_branch" ]; then
    printf "  ${dim}←${reset}  %s" "$wt_orig_branch"
  fi
  printf "\n"
else
  cwd=$(echo "$input" | jq -r '.cwd // ""')
  cwd="${cwd/#$HOME\/Documents\/code\//}"
  printf "📂 \033[36m%s${reset}\n" "$cwd"
fi
