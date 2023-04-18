% just get a renderer going?

renderer = StimulusRenderer(renderable); % can be an array of renderables?
renderer.setScreenID(1); % direct call to psychtoolbox
renderer.initialize(); % pass a timer, but do we need it? probably...

renderer.start();

% wait for trigger, should be an ID
renderer.drawStimulus(idx)

renderer.wait? % what here?

renderer.finish();
