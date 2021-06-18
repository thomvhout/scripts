#!/bin/sh

### Files ###
buienradar="/tmp/buienradar"
weatherSprite="/tmp/weatherSprite.png"
weatherGIF="/tmp/weather.gif"

### Get Image ###
curl https://www.buienradar.nl/ > $buienradar

timestamp=$(sed -rn "s/.*timestamp=([0-9]{12}).*/\1/p" $buienradar)

time1=$(echo $timestamp | awk '{print $1}')
time3=$(echo $timestamp | awk '{print $3}')

wget "https://image.buienradar.nl/2.0/image/sprite/RadarMapRainNL?extension=png&width=550&height=512&renderText=True&renderBranding=False&renderBackground=True&history=0&forecast=12&skip=0&timestamp=$time3&$time1" -O $weatherSprite

convert -dispose 3 -delay 80 -loop 0 $weatherSprite -crop 550x512 +repage $weatherGIF

### View Image ###
alacritty &
sleep 1

pid=$(pgrep alacritty)
wid=$(xdotool search --pid $pid)

for i in {0..10}; do xdotool key --window $wid Ctrl+minus; done
xdotool type --window $wid "chafa $weatherGIF --dither diffusion --dither-grain 1 --dither-intensity 10"
xdotool key --window $wid Return
