# Content
This is where I store my dotfiles. I use [GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) for moving the dotfiles where needed. For example, if I want to place my bash related dotfiles, I type:
```sh
$ stow bash
```
where bash is the name of the folder under the dotfile folder.

Alternatively, you can run the setup script that install things that I usually need
```sh
$ ./setup.sh
```


# License
Everything authored by me is released under the GNU GPL 3.0 license. Some files are authored by others, and are included as part of my own setup; they still belong to the original authors.

