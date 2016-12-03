function [status] = build_mex(build_dir, src_files, varargin)
    % Compile C/C++ files to Matlab MEX files for Windows, MacOS and Linux
    % (Tested on Ubuntu 14.04).
    %
    % Parameters:
    %  path: the directory name of the folder where the source functions are
    %  located. It will be also used as the build directory for MEX files.
    %  @type char
    %  f_list: the list of file names that need to be compiled. @type
    %  cellstr 
    %  varargin: extra MEX build options @type varargin
    %
    % @author Wen-Loong Ma <wenloong.ma@gmail.com>
    % @author Ayonga Hereid
    % Copyright (c) 2016, AMBER Lab
    % All right reserved.
    
    
   
    
    
    % get the default MEX extension of the current OS
    mex_ext = mexext();
    
    % check the directory exists
    if ~(exist(build_dir, 'dir'))
        fprintf('The build directory does not exist: %s\n', build_dir);
        fprintf('Aborting ...\n');
        status = false;
        return;
    end
    
    if ischar(src_files)
        % convert to a cell
        src_files = {src_files};
    end
    num_files = length(src_files);
    
    % parpool(4)
    tic
    for i = 1 : num_files
        
        src_file_full_path = fullfile(build_dir,[src_files{i},'.cc']);
        
        src_file = dir(src_file_full_path);
        if isempty(src_file)
            fprintf('File not found: %s\n', src_files{i});
            continue;
        end
        
        % check if an already compiled MEX file exists
        if exist(fullfile(build_dir,[src_files{i},'.',mex_ext]), 'file')
            mexFile = dir(fullfile(build_dir,[src_files{i},'.',mex_ext]));
            mexDate = datetime(mexFile.date);
            srcData = datetime(src_file.date);
            
            % abort build process if the MEX file is newer than the source file
            if mexDate > srcData
                fprintf('This file has been already compiled: %s\n', src_files{i});
                continue;
            end
       
        end
        
        fprintf('Compiling: %s\n', src_files{i});
        
        mex(...
            '-g', ...
            '-outdir', build_dir, ...
            varargin{:}, ...
            src_file_full_path ...
            );
        
        %         disp(['%s.mex  ', src_files{i}]);
    end
    toc
    
    %     delete('*.pdb');
    %     delete('*.lib');
    
    
end









