export CURRENT_SHELL=$(ps -cp $$ | tail -n1 | rev | cut -d' ' -f1 | rev | tr -dc '[:alnum:]')

# Load everything in .bashrc.d.
test -d ~/.bashrc.d && eval "$(
    find "$_"                         \
        -type d -iname '*.bak' -prune \
        -o -type f                    \
        -exec test -r {} \;           \
        -exec printf '. %s;:' {} \;   \
        -exec basename {} \;          \
    | sort -t: -k2                    \
    | cut -d: -f1                     \
)"

# Load .bashrc for interactive login-shells.
[[ CURRENT_SHELL == bash && $- == *i* ]] && test -r ~/.bashrc && . "$_"

unset CURRENT_SHELL
