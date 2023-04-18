% just get a renderer going?
orientation_list = [0:30:330]
for ori = 1:numel(orientation_list)
    stimulus(ori) = DriftingGrating(orientation_list(ori));
end

renderer = StimulusRenderer(renderable); % can be an array of renderables?
renderer.setScreenID(1); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% wait for trigger, should be an ID
for idx = 1:numel(stimulus)
    renderer.drawStimulus(idx, 3) % for 3 seconds
    pause(2) % 2 seconds wait
end
renderer.finish();
