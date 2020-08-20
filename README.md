# Dots
I use [GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) to place dotfiles where needed. For example, to have the i3wm related dotfiles, do
```bash
stow i3wm
```
Alternatively, script ``setup.sh`` installs programs and utilities I usually want. 
Script ``rice.sh`` installs themes and icons plus the i3wm-related packages I currently use (see i3wm `config`).

## i3wm setup
- [i3-gaps](https://github.com/Airblader/i3) (4.17.1 from [speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))
- [polybar](https://github.com/polybar/polybar) (3.3.0 from [speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))
- [rofi](https://github.com/davatorium/rofi) (1.5.0 from Ubuntu Bionic ppa) 
- [dunst](https://github.com/dunst-project/dunst) (1.5.0 from source)
- [feh](https://github.com/derf/feh) (2.23.2 from Ubuntu Bionic ppa)
- [compton](https://github.com/chjj/compton) (v7 from [speed-ricer ppa](https://launchpad.net/~kgilmer/+archive/ubuntu/speed-ricer))

## License
Everything authored by me is released under the GNU GPL 3.0 license. Some files are authored by others, and are included as part of my own setup; they still belong to the original authors.
