% ָ����Ƶ�ļ�·��
videoFile = 'E:\train\Jump\Jump_8_1.mp4';

% ����VideoReader��������ȡ��Ƶ
v = VideoReader(videoFile);

% ����Ҫ���������֡��
numSamples = 4; % ���磬�������4֡

% ��ȡ��Ƶ����֡��
totalFrames = floor(v.Duration * v.FrameRate);

% ��������Ҳ��ظ���֡����
randIndices = randperm(totalFrames, numSamples);

% ��ʼ��һ���������洢����֡��ͼ���ļ�·��
framePaths = cell(1, numSamples);

% �������ڴ洢ͼ����ļ���
outputFolder = 'sampledFrames';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% ��ȡ�ͱ���ָ�������֡
for i = 1:numSamples
    % ��λ�����ѡ���֡
    v.CurrentTime = (randIndices(i)-1) / v.FrameRate;
    
    % ��ȡ֡
    frame = readFrame(v);
    
    % ����֡������
    % ע�⣺������������������е�֡����ԭ��Ƶ˳������
    framePaths{i} = fullfile(outputFolder, sprintf('frame%d.jpg', randIndices(i)));
    
    % ��֡����Ϊͼ��
    imwrite(frame, framePaths{i});
    
    % �򿪲���ʾͼ��
    figure;
    imshow(frame);
    title(sprintf('Randomly Sampled Frame %d', randIndices(i)));
end

% ��ʱ��framePaths������������������֡��ͼ���ļ�·��
