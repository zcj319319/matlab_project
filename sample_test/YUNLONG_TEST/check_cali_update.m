if check_cali_change==1
    if sum(calib.subgec_opgain_code-calib_pre.subgec_opgain_code)==0
        calib.change_subgec=0;
    else
        calib.change_subgec=1;
    end
    if sum(calib.bkgec_coeff_fb2-calib_pre.bkgec_coeff_fb2)==0
        calib.change_bkgec=0;
    else
        calib.change_bkgec=1;
    end
    if sum(calib.gec_coeff-calib_pre.gec_coeff)==0
        calib.change_gec=0;
    else
        calib.change_gec=1;
    end
    if sum(calib.tios_coeff-calib_pre.tios_coeff)==0
        calib.change_tios=0;
    else
        calib.change_tios=1;
    end
    if sum(calib.tigain_coeff-calib_pre.tigain_coeff)==0
        calib.change_tigain=0;
    else
        calib.change_tigain=1;
    end
    if sum(calib.tiskew_code-calib_pre.tiskew_code)==0
        calib.change_tiskew=0;
    else
        calib.change_tiskew=1;
    end
end