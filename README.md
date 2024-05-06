<div align="center">
<img src="https://github.com/iikrllx/dotfiles-debian/blob/master/images/logo-no-background.svg">
<a href="https://github.com/iikrllx/dotfiles-debian">
    <img src="https://img.shields.io/badge/debian-%23CE0056?style=flat&logo=Debian&logoColor=%23CE0056&label=dotfiles&labelColor=white">
</a>
<a href="https://github.com/iikrllx/dotfiles-debian/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/GPLv3-green?style=flat&label=License&labelColor=blue">
</a>
</div>

This is my Debian dotfiles (backup). Configuration files, useful scripts and aliases for my work, backgrounds,
notes, color schemes, etc. There are not only dotfiles here, but also some normal files that can be in ```/etc```.

I'm lazy, so there's a script [./init.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)
which configure/install my work environment automatically. Installs the necessary programs/packages, configures various
development tools, hotkeys, desktop environment, home directory, etc. I am using the latest stable version
of Debian with Xfce. I like Xfce because there is nothing superfluous in it.

Xfce Desktop:
![screenshot](./images/example-a.png)
Terminal Emulator with Tmux:
![screenshot](./images/example-b.png)

## Table of contents
- [Description of the environment](#description-of-the-environment)
- [Test all environment](#test-all-environment)
- [Install the environment using a script](#install-the-environment-using-a-script)
- [Bashrc](#bashrc)
- [Scripts](#scripts)
- [xfce4-terminal](#xfce4-terminal)
- [Application shortcuts](#application-shortcuts)
- [The best old-school fonts in my opinion](#the-best-old-school-fonts-in-my-opinion)

## Description of the environment
- <strong>OS:</strong> ```Debian```
- <strong>DE:</strong> ```Xfce```
- <strong>DM:</strong> ```LightDM```
- <strong>WM:</strong> ```Xfwm4```
- <strong>Shell:</strong> ```Bash```
- <strong>Browser:</strong> ```Firefox```
- <strong>File Manager:</strong> ```Thunar```
- <strong>Text Editor:</strong> ```Vim```, ```Mousepad```
- <strong>Terminal File Navigation:</strong> ```MC```
- <strong>Terminal Emulator:</strong> ```xfce4-terminal```
- <strong>Terminal Multiplexer:</strong> ```Tmux```
- <strong>Compiler:</strong> ```GCC```
- <strong>Debuger:</strong> ```GDB Dashboard```
- <strong>Version control system:</strong> ```Git```
- <strong>Text-mode interface for git:</strong> ```Tig```
- <strong>Mail Client:</strong> ```neomutt```
- <strong>Additional packages:</strong> [./init.sh --install-packages](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)

## Test all environment
On a clean Debian virtual machine:

```
$ git clone https://github.com/iikrllx/dotfiles-debian.git
$ cd dotfiles-debian
$ ./init.sh --initd --sources.list --install-packages --clean-home --bashrc --bash-completion \
            --xfce --xfce-terminal --mc --tmux --vim --mousepad --gdb --neomutt --newsboat \
            --dircolors --local-bin --local-share
$ reboot
```
Enjoy.

## Install the environment using a script
Usage information:
```
$ ./init.sh --help
```
For example, [configure](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)
[.bashrc](https://github.com/iikrllx/dotfiles-debian/blob/master/.bashrc)
(bash read), [vim](https://github.com/iikrllx/dotfiles-debian/blob/master/.vimrc) and
[tmux](https://github.com/iikrllx/dotfiles-debian/blob/master/.tmux.conf):
```
$ ./init.sh --bashrc --vim --tmux
```

## Bashrc
Functions:

```
$ c-tm
$ c-tmr
```
I use these functions as a timer with a signal.
Remind myself of something.

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
Renames all files to random names in the current directory. For example:
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

```
$ c-vb
```
Vim open ~/vbuf file.<br/>
This file has saved lines from the clipboard.<br/>

---

```
$ c-date
```
Date to clipboard.

---

## Scripts
[mygit.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/.local/bin/mygit.sh) -
this script manage all my git projects (simple git operations).<br/>
[crypt.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/.local/bin/crypt.sh) -
this script encrypt/decrypt regular file with sensitive information (using a password).<br/>
[skeleton.sh](https://github.com/iikrllx/dotfiles-debian/blob/master/.local/bin/skeleton.sh) -
prepare the skeleton of the C source code.<br/>

## xfce4-terminal
Installation Xfce Terminal Emulator configuration with colorschemes + dircolors.
```
$ ./init.sh --xfce-terminal --dircolors
```

Example of changing the terminal color scheme.

![screenshot](./images/terminal-a.png)
![screenshot](./images/terminal-b.png)
![screenshot](./images/terminal-c.png)
![screenshot](./images/terminal-d.png)

## Application shortcuts
```
$ ./init.sh --xfce-hotkeys
```

![screenshot](./images/hotkeys-a.png)

## The best old-school fonts in my opinion
I use these fonts from time to time.<br/>
These fonts are installed using [./init.sh --install-packages](https://github.com/iikrllx/dotfiles-debian/blob/master/init.sh)

```
glass tty vt220 bold
px ibm ega8 regular
px ibm ega9 regular
px ibm mda regular
px ibm vga8 regular
px ibm vga9 regular
terminus medium
unifont regular
unifont-jp regular
hack regular
```

Example of changing the font.

![screenshot](./images/font-a.png)
![screenshot](./images/font-b.png)
![screenshot](./images/font-c.png)
![screenshot](./images/font-d.png)

## License
This project is licensed under the GPLv3 License - see the
[LICENSE](https://github.com/iikrllx/dotfiles-debian/blob/master/LICENSE) file for details.
