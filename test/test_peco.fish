# test for `gencomp peco`
#
# peco version: peco version v0.5.1

# dummy function
function peco
    string trim "

Usage: peco [options] [FILE]

Options:
  -h, --help            show this help message and exit
  --query               initial value for query
  --rcfile              path to the settings file
  --version             print the version and exit
  -b, --buffer-size     number of lines to keep in search buffer
  --null                expect NUL (\0) as separator for target/output
  --initial-index       position of the initial index of the selection (0 base)
  --initial-matcher     specify the default matcher (deprecated)
  --initial-filter      specify the default filter
  --prompt              specify the prompt string
  --layout              layout to be used. 'top-down' or 'bottom-up'. default is 'top-down'
  --select-1            select first item and immediately exit if the input contains only 1 item
  --on-cancel           specify action on user cancel. 'success' or 'error'.
                        default is 'success'. This may change in future versions
  --selection-prefix    use a prefix instead of changing line color to indicate currently selected lines.
                        default is to use colors. This option is experimental
  --exec                execute command instead of finishing/terminating peco.
                        Please note that this command will receive selected line(s) from stdin,
                        and will be executed via '/bin/sh -c' or 'cmd /c'
"
end

# option completions generated in a local environment
string trim "
--buffer-size	number of lines to keep in search buffer
--exec	execute command instead of finishing/terminating peco.
--help	show this help message and exit
--initial-filter	specify the default filter
--initial-index	position of the initial index of the selection (0 base)
--initial-matcher	specify the default matcher (deprecated)
--layout	layout to be used. 'top-down' or 'bottom-up'. default is 'top-down'
--null	expect NUL (\0) as separator for target/output
--on-cancel	specify action on user cancel. 'success' or 'error'.
--prompt	specify the prompt string
--query	initial value for query
--rcfile	path to the settings file
--select-1	select first item and immediately exit if the input contains only 1 item
--selection-prefix	use a prefix instead of changing line color to indicate currently selected lines.
--version	print the version and exit
-b	number of lines to keep in search buffer
-h	show this help message and exit
" | read -z -l want

# execute gencomp
gencomp peco
complete -C'peco -' | sort | uniq | read -z -l got

# test
test 'completion of peco'
    $want = $got
end
