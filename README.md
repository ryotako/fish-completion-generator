:us: [:jp:](https://github.com/ryotako/fish-completion-generator/wiki)

# fish-completion-generator

[![Build Status][travis-badge]][travis-link]
[![Slack Room][slack-badge]][slack-link]
[![fish2.7.0](https://img.shields.io/badge/fish-2.7.0-brightgreen.svg)](https://github.com/fish-shell/fish-shell)

generate completions for fish-shell with `--help` option

## Install

With [fisherman]

```
fisher ryotako/fish-completion-generator
```

## Usage

```fish
NAME:
    gencomp - Completion generator for fish-shell

USAGE:
    gencomp [options] [command names...]

OPTIONS:
    -d, --dry-run      print completions without execution
    --edit             edit a generated completion
    --erase            erase generated completions
    -l, --list         list generated completions
    -r, --root         print the directory to save completions
    -S, --subcommands  generate completion for subcommands
    -u, --use          use the specified command to get usage
                       ``{}'' is replaced with the arguments
    -w, --wraps        inherit existing completions
    -h, --help         show this help

VARIABLES:
    gencomp_dir        directory to save completions

EXAMPLES:
    gencomp peco
    gencomp ghq --subcommands
    gencomp bd --use '{} -h'
    gencomp my-git --wraps git
```


[travis-link]: https://travis-ci.org/ryotako/fish-completion-generator
[travis-badge]: https://img.shields.io/travis/ryotako/fish-completion-generator.svg
[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[fisherman]: https://github.com/fisherman/fisherman
