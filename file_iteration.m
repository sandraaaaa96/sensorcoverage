%% 

og_folder='C:\Users\this_\Google Drive (ngylsandra@gmail.com)\SJ';
sj={'csvs_LLZ_south','csvs_LLZ_west','csvs_FS1_left','csvs_FS1_right'}; %add to this
i=1;
while i<=length(sj)
    working_dir=sj{i};
    cd(working_dir);
    filenames = dir;
    filenames1={filenames().name};
    cd(og_folder);
    k=3;
    while k<=length(filenames1)
        antennabeampattern(char(filenames1(k)),working_dir);
        k=k+1;
    end
    i=i+1;
end