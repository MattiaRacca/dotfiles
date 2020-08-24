#!/bin/bash

## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## vpn_module: vpn scripts for a polybar, setup stock for Mullvad VPN
## 	by Shervin S. (shervin@tuta.io)

## 	vpn_module reports your VPN's status as [<ip_address> | connecting... | No VPN ].
##  With optional dependencies, <ip_address> will be replaced with <city> <country>.
##  You can also connect and disconnect via left-clicks, or with rofi, right-click to
##  access a menu and select between your favorite locations, set in VPN_LOCATIONS,
##  as well as 35 countries covered by Mullvad VPN.

##	dependencies (assuming use with Mullvad VPN):
##		mullvad-vpn (or mullvad-vpn-cli)

##	optional dependencies:
##		rofi 				  - allows menu-based control of mullvad
##		geoip, geoip-database - provide country instead of public ip address
## 		geoip-database-extra  - also provides city info
##      xclip                 - allows copying ip address to clipboard

## polybar setup:
## - Append contents of vpn_user_module file to user_modules.ini
## - Add "vpn" module to your config.ini under modules


## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## User Settings

## [Set VPN commands]. Setup for Mullvad is done below.
# The first three commands should have direct equivalents for most VPNs.
# The relay_set command assumes <country_code> <city_code> will follow as arguments. See below.
VPN_CONNECT="nordvpn connect"
VPN_DISCONNECT="nordvpn disconnect"
VPN_GET_STATUS="nordvpn status"

## [Set VPN status parsing]
# The first command cuts the status, which is compared to keywords below.
VPN_STATUS="$($VPN_GET_STATUS | grep Status |cut -d' ' -f6)"	# returns Connected/Connecting/<other>
CONNECTED=Connected
CONNECTING=Connecting

## [Set colors] (set each variable to nothing for default color)
# green=#00CC66
# red=#FF3300
# blue=#0066FF
# orange=#FF6600
# yellow=#FFFF00
# purple=#CC33FF
COLOR_CONNECTED=#86abb4
COLOR_CONNECTING=#facb6d
COLOR_DISCONNECTED=#de421f

## [Set 4 favorite VPN locations]
VPN_LOCATIONS=("fi" "it" "de" "ch")

## [Set optional rofi menu style]. `man rofi` for help.
icon_connect=
icon_fav=
rofi_font="Dejavu Sans Mono 13"
rofi_theme=".config/rofi/Ukiyo-e.rasi"
rofi_location="-location 0"
rofi_menu_name="Nordvpn"


## @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
## Main Script

# They ought to connect to your VPN's choice of server in the region.
# COUNTRIES=("Australia (au)" "Austria (at)" "Belgium (be)" "Canada (ca)" "Czech Republic (cz)" "Denmark (dk)" "Finland (fi)" "France (fr)" "Germany (de)" "Greece (gr)" "Hong Kong (hk)" "Hungary (hu)" "Ireland (ie)" "Italy (it)" "Japan (jp)" "Latvia (lv)" "Luxembourg (lu)" "Netherlands (nl)" "Norway (no)" "Poland (pl)" "Spain (es)" "Sweden (se)" "Switzerland (ch)" "UK (gb)" "USA (us)")
# COUNTRY_CODES=("au" "at" "be" "ca" "cz" "dk" "fi" "fr" "de" "gr" "hk" "hu" "ie" "it" "jp" "lv" "lu" "nl" "no" "pl" "es" "se" "ch" "gb" "us")

# Concatenate favorite and country arrays
VPN_CODES=("${VPN_LOCATIONS[@]}")
# VPN_CODES+=("${COUNTRY_CODES[@]}")
# VPN_LOCATIONS+=("${COUNTRIES[@]}")


vpn_report() {
# continually reports connection status
	if [ "$VPN_STATUS" = "$CONNECTED"  ]; then
		ip_address=$($VPN_GET_STATUS | \
		awk 'match($0,/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/){print substr($0,RSTART,RLENGTH)}')
# move this above the first if statement if something breaks

		if hash geoiplookup 2>/dev/null; then
			country=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" " | cut -c1-2)
			# country=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" " | cut -f1 -d".") # for the server name instead
			echo "%{F$COLOR_CONNECTED}${country}%{F-}"
		else
			echo "%{F$COLOR_CONNECTED}$ip_address%{F-}"
		fi
	elif [ "$VPN_STATUS" = "$CONNECTING" ]; then
		echo "%{F$COLOR_CONNECTING}Connecting...%{F-}"
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
			-line-padding 4 -padding 10 -lines 5 \
			-sep "|" -dmenu -i -p "$rofi_menu_name" <<< \
			" $icon_connect (dis)con| $icon_fav ${VPN_LOCATIONS[0]}| $icon_fav ${VPN_LOCATIONS[1]}| $icon_fav ${VPN_LOCATIONS[2]}| $icon_fav ${VPN_LOCATIONS[3]}")"
        ACTUAL_COMMAND=true
	    case "$MENU" in
			*connect) vpn_toggle_connection; return;;
			*"${VPN_LOCATIONS[0]}") $VPN_CONNECT ${VPN_CODES[0]} > /dev/null;;
			*"${VPN_LOCATIONS[1]}") $VPN_CONNECT ${VPN_CODES[1]} > /dev/null;;
			*"${VPN_LOCATIONS[2]}") $VPN_CONNECT ${VPN_CODES[2]} > /dev/null;;
			*"${VPN_LOCATIONS[3]}") $VPN_CONNECT ${VPN_CODES[3]} > /dev/null;;
			"") ACTUAL_COMMAND=false; return;;
			*) $VPN_CONNECT $MENU > /dev/null;;
	    esac

	    if [ "$VPN_STATUS" = "$CONNECTED" ]; then
	        true
	    else
	        $VPN_CONNECT
	    fi
	fi
}

ip_address_to_clipboard() {
ip_address=$($VPN_GET_STATUS | grep "Current server" | cut -f3 -d" ")
echo "$ip_address" | xclip -selection clipboard
}


# cases for polybar user_module.ini
case "$1" in
	--toggle-connection) vpn_toggle_connection ;;
	--location-menu) vpn_location_menu ;;
	--ip-address) ip_address_to_clipboard ;;
	*) vpn_report ;;
esac
