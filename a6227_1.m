%data_test, data_train, label_train  已经加载到工作空间

 
% 初始化预测结果向量
y_pred_bayes = zeros(size(data_test, 1), 1);
y_pred_nb = zeros(size(data_test, 1), 1);
y_pred_lda = zeros(size(data_test, 1), 1);
% 1. 贝叶斯决策规则 - 假设特征条件概率是正态分布
% 对于简单起见，这里我们直接使用fitcnb实现，虽然这不是纯粹的贝叶斯决策规则实现
% 在实际应用中，你可能需要根据问题具体计算类条件概率和先验概率
bayesModel = fitcnb(data_train, label_train);
y_pred_bayes = predict(bayesModel, data_test);
 
% 2. 朴素贝叶斯分类器
nbModel = fitcnb(data_train, label_train);
y_pred_nb = predict(nbModel, data_test);
 
% 3. 线性判别分析
ldaModel = fitcdiscr(data_train, label_train);
y_pred_lda = predict(ldaModel, data_test);
 
% 打印或保存预测结果
fprintf('贝叶斯:\n');
disp(y_pred_bayes);
 
fprintf('朴素贝叶斯:\n');
disp(y_pred_nb);
 
fprintf('线性判别:\n');
disp(y_pred_lda);

