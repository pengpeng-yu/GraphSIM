function [L,M,N]=RGB2LMN_graph(A)
L=0.06*A(:,1)+0.63*A(:,2)+0.27*A(:,3);
M=0.3*A(:,1)+0.04*A(:,2)-0.35*A(:,3);
N=0.34*A(:,1)-0.60*A(:,2)+0.17*A(:,3);
