# Simple Adverts

_**English** | [Русский](README.ru.md)_

AMX Mod X plugin for Counter-Strike.

This plugin periodically displays notifications to players in the chat, HUD or DHUD, depending on the settings.

The alerts are stored in ***addons\amxmodx\configs\next21_ads\ads.ini***.

For certain maps, you can create a separate file: ***addons\amxmodx\configs\next21_ads\map_name-ads.ini***.

You can use special tags in notifications:
- %ip% — is replaced with the current server ip address;
- %hostname% — to the current server name;
- %mapname% — the current name of the map;
- %new% — line break for HUD or DHUD messages.

Using the ***n21_ads_reset*** server command, you can update the alert list without changing the map.

## Cvars
- ```n21_ads_printmode "0"``` Where to display notifications (0 - in chat, 1 - in HUD, 2 - in DHUD).
- ```n21_ads_prefix "!g[Adverts]!y "``` Alert prefix.
- ```n21_ads_interval "60.0"``` Time interval between alerts in seconds.
- ```n21_ads_order "1"``` Display alerts in order, not random.
- ```n21_ads_effect "1"``` Effect for HUD/DHUD notifications (0 - no effects, 1 - blinking, 2 - prints letters one by one).
- ```n21_ads_fxtime "1.0"``` Duration of the second effect.
- ```n21_ads_holdtime "10.0"``` How many seconds the notification will remain on the screen.
- ```n21_ads_fadetime "0.1"``` How many seconds will the text be printed.
- ```n21_ads_fadeouttime "0.2"``` How many seconds will the text disappear.
- ```n21_ads_channel "-1"``` Channel for HUD alerts.
- ```n21_ads_alive "0"``` Whom to show notifications to (0 - everyone, 1 - only alive, 2 - only dead).
- ```n21_ads_team "0"``` Which team to show alerts (0 - to everyone, 1 - to the terrorist team, 2 - to the counter-terrorist team, 3 - to the spectators).
- ```n21_ads_color "0"``` Use random colors for HUD/DHUD alerts.
- ```n21_ads_red "255"``` RGB red for HUD/DHUD alerts.
- ```n21_ads_green "255"``` RGB green for HUD/DHUD alerts.
- ```n21_ads_blue "255"``` RGB blue for HUD/DHUD alerts.
- ```n21_ads_pos_x "-1.0"``` Horizontal position of HUD/DHUD alerts.
- ```n21_ads_pos_y "0.25"``` Vertical position of HUD/DHUD alerts.
- ```n21_ads_console "0"``` Repeat HUD/DHUD notifications to the console (it will be convenient for the user to copy links and other addresses from there).

## Authors
- **Oli Desu**
