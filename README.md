

Download and unzip buildroot
Git clone mpdLight
cd buildroot
make O=../build-pi3_642 BR2_EXTERNAL=/home/control/mdpLight/pi3_64-config menuconfig



make O=../build-pi3_642 raspberrypi3_64_defconfig 


make  O=../build-pi4  BR2_EXTERNAL=../pi4-config/  custom_pi4_defconfig 
  [...]