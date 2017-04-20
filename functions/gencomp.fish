function gencomp -d 'generate completions for fish-shell with usage messages'

    # variables
    if test -z "$gencomp_dir"
        set -gx gencomp_dir ~/.config/fish/generated_completions
    end

    # help command
    function __gencomp_help
        string trim "
NAME:
    gencomp - Completion generator for fish-shell

USAGE:
    gencomp [options] [command] [arguments...]

COMMANDS:
    ls      List generated completions
    rm      Remove generated completions 
    help    Show this help

OPTIONS:
    -v, --verbose   print commands for completion
    -p, --print     print commands for completion without execution
    -q, --quiet     suppress error messages

    -h, --help      show this help
"
    end

    # ls command
    function __gencomp_ls -V gencomp_dir
        ls $gencomp_dir | string match -r '.*(?=\.fish$)'
    end
    
    # rm command 
    function __gencomp_rm -V gencomp_dir
        for cmd in $argv
            if contains $cmd (__gencomp_ls)
                rm "$gencomp_dir/$cmd.fish"
            end
        end
    end

    set -l cmds
    set -l opts
    while count $argv >/dev/null
        switch $argv[1]
            case help -h --help
                __gencomp_help
                return
            case ls
                __gencomp_ls
                return
            case rm
                set -e argv[1]
                __gencomp_rm $argv
                return
            case -p --print
                set opts $opts p
            case -v --verbose
                set opts $opts v
            case -q --quiet
                set opts $opts q
            case '-*'
                echo "gencomp: invalid option '$argv[1]'"
                return
            case '*'
                set cmds $cmds $argv[1]
        end
        set -e argv[1]
    end

    # loop for each command
    for cmd in $cmds
        
        # command is available?
        if not type -q $cmd
            contains q $opts
            or echo "gencomp: command '$cmd' is not found" >/dev/stderr
            continue
        end

        eval "$cmd --help" ^&1 | read -z -l lines

        # --help option is available?
        if test $status != 0
            contains q $opts
            or echo "gencomp: '$cmd --help' is not available" >/dev/stderr
            continue
        end

        set -l outs
        for line in (echo $lines)
            set -l i '^[ \t]*' # indent
            set -l d '(?:,[ \t]*|[ \t]+|[ \t]\|[ \t])' # delimiter
            set -l t '(?:[,=][ \t]*|[ \t]+)' # tab
            set -l c '[\w\?!@]' # charactors
            set -l C '[\w\?!@-]' # charactors including -
            
            # -h, --help    help message like this
            set -l a (string match -r "$i-($c)$d--($C+)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[4]")
                if test -z $msg
                    set msg $a[3]
                end
                set outs $outs "complete -c $cmd -s $a[2] -l $a[3] -d '$msg'"

                continue
            end

            # --help, -h    help message like this
            set -l a (string match -r "$i--($C+)$d-($c)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[4]")
                if test -z $msg
                    set msg $a[2]
                end
                set outs $outs "complete -c $cmd -s $a[3] -l $a[2] -d '$msg'"

                continue
            end

            # --help    help message like this
            set -l a (string match -r "$i--($C+)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3]")
                set outs $outs "complete -c $cmd -l $a[2] -d '$msg'"

                continue
            end

            # -h    help message like this
            set -l a (string match -r "$i-($c)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3]")
                set outs $outs "complete -c $cmd -s $a[2] -d '$msg'"

                continue
            end
            
            # -help
            set -l a (string match -r "$i-($c$C+)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3]")
                set outs $outs "complete -c $cmd -o $a[2] -d '$msg'"

                continue
            end

            # [-no]-option  enable/disable ...
            set -l a (string match -r "$i\[-no\]-($c$C+)$t(.*)\$" -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3]")
                set outs $outs "complete -c $cmd -o $a[2] -d '$msg'"
                set outs $outs "complete -c $cmd -o no-$a[2] -d '$msg'"

                continue
            end

        end
        

        if begin; contains v $opts; or contains p $opts; end
            string join \n $outs
        end

        if not contains p $opts
            if not test -d "$gencomp_dir"
                mkdir -p "$gencomp_dir"
            end

            string join \n $outs > "$gencomp_dir/$cmd.fish"
            eval (string join '; ' $outs)
        end

    end
end
