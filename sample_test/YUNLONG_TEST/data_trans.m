MEM_SEC_NUM = 64;
MEM_SEC_SIZE = 1024;

% need config
start_sec_idx = 0;
end_sec_idx = 63;
bit_num = 2;

read_write_path = 'C:\\Users\\Tauren_LAB_0\\Desktop\\yunlong_test\\yunlong_ui_v0.1\\';
read_file_name = strcat(read_write_path,'memory_dump_data.txt');
write_file_name = strcat(read_write_path,'read_data_from_testmem_after_trans.txt');
xtemp=textread('memory_dump_data.txt', '%s');

smp_width = (2^bit_num)*32;
smp_sec_num = 2^bit_num;
sec_use_num = end_sec_idx - start_sec_idx + 1;
sec_grp_num = floor(sec_use_num/smp_sec_num);

for sec_grp_idx = 0:(sec_grp_num-1)
    for sec_depth_idx = 0:(MEM_SEC_SIZE-1)
        for smp_sec_idx = 0:(smp_sec_num-1)
            wtemp=xtemp(sec_grp_idx*smp_sec_num*MEM_SEC_SIZE + smp_sec_idx*MEM_SEC_SIZE + sec_depth_idx)
        end
    end
end

