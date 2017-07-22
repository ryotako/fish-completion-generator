# fish-completion-generator

[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]

generate completions for fish-shell with `--help` option

## Install

With [fisherman]

```
fisher ryotako/fish-completion-generator
```

## Usage

```fish
USAGE:
    gencomp [options] [commands names...]

OPTIONS:
    -l, --list        list generated completions
    -e, --erase       erase generated completions
    -d, --dry-run     print completions without saving
    -r, --root        print the directory to save completions
    -s, --subcommand  generate completion for subcommands
    -u, --use         use the specified command to get usage
                      ``{}'' is replaced with the arguments
    -h, --help        show this help
```


[travis-link]: https://travis-ci.org/ryotako/fish-completion-generator
[travis-badge]: https://img.shields.io/travis/ryotako/fish-completion-generator.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
