close all;
clear;
clc;

addpath(genpath('source-code/'));

hazy = imread('hazy_scene.png');
yellowdust = imread('yellow_dust.jpg');
synthetic = imread('synthetic_scene.png');

[j1,t1,ten1] = OTM(hazy);
[j2,t2,ten2] = OTM(yellowdust);
[j3,t3,ten3] = OTM(synthetic);

figure;
hazy = double(hazy(1:size(j1,1),1:size(j1,2),:))/255;
subplot(211); imshow([hazy,j1]);
subplot(212); imshow([t1,ten1],[]); colormap(jet(256));

figure;
yellowdust = double(yellowdust(1:size(j2,1),1:size(j2,2),:))/255;
subplot(211); imshow([yellowdust,j2]);
subplot(212); imshow([t2,ten2],[]); colormap(jet(256));

figure;
synthetic = double(synthetic(1:size(j3,1),1:size(j3,2),:))/255;
subplot(211); imshow([synthetic,j3]);
subplot(212); imshow([t3,ten3],[]); colormap(jet(256));
