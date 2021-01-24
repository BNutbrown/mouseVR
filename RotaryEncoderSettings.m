function [ vr ] = RotaryEncoderSettings( vr )
%  Setup rotary encoder 
vr.RotaryEncoder.daqSessRotEnc = daq.createSession('ni'); % opens the session...
vr.RotaryEncoder.counterCh = vr.RotaryEncoder.daqSessRotEnc.addCounterInputChannel(vr.devNames{1}, 'ctr0', 'Position');
vr.RotaryEncoder.counterCh.EncoderType = 'X4';%it was X4 from TW...
vr.GainManipulation.Value=1;
% vr.RotaryEncoder.speedVoltageCh = vr.RotaryEncoder.daqSessRotEnc.addAnalogOutputChannel(vr.devNames{1}, 0, 'Voltage');

resetCounter( vr.RotaryEncoder.counterCh );
thisCount = vr.RotaryEncoder.daqSessRotEnc.inputSingleScan;
vr.RotaryEncoder.count = thisCount;


