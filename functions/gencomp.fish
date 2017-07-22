function gencomp -d 'generate completions for fish-shell with usage messages'
    # variable
    if test -z "$gencomp_dir"
        if test -z "XDG_CONFIG_HOME"
            set -g gencomp_dir "$XDG_CONFIG_HOME/fish/generated_completions"
        else
            set -g gencomp_dir "$HOME/.config/fish/generated_completions"
        end
    end

    # usage
    function __gencomp_usage
        echo "NAME:"
        echo "    gencomp - Completion generator for fish-shell"
        echo
        echo "USAGE:"
        echo "    gencomp [options] [command names...]"
        echo
        echo "OPTIONS:"
        echo "    -l, --list        list generated completions"
        echo "    -e, --erase       erase generated completions"
        echo "    -d, --dry-run     print completions without saving"
        echo "    -r, --root        print the directory to save completions"
        echo "    -s, --subcommand  generate completion for subcommands"
        echo "    -u, --use         use the specified command to get usage"
        echo "                      ``{}'' is replaced with the arguments"
        echo "    -h, --help        show this help"
        echo "VARIABLES:"
        echo "    gencomp_dir       directory to save completions"
        echo
        echo "EXAMPLES:"
        echo "    gencomp peco"
        echo "    gencomp ghq -s"
        echo "    gencomp bd -u '{} -h'"
    end

    function __gencomp_option_completion -a cmd sub short long old desc
        echo -n "complete -c $cmd"
        if test "$long" = version
            echo -n " -n __fish_no_arguments"
        else if test -n "$sub"
            echo -n ' -n '(string escape -- "__fish_seen_subcommand_from $sub")
        end
        test -n "$short" ; and echo -n ' -s '(string escape -- "$short")
        test -n "$long"  ; and echo -n ' -l '(string escape -- "$long")
        test -n "$old"   ; and echo -n ' -s '(string escape -- "$old")
        test -n "$desc"  ; and echo -n ' -d '(string trim "$desc" | string escape)
        echo
    end

    function __gencomp_subcommand_completion -a cmd sub desc
        echo -n "complete -f -c $cmd"
        echo -n " -n __fish_use_subcommand -a "(string escape -- "$sub")
        echo -n " -d "(string trim "$desc" | string escape)
        echo
    end

    function __gencomp_parse -a cmd sub usage parse_subcommand
        set -l section default

        eval (string replace -a -- "{}" "$cmd $sub" "$usage") 2>&1 | tr \t ' ' | while read -l line

            # parse subcommand
            if string match -iqr "^([\w ]* )?commands?( [\w ]*)?" -- "$line"
                set section command
                continue
            end

            if test "$section" = command -a -z "$sub"

                # e.g.)
                # COMMANDS
                #     command, c   do something
                set -l words (string match -r -- '^ +([\w-]+)(?:, *)\w(?:[,= ] *)(.*)' "$line")
                if test (count $words) = 3
                    __gencomp_subcommand_completion "$cmd" "$words[2]" "$words[3]"
                    if test "$parse_subcommand" = true
                        __gencomp_parse "$cmd" "$words[2]" "$usage" false
                    end
                    continue
                end

                # e.g.)
                # COMMANDS
                #     command    do simething
                set -l words (string match -r -- '^ +(\w+)(?:[,= ] *)(.*)' "$line")
                if test (count $words) = 3
                    __gencomp_subcommand_completion "$cmd" "$words[2]" "$words[3]"
                    if test "$parse_subcommand" = true
                        __gencomp_parse "$cmd" "$words[2]" "$usage" false
                    end
                    continue
                end
                
                set section default
            end

            # parse options

            # e.g.) -h, --help  show help
            set -l words (string match -r -- "^ *-(\w)(?:, | )--(\w[\w-]+) +(.*)" "$line")
            if test (count $words) = 4
                __gencomp_option_completion "$cmd" "$sub" "$words[2]" "$words[3]" "" "$words[4]"
                continue
            end
            
            # e.g.) --help, -h  show help
            set -l words (string match -r -- "^ *--(\w[\w-]+)(?:, | )-(\w) +(.*)" "$line")
            if test (count $words) = 4
                __gencomp_option_completion "$cmd" "$sub" "$words[3]" "$words[2]" "" "$words[4]"
                continue
            end

            # e.g.) --help  shiw help
            set -l words (string match -r -- "^ *--(\w[\w-]+) +(.*)" "$line")
            if test (count $words) = 3
                __gencomp_option_completion "$cmd" "$sub" "" "$words[2]" "" "$words[3]"
                continue
            end

            # e.g.) -h  shiw help
            set -l words (string match -r -- "^ *-(\w) +(.*)" "$line")
            if test (count $words) = 3
                __gencomp_option_completion "$cmd" "$sub" "$words[2]" "" "" "$words[3]"
                continue
            end

            # e.g.) -help  shiw help
            set -l words (string match -r -- "^ *-(\w[\w-]+) +(.*)" "$line")
            if test (count $words) = 3
                __gencomp_option_completion "$cmd" "$sub" "" "" "$words[2]" "$words[3]"
                continue
            end

        end
    end

    set -l key unparsed
    set -l value
    set -l action
    set -l commands
    set -l is_dry_run false
    set -l parse_subcommand false
    set -l usage "{} --help"

    argu {e,erase} {l,list} {d,dry-run} {h,help} {r,root} {s,subcommand} {u,use}:\
        -- $argv | while read key value
        switch "$key"
            case _
                set commands $commands "$value"
            case -e --erase
                set action $action erase 
            case -l --list
                set action $action list
            case -d --dry-run
                set is_dry_run true
            case -r --root
                echo "$gencomp_dir"
                return
            case -s --subcommand
                set parse_subcommand true
            case -u --use
                set usage "$value"
            case -h --help
                __gencomp_usage
                return
        end
    end

    if begin count $argv >/dev/null; and test "$key" = unparsed; end
        return 1
    else if test (count $action) -gt 1
        echo "gencomp: invalid option combinaton" >&2
        return 1
    else if test -n "$action" -a "$is_dry_run" = true
        echo "gencomp: invalid option combinaton" >&2
        return 1
    else if test -n "$action" -a "$parse_subcommand" = true
        echo "gencomp: invalid option combinaton" >&2
        return 1
    end

    # default action
    if test -z "$action"
        set action (count $commands >/dev/null; and echo complete; or echo list)
    end
    
    # subcommand parsing requires a place holder in $usage
    if not string match -q "*{}*" -- "$usage"
        set parse_subcommand false
    end

    switch "$action"
        case erase
            for command in $commands
                if test -f "$gencomp_dir/$command.fish"
                    rm "$gencomp_dir/$command.fish"
                end
            end
        case list
            for path in "$gencomp_dir"/*.fish
                basename "$path" .fish 
            end
        case complete

            for command in $commands
                if not type -q "$command"
                    echo "gencomp: command '$command' is not found" >&2
                    continue
                end

                if test "$is_dry_run" != true
                    mkdir -p "$gencomp_dir"
                    or continue

                    echo > "$gencomp_dir/$command.fish"
                    or continue
                end

                for completion in (__gencomp_parse "$command" "" "$usage" "$parse_subcommand")
                    if test "$is_dry_run" = true
                        echo "$completion"
                    else
                        eval "$completion"
                        and echo "$completion" >> "$gencomp_dir/$command.fish"
                    end
                end
            end 

    end
end
