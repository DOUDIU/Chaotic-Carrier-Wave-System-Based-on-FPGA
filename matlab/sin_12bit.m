% %生成12位单周期正弦波信号,4096个数据
% N = 4096;
% i = 1:1:4096;
% y = 2048*(sin(2*pi/4096*i)+1);
% y1 = dec2bin(y,12);
% fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sin.txt','w');              %需要改文件名称的地方
% y2 = zeros(1,N);
% for i=1:1:4096
% %     y2(i)=str2num(y1(i));
%     fprintf(fid,'%s\n',y1(i));          %data：需要导出的数据名称，10位有效数字，保留3位小数（包含小数点），f为双精度，g为科学计数法
% end
% fclose(fid);
clc;
clear;
i=0:2*pi/4095:2*pi;
y=(sin(i)+1)*4095/2;
k=dec2bin(y,12);
fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sin.txt','wt');

for i=1:4096%1024行
    for j=1:12%11列
        fprintf(fid,'%s',k(i,j));%输出
            if mod(j,12)==0%判断是否输出了11个字符
                fprintf(fid,'\n');%每输出11个字符也就是输出了一行，输出一个回车
            end;
	 end;
end;
fclose(fid);