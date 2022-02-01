function [Kele] = all_frame_element_stiffnesses(c,s,L,E,A,I)
% function [Kele] = all_frame_element_stiffnesses(c,s,L,E,A,I)
%     Input:   c(numele)
%              s(numele)
%              L(numele)
%              E(numele)
%              A(numele)
%              I(numele)
%     Output:  Kele(6,6,numele)
%
numele=size(c,2);
Kele = zeros(6,6,numele);
for n=1:numele,
    Kele(1:6,1:6,n) = frame_stiffness(E(n),A(n),I(n),L(n),c(n),s(n));
end
%
%
%
