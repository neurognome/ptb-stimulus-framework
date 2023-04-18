% just get a renderer going?
orientation_list = [0:30:330];
for ori = 1:numel(orientation_list)
    stimulus(ori) = DriftingGrating(orientation_list(ori));
end

renderer = StimulusRenderer(stimulus); % can be an array of renderables?
renderer.setScreenID(0); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% wait for trigger, should be an ID
idx=1
renderer.drawStimulus(idx, 3) % for 3 seconds
pause(2) % 2 seconds wait

renderer.finish();
