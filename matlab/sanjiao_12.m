clc;
clear;
i=-2047:1:2048;
y=4095*tripuls(i,4095);
k=dec2bin(y,12);
fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sanjaio_12.txt','wt');

for i=1:4096%1024��
    for j=1:12%11��
        fprintf(fid,'%s',k(i,j));%���
            if mod(j,12)==0%�ж��Ƿ������11���ַ�
                fprintf(fid,'\n');%ÿ���11���ַ�Ҳ���������һ�У����һ���س�
            end;
	 end;
end;
fclose(fid);