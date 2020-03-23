function antennabeampattern(file,working_dir)

%file naming conventions
og_folder='C:\Users\this_\Google Drive (ngylsandra@gmail.com)\SJ';
cd(working_dir)
data = readtable(file,'HeaderLines',1);
cd(og_folder);
cd(sprintf('Processed_%s',working_dir));
file_att=regexp(file,'_','split');
freq = file_att{2};
jammer_elevation = file_att{3};
date=file_att{1};
dir=sprintf('%s_%s_%s_%s',working_dir,date,freq,jammer_elevation);
if ~exist(dir, 'dir')
   mkdir(dir)
end
cd(dir);

%the real deal
%import the cylindrical, convert to cartesian
L = data{:,2};
theta_rad = (data{:,3})*pi()/180;
z = data{:,1};
[x,y,z]=pol2cart(theta_rad,L,z);

figure
sc=20;
scatter3(x,y,z,sc,'k','filled')
title(sprintf('Jammed Points, %s, %s',freq,jammer_elevation));
axis([0 2000 0 2000 0 400]);
xlabel('xDj,h');
ylabel('yDj,h');
zlabel('Height(m)');
hold on;
fenceline=800;
[xf,yf,zf]=cylinder(fenceline,40);
zf=zf*40;
surface(xf,yf,zf,'FaceColor','none','EdgeColor','r')
view(0,90)
filename_090=sprintf('JammedPoints_%s_%s_%s_090.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_090);
view(0,0)
filename_00=sprintf('JammedPoints_%s_%s_%s_00.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_00);
view(-45,45)
filename_45=sprintf('JammedPoints_%s_%s_%s_45.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_45);

%normalise gain over the longest diagonal
%separate by profile later (if needed?)
diagonal=sqrt(L.^2+z.^2);
gain=diagonal./max(diagonal);
[x1,y1,z1]=pol2cart(theta_rad,gain,z);

%plot convexhull using DT; check if enough points
if length(x1)>5
    K = convhull(x1,y1,z1);
end

%plot suspected gain
figure
scatter3(x1,y1,z1,sc,'k','filled')
title(sprintf('Normalised Gain (Linear), %s, %s',freq,jammer_elevation));
axis([0 1 0 1 0 400]);
xlabel('xGain (Linear)');
ylabel('yGain (Linear)');
zlabel('Height(m)');
hold on;
if exist('K','var')==1
    trisurf(K,x1,y1,z1,'FaceColor','none','EdgeColor','b');
end
hold on;
[xs,ys,zs]=sphere(24);
surface(xs,ys,zs,'FaceColor','none','EdgeColor','k')
hold on;

view(0,90)
filename_090_1=sprintf('BeamPattern_%s_%s_%s_090.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_090_1);
view(0,0)
filename_00_1=sprintf('BeamPattern_%s_%s_%s_00.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_00_1);
view(-45,45)
filename_45_1=sprintf('BeamPattern_%s_%s_%s_45.jpg',date,freq,jammer_elevation);
saveas(gcf,filename_45_1);
close all;

%sanity check back to working folder
cd(og_folder);

end
