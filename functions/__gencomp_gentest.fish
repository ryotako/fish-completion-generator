function __gencomp_gentest -a cmd -d 'generate scaffold of test file'
    if not type -q $cmd
        echo "__gencomp_gentest: command '$cmd' is not found"
        return
    end

    function __gencomp_escape
        cat | string replace -a \" \\\" | string replace -a \$ \\\$
    end

    eval "$cmd --version" ^&1 | read -l version
    eval "$cmd --help" ^&1 | __gencomp_escape | read -z -l help
    # gencomp $cmd
    complete -C"$cmd -" | sort | uniq | __gencomp_escape | read -z -l candidates

    string trim "
# test for `gencomp $cmd`
#
# $cmd version: $version

# dummy function
function $cmd
    string trim \"
$help\"
end

# option completions generated in a local environment
string trim \"
$candidates\" | read -z -l want

# execute gencomp
gencomp $cmd
complete -C'$cmd -' | sort | uniq | read -z -l got

# test
test 'completion of $cmd'
    \$want = \$got
end

"
end
