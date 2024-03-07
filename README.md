# dotfiles-debian
This is my Debian dotfiles (backup). Configuration files, useful scripts and aliases for my work, backgrounds,
old-school fonts, etc. There are not only dotfiles here, but also some normal files that can be in ```/etc```.

I'm lazy, so there's a script [./init.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)
which configure my work environment automatically. Installs the necessary programs/packages, configures various
development tools, hotkeys, desktop environment, home directory, etc.

I am using the latest stable version of Debian with Xfce. I like Xfce because there is nothing superfluous in it.

![screenshot](./.local/share/example-b.png)
![screenshot](./.local/share/example-a.png)

## Description of the environment
- <strong>OS:</strong> ```Debian```
- <strong>DE:</strong> ```Xfce```
- <strong>DM:</strong> ```LightDM```
- <strong>Shell:</strong> ```Bash```
- <strong>Browser:</strong> ```Firefox```
- <strong>File Manager:</strong> ```Thunar```

- <strong>Text:</strong> ```Vim, Mousepad, MC```
- <strong>Terminal:</strong> ```xfce4-terminal, Tmux```
- <strong>Terminal fonts:</strong> ```Terminus, Unifont, VT220, by IBM, Hack```
- <strong>DE fonts:</strong> ```Sans (default fonts)```

- <strong>Compiler:</strong> ```GCC```
- <strong>Debuger:</strong> ```GDB Dashboard```

- <strong>Version control system:</strong> ```Git```
- <strong>Text-mode interface for git:</strong> ```Tig```

- <strong>Additional packages:</strong> [./init.sh --packages](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)

## Configure environment
```
$ ./init.sh --help
Usage: init.sh [option]

  [option]
  --ftp                  ftp server configuration
  --hosts                modify hosts
  --sysctl               modify kernel parameters
  --initd                init.d script for user home directory
  --packages             install packages
  --clean-home           cleanup home directory
  --bashrc               ~/.bashrc extra rules
  --bash-completion      enable bash completion
  --locales              generate 'en_US' 'ru_RU' locales
  --xfce                 xfce configurations
  --mc                   midnight commander configuration
  --tmux                 tmux configuration
  --vim                  vim configuration with plugins
  --mousepad             mousepad configuration
  --gdb                  gdb configuration
  --other                other operations
  -h, --help             show this help and exit
```

For example, [configure](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)
[.bashrc](https://github.com/iikrllx/dotfiles-debian/blob/master/.bashrc)
(bash read), [vim](https://github.com/iikrllx/dotfiles-debian/blob/master/.vimrc) and
[tmux](https://github.com/iikrllx/dotfiles-debian/blob/master/.tmux.conf):
```
$ ./init.sh --bashrc --vim --tmux
```

## .bashrc
Functions:

```
$ c-tm
$ c-tmr
```
I use these functions as a timer with a signal.
Remind yourself of something.

---

```
$ c-cc
```
Clear the clipboard.

---

```
$ c-rnd-0
$ c-rnd-1
```
Generate random symbols.<br/>
c-rnd-0 (12 a-z0-9 symbols to clipboard)<br/>
c-rnd-1 (28 a-zA-Z0-9 symbols to stdout)<br/>

---

```
$ c-rename
```
Renames all files to random names in current directory. For example:
```
$ ls
a.txt  b.txt  my-secrets.txt  secret.txt

$ c-rename "txt"
$ ls
1z2otasm1idc.txt  7ixi4wocijea.txt  ttowy8plqm2y.txt  x74gy8x7si42.txt
```

---

```
$ c-deb-clean
```
I like use this function for clean 'rc' packages, debs autoremove and autoclean.

---

```
$ c-sd
$ c-rb
```
Shutdown and reboot.

---

## The best old-school fonts in my opinion
```
glass tty vt220 bold
px ibm ega8 regular
px ibm ega9 regular
px ibm mda regular
px ibm vga8 regular
px ibm vga9 regular
unifont regular
unifont-jp regular
```

## Mousepad
How export mousepad configuration ? Commands:
```
$ dconf dump /org/xfce/mousepad/ > mousepad.settings
$ dconf load /org/xfce/mousepad/ < mousepad.settings
```
