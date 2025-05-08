% 指定视频文件路径
videoFile = 'E:\train\Jump\Jump_8_1.mp4';

% 创建VideoReader对象来读取视频
v = VideoReader(videoFile);

% 定义要随机采样的帧数
numSamples = 4; % 例如，随机采样4帧

% 获取视频的总帧数
totalFrames = floor(v.Duration * v.FrameRate);

% 生成随机且不重复的帧索引
randIndices = randperm(totalFrames, numSamples);

% 初始化一个数组来存储采样帧的图像文件路径
framePaths = cell(1, numSamples);

% 创建用于存储图像的文件夹
outputFolder = 'sampledFrames';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% 读取和保存指定的随机帧
for i = 1:numSamples
    % 定位到随机选择的帧
    v.CurrentTime = (randIndices(i)-1) / v.FrameRate;
    
    % 读取帧
    frame = readFrame(v);
    
    % 保存帧到数组
    % 注意：由于随机采样，数组中的帧不按原视频顺序排列
    framePaths{i} = fullfile(outputFolder, sprintf('frame%d.jpg', randIndices(i)));
    
    % 将帧保存为图像
    imwrite(frame, framePaths{i});
    
    % 打开并显示图像
    figure;
    imshow(frame);
    title(sprintf('Randomly Sampled Frame %d', randIndices(i)));
end

% 此时，framePaths数组包含了随机采样的帧的图像文件路径
