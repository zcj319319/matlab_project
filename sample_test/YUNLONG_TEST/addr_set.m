%%
ALG_BASE={'0x02100';'0x03100';'0x10100';'0x11100';'0x12100';'0x13100';'0x14100';'0x15100';'0x16100';'0x17100'};
ALG_TOP_BASE={'0x02000';'0x03000';'0x10000';'0x11000';'0x12000';'0x13000';'0x14000';'0x15000';'0x16000';'0x17000'};
AND_ANA_BASE={'0x0','0x17','0x2e','0x45','0x5c','0x73','0x8a','0xa1','0xb8','0xcf'};
ALG_RXFB={'fb0','fb1','rx0','rx1','rx2','rx3','rx4','rx5','rx6','rx7'};
% pll_set;
% analog_set;
% adc_set;

%% channel select


for ind_alg=1:10
    xtemp=string(ALG_RXFB(ind_alg));
    if strcmp(xtemp,ALG_IND)
        break;
    end
end

BASE_ADDR_CALIB_ALG = string(ALG_BASE(ind_alg));
BASE_ADDR_CALIB_ALG_TOP = string(ALG_TOP_BASE(ind_alg));
BASE_ADDR_ANA = string(AND_ANA_BASE(ind_alg));