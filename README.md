# Dots
I use [GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) to place dotfiles where needed. For example, to have the `vim` related dotfiles, do
```bash
stow vim
```
Alternatively, script ``setup.sh`` installs programs and utilities I usually want.
Script ``rice.sh`` installs themes and icons plus the i3wm-related packages I currently use (see i3wm `config`).

## i3wm setup ()
- [i3-gaps](https://github.com/Airblader/i3) ([speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))
- [polybar](https://github.com/polybar/polybar) ([speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))
- [rofi](https://github.com/davatorium/rofi) (from Ubuntu ppa)
- [dunst](https://github.com/dunst-project/dunst) (from Ubuntu ppa)
- [feh](https://github.com/derf/feh) (from Ubuntu ppa)
- [compton](https://github.com/chjj/compton) ([speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))
- [urxvt](https://wiki.archlinux.org/index.php/Rxvt-unicode) (from Ubuntu ppa)
- vim + [vim-plug](https://github.com/junegunn/vim-plug): [lightline](https://github.com/itchyny/lightline.vim) and [wombat-scheme](https://github.com/sheerun/vim-wombat-scheme)

## License
Everything authored by me is released under the GNU GPL 3.0 license. Some files are authored by others, and are included as part of my own setup; they still belong to the original authors.
