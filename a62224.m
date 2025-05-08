% Load the pre-trained VGG16 Network
net = vgg16;
inputSize = net.Layers(1).InputSize(1:2);

% Assume 'sampledFrames' contains the frames sampled from your video
% Each frame should be resized and preprocessed according to the network's requirements
% 指定视频文件路径
videoFile = 'E:\train\Jump\Jump_8_1.mp4';

% 创建VideoReader对象来读取视频
v = VideoReader(videoFile);

% 定义要随机采样的帧数 
numSamples = 4; % 例如，随机采样10帧

% 获取视频的总帧数
totalFrames = floor(v.Duration * v.FrameRate);

% 生成随机且不重复的帧索引
randIndices = randperm(totalFrames, numSamples);

% 初始化一个数组来存储采样帧
sampledFrames = cell(1, numSamples);

% 创建用于存储图像的文件夹
outputFolder = 'sampledFrames';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 定义归一化的全局均值和标准差
globalMean = [0.07 0.07 0.07];
globalStd = [0.1 0.09 0.08];

% 读取、归一化和保存指定的随机帧
for i = 1:numSamples
    % 定位到随机选择的帧
    v.CurrentTime = (randIndices(i)-1) / v.FrameRate;
    
    % 读取帧
    frame = readFrame(v);
    
    % 归一化像素值
    normalizedFrame = (double(frame) / 255 - globalMean) / globalStd;

    % 保存归一化后的帧到数组
    sampledFrames{i} = normalizedFrame;
% Initialize a matrix to hold the features extracted from each frame

numFrames = numel(sampledFrames);
features = zeros(numFrames, prod(net.Layers(end-3).OutputSize));

% Extract features from each frame using VGG16
for i = 1:numFrames
    frame = sampledFrames{i};
    
    % Resize and preprocess the frame
    if size(frame, 1) ~= inputSize(1) || size(frame, 2) ~= inputSize(2)
        frame = imresize(frame, inputSize(1:2));
    end
    
    % Preprocess the frame for VGG16
    % VGG16 expects input range of [0, 255] and BGR channel order
    frame = double(frame) - net.meta.normalization.averageImage;

    % Extract features using activations from 'fc7' layer of VGG16
    features(i, :) = activations(net, frame, 'fc7');
end

% Apply pooling (average) across all features to fuse them
fusedFeatures = mean(features, 1);

% 'fusedFeatures' is now ready to be used as input for a classifier
disp('Fused Features:');
disp(fusedFeatures);
