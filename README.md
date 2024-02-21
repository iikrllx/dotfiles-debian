# dotfiles-debian
This is my Debian dotfiles (backup). Configuration files, useful scripts and aliases for my work, backgrounds,
old-school fonts, etc. There are not only dotfiles here, but also some normal files that can be in ```/etc```.

I'm lazy, so there's a script [./init.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)
which configure my work environment automatically. Installs the necessary programs/packages, configures various
development tools and the home environment. If you don't need Russian language in the interface, run the following
command after running the script ```init.sh```.
```
$ echo LANG="en_US.UTF8" | sudo tee /etc/default/locale
```

I am using the latest stable version of Debian with Xfce. I like Xfce because there is nothing superfluous in it.

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

- <strong>Additional packages:</strong> [./init.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)

## Installation
```
$ ./init.sh
$ sudo reboot
```

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
