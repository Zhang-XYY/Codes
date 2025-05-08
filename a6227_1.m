%data_test, data_train, label_train  �Ѿ����ص������ռ�

 
% ��ʼ��Ԥ��������
y_pred_bayes = zeros(size(data_test, 1), 1);
y_pred_nb = zeros(size(data_test, 1), 1);
y_pred_lda = zeros(size(data_test, 1), 1);
% 1. ��Ҷ˹���߹��� - ��������������������̬�ֲ�
% ���ڼ��������������ֱ��ʹ��fitcnbʵ�֣���Ȼ�ⲻ�Ǵ���ı�Ҷ˹���߹���ʵ��
% ��ʵ��Ӧ���У��������Ҫ�����������������������ʺ��������
bayesModel = fitcnb(data_train, label_train);
y_pred_bayes = predict(bayesModel, data_test);
 
% 2. ���ر�Ҷ˹������
nbModel = fitcnb(data_train, label_train);
y_pred_nb = predict(nbModel, data_test);
 
% 3. �����б����
ldaModel = fitcdiscr(data_train, label_train);
y_pred_lda = predict(ldaModel, data_test);
 
% ��ӡ�򱣴�Ԥ����
fprintf('��Ҷ˹:\n');
disp(y_pred_bayes);
 
fprintf('���ر�Ҷ˹:\n');
disp(y_pred_nb);
 
fprintf('�����б�:\n');
disp(y_pred_lda);

