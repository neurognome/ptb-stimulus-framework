% Test triggered from daq, randomly presenting stimuli each trial. Sends flip
% on/off info to daq.
% Also attempts to send a binary pulse output that indicates the stim ID.
% clear
% sca

function basic_ori_trigger(date, mouse, exp)
% 
% date = '230817';
% mouse = 'KKS005-3';
% exp = '2ori';

addpath(genpath('C:\_code\ptb-stimulus-framework'));

daqtrig=1; 
% just gt a renderer going?
orientation_list = 0:30:330;
% sz_list = [6, 12, 24, 50];
% c=0;
% for ori = 1:numel(orientation_list)
%     for sz = 1:numel(sz_list)
%         c=c+1;
%         stimulus{c} = DriftingGrating(orientation_list(ori), [], [], [], [], sz_list(sz));
%     end
% end

c = 0;
for ori = 1:numel(orientation_list)
    c = c+1;
    stimulus{c} = DriftingGrating(orientation_list(ori));
end

renderer = StimulusRenderer(stimulus); % can be an array of renderables?
renderer.setScreenID(2); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% NIDAQ OUTPUT
dq = daq.createSession('ni');

% in use
% note changes between here and test_franken_trigger_send_pulse
addDigitalChannel(dq,'Dev1', 'Port0/Line2', 'OutputOnly'); %stim on indicator to master
addDigitalChannel(dq,'Dev1', 'Port0/Line4', 'OutputOnly'); %stim on indicator to SI
addDigitalChannel(dq,'Dev1', 'Port0/Line3', 'OutputOnly'); %pulsing info to master
addDigitalChannel(dq,'Dev1', 'Port0/Line6', 'OutputOnly'); % clock output for bin repr

BLANK = [0 0 0 0];
STIM_ON = [1 1 0 0];
STIM_OFF = [0 0 0 0];
CLK_PULSE_OFF = [0 0 0 1];
CLK_PULSE_ON = [0 0 1 1];


%NIDAQ INPUT
s0 = daq.createSession('ni');
[~,~] = s0.addAnalogInputChannel('Dev1',2,'Voltage');
[~, ~] = s0.addDigitalChannel('Dev1', 'port0/line1', 'InputOnly');
addTriggerConnection(s0,'external','Dev1/PFI6','StartTrigger');
s0.ExternalTriggerTimeout = 20;
s0.NumberOfScans = 2;
s0.Rate = 10000;


mxNumTrials = 2000;

% for simple case of random stimulus presentation
% or do a while loop or whatever
clear stimParams
for i=1:mxNumTrials
    
    % randomly choose a stimulus
    idx = randi(numel(stimulus));
    disp(['stim id is ' num2str(idx)])
    
    if daqtrig
        try
            disp('awaiting trigger!')
            % block until recv trig from daq
            s0.startForeground();

        catch
            disp('daq start trigger timed out...')
            % cleanup and save what's been done
            renderer.finish();
            save_folder_local = 'C:/Users/holos/OneDrive/Documents/stimdata/'; % ends with /
            save_folder_remote = 'Z:/scope2kshare/KKS/pt-data/'; % ends with /
            save_name = [date '_' mouse '_' exp '.mat'];
            save([save_folder_local save_name], 'stimParams', 'stimulus', '-v7.3')
            save([save_folder_remote save_name], 'stimParams', 'stimulus', '-v7.3')
            return
        end
    else
       pause(1)
    end
    
    outputSingleScan(dq, STIM_ON) % set stim indicators up
    renderer.drawStimulus(idx, 1)
    outputSingleScan(dq, STIM_OFF) % set stim indicators down
    stimParams(:, i) = cat(1, stimulus{idx}.ori, stimulus{idx}.size,...
        stimulus{idx}.temp_freq, stimulus{idx}.spat_freq, ...
        stimulus{idx}.contrast);
    
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
disp('got  here. finished.')
renderer.finish();

save_folder_local = 'C:/Users/holos/OneDrive/Documents/stimdata/'; % ends with /
save_folder_remote = 'Z:/scope2kshare/KKS/pt-data/'; % ends with /
save_name = [date '_' mouse '_' exp '.mat'];
save([save_folder_local save_name], 'stimParams', 'stimulus', '-v7.3')
save([save_folder_remote save_name], 'stimParams', 'stimulus', '-v7.3')
end