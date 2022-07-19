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