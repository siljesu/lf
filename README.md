
# Lingua Franca on NXP FRDM-K22F & FreeRTOS

## Build LF Compiler

To build the LF compiler, run
```sh
    $ sudo ./build-lfc
```
This is necessary since the source of the compiler has been changed to allow FreeRTOS to change the auto-generated main-function.

## Bare-metal

Build Docker image using the command
```sh
    $ docker build -t lf-nxp -f Dockerfile.nxp .
```
Run a container which builds the lf file given as input, by using
```sh
    $ docker run -v <YOUR PATH>/lf/nxp-support:/lf/nxp-support lf-nxp:latest /lf/nxp-support/src/<APPLICATION NAME>/<APPLICATION NAME>.lf
```
Note: "-v </your/path>/lf/nxp-support:/lf/freertos-support" is used to share the nxp-support folder with the container. This means that, during development on your host, a new container can be run to build your changes.

## FreeRTOS

Build Docker image using the command
```sh
  $ docker build -t lf-freertos -f Dockerfile.freertos .
```
Run a container which builds the lf file given as input, by using
```sh
  $ docker run -v <YOUR PATH>/lf/freertos-support:/lf/freertos-support lf-freertos:latest /lf/freertos-support/src/<APPLICATION NAME>/<APPLICATION NAME>.lf
```
Note: "-v </your/path>/lf/freertos-support:/lf/freertos-support" is used to share the freertos-support folder with the container. This means that, during development on your host, a new container can be run to build your changes.

## Debugging with GDB

To flash a new firmware to the board, do the following:
    - Hold in the reset button while plugging the board into the computer. The board will mount on the computer as "MAINTANENCE".
    - Drag and drop the downloaded binary file (Jlink OpenSDA V2.1) into "MAINTANENCE". This file is provided inside the "install" folder.
    - Wait a little, then unplug the board. Plug in the board again and the board has new firmware for a Jlink GDB server.

The Jlink GDB server is downloaded from https://www.segger.com/products/debug-probes/j-link/tools/j-link-gdb-server/about-j-link-gdb-server/. To install, run 
```sh
    $ sudo apt install ./JLink_Linux_V782_x86_64.deb
```
The SEGGER software should now have been installed in /opt/SEGGER

To run the GDB server, connecting to the FRDM-K22F debugging circuitry, first connect the board to the host computer via the USB cable, and then run the following command
```sh    
    $ /opt/SEGGER/JLink/JLinkGDBServerCLExe -localhostonly -ir -if SWD -speed 1000 -s -device MK22FN512VLH12
```
Now, the server should have successfully established a connection to the board. The next step is to run the GDB client, which is just the normal GDB application. In the case of arm-none-eabi-gdb, and the specific version used in this paper, which can be found in the "install" folder:
```sh    
    $ /opt/gcc-arm-none-eabi-10.3-2021.10/bin/arm-none-eabi-gdb
```
Lastly, connect to the server and load the program inside GDB with the following commands:
```sh
    $ target remote localhost:2331
    $ monitor reset
    $ file /path/to/your/file.elf
    $ load /path/to/your/file.elf
```

Putty is used to print the serial interface output. Install by running 
```
    $ sudo apt install -y putty
```
Launch Putty to listen on /dev/ttyACM0, with the settings, to get debugging output from the board:
```sh
    $ sudo putty /dev/ttyACM0 -serial -sercfg 115200,8,n,1,N
```
