#!/usr/bin/expect -f

set timeout -1
set var1 [lindex $argv 0]
spawn spim -file ./prj2.asm
expect ""
send -- "$var1\n"
expect eof
exit
