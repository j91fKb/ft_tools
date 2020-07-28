function mkdir_ext(path)

if any(path == '.')
    dir_to_make = fileparts(path);
else
    dir_to_make = path;
end 
    
if ~exist(dir_to_make, 'dir')
    mkdir(dir_to_make)
end

end

