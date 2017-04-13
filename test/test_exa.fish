# test for `gencomp exa`
#
# exa version: exa 0.4.0

# dummy function
function exa
    string trim "
Usage:
  exa [options] [files...]

DISPLAY OPTIONS
  -1, --oneline      display one entry per line
  -G, --grid         display entries in a grid view (default)
  -l, --long         display extended details and attributes
  -R, --recurse      recurse into directories
  -T, --tree         recurse into subdirectories in a tree view
  -x, --across       sort multi-column view entries across

  --color=WHEN,  --colour=WHEN   when to colourise the output (always, auto, never)
  --color-scale, --colour-scale  colour file sizes according to their magnitude

FILTERING AND SORTING OPTIONS
  -a, --all                  show dot-files
  -d, --list-dirs            list directories as regular files
  -r, --reverse              reverse order of files
  -s, --sort SORT_FIELD      field to sort by. Choices: name,
                                 size, extension, modified,
                                 accessed, created, inode, none
  --group-directories-first  list directories before other files
  -I, --ignore-glob GLOBS    glob patterns (pipe-separated) of files to ignore

LONG VIEW OPTIONS
  -b, --binary       use binary prefixes in file sizes
  -B, --bytes        list file sizes in bytes, without prefixes
  -g, --group        show group as well as user
  -h, --header       show a header row at the top
  -H, --links        show number of hard links
  -i, --inode        show each file's inode number
  -L, --level DEPTH  maximum depth of recursion
  -m, --modified     display timestamp of most recent modification
  -S, --blocks       show number of file system blocks
  -t, --time FIELD   which timestamp to show for a file. Choices:
                         modified, accessed, created
  -u, --accessed     display timestamp of last access for a file
  -U, --created      display timestamp of creation for a file
  --git              show git status for files
  -@, --extended     display extended attribute keys and sizes

"
end

# option completions generated in a local environment
string trim "
--accessed	display timestamp of last access for a file
--across	sort multi-column view entries across
--all	show dot-files
--binary	use binary prefixes in file sizes
--blocks	show number of file system blocks
--bytes	list file sizes in bytes, without prefixes
--color	WHEN,  --colour=WHEN   when to colourise the output (always, auto, never)
--color-scale	, --colour-scale  colour file sizes according to their magnitude
--created	display timestamp of creation for a file
--extended	display extended attribute keys and sizes
--git	show git status for files
--grid	display entries in a grid view (default)
--group	show group as well as user
--group-directories-first	list directories before other files
--header	show a header row at the top
--ignore-glob	GLOBS    glob patterns (pipe-separated) of files to ignore
--inode	show each file's inode number
--level	DEPTH  maximum depth of recursion
--links	show number of hard links
--list-dirs	list directories as regular files
--long	display extended details and attributes
--modified	display timestamp of most recent modification
--oneline	display one entry per line
--recurse	recurse into directories
--reverse	reverse order of files
--sort	SORT_FIELD      field to sort by. Choices: name,
--time	FIELD   which timestamp to show for a file. Choices:
--tree	recurse into subdirectories in a tree view
-1	display one entry per line
-@	display extended attribute keys and sizes
-B	list file sizes in bytes, without prefixes
-G	display entries in a grid view (default)
-H	show number of hard links
-I	GLOBS    glob patterns (pipe-separated) of files to ignore
-L	DEPTH  maximum depth of recursion
-R	recurse into directories
-S	show number of file system blocks
-T	recurse into subdirectories in a tree view
-U	display timestamp of creation for a file
-a	show dot-files
-b	use binary prefixes in file sizes
-d	list directories as regular files
-g	show group as well as user
-h	show a header row at the top
-i	show each file's inode number
-l	display extended details and attributes
-m	display timestamp of most recent modification
-r	reverse order of files
-s	SORT_FIELD      field to sort by. Choices: name,
-t	FIELD   which timestamp to show for a file. Choices:
-u	display timestamp of last access for a file
-x	sort multi-column view entries across
" | read -z -l want

# execute gencomp
gencomp exa
complete -C'exa -' | sort | uniq | read -z -l got

# test
test 'completion of exa'
    $want = $got
end
