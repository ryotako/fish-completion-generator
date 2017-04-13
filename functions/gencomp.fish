function gencomp -d 'generate completions for fish-shell with usage messages'
    
    function __gencomp_help
        string trim "
NAME:
    gencomp - Completion generator for fish-shell

USAGE:
    gencomp [options] arguments...

OPTIONS:
    -v, --verbose   print commands for completion
    -p, --print     print commands for completion without execution
    -q, --quiet     suppress error messages

    -h, --help      show this help
"
    end

    set -l cmds
    set -l opts
    while count $argv >/dev/null
        switch $argv[1]
            case -h --help
                __gencomp_help
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
            
            # -h, --help    help message like this
            set -l a (string match -r '^[ \t]*-([^- ]),? +--([^,= ]+)=? *(.*)$' -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[4..-1]")
                set outs $outs "complete -c $cmd -s $a[2] -l $a[3] -d '$msg'"

                continue
            end

            # --help, -h    help message like this
            set -l a (string match -r '^[ \t]*--([^, ]+),? +-([^-= ])=? *(.*)$' -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[4..-1]")
                set outs $outs "complete -c $cmd -s $a[3] -l $a[2] -d '$msg'"

                continue
            end

            # --help    help message like this
            set -l a (string match -r '^[ \t]*--([^,= ]+)=? *(.*)$' -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3..-1]")
                set outs $outs "complete -c $cmd -l $a[2] -d '$msg'"

                continue
            end

            # -h    help message like this
            set -l a (string match -r '^[ \t]*-([^-= ])=? *(.*)$' -- $line)
            if test $status = 0
                set -l msg (string replace -a \' \\\' -- "$a[3..-1]")
                set outs $outs "complete -c $cmd -s $a[2] -d '$msg'"

                continue
            end

        end

        for out in $outs
            if begin; contains v $opts; or contains p $opts; end
                echo $out
            end
            if not contains p $opts
                eval $out
            end
        end

    end
end
