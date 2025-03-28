% This script plots the different font types of your matlab version.
% You may need to adjust some parameters to fit your screen resolution.
% After you run the scrip, maximize plot windows to see results better.
%
% Program Written by: Juan Camilo Medina
% The University of Notre Dame  -  01/2012
% ------------------------------------------------------------------------%
clear all; close all; clc;
c=listfonts
for n=1:ceil(length(c)/35)
    if n<=6
        figure(1); axis([0 3 0 145]); axis off;
        for j=(n-1)*35+1:min(n*35,length(c))
            text(0.6*(n-1)-0.3,4*(j-(35*(n-1))),c{j},'FontSize',14,...
                'FontName',c{j})
        end
    else
        figure(2); axis([0 3.8 0 145]); axis off;
        for j=(n-1)*35+1:min(n*35,length(c))
            text(0.9*(n-7)-0.3,4*(j-(35*(n-1))),c{j},'FontSize',14,...
                'FontName',c{j})
        end
    end
end
