## cch - Color Code Highlighter

This program prints ANSI true color escape sequences for valid HTML (hex) codes.

![Screenshot](https://raw.githubusercontent.com/dcx86r/cch/master/sample.jpg)

#### Dependencies

* perl core v5.10+ 
* 24-bit color support - [see compatible terminals](https://gist.github.com/XVilka/8346728)

#### Installation

`[sudo] sh installer install` to install in $PATH
`[sudo] sh installer uninstall` to uninstall

#### Examples

`cch ~/.Xresources | less -r`
`echo #111 #222 #333 #444 | cch -b` 
