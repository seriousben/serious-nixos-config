#-------------------------------------------------------------------------------
# SSH Agent
#-------------------------------------------------------------------------------
function __ssh_agent_is_started -d "check if ssh agent is already started"
    if begin
        test -f $SSH_ENV; and test -z "$SSH_AGENT_PID"
        end
        source $SSH_ENV >/dev/null
    end

    if test -z "$SSH_AGENT_PID"
        return 1
    end

    ssh-add -l >/dev/null 2>&1
    if test $status -eq 2
        return 1
    end
end

function __ssh_agent_start -d "start a new ssh agent"
    ssh-agent -c | sed 's/^echo/#echo/' >$SSH_ENV
    chmod 600 $SSH_ENV
    source $SSH_ENV >/dev/null
    ssh-add
end

if not test -d $HOME/.ssh
    mkdir -p $HOME/.ssh
    chmod 0700 $HOME/.ssh
end

if test -d $HOME/.gnupg
    chmod 0700 $HOME/.gnupg
end

if test -z "$SSH_ENV"
    set -xg SSH_ENV $HOME/.ssh/environment
end

if not __ssh_agent_is_started
    __ssh_agent_start
end

#-------------------------------------------------------------------------------
# Programs
#-------------------------------------------------------------------------------
# Vim: We should move this somewhere else but it works for now
mkdir -p $HOME/.vim/{backup,swap,undo}

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------
# Do not show any greeting
set --universal --erase fish_greeting
function fish_greeting
end
funcsave fish_greeting >/dev/null

# Override the nix prompt for the theme so that we show a more concise prompt
function __bobthefish_prompt_nix -S -d 'Display current nix environment'
    [ "$theme_display_nix" = no -o -z "$IN_NIX_SHELL" ]
    and return

    __bobthefish_start_segment $color_nix
    echo -ns N ' '

    set_color normal
end

# config for https://github.com/oh-my-fish/theme-bobthefish
set -g theme_display_date no
set -g theme_display_k8s_context yes
set -g theme_nerd_fonts yes
set -g theme_color_scheme dracula

# My color scheme
set -U fish_color_normal normal
set -U fish_color_command F8F8F2
set -U fish_color_quote F1FA8C
set -U fish_color_redirection 8BE9FD
set -U fish_color_end 50FA7B
set -U fish_color_error FF5555
set -U fish_color_param 5FFFFF
set -U fish_color_comment 6272A4
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion BD93F9
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan

# https://direnv.net/docs/hook.html
set -g direnv_fish_mode eval_on_arrow

#-------------------------------------------------------------------------------
# Vars
#-------------------------------------------------------------------------------
set -x GOPRIVATE github.com/keycardlabs

# NODE_EXTRA_CA_CERTS: Use CA bundle if it exists
if test -f $HOME/.config/certs/ca-bundle.pem
    set -x NODE_EXTRA_CA_CERTS $HOME/.config/certs/ca-bundle.pem
    set -x SSL_CERT_FILE $HOME/.config/certs/ca-bundle.pem
    set -x REQUEST_CA_BUNDLE $HOME/.config/certs/ca-bundle.pem
end

contains $HOME/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/bin
contains $HOME/go/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/go/bin
contains $HOME/.cargo/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/.cargo/bin
# Add ~/.local/bin for pipx
contains $HOME/.local/bin $fish_user_paths; or set -Ua fish_user_paths $HOME/.local/bin

# Exported variables
if isatty
    set -x GPG_TTY (tty)
end

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
function update_repo
    set -l repo $argv[1]

    # Check if we're in a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "⚠️ $repo is not a git repository"
        return
    end

    # Check for changes
    git diff --quiet 2>/dev/null
    set -l diffStatus $status

    # Get current branch
    set -l ref (command git symbolic-ref HEAD 2>/dev/null)
    set -l branch (string replace "refs/heads/" "" "$ref")

    # Update if we're on main/master branch with no changes
    if test "$branch" = "master" -o "$branch" = "main"
        if test $diffStatus -eq 0
            # Check if repository has any commits
            if not git rev-parse --quiet HEAD >/dev/null 2>&1
                echo "🟡 $repo has no commits yet, nothing to update"
                return
            end

            # Store current commit hash before pulling
            set -l before_hash (git rev-parse HEAD)
            set -l out (command git up 2>&1)

            if test $status -eq 0
                # Store commit hash after pulling
                set -l after_hash (git rev-parse HEAD)

                # Compare hashes to see if there were updates
                if test "$before_hash" = "$after_hash"
                    echo "🔵 $repo is already up to date"
                else
                    echo "🟢 Updated $repo"
                end
            else
                echo "🔴 ERROR updating $repo:"
                echo ">>>>>>>"
                echo "$out"
                echo "<<<<<<<<<<"
            end
        else
            set -l changes (command git diff --shortstat 2>/dev/null)
            echo "🟠 $repo NOT UPDATED, has changes: $changes"
        end
    else
        echo "🟣 $repo NOT UPDATED, on branch: $branch"
    end
end

function update_repos
    for dir in (find . -maxdepth 1 -type d)
        if test -d "$dir/.git"
            pushd "$dir"
            update_repo (basename "$dir")
            prevd
        end
    end
end

function op_apply
    op inject -i .envrc.secrets.tmpl -o .envrc.secrets
end

function update_claude_ext
    env NIXPKGS_ALLOW_UNFREE=1 nix path-info --impure github:NixOS/nixpkgs/nixpkgs-unstable#claude-code
end
