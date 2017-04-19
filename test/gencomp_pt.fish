# test for `gencomp pt`
#
# pt version: pt version 2.1.5

# dummy function
function pt
    string trim "
Usage:
  pt [OPTIONS] PATTERN [PATH]

Application Options:
      --version             Show version

Output Options:
      --color               Print color codes in results (default: true)
      --nocolor             Don't print color codes in results (default: false)
      --color-line-number=  Color codes for line numbers (default: 1;33)
      --color-path=         Color codes for path names (default: 1;32)
      --color-match=        Color codes for result matches (default: 30;43)
      --group               Print file name at header (default: true)
      --nogroup             Don't print file name at header (default: false)
  -0, --null                Separate filenames with null (for 'xargs -0')
                            (default: false)
      --column              Print column (default: false)
      --numbers             Print Line number. (default: true)
  -N, --nonumbers           Omit Line number. (default: false)
  -A, --after=              Print lines after match
  -B, --before=             Print lines before match
  -C, --context=            Print lines before and after match
  -l, --files-with-matches  Only print filenames that contain matches
  -c, --count               Only print the number of matching lines for each
                            input file.
  -o, --output-encode=      Specify output encoding (none, jis, sjis, euc)

Search Options:
  -e                        Parse PATTERN as a regular expression (default:
                            false). Accepted syntax is the same as
                            https://github.com/google/re2/wiki/Syntax except
                            from \C
  -i, --ignore-case         Match case insensitively
  -S, --smart-case          Match case insensitively unless PATTERN contains
                            uppercase characters
  -w, --word-regexp         Only match whole words
      --ignore=             Ignore files/directories matching pattern
      --vcs-ignore=         VCS ignore files (default: .gitignore)
      --global-gitignore    Use git's global gitignore file for ignore patterns
      --home-ptignore       Use \$Home/.ptignore file for ignore patterns
  -U, --skip-vcs-ignores    Don't use VCS ignore file for ignore patterns
  -g=                       Print filenames matching PATTERN
  -G, --file-search-regexp= PATTERN Limit search to filenames matching PATTERN
      --depth=              Search up to NUM directories deep (default: 25)
  -f, --follow              Follow symlinks
      --hidden              Search hidden files and directories

Help Options:
  -h, --help                Show this help message

"
end

# option completions generated in a local environment
string trim "
--after	Print lines after match
--before	Print lines before match
--color	Print color codes in results (default: true)
--color-line-number	Color codes for line numbers (default: 1;33)
--color-match	Color codes for result matches (default: 30;43)
--color-path	Color codes for path names (default: 1;32)
--column	Print column (default: false)
--context	Print lines before and after match
--count	Only print the number of matching lines for each
--depth	Search up to NUM directories deep (default: 25)
--file-search-regexp	PATTERN Limit search to filenames matching PATTERN
--files-with-matches	Only print filenames that contain matches
--follow	Follow symlinks
--global-gitignore	Use git's global gitignore file for ignore patterns
--group	Print file name at header (default: true)
--help	Show this help message
--hidden	Search hidden files and directories
--home-ptignore	Use \$Home/.ptignore file for ignore patterns
--ignore	Ignore files/directories matching pattern
--ignore-case	Match case insensitively
--nocolor	Don't print color codes in results (default: false)
--nogroup	Don't print file name at header (default: false)
--nonumbers	Omit Line number. (default: false)
--null	Separate filenames with null (for 'xargs -0')
--numbers	Print Line number. (default: true)
--output-encode	Specify output encoding (none, jis, sjis, euc)
--skip-vcs-ignores	Don't use VCS ignore file for ignore patterns
--smart-case	Match case insensitively unless PATTERN contains
--vcs-ignore	VCS ignore files (default: .gitignore)
--version	Show version
--word-regexp	Only match whole words
-0	Separate filenames with null (for 'xargs -0')
-A	Print lines after match
-B	Print lines before match
-C	Print lines before and after match
-G	PATTERN Limit search to filenames matching PATTERN
-N	Omit Line number. (default: false)
-S	Match case insensitively unless PATTERN contains
-U	Don't use VCS ignore file for ignore patterns
-c	Only print the number of matching lines for each
-e	Parse PATTERN as a regular expression (default:
-f	Follow symlinks
-g	Print filenames matching PATTERN
-h	Show this help message
-i	Match case insensitively
-l	Only print filenames that contain matches
-o	Specify output encoding (none, jis, sjis, euc)
-w	Only match whole words
" | read -z -l want

# execute gencomp
gencomp pt
complete -C'pt -' | sort | uniq | read -z -l got

# test
test 'completion of pt'
    $want = $got
end
