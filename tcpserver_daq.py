# LR 2020
# Offloads NI card output from Matlab VR to this python script running asynchronously, via TCP connection. (prevents long frame drops)
# Virmen VR connects to this TCP server.
# The VR program sends a TCP signal to this script, which triggers an output from NI cards


import socket
import sys
import time
import nidaqmx
import numpy as np
import ctypes
from colorama import init
from termcolor import colored
init()


# mappings
REWARD = 0
FRAME = 1
STIM = 2


# make daq output arrays (ms)
whole_trigger_dur = 300
reward_dur = 250
stim_dur = 20
blank_trigger = [0]*whole_trigger_dur
reward_trigger = [5]*reward_dur + [0]*(whole_trigger_dur-reward_dur)
stim_trigger = [5]*stim_dur + [0]*(whole_trigger_dur-stim_dur)
analog_output = [blank_trigger, stim_trigger]
frame_flip = np.array([0], dtype=np.bool)

# reward + stim daq task
daq0 = nidaqmx.Task()  
daq0.ao_channels.add_ao_voltage_chan("Dev2/ao0:1")
daq0.timing.cfg_samp_clk_timing(rate=1000, samps_per_chan=whole_trigger_dur, sample_mode=nidaqmx.constants.AcquisitionType.FINITE)
daq0.out_stream.regen_mode = nidaqmx.constants.RegenerationMode.ALLOW_REGENERATION

# frame flip daq task
daq1 = nidaqmx.Task()  
daq1.do_channels.add_do_chan("Dev2/port0/line0")

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('localhost', 6666)
print(colored('Starting server on {} port {}'.format(*server_address), 'yellow'))
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

while True:
	# Wait for a connection
	print(colored('Waiting for a connection...','green'))
	connection, client_address = sock.accept()
	try:
		print(colored('Connection from: ', 'green'), colored(client_address, 'grey', 'on_green'))

		# Receive the data in small chunks
		while True:
			data = connection.recv(16)
			timestamp = time.strftime('%Y/%m/%d %H:%M:%S')
			if data:
				# convert to integer from bytes
				dataInt = int.from_bytes(data, 'big')  
				
				# deliver appropriate daq trigger
				if dataInt == REWARD:
					print(timestamp + ' - ' + colored('Reward', 'cyan'))
					daq0.stop()
					analog_output = [reward_trigger, blank_trigger]
					daq0.write(analog_output, auto_start=True)

				elif dataInt == FRAME:
					#print(timestamp + ' - Frame')
					daq1.write(frame_flip, auto_start=True)
					frame_flip = ~frame_flip

				elif dataInt == STIM:
					print(timestamp + ' - ' + colored('Reward', 'yellow'))
					daq0.stop()
					analog_output = [blank_trigger, stim_trigger]
					daq0.write(analog_output, auto_start=True)

				else:
					print(timestamp + ' - Not recognised')
			else:
				print(colored('Disconnected. No data from ','red'), client_address)
				break

	finally:
		# Clean up the connection
		connection.close()
