close, clear, clc

file_name = '/some-path//WIDER/wider_face_split/wider_face_val.mat';
root_image_dir = '/some-path/WIDER/WIDER_val/images/';
root_label_dir = strrep(root_image_dir,'images','labels');
load(file_name);
label = 0;
formatSpec = '%d %f %f %f %f\n';

for i = 1:length(event_list)
    disp(event_list{i});
    event_image_dir = [root_image_dir event_list{i} '/'];
    event_label_dir = strrep(event_image_dir,'images','labels');
    if ~exist(event_label_dir,'dir')
        command = ['mkdir ' event_label_dir];
        system(command);
    end
    
    for j = 1:length(file_list{i})
        image_name = [event_image_dir file_list{i}{j} '.jpg'];
        img = imread(image_name);
        img_width = size(img,2);
        img_height = size(img,1);
        label_file = [event_label_dir file_list{i}{j} '.txt'];
        fid = fopen(label_file,'w');
        for k = 1:size(face_bbx_list{i}{j},1)
            bbox(1) = (face_bbx_list{i}{j}(k,1) + face_bbx_list{i}{j}(k,3)/2)/img_width;
            bbox(2) = (face_bbx_list{i}{j}(k,2) + face_bbx_list{i}{j}(k,4)/2)/img_height;
            bbox(3) = face_bbx_list{i}{j}(k,3)/img_width;
            bbox(4) = face_bbx_list{i}{j}(k,4)/img_height;
            if ~invalid_label_list{i}{j}(k)
                fprintf(fid,formatSpec,label,bbox);
            end
        end
        fclose(fid);
    end
end
