% just get a renderer going?
orientation_list = [0:30:330];
% sz_list = round(linspace(10, 1000, length(orientation_list)));
% for ori = 1:numel(orientation_list)
%     stimulus(ori) = DriftingGrating(orientation_list(ori), [], [], [], [], sz_list(ori));
% end

for ori = 1:numel(orientation_list)
    stimulus(ori) = FigureGroundStim(orientation_list(ori), [], [], [], [], 100, []);
end

renderer = StimulusRenderer(stimulus); % can be an array of renderables?
renderer.setScreenID(0); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% wait for trigger, should be an ID
for idx = 1:numel(stimulus) % pass direct?
renderer.drawStimulus(idx, 1) % for 3 seconds
pause(2) % 2 seconds wait
end

renderer.finish();
