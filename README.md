# mouseVR
Virtual reality software for running rodent neuroscience experiments.

Built with ViRMeN which provides a graphics engine to perform 3D rendering of virtual environments that we adapted for computer monitors and a Matlab toolbox for programming experimental logic and manipulating environments in real time

Written by: Beckie Nutbrown (@beckienutbrown) & Lloyd Russell ([@llerussell](https://github.com/llerussell)) -- Hausser-lab and Barry-lab (UCL)

![image](https://i.imgur.com/8oDdlv5.png)
![image](https://i.imgur.com/koTY4e2.gif)
![image](https://i.imgur.com/3JtB4wk.gif)


## Software requirements:
* MATLAB 2015a 32-bit
* ViRMeN* (https://pni.princeton.edu/pni-software-tools/virmen) 


## Hardware requirements:
![image](https://i.imgur.com/KAo4fOY_d.webp?maxwidth=760&fidelity=grand)

### Screens
* 3 x 1024 x 600 HD raspberry pi screens </br>
* 1 x USB hub for power with power supply</br>
* 1 x HDMI/DisplayPort hub</br>
* 3 x HDMI cables </br>
* Custom removable screen holder on a magnetic base </br>

### Movement
* 1 x Polystyrene ball </br>
* 1 x Kubler rotary encoder (1024)</br>
* NI DAQ I/O device </br>

### Reward delivery & detection
* Custom lick port</br>
* Custom circuit for reward delivery </br>
* Solenoid valve</br>
* NI DAQ I/O device </br>


## Notes
### Install notes
* put virmen folder local (e.g C:/Virmen)
* replace virmenEngine.m with version in customFunctionsVR
* put transformPerspectiveMultipleScreens.m in local transforms folder
* put moveWithRotaryEncoderBruker.m in the local movements folder
* put 5WORLDS.mat and Bruker2_virmen_TCP.m in the local experiments folder
* add Virmen folder and CustomVRFunctions folder to MATLAB path

run virmen, then go Experiment>Open>5WORLDS.mat


### Usage notes
* runTCPserver.py must be running for matlab to connect and start the session
* NI daq devices must also be present
* As we have multiple machines runing the same code, and these machines have different NI devices, we use ComputerNIMappings.cfg file to configure which devices are used on each machine. the file must contain the current computers name and device names!


### General
lick detection as counter channel detecting rising edges. updated at same time as rotary encoder.
analog outputs to reward and photostim were causing frame drops so offloaded to a sepearte python app - connected via TCP


### To do
rewrite screen transform function as a C/MEX function


## References
* Aronov, D. and Tank, D. W. (2014) Engagement of Neural Circuits Underlying 2D Spatial Navigation in a Rodent Virtual Reality System. Neuron 84(2): 442-56.


