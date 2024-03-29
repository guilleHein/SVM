%% CLP
% Práctica 5, BD: SPAM, Classifier: SV
% April 2016, MC
clear
close all
clc

i_plot=1;                               % 1 dibuja BD
i_lineal=0;                             % Linear Classifier
i_gauss=1;                              % Gaussian Kernel Classifier
%% Loading SPAM Database
% load dataspam.txt -ascii
load dataspam
Labs=dataspam(:,end);
N_feat=size(dataspam,2)-1;
X=dataspam(:,1:57);
N_datos=length(Labs);

%% Scatter plot
if i_plot==1
    figure('name','Scatter PLOT of signs')
    X2=X(:,49:54);
    gplotmatrix(X2,X2,Labs)
    zoom on
    clear X2
end
drawnow
clear i_plot

%% Cuantificación binaria de características
X=X(:,1:54);
A=find(X>0);
X(A)=ones(size(A));

%% Generación BD Train (60 %), Cross Validation (20%) y BD Test (20%)
%Aleatorización orden de los vectores
indexperm=randperm(N_datos);
X=X(indexperm,:);
Labs=Labs(indexperm);

% Identificación de un vector para cálculo de probabilidad:
V_analisis=X(N_datos,:);
Lab_analisis=Labs(N_datos)
N_datos=N_datos-1;
X=X(1:N_datos,:);
Labs=Labs(1:N_datos);

% Generación BD Train, BD CV, BD Test
N_train=round(0.6*N_datos)
N_val=round(0.8*N_datos)-N_train
N_test=N_datos-N_train-N_val

% Train
X_train=X(1:N_train,:);
Labs_train=Labs(1:N_train);

%Val: Validation
X_val=X(N_train+1:N_train+N_val,:);
Labs_val=Labs(N_train+1:N_train+N_val);

% Test
X_test=X(N_train+N_val+1:N_datos,:);
Labs_test=Labs(N_train+N_val+1:N_datos);

clear indexperm


%% Clasificador lineal
if i_lineal ==1
    %%P = 0.1;
    Linear_model = fitcsvm(X_train, Labs_train, 'BoxConstraint',P);
    fprintf(1,'\n Clasificador SVM lineal\n')
    Linear_out = predict(Linear_model, X_train);
    Err_train=sum(Linear_out~=Labs_train)/length(Labs_train);
    fprintf(1,'error train = %g   \n', Err_train)
    Linear_out = predict(Linear_model, X_test);
    Err_test=sum(Linear_out~=Labs_test)/length(Labs_test);
    fprintf(1,'error test = %g   \n', Err_test)
    fprintf(1,'\n  \n  ')
    % Test confusion matrix
    CM_Linear_test=confusionmat(Labs_test,Linear_out)
    clear Err_train Err_test Linear_out
end
%clear i_lineal
Err_val_min=1;
i=0;
 P_opt=0;
    h_opt=0;
for P=0.01:0.1:5
    i=i+1;
    j=0;
for h=[1 2.5 25 100]
%% Clasificador kernel gaussiano
j=j+1;
if i_gauss ==1
    %P = 0.1;
    %h=1;
    Gauss_model = fitcsvm(X_train, Labs_train, 'BoxConstraint',P,...
        'KernelFunction','RBF','KernelScale',h);
    %fprintf(1,'\n Clasificador Kernel Gaussiano\n')
    Gauss_out_test = predict(Gauss_model, X_train);
    Err_train=sum(Gauss_out_test~=Labs_train)/length(Labs_train);
    %fprintf(1,'error train = %g   \n', Err_train)
    Gauss_out_val = predict(Gauss_model, X_val);
    Err_val=sum(Gauss_out_val~=Labs_val)/length(Labs_val);
    %fprintf(1,'error val = %g   \n', Err_val)
    %fprintf(1,'\n  \n  ')
    % Test confusion matrix
    %CM_Gauss_test=confusionmat(Labs_test,Gauss_out)
    %lear Err_train Err_test Gauss_out
end
%clear i_gauss
err_train_mat(i,j)=Err_train;
err_val_mat(i,j)=Err_val;
if Err_val<=Err_val_min
    Err_val_min=Err_val;
    P_opt=P;
    h_opt=h;
    Gauss_model_opt=Gauss_model;
    %Gauss_out_opt=Gauss_out;
end   
end
end
P=0.01:0.1:5;
h=[1 2.5 25 100];
figure
title('error train')
surf(h,P,err_train_mat)
figure
title('error validation')
surf(h,P,err_val_mat)