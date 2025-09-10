@reboot $HOME/.dropbox-dist/dropboxd
0 14 * * 1-5 docker run --rm scholarscraper
0 12 * * * rsync $HOME/Documents/Miscellanea/ukiyo_e_block_page/data $HOME/Dropbox/Miscellanea/ukiyo-e_blockpage/ -r
0 12 * * 1-5 /bin/bash -lc 'crontab -l > $HOME/dotfiles/crontabs/$(hostname)'
