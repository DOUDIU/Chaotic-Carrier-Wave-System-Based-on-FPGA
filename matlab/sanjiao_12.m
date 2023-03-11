clc;
clear;
i=-2047:1:2048;
y=4095*tripuls(i,4095);
k=dec2bin(y,12);
fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sanjaio_12.txt','wt');

for i=1:4096%1024行
    for j=1:12%11列
        fprintf(fid,'%s',k(i,j));%输出
            if mod(j,12)==0%判断是否输出了11个字符
                fprintf(fid,'\n');%每输出11个字符也就是输出了一行，输出一个回车
            end;
	 end;
end;
fclose(fid);