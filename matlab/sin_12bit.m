% %����12λ���������Ҳ��ź�,4096������
% N = 4096;
% i = 1:1:4096;
% y = 2048*(sin(2*pi/4096*i)+1);
% y1 = dec2bin(y,12);
% fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sin.txt','w');              %��Ҫ���ļ����Ƶĵط�
% y2 = zeros(1,N);
% for i=1:1:4096
% %     y2(i)=str2num(y1(i));
%     fprintf(fid,'%s\n',y1(i));          %data����Ҫ�������������ƣ�10λ��Ч���֣�����3λС��������С���㣩��fΪ˫���ȣ�gΪ��ѧ������
% end
% fclose(fid);
clc;
clear;
i=0:2*pi/4095:2*pi;
y=(sin(i)+1)*4095/2;
k=dec2bin(y,12);
fid=fopen('D:\FPGA\FPGA_program\quartus\DDS\rtl\sin.txt','wt');

for i=1:4096%1024��
    for j=1:12%11��
        fprintf(fid,'%s',k(i,j));%���
            if mod(j,12)==0%�ж��Ƿ������11���ַ�
                fprintf(fid,'\n');%ÿ���11���ַ�Ҳ���������һ�У����һ���س�
            end;
	 end;
end;
fclose(fid);