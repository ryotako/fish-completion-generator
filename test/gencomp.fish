function setup
    set -g __gencomp_dir (realpath (mktemp -d))
    set -g gencomp_dir "$__gencomp_dir"

    function __gencomp_dummy_command1
        switch "$argv[1]" 
            case -h --help
                string trim "
NAME:
   foo

USAGE:
   foo [global options] command [command options] [arguments...]

VERSION:
   0.0.0

COMMANDS:
     new, n     create foo
     list, l    list foo
     edit, e    edit foo
     help, h    Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h     show help
   --version, -v  print the version
"
            case list
                switch "$argv[2]"
                    case -h --help
                        string trim "
NAME:
   foo list - list foo

USAGE:
   foo list [command options] [arguments...]

OPTIONS:
   --fullpath  show file path of foo
"
                end
        end
    end
end

function teardown
    rm -rf "$__gencomp_dir"
end

test "generate completions"
    0 = (gencomp __gencomp_dummy_command1; echo $status)
end

test "complete them"
    new list edit help = (complete -C"__gencomp_dummy_command1 " | awk '{print $1}') 
end

test "list completions"
    __gencomp_dummy_command1 = (gencomp __gencomp_dummy_command1; gencomp --list)
end

test "erase completions"
    0 = (count (gencomp __gencomp_dummy_command1
        gencomp --erase __gencomp_dummy_command1
        gencomp --list))
end

test "root of completions"
    "$__gencomp_dir" = (gencomp --root)
end

test "dry-run"
    (string trim "
complete -f -c __gencomp_dummy_command1 -n __fish_use_subcommand -a new -d 'create foo'
complete -f -c __gencomp_dummy_command1 -n __fish_use_subcommand -a list -d 'list foo'
complete -f -c __gencomp_dummy_command1 -n __fish_use_subcommand -a edit -d 'edit foo'
complete -f -c __gencomp_dummy_command1 -n __fish_use_subcommand -a help -d 'Shows a list of commands or help for one command'
") = (gencomp __gencomp_dummy_command1 --dry-run)
end

test "generate completions of subcommands' option"
    "--fullpath" = (gencomp __gencomp_dummy_command1 --subcommands;\
        complete -C"__gencomp_dummy_command1 list -" | awk '{print $1}')
end

