filename = 'E:\360MoveData\Users\Administrator\Desktop\6227 as2\TrainingData.xlsx';  % 使用完整路径
% 使用readtable读取前四列
% 此处我们假设要读取的列是A到D
data_train = readtable(filename, 'Range', 'A:D', 'ReadVariableNames', false);
% 使用readtable读取第五列，即'E'列
label_train = readtable(filename, 'Range', 'E:E', 'ReadVariableNames', false);
% 指定要删除的行号
rowsToDelete = [38, 60, 82];

% 确保行号在表格或矩阵的行数范围内
rowsToDelete = rowsToDelete(rowsToDelete <= size(data_train, 1));
% 确保行号在表格或矩阵的行数范围内
rowsToDelete = rowsToDelete(rowsToDelete <= size(label_train, 1));
% 删除指定的行
label_train(rowsToDelete, :) = [];
data_train(rowsToDelete, :) = [];

% 转换第一列
if iscell(data_train{:, 1})
    data_train{:, 1} = cellfun(@str2double, data_train{:, 1}, 'UniformOutput', false);
elseif isstring(data_train{:, 1})
    data_train{:, 1} = str2double(data_train{:, 1});
end
 
% 转换第四列
if iscell(data_train{:, 4})
    data_train{:, 4} = cellfun(@str2double, data_train{:, 4}, 'UniformOutput', false);
elseif isstring(data_train{:, 4})
    data_train{:, 4} = str2double(data_train{:, 4});
end

% 假设 data_train 是一个表格，每列是一个变量
% 初始化一个用于标记异常值的逻辑索引表，与data_train大小一致
outliers = false(size(data_train));

% 遍历 data_train 中的每一列
for i = 1 : width(data_train)
    % 跳过非数值数据
    if isnumeric(data_train{:, i})
        % 计算当前列的平均值和标准差
        mu = mean(data_train{:, i});
        sigma = std(data_train{:, i});
        
        % 找出超出 3-sigma 范围的值
        outliers(:, i) = abs(data_train{:, i} - mu) > 3 * sigma;
    end
end

% 将outliers表中的每个true标记为异常值
% 可以选择输出有异常值的行索引和列名称
[row_indices, col_indices] = find(outliers);

% 显示异常值的位置和对应的值
for j = 1 : length(row_indices)
    row = row_indices(j);
    col = col_indices(j);
    fprintf('异常值在第%d行，变量%s，值为: %f\n', row, data_train.Properties.VariableNames{col}, data_train{row, col});
end

% 如果你想要创建一个没有异常值的新表，你可以使用以下代码
data_train_cleaned = data_train;
data_train_cleaned(any(outliers, 2), :) = [];

% 定义要删除的行
rowsToDeletelabel = [93, 95, 88, 114];

% 对行进行排序，确保按降序删除，以避免索引改变
rowsToDeletelabel = sort(rowsToDeletelabel, 'descend');

% 循环删除指定的行
for i = rowsToDeletelabel
    label_train(i, :) = [];
end

% 注意：直接删除未排序的行索引可能会导致错误，因为每删除一行
% 表中的索引就会发生变化。通过降序删除，我们可以保证
% 每次删除操作都不会影响剩余要删除行的索引。



% % 获取data_train第一列的行数
% numRows = size(data_train, 1);
% 
% % 遍历第一列的每个单元格
% for i = 1:numRows
%     % 假设每个单元格中的数组只有一个元素，直接转换成数值
%     % 如果单元格本身就是数值或数值数组，就直接提取第一个元素
%     % 如果是单元格数组，则需要先提取出来
%     if iscell(data_train{i, 1})
%         % 如果单元格内是数组，则取数组的第一个元素
%         % 如果单元格内已经是单个数值，则直接赋值
%         if numel(data_train{i, 1}) == 1
%             data_train{i, 1} = data_train{i, 1}(1);
%         else
%             % 如果数组中有多个元素，则需要进一步决定如何处理
%             % 这里只取第一个元素作为示例
%             data_train{i, 1} = data_train{i, 1}(1);
%         end
%     else
%         % 如果单元格内不是数组（即直接是数值），则不需要转换
%         continue;
%     end
% end
% 
% 使用fitctree训练一个分类决策树模型
classificationTreeModel = fitctree(data_train_cleaned, label_train);
% % 查看训练好的树
view(classificationTreeModel, 'Mode', 'graph');
% 
 filenametest = 'E:\360MoveData\Users\Administrator\Desktop\6227 as2\TestData.xlsx';  % 使用完整路径
data_test = readtable(filenametest, 'Range', 'A:D', 'ReadVariableNames', false);
% 
 predictedLabels = predict(classificationTreeModel, data_test);
% % 显示预测结果
 disp('Predicted labels:');
disp(predictedLabels);


% Delete the rows from label_train
for k = rowsToDeletelabel'
    label_train(k, :) = [];




