clc;
clear;
i=0:1:4095;
y=i;
k=dec2bin(y,12);
fid=fopen('..\wave_data\Saw_Tooth_12.txt','wt');

for i=1:4096%1024��
    for j=1:12%11��
        fprintf(fid,'%s',k(i,j));%���
            if mod(j,12)==0%�ж��Ƿ������11���ַ�
                fprintf(fid,'\n');%ÿ���11���ַ�Ҳ���������һ�У����һ���س�
            end;
	 end;
end;
fclose(fid);