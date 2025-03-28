%%
plotColor  = rgb("White");
set(gcf,'color',plotColor );
% 
% xlabel('X', 'FontSize', 20);
% ylabel('Y', 'FontSize', 20);



X = categorical({'American U', 'Brown', 'Columbia', 'Georgetown', 'Harvard ',...
   'The New School', 'NYU' , 'Tufts', 'Brandeis U',  ...
   'MIT', 'UChicago', 'Northwestern', 'Duke'});
X = reordercats(X,{'American U', 'Brown', 'Columbia', 'Georgetown', 'Harvard ',...
   'The New School', 'NYU' , 'Tufts', 'Brandeis U',  ...
   'MIT', 'UChicago', 'Northwestern', 'Duke' });

Y = [ 36, 42, 44, 33, 40 ,42, 45, 39, 36, ...
      47, 33, 35, 38]; 

colors = [ rgb("Blue"); rgb("Brown"); rgb("LightSkyBlue"); rgb("Silver")...
    ; rgb("Crimson"); rgb("Orange"); rgb("Indigo"); rgb("SaddleBrown"); rgb("DodgerBlue");...
     rgb("Silver"); rgb("DarkRed"); rgb("Purple"); rgb("Navy") ]; 

%Control Coloar 
b = bar( X, Y ); 
b.FaceColor = 'flat';
b.FaceAlpha = .5;
b.EdgeColor = rgb("Gainsboro");
ylabel( join([ "Salary", newline, "(1000s $) "]) )
title = join(["Average Stipend of Grad Students at Private Universities"...
    "with Unionized Grad Student Body"]);
for i  = 1:length(Y)
b.CData(i,:) = colors(i,:);
end 

set(gca,'FontSize', 18 );
% set(get(gca,'ylabel'),'rotation',0)
set(gca, 'fontname', 'Cambria Math'); 


yl = yline( 31, '-', 'Vanderbilt *','FontSize', 25 ,'fontname', 'Stencil',   'LineWidth',2 );
yl.Color = rgb("Black");
yl.LabelHorizontalAlignment = 'center';
text(1:length(Y),Y,num2str(Y'),'vert','bottom','horiz','center','fontname', 'Stencil',...
    'FontSize', 14 ); 
y1.FaceAlpha = 1;
box off


%%
plotColor  = rgb("White");
set(gcf,'color',plotColor );
X = categorical({ 'MIT', 'UChicago', 'Northwestern', 'Duke' });
X = reordercats(X,{'MIT', 'UChicago', 'Northwestern', 'Duke'  });
Y = [47 33 35 38]; 

colors = [ rgb("Silver"); rgb("DarkRed"); rgb("Purple"); rgb("Navy") ]; 

b = bar( X, Y ); 
b.FaceColor = 'flat';
b.FaceAlpha = .5;
b.EdgeColor = rgb("Gainsboro");
ylabel( join([ "Salary", newline, "(1000s $) "]) )
title = join(["Average Stipend of Grad Students at Private Universities"...
    "with Unionized Grad Student Body"]);
for i  = 1:length(Y)
b.CData(i,:) = colors(i,:);
end 

set(gca,'FontSize', 18 );
% set(get(gca,'ylabel'),'rotation',0)
set(gca, 'fontname', 'Cambria Math'); 


yl = yline( 31, '-', 'Vanderbilt *','FontSize', 25 ,'fontname', 'Stencil',   'LineWidth',2 );
yl.Color = rgb("Black");
yl.LabelHorizontalAlignment = 'center';
y1.FaceAlpha = 1;
box off




