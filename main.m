% MSCNN ȥ��������
% ʵ�ֹ���
% 1.����ͼȥ��������SOTS/outdoor/dehaze
% 2.����ƽ��PSNR��SSIM
clear;close all; clc;
addpath(genpath('./'));
run(fullfile(fileparts(mfilename('fullpath')), './matlab/vl_setupnn.m')) ;
gamma =1.0;
% dehaze��ȥ��,���棬����
% calc:    ������psnr��ssim
mode = 'dehaze';
clear_dir = 'D:\Projects\Dehaze\��������ȥ�����\HazeRD�ϳɲ��Լ�\clear\'; % ����ͼƬ�ļ���
haze_dir = 'D:\Projects\Dehaze\��������ȥ�����\��ʵ��ͼ���ݼ�\';  %�ϳ���ͼ�ļ���
dehazed_dir = 'D:\Projects\Dehaze\��������ȥ�����\MSCNN_dehazing\��ʵ��ͼȥ����\';        % ȥ��ͼ����Ŀ¼
filelist = dir(strcat(clear_dir,'*.jpg'));
file_num = length(filelist);            % �ļ�����
file_names = cell(1,file_num);      % �ļ���
for i = 1:file_num
    file_names{i} = filelist(i).name;
end

% ��������ͼ
clear_imgs = cell(1,file_num);
% ��clear
for i = 1:file_num
    clear_imgs{i} = imread(strcat(clear_dir,file_names{i}));
end

if strcmp(mode,'calc')
    % ��ȥ��ͼ
    dehazed_imgs = cell(1,file_num);
    for i = 1:file_num
        dehazed_imgs{i} = imread(strcat(dehazed_dir,file_names{i}));
    end
else
    %   ȥ��
    dehazed_imgs = cell(1,file_num);
    for i = 1:file_num
        imagename = strcat(haze_dir,file_names{i});
        dehazed_imgs{i} = mscnndehazing(imagename, gamma);
    end
    %  д��ȥ��ͼ
    for i = 1:file_num
        imwrite(dehazed_imgs{i},strcat(dehazed_dir,file_names{i}));
    end
end

% ����PSNRƽ��ֵ
total_psnr = 0;
for i = 1:file_num
    total_psnr = total_psnr + psnr(dehazed_imgs{i},clear_imgs{i});
end
PSNR = total_psnr/file_num

% ����SSIMƽ��ֵ
total_ssim = 0;
for i= 1:file_num
    total_ssim = total_ssim + ssim(dehazed_imgs{i},clear_imgs{i});
end
SSIM = total_ssim / file_num
