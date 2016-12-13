FP=31;
TP=335;
FN=24;
TN=530;

Ec=(FP+FN)/(FP+TP+FN+TN)
A=1-Ec
P=TP/(TP+FP)
S=TP/(TP+FN)
Es=TN/(TN+FP)
F_score=2*P*S/(P+S)

Pr_Spam=(TP+FP)/(TP+FP+TN+FN)
Pr_Mail=(TN+FN)/(TP+FP+TN+FN)


