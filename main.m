% MSCNN 去雾主程序
% 实现功能
% 1.将雾图去雾并保存在SOTS/outdoor/dehaze
% 2.计算平均PSNR和SSIM
clear;close all; clc;
addpath(genpath('./'));
run(fullfile(fileparts(mfilename('fullpath')), './matlab/vl_setupnn.m')) ;
gamma =1.0;
% dehaze：去雾,保存，计算
% calc:    仅计算psnr和ssim
mode = 'dehaze';
clear_dir = 'D:\Projects\Dehaze\其他论文去雾代码\HazeRD合成测试集\clear\'; % 清晰图片文件夹
haze_dir = 'D:\Projects\Dehaze\其他论文去雾代码\真实雾图数据集\';  %合成雾图文件夹
dehazed_dir = 'D:\Projects\Dehaze\其他论文去雾代码\MSCNN_dehazing\真实雾图去雾结果\';        % 去雾图保存目录
filelist = dir(strcat(clear_dir,'*.jpg'));
file_num = length(filelist);            % 文件数量
file_names = cell(1,file_num);      % 文件名
for i = 1:file_num
    file_names{i} = filelist(i).name;
end

% 读入清晰图
clear_imgs = cell(1,file_num);
% 读clear
for i = 1:file_num
    clear_imgs{i} = imread(strcat(clear_dir,file_names{i}));
end

if strcmp(mode,'calc')
    % 读去雾图
    dehazed_imgs = cell(1,file_num);
    for i = 1:file_num
        dehazed_imgs{i} = imread(strcat(dehazed_dir,file_names{i}));
    end
else
    %   去雾
    dehazed_imgs = cell(1,file_num);
    for i = 1:file_num
        imagename = strcat(haze_dir,file_names{i});
        dehazed_imgs{i} = mscnndehazing(imagename, gamma);
    end
    %  写入去雾图
    for i = 1:file_num
        imwrite(dehazed_imgs{i},strcat(dehazed_dir,file_names{i}));
    end
end

% 计算PSNR平均值
total_psnr = 0;
for i = 1:file_num
    total_psnr = total_psnr + psnr(dehazed_imgs{i},clear_imgs{i});
end
PSNR = total_psnr/file_num

% 计算SSIM平均值
total_ssim = 0;
for i= 1:file_num
    total_ssim = total_ssim + ssim(dehazed_imgs{i},clear_imgs{i});
end
SSIM = total_ssim / file_num
