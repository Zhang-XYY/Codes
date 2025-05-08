% Load the pre-trained VGG16 Network
net = vgg16;
inputSize = net.Layers(1).InputSize(1:2);

% Assume 'sampledFrames' contains the frames sampled from your video
% Each frame should be resized and preprocessed according to the network's requirements
% ָ����Ƶ�ļ�·��
videoFile = 'E:\train\Jump\Jump_8_1.mp4';

% ����VideoReader��������ȡ��Ƶ
v = VideoReader(videoFile);

% ����Ҫ���������֡�� 
numSamples = 4; % ���磬�������10֡

% ��ȡ��Ƶ����֡��
totalFrames = floor(v.Duration * v.FrameRate);

% ��������Ҳ��ظ���֡����
randIndices = randperm(totalFrames, numSamples);

% ��ʼ��һ���������洢����֡
sampledFrames = cell(1, numSamples);

% �������ڴ洢ͼ����ļ���
outputFolder = 'sampledFrames';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% �����һ����ȫ�־�ֵ�ͱ�׼��
globalMean = [0.07 0.07 0.07];
globalStd = [0.1 0.09 0.08];

% ��ȡ����һ���ͱ���ָ�������֡
for i = 1:numSamples
    % ��λ�����ѡ���֡
    v.CurrentTime = (randIndices(i)-1) / v.FrameRate;
    
    % ��ȡ֡
    frame = readFrame(v);
    
    % ��һ������ֵ
    normalizedFrame = (double(frame) / 255 - globalMean) / globalStd;

    % �����һ�����֡������
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
