function vr = InitialiseTCPConnection(vr)
% mappings
vr.tcp = [];
vr.tcp.REWARD = 0;
vr.tcp.FRAME  = 1;
vr.tcp.STIM   = 2;

% params
vr.tcp.address = 'localhost';
vr.tcp.port    = 6666;

% open connection
vr.tcp.t = tcpip(vr.tcp.address, vr.tcp.port, 'NetworkRole','Client');
vr.tcp.t.OutputBufferSize = 1;  % only ever send one byte at a time
fopen(vr.tcp.t);
