% 指定视频文件路径
videoFile = 'E:\train\Jump\Jump_8_1.mp4';
if exist(videoFile, 'file') == 2
    disp('文件存在');
else
    disp('文件不存在');
end

% 创建一个VideoReader对象来读取视频
v = VideoReader(videoFile);s

% 定义采样间隔，例如每10帧采样一次
samplingInterval = 10;


% 初始化一个数组来存储采样帧
sampledFrames = {};
frameIndex = 0;

% 创建一个目录用于存储采样的图像文件
outputDir = 'sampledFrames';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

while hasFrame(v)
    frame = readFrame(v);
    frameIndex = frameIndex + 1;
    
    % 如果当前帧是采样间隔的倍数，则保存该帧
    if mod(frameIndex, samplingInterval) == 0
        % 将帧添加到数组
        sampledFrames{end+1} = frame;
        
        % 保存当前帧为图像文件
        filename = fullfile(outputDir, sprintf('frame%d.jpg', frameIndex));
        imwrite(frame, filename);
        
        % 打开并显示图像
        figure; imshow(frame); title(sprintf('Frame %d', frameIndex));
    end
end

% 现在sampledFrames包含了所有采样得到的帧，且相应的图像已保存和显示

