% function cantilever_plot
% Plot of deformed shape of cantilever beam subjected to tip vertical load
close all
figure(1)
X = 0:100:1000;
Y = zeros(1,11);
Xnew = X + [0. U(1,11,1) U(4,11,1) U(7,11,1) U(10,11,1) U(13,11,1) U(16,11,1) U(19,11,1) ...
    U(22,11,1) U(25,11,1) U(28,11,1)];
Ynew = Y + [0. U(2,11,1) U(5,11,1) U(8,11,1) U(11,11,1) U(14,11,1) U(17,11,1) U(20,11,1) ...
    U(23,11,1) U(26,11,1) U(29,11,1)];
%
Xnew = [Xnew; X + [0. U(1,21,1) U(4,21,1) U(7,21,1) U(10,21,1) U(13,21,1) U(16,21,1) U(19,21,1) ...
    U(22,21,1) U(25,21,1) U(28,21,1)]];
Ynew = [Ynew; Y + [0. U(2,21,1) U(5,21,1) U(8,21,1) U(11,21,1) U(14,21,1) U(17,21,1) U(20,21,1) ...
    U(23,21,1) U(26,21,1) U(29,21,1)]];
%
Xnew = [Xnew; X + [0. U(1,31,1) U(4,31,1) U(7,31,1) U(10,31,1) U(13,31,1) U(16,31,1) U(19,31,1) ...
    U(22,31,1) U(25,31,1) U(28,31,1)]];
Ynew = [Ynew; Y + [0. U(2,31,1) U(5,31,1) U(8,31,1) U(11,31,1) U(14,31,1) U(17,31,1) U(20,31,1) ...
    U(23,31,1) U(26,31,1) U(29,31,1)]];
%
Xnew = [Xnew; X + [0. U(1,41,1) U(4,41,1) U(7,41,1) U(10,41,1) U(13,41,1) U(16,41,1) U(19,41,1) ...
    U(22,41,1) U(25,41,1) U(28,41,1)]];
Ynew = [Ynew; Y + [0. U(2,41,1) U(5,41,1) U(8,41,1) U(11,41,1) U(14,41,1) U(17,41,1) U(20,41,1) ...
    U(23,41,1) U(26,41,1) U(29,41,1)]];
%
plot(X,Y,'k-',X,Y,'ko');
hold on;
plot(Xnew(1,:),Ynew(1,:),'k-',Xnew(1,:),Ynew(1,:),'ko');
hold on;
plot(Xnew(2,:),Ynew(2,:),'k-',Xnew(2,:),Ynew(2,:),'ko');
hold on;
plot(Xnew(3,:),Ynew(3,:),'k-',Xnew(3,:),Ynew(3,:),'ko');
hold on;
plot(Xnew(4,:),Ynew(4,:),'k-',Xnew(4,:),Ynew(4,:),'ko');
axis equal;
%
%
load = 0:2.:80;
figure(2);
plot(-U(28,1:41,1),load);
figure(3)
plot(-U(29,1:41,1),load);
figure(4)
plot(-U(30,1:41,1),load);