% Test triggered from daq, randomly presenting stimuli each trial. Sends flip
% on/off info to daq.
% Also attempts to send a binary pulse output that indicates the stim ID.
clear

daqtrig=0;
% just get a renderer going?
orientation_list = [0:45:135];
sz_list = round(linspace(100, 1000, length(orientation_list)));
% visDeg2px(10,10,15,
c=0;
% for ori = 1:numel(orientation_list)
%     c=c+1;
%     stimulus(c) = DriftingGrating(orientation_list(ori), [], [], [], [], sz_list(ori));
% end
% for ori = 1:numel(orientation_list)
%     c=c+1;
%     stimulus(c) = FigureGroundStim(orientation_list(ori), [], [], [], [], 1000, 100);
% end
for ori = 1:numel(orientation_list)
    c=c+1;
    stimulus(c) = HoleStim(orientation_list(ori), [], [], [], [], 15, 50);
end

renderer = StimulusRenderer(stimulus); % can be an array of renderables?
renderer.setScreenID(1); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% NIDAQ OUTPUT
dq = daq.createSession('ni');

% in use
% note changes between here and test_franken_trigger_send_pulse
addDigitalChannel(dq,'Dev2', 'Port0/Line1', 'OutputOnly'); %stim on indicator to master
addDigitalChannel(dq,'Dev2', 'Port0/Line4', 'OutputOnly'); %stim on indicator to SI
addDigitalChannel(dq,'Dev2', 'Port0/Line3', 'OutputOnly'); %pulsing info to master
addDigitalChannel(dq,'Dev2', 'Port0/Line6', 'OutputOnly'); % clock output for bin repr

BLANK = [0 0 0 0];
STIM_ON = [1 1 0 0];
STIM_OFF = [0 0 0 0];
CLK_PULSE_OFF = [0 0 0 1];
CLK_PULSE_ON = [0 0 1 1];


%NIDAQ INPUT
s0 = daq.createSession('ni');
[~,~] = s0.addAnalogInputChannel('Dev2',2,'Voltage');
addTriggerConnection(s0,'external','Dev2/PFI1','StartTrigger');
s0.ExternalTriggerTimeout = 20;
s0.NumberOfScans = 2;
s0.Rate = 10000;


mxNumTrials = 10;

% for simple case of random stimulus presentation
% or do a while loop or whatever
clear stimLog
for i=1:mxNumTrials
    
    % randomly choose a stimulus
    idx = randi(numel(stimulus));
    
    if daqtrig
        try
            disp('awaiting trigger!')
            % block until recv trig from daq
            s0.startForeground();

        catch
            disp('daq start trigger timed out...')
            % cleanup and save what's been done
            renderer.finish();
            return
        end
    else
       pause(1)
    end
    
    outputSingleScan(dq, STIM_ON) % set stim indicators up
    renderer.drawStimulus(idx, 1)
    outputSingleScan(dq,STIM_OFF) % set stim indicators down
    stimLog(i) = idx;
    
    binaryVec = decimalToBinaryVector(idx, 8);
    
    for pulseI = 1:8 % 12 bits should be way plenty
        valToSend = binaryVec(pulseI);
        if valToSend == 0
            outputSingleScan(dq, CLK_PULSE_OFF);
        else
            outputSingleScan(dq, CLK_PULSE_ON);
        end
        pause(.005)
        outputSingleScan(dq, BLANK);
        pause(.005)
    end
    if ~daqtrig
        pause(2)
    end
    
end
disp('got  here')
renderer.finish();
    