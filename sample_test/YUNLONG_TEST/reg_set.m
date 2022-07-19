
%%
reg_cfg_path="C:\\Users\\Tauren_LAB_0\\Desktop\\yunlong_test\\";
if reg_smpl==0
    SheetArray={'Pll','adc_init_env','adc_init_self','smp_send_init','ADC_smp_test_cfg'};
elseif smp_origin==0&&smp_dual==0
    SheetArray={'smp_send_init','ADC_smp_test_cfg'};
elseif smp_origin==0&&smp_dual==1
    SheetArray={'smp_send_init','adc_smp_dual'};
elseif smp_origin==1
    SheetArray={'smp_send_init','adc_smp_origin'};    
end
for i_sheet=1:length(SheetArray)
    reg_pair = readtable(strcat(reg_cfg_path,"test_adc.xls"),'Sheet',string(SheetArray(i_sheet)),'Range','A:B','ReadVariableNames',false);
    reg_pair=string(reg_pair{:,:});
    for k=1:size(reg_pair,1)
        if strlength(reg_pair(k,1))~=0
            spi_write_raw(reg_pair(k,1), reg_pair(k,2));
        else
            break;
        end
    end
end