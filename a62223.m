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
    
    % 将归一化后的帧保存为图像
    normalizedFramePath = fullfile(outputFolder, sprintf('normalizedFrame%d.jpg', randIndices(i)));
    imwrite(normalizedFrame, normalizedFramePath);
    
    % 打开并显示归一化后的图像
    figure;
    imshow(normalizedFrame);
    title(sprintf('Normalized Randomly Sampled Frame %d', randIndices(i)));
end
