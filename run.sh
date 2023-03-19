#!/usr/bin/expect -f

set timeout -1
set var1 [lindex $argv 0]
set var2 [lindex $argv 1]
spawn spim -file ./prj2.asm
expect ""
send -- "$var1\n"
expect ""
send -- "$var2\n"
expect eof
exit
