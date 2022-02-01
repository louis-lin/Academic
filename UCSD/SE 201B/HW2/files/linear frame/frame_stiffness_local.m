function [Kele] = frame_stiffness_local(E,A,I,L)
% function [Kele] = frame_stiffness_local(E,A,I,L)
Kele=[4*E*I/L 2*E*I/L 0; 2*E*I/L 4*E*I/L 0; 0 0 E*A/L];
%
%
%