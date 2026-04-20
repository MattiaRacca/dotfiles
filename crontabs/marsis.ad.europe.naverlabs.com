@reboot ~/.dropbox-dist/dropboxd
0 14 * * 1-5 docker run --rm scholarscraper:slim
0 12 * * 1-5 /bin/bash -lc 'crontab -l > /home/mracca/dotfiles/crontabs/marsis.ad.europe.naverlabs.com'
