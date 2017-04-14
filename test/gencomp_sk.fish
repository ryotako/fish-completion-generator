# test for `gencomp sk`
#
# sk version: 0.2.0

# dummy function
function sk
    string trim "

Usage: sk [options]

  Options
    -h, --help           print this help menu
    --version            print out the current version of skim

  Search
    -t, --tiebreak [score,index,begin,end,-score,...]
                         comma seperated criteria
    -n, --nth 1,2..5     specify the fields to be matched
    --with-nth 1,2..5    specify the fields to be transformed
    -d, --delimiter \t  specify the delimiter(in REGEX) for fields
    --exact              start skim in exact mode
    --regex              use regex instead of fuzzy match

  Interface
    -b, --bind KEYBINDS  comma seperated keybindings, in KEY:ACTION
                         such as 'ctrl-j:accept,ctrl-k:kill-line'
    -m, --multi          Enable Multiple Selection
    --no-multi           Disable Multiple Selection
    -p, --prompt '> '    prompt string for query mode
    --cmd-prompt '> '    prompt string for command mode
    -c, --cmd ag         command to invoke dynamically
    -I replstr           replace `replstr` with the selected item
    -i, --interactive    Start skim in interactive(command) mode
    --ansi               parse ANSI color codes for input strings
    --color [BASE][,COLOR:ANSI]
                         change color theme
    --reverse            Reverse orientation

  Scripting
    -q, --query \"\"       specify the initial query
    -e, --expect KEYS    comma seperated keys that can be used to complete skim

  Environment variables
    SKIM_DEFAULT_COMMAND Default command to use when input is tty
    SKIM_DEFAULT_OPTIONS Default options (e.g. '--ansi --regex')
                         You should not include other environment variables
                         (e.g. '-c \"\$HOME/bin/ag\"')
"
end

# option completions generated in a local environment
string trim "
--ansi	parse ANSI color codes for input strings
--bind	KEYBINDS  comma seperated keybindings, in KEY:ACTION
--cmd	ag         command to invoke dynamically
--cmd-prompt	'> '    prompt string for command mode
--color	[BASE][,COLOR:ANSI]
--delimiter	\t  specify the delimiter(in REGEX) for fields
--exact	start skim in exact mode
--expect	KEYS    comma seperated keys that can be used to complete skim
--help	print this help menu
--interactive	Start skim in interactive(command) mode
--multi	Enable Multiple Selection
--no-multi	Disable Multiple Selection
--nth	1,2..5     specify the fields to be matched
--prompt	'> '    prompt string for query mode
--query	\"\"       specify the initial query
--regex	use regex instead of fuzzy match
--reverse	Reverse orientation
--tiebreak	[score,index,begin,end,-score,...]
--version	print out the current version of skim
--with-nth	1,2..5    specify the fields to be transformed
-I	replstr           replace `replstr` with the selected item
-b	KEYBINDS  comma seperated keybindings, in KEY:ACTION
-c	ag         command to invoke dynamically
-d	\t  specify the delimiter(in REGEX) for fields
-e	KEYS    comma seperated keys that can be used to complete skim
-h	print this help menu
-i	Start skim in interactive(command) mode
-m	Enable Multiple Selection
-n	1,2..5     specify the fields to be matched
-p	'> '    prompt string for query mode
-q	\"\"       specify the initial query
-t	[score,index,begin,end,-score,...]
" | read -z -l want

# execute gencomp
gencomp sk
complete -C'sk -' | sort | uniq | read -z -l got

# test
test 'completion of sk'
    $want = $got
end
