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
    
    % ����һ�����֡����Ϊͼ��
    normalizedFramePath = fullfile(outputFolder, sprintf('normalizedFrame%d.jpg', randIndices(i)));
    imwrite(normalizedFrame, normalizedFramePath);
    
    % �򿪲���ʾ��һ�����ͼ��
    figure;
    imshow(normalizedFrame);
    title(sprintf('Normalized Randomly Sampled Frame %d', randIndices(i)));
end
