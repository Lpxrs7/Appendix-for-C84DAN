%% Script creates nice subplots for Lab Report

% . Load in rendered highres images that have undergone the slicer function 
[X1, map1]  = imread('renderedThreshStat1midplanes.png');
[X2, map2]  = imread('renderedThreshStat2midplanes.png');
[X3, map3]  = imread('renderedThreshStat3midplanes.png');


% plot on the same plot
subplot(3,1,1), imshow(X1, map1), title('Faces');
subplot(3,1,2), imshow(X2, map2), title('Objects');
subplot(3,1,3), imshow(X3, map3), title('Scenes');

% . Convert to PDF first to minimise pixelation

%% Subplot for stimuli

[X4, map4]  = imread('Face.Stim.png');
[X5, map5]  = imread('Object.Stim.png');
[X6, map6]  = imread('Scene.Stim.png');


subplot(3,1,1), imshow(X4, map4), title('Faces');
subplot(3,1,2), imshow(X5, map5), title('Objects');
subplot(3,1,3), imshow(X6, map6), title('Scenes');
