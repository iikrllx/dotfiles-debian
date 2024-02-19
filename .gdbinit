# follow the child process
# be careful with this, debug can become magical in some cases
set follow-fork-mode child

# control of duplicate history entries
set history remove-duplicates 1

# set history file
set history filename ~/.gdb_history

# set a limit on how many elements will print
set print elements 0

# save history
set history save on

# print structures in a compact format
set print pretty off

# pagination off
set pagination off

# the default value of max-value-size is currently 64k
set max-value-size unlimited

# select which modules to display
# this actual for https://git.io/.gdbinit
# I don't need to show source because I use tui mode
dashboard -layout stack variables

# tui mode
tui enable
