#!/bin/bash
# PORTMASTER: perfect_dark.zip, Perfect Dark.sh

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Set variables
GAMEDIR="/$directory/ports/perfect_dark"


# Permissions
$ESUDO chmod 0777 /dev/tty0

cd $GAMEDIR

# Copy the right build to the main folder
if [ $CFW_NAME == "ArkOS" ] || [ "$CFW_NAME" == 'ArkOS wuMMLe' ]  || [ "$CFW_NAME" == "knulli" ]; then
	cp -f "$GAMEDIR/bin/pd_armhf_compatibility.elf" pd.elf
else
	cp -f "$GAMEDIR/bin/pd_armhf_performance.elf" pd.elf
fi

# Run the game
echo "Loading, please wait... (might take a while!)" > /dev/tty0 
LD_LIBRARY_PATH="/usr/lib32" /usr/lib/ld-linux-armhf.so.3 ./pd.elf --rom-file ./rom/pd.ntsc-final.z64 --basedir $GAMEDIR --savedir $GAMEDIR
$ESUDO systemctl restart oga_events & 
printf "\033c" >> /dev/tty1 
printf "\033c" > /dev/tty0
