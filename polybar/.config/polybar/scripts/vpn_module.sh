#!/bin/bash

## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## vpn_module: vpn scripts for a polybar, setup NordVPN
## 	by Shervin S. (shervin@tuta.io), modified for Nordvpn by Mattia Racca (@MattiaRacca)

## 	vpn_module reports your VPN's status as [country_code | connecting... | No VPN ].

##	dependencies:
##	nordvpn

##	optional dependencies:
##	rofi			- allows menu-based control of mullvad
##      xclip			- allows copying server address to clipboard

## polybar setup:
## - Append contents of vpn_user_module file to user_modules.ini
## - Add "vpn" module to your config.ini under modules


## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## User Settings

## [Set VPN commands]. Setup for Nordvpn is done below.
VPN_CONNECT="nordvpn connect"
VPN_DISCONNECT="nordvpn disconnect"
VPN_GET_STATUS="nordvpn status"

## [Set VPN status parsing]
# The first command cuts the status, which is compared to keywords below.
VPN_STATUS="$($VPN_GET_STATUS | grep Status |cut -d' ' -f6)"	# returns Connected/Connecting/<other>
CONNECTED=Connected
CONNECTING=Connecting
SHOW_IP=false

## [Set colors] (set each variable to nothing for default color)
COLOR_CONNECTED=#86abb4
COLOR_CONNECTING=#facb6d
COLOR_DISCONNECTED=#de421f

## [Set 4 favorite VPN locations]
VPN_LOCATIONS=("fi" "it" "de" "ch")

## [Set optional rofi menu style]. `man rofi` for help.
icon_connect=
icon_fav=
icon_p2p=
rofi_font="Dejavu Sans Mono 13"
rofi_theme=".config/rofi/Ukiyo-e.rasi"
rofi_location="-location 0"
rofi_menu_name="Nordvpn"


## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Main Script

# Concatenate favorite and country arrays
VPN_CODES=("${VPN_LOCATIONS[@]}")

vpn_report() {
# continually reports connection status
	if [ "$VPN_STATUS" = "$CONNECTED"  ]; then
		ip_address=$($VPN_GET_STATUS | \
		awk 'match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){print substr($0,RSTART,RLENGTH)}')
# move this above the first if statement if something breaks

		if [ "$SHOW_IP" = false ]; then
			country=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" " | cut -c1-2)
			# country=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" " | cut -f1 -d".") # for the server name instead
			echo "%{F$COLOR_CONNECTED}${country}%{F-}"
		else
			echo "%{F$COLOR_CONNECTED}$ip_address%{F-}"
		fi
	elif [ "$VPN_STATUS" = "$CONNECTING" ]; then
		echo "%{F$COLOR_CONNECTING}%{F-}"
	else
		echo "%{F$COLOR_DISCONNECTED}%{F-}"
	fi
}

vpn_toggle_connection() {
# connects or disconnects vpn
    if [ "$VPN_STATUS" = "$CONNECTED" ]; then
        $VPN_DISCONNECT > /dev/null
    else
        $VPN_CONNECT > /dev/null
    fi
}


vpn_location_menu() {
# Allows control of VPN via rofi menu. Selects from VPN_LOCATIONS.
	if hash rofi 2>/dev/null; then
		MENU="$(rofi \
			-font "$rofi_font" -theme "$rofi_theme" $rofi_location \
			-columns 1 -width 10 -hide-scrollbar \
			-line-padding 4 -padding 10 -lines 6 \
			-sep "|" -dmenu -i -p "$rofi_menu_name" <<< \
			" $icon_connect (dis)con| $icon_p2p P2P| $icon_fav ${VPN_LOCATIONS[0]}| $icon_fav ${VPN_LOCATIONS[1]}| $icon_fav ${VPN_LOCATIONS[2]}| $icon_fav ${VPN_LOCATIONS[3]}")"
	    case "$MENU" in
			*con) vpn_toggle_connection; return;;
			*P2P) $VPN_CONNECT P2P > /dev/null; return;;
			*"${VPN_LOCATIONS[0]}") $VPN_CONNECT ${VPN_CODES[0]} > /dev/null;;
			*"${VPN_LOCATIONS[1]}") $VPN_CONNECT ${VPN_CODES[1]} > /dev/null;;
			*"${VPN_LOCATIONS[2]}") $VPN_CONNECT ${VPN_CODES[2]} > /dev/null;;
			*"${VPN_LOCATIONS[3]}") $VPN_CONNECT ${VPN_CODES[3]} > /dev/null;;
			"") return;;
			*) $VPN_CONNECT $MENU > /dev/null;;
	    esac
	fi
}

server_address_to_clipboard() {
server_address=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" ")
echo "$server_address" | xclip -selection clipboard
}


# cases for polybar user_module.ini
case "$1" in
	--toggle-connection) vpn_toggle_connection ;;
	--location-menu) vpn_location_menu ;;
	--ip-address) server_address_to_clipboard ;;
	*) vpn_report ;;
esac
