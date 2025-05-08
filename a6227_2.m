filename = 'E:\360MoveData\Users\Administrator\Desktop\6227 as2\TrainingData.xlsx';  % ʹ������·��
% ʹ��readtable��ȡǰ����
% �˴����Ǽ���Ҫ��ȡ������A��D
data_train = readtable(filename, 'Range', 'A:D', 'ReadVariableNames', false);
% ʹ��readtable��ȡ�����У���'E'��
label_train = readtable(filename, 'Range', 'E:E', 'ReadVariableNames', false);
% ָ��Ҫɾ�����к�
rowsToDelete = [38, 60, 82];

% ȷ���к��ڱ�������������Χ��
rowsToDelete = rowsToDelete(rowsToDelete <= size(data_train, 1));
% ȷ���к��ڱ�������������Χ��
rowsToDelete = rowsToDelete(rowsToDelete <= size(label_train, 1));
% ɾ��ָ������
label_train(rowsToDelete, :) = [];
data_train(rowsToDelete, :) = [];

% ת����һ��
if iscell(data_train{:, 1})
    data_train{:, 1} = cellfun(@str2double, data_train{:, 1}, 'UniformOutput', false);
elseif isstring(data_train{:, 1})
    data_train{:, 1} = str2double(data_train{:, 1});
end
 
% ת��������
if iscell(data_train{:, 4})
    data_train{:, 4} = cellfun(@str2double, data_train{:, 4}, 'UniformOutput', false);
elseif isstring(data_train{:, 4})
    data_train{:, 4} = str2double(data_train{:, 4});
end

% ���� data_train ��һ�����ÿ����һ������
% ��ʼ��һ�����ڱ���쳣ֵ���߼���������data_train��Сһ��
outliers = false(size(data_train));

% ���� data_train �е�ÿһ��
for i = 1 : width(data_train)
    % ��������ֵ����
    if isnumeric(data_train{:, i})
        % ���㵱ǰ�е�ƽ��ֵ�ͱ�׼��
        mu = mean(data_train{:, i});
        sigma = std(data_train{:, i});
        
        % �ҳ����� 3-sigma ��Χ��ֵ
        outliers(:, i) = abs(data_train{:, i} - mu) > 3 * sigma;
    end
end

% ��outliers���е�ÿ��true���Ϊ�쳣ֵ
% ����ѡ��������쳣ֵ����������������
[row_indices, col_indices] = find(outliers);

% ��ʾ�쳣ֵ��λ�úͶ�Ӧ��ֵ
for j = 1 : length(row_indices)
    row = row_indices(j);
    col = col_indices(j);
    fprintf('�쳣ֵ�ڵ�%d�У�����%s��ֵΪ: %f\n', row, data_train.Properties.VariableNames{col}, data_train{row, col});
end

% �������Ҫ����һ��û���쳣ֵ���±������ʹ�����´���
data_train_cleaned = data_train;
data_train_cleaned(any(outliers, 2), :) = [];

% ����Ҫɾ������
rowsToDeletelabel = [93, 95, 88, 114];

% ���н�������ȷ��������ɾ�����Ա��������ı�
rowsToDeletelabel = sort(rowsToDeletelabel, 'descend');

% ѭ��ɾ��ָ������
for i = rowsToDeletelabel
    label_train(i, :) = [];
end

% ע�⣺ֱ��ɾ��δ��������������ܻᵼ�´�����Ϊÿɾ��һ��
% ���е������ͻᷢ���仯��ͨ������ɾ�������ǿ��Ա�֤
% ÿ��ɾ������������Ӱ��ʣ��Ҫɾ���е�������



% % ��ȡdata_train��һ�е�����
% numRows = size(data_train, 1);
% 
% % ������һ�е�ÿ����Ԫ��
% for i = 1:numRows
%     % ����ÿ����Ԫ���е�����ֻ��һ��Ԫ�أ�ֱ��ת������ֵ
%     % �����Ԫ���������ֵ����ֵ���飬��ֱ����ȡ��һ��Ԫ��
%     % ����ǵ�Ԫ�����飬����Ҫ����ȡ����
%     if iscell(data_train{i, 1})
%         % �����Ԫ���������飬��ȡ����ĵ�һ��Ԫ��
%         % �����Ԫ�����Ѿ��ǵ�����ֵ����ֱ�Ӹ�ֵ
%         if numel(data_train{i, 1}) == 1
%             data_train{i, 1} = data_train{i, 1}(1);
%         else
%             % ����������ж��Ԫ�أ�����Ҫ��һ��������δ���
%             % ����ֻȡ��һ��Ԫ����Ϊʾ��
%             data_train{i, 1} = data_train{i, 1}(1);
%         end
%     else
%         % �����Ԫ���ڲ������飨��ֱ������ֵ��������Ҫת��
%         continue;
%     end
% end
% 
% ʹ��fitctreeѵ��һ�����������ģ��
classificationTreeModel = fitctree(data_train_cleaned, label_train);
% % �鿴ѵ���õ���
view(classificationTreeModel, 'Mode', 'graph');
% 
 filenametest = 'E:\360MoveData\Users\Administrator\Desktop\6227 as2\TestData.xlsx';  % ʹ������·��
data_test = readtable(filenametest, 'Range', 'A:D', 'ReadVariableNames', false);
% 
 predictedLabels = predict(classificationTreeModel, data_test);
% % ��ʾԤ����
 disp('Predicted labels:');
disp(predictedLabels);


% Delete the rows from label_train
for k = rowsToDeletelabel'
    label_train(k, :) = [];




