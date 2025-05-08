% ָ����Ƶ�ļ�·��
videoFile = 'E:\train\Jump\Jump_8_1.mp4';
if exist(videoFile, 'file') == 2
    disp('�ļ�����');
else
    disp('�ļ�������');
end

% ����һ��VideoReader��������ȡ��Ƶ
v = VideoReader(videoFile);s

% ����������������ÿ10֡����һ��
samplingInterval = 10;


% ��ʼ��һ���������洢����֡
sampledFrames = {};
frameIndex = 0;

% ����һ��Ŀ¼���ڴ洢������ͼ���ļ�
outputDir = 'sampledFrames';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

while hasFrame(v)
    frame = readFrame(v);
    frameIndex = frameIndex + 1;
    
    % �����ǰ֡�ǲ�������ı������򱣴��֡
    if mod(frameIndex, samplingInterval) == 0
        % ��֡��ӵ�����
        sampledFrames{end+1} = frame;
        
        % ���浱ǰ֡Ϊͼ���ļ�
        filename = fullfile(outputDir, sprintf('frame%d.jpg', frameIndex));
        imwrite(frame, filename);
        
        % �򿪲���ʾͼ��
        figure; imshow(frame); title(sprintf('Frame %d', frameIndex));
    end
end

% ����sampledFrames���������в����õ���֡������Ӧ��ͼ���ѱ������ʾ

