tx_r_term0_value=0;
tx_r_term0_en=0;
rx_r_term1_value=0;
rx_r_term1_en=0;
rx_r_term2_value=0;
rx_r_term2_en=0;

tx_l_term0_value=0;
tx_l_term0_en=0;
rx_l_term1_value=0;
rx_l_term1_en=0;
rx_l_term2_value=0;
rx_l_term2_en=0;
%%
tx_r_term0_bit2_value=floor(tx_r_term0_value/4);
tx_r_term0_bit1_value=floor(mod(tx_r_term0_value,4)/2);
tx_r_term0_bit0_value=floor(mod(tx_r_term0_value,2)/1);

rx_r_term1_bit2_value=floor(rx_r_term1_value/4);
rx_r_term1_bit1_value=floor(mod(rx_r_term1_value,4)/2);
rx_r_term1_bit0_value=floor(mod(rx_r_term1_value,2)/1);

rx_r_term2_bit2_value=floor(rx_r_term2_value/4);
rx_r_term2_bit1_value=floor(mod(rx_r_term2_value,4)/2);
rx_r_term2_bit0_value=floor(mod(rx_r_term2_value,2)/1);

tx_l_term0_bit2_value=floor(tx_l_term0_value/4);
tx_l_term0_bit1_value=floor(mod(tx_l_term0_value,4)/2);
tx_l_term0_bit0_value=floor(mod(tx_l_term0_value,2)/1);

rx_l_term1_bit2_value=floor(rx_l_term1_value/4);
rx_l_term1_bit1_value=floor(mod(rx_l_term1_value,4)/2);
rx_l_term1_bit0_value=floor(mod(rx_l_term1_value,2)/1);

rx_l_term2_bit2_value=floor(rx_l_term2_value/4);
rx_l_term2_bit1_value=floor(mod(rx_l_term2_value,4)/2);
rx_l_term2_bit0_value=floor(mod(rx_l_term2_value,2)/1);
%%
tx_r_term0_bit2_addr=7821;
tx_r_term0_bit1_addr=7822;
tx_r_term0_bit0_addr=7823;
tx_r_term0_en_addr=7687;

rx_r_term1_bit2_addr=14763;
rx_r_term1_bit1_addr=14762;
rx_r_term1_bit0_addr=14761;
rx_r_term1_en_addr=14760;

rx_r_term2_bit2_addr=14756;
rx_r_term2_bit1_addr=14757;
rx_r_term2_bit0_addr=14758;
rx_r_term2_en_addr=14759;

tx_l_term0_bit2_addr=7533;
tx_l_term0_bit1_addr=7534;
tx_l_term0_bit0_addr=7535;
tx_l_term0_en_addr=7399;

rx_l_term1_bit2_addr=14731;
rx_l_term1_bit1_addr=14730;
rx_l_term1_bit0_addr=14729;
rx_l_term1_en_addr=14728;

rx_l_term2_bit2_addr=14727;
rx_l_term2_bit1_addr=14726;
rx_l_term2_bit0_addr=14725;
rx_l_term2_en_addr=14724;

%% 
spi_singlebit(tx_r_term0_bit2_addr,tx_r_term0_bit2_value)
spi_singlebit(tx_r_term0_bit1_addr,tx_r_term0_bit1_value)
spi_singlebit(tx_r_term0_bit0_addr,tx_r_term0_bit0_value)
spi_singlebit(tx_r_term0_en_addr,tx_r_term0_en)

spi_singlebit(rx_r_term1_bit2_addr,rx_r_term1_bit2_value)
spi_singlebit(rx_r_term1_bit1_addr,rx_r_term1_bit1_value)
spi_singlebit(rx_r_term1_bit0_addr,rx_r_term1_bit0_value)
spi_singlebit(rx_r_term1_en_addr,rx_r_term1_en)

spi_singlebit(rx_r_term2_bit2_addr,rx_r_term2_bit2_value)
spi_singlebit(rx_r_term2_bit1_addr,rx_r_term2_bit1_value)
spi_singlebit(rx_r_term2_bit0_addr,rx_r_term2_bit0_value)
spi_singlebit(rx_r_term2_en_addr,rx_r_term2_en)

spi_singlebit(tx_l_term0_bit2_addr,tx_l_term0_bit2_value)
spi_singlebit(tx_l_term0_bit1_addr,tx_l_term0_bit1_value)
spi_singlebit(tx_l_term0_bit0_addr,tx_l_term0_bit0_value)
spi_singlebit(tx_l_term0_en_addr,tx_l_term0_en)

spi_singlebit(rx_l_term1_bit2_addr,rx_l_term1_bit2_value)
spi_singlebit(rx_l_term1_bit1_addr,rx_l_term1_bit1_value)
spi_singlebit(rx_l_term1_bit0_addr,rx_l_term1_bit0_value)
spi_singlebit(rx_l_term1_en_addr,rx_l_term1_en)

spi_singlebit(rx_l_term2_bit2_addr,rx_l_term2_bit2_value)
spi_singlebit(rx_l_term2_bit1_addr,rx_l_term2_bit1_value)
spi_singlebit(rx_l_term2_bit0_addr,rx_l_term2_bit0_value)
spi_singlebit(rx_l_term2_en_addr,rx_l_term2_en)
%%
function []=spi_singlebit(abs_addr_dec,value)
% tx/fb/rx term0 en
addr=dec2hex(floor(abs_addr_dec/32));
addr=strcat('0x',addr);
bit_num=abs_addr_dec-floor(abs_addr_dec/32)*32;

xtemp=spi_read('0x0', addr ); %
xtemp=strcat(xtemp(1,:),xtemp(2,:),xtemp(3,:),xtemp(4,:));
xtemp=hex2dec(xtemp);

xtemp_l=mod(xtemp,2^(bit_num)); % lower num
xtemp_h=floor(xtemp/2^(bit_num+1));% higher num

xtemp=xtemp_h*2^(bit_num+1)+xtemp_l+value*2^(bit_num); % change according bit value

spi_write('0x0', addr ,strcat('0x',dec2hex(xtemp))); %

end