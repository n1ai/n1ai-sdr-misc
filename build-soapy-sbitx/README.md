# build-soapy-sbitx

Script to build and/or install Soapy components for sbitx as well as few Soapy clients:
- gqrx
- CubicSDR
- pihpsdr (currently, g0orx version)


## Running The Script


It's pretty simple.  Just download the `build-soapy-sbitx.sh`file by clicking on it above this text, then use the *Download Raw File* option on the top right (i.e. the download symbol) which will bring the file onto your computer.  If you do this with a browser running on sbitx it will end up in the *Downloads* folder but you can put it into any convenient folder.  

Once the file is downloaded into any convenient folder on your sibtx Pi, open a terminal window in that same folder.  To do this on the sbitx Pi you can open *Accessories -> File Manager* from the main desktop menu, then navigate to the folder, then right click on that folder and choose *Open Terminal*.

Once the script runs, will need to answer a simple y/n question at the start.  Also, if you do not have the SdrPlay API already installed, it will later ask you to accept its license so be ready to answer some more simple y/N/ENTER questions.

To run it the first time, without capturing its output, just do:

```bash
bash ./build-soapy-sbitx.sh
```

If it fails, run it a second time capturing its output using the `tee` command:

```bash
bash ./build-soapy-sbitx.sh |& tee build-soapy-sbitx.log
```

... then share the log file on Discord

As the script output says, the script will run a LONG time.  It may even fail or lock up the system or crash it.  Let me know if this happens.  

You will know when it is done when it outputs the following:
```
######                            ###
#     #   ####   #    #  ######   ###
#     #  #    #  ##   #  #        ###
#     #  #    #  # #  #  #####     #
#     #  #    #  #  # #  #
#     #  #    #  #   ##  #        ###
######    ####   #    #  ######   ###
```

## Running the sbitx_control program

When the script is done you will next start the sbtix_ctrl program.  This program controls the sbitx radio based on commands that come from the sbitx soapy library each of the SDR applications access.  The example below starts it in the background.  In the future this code will probably be build into the sbitx soapy library and won't be a standalone program any more.

```bash
/usr/local/bin/sbitx_ctrl &
```

Next, run any of the following clients.  You should probably pick the one you are most familiar with.  You should also plan to test the app with a known good SDR such as RTLSDR first to be sure it works correctly, you get audio output, etc.

## Running PiHPSDR

Some notes:
1. There should be a PiHPSDR menu options now
2. If not, then run ```/opt/pihpsdr/pihpsdr```

When it first comes up:
1. Wait if/when it says it needs to build wisdom files, this takes a while
1. If you only use sbitx then on the device selection screen go into protocols and uncheck protocols 1 and 2 so the next startup of the program is faster
1. After you chose sbitx on the device selection screen, if you want audio then select Menu -> RX (Receive) and click on the local audio check box and then pick your sound device from the drop down -- in my case it's a usb sound card dongle to speakers

## Running GQRX

- When gqrx starts, it will present I/O Devices selector for I/Q input 
- Choose device "sBitx (ALSA IQ Bridge)" 
- It fills in the device string "driver=sbitx,soapy=2"
- Also pick your audio output device 
- In my case I have a usb sound card dongle
- Once the main window opens, use the toolbar play symbol to start the dsp
- On the right pane, receiver tab: select AM/USB/whatever
- On the right pane, FFT tab: there are lots of settings for the panadapter / waterfall including speed, color theme, gain, zoom, etc.
- On the right pane, Audio window: if you have a signal tuned and a demodulator selected then you should see a audio waveform -- if not, check squelch settings in the receiver tab


## Running CubicSDR

CubicSDR will start with a device selection and it should list sbitx as an option.  After this, please consult someone familiar with CubicSDR because I find it to be very confusing and have never mastered it.

## TODO

Some things I hope to do in the near future:
- build linhpsdr
- build the dl1ycf fork of pihpsdr intead of the g0orx one
- build quisk and set it up to do sbitx either directly or via soapy

