clc;
clear;
i=0:2*pi/4095:2*pi;
y=(sin(i)+1)*4095/2;
k=dec2bin(y,12);
fid=fopen('..\wave_data\sin_12.txt','wt');

for i=1:4096%1024��
    fprintf(fid,'rom[%4d]   <=      12''b',i-1);%ÿ���11���ַ�Ҳ���������һ�У����һ���س�
    for j=1:12%11��
        fprintf(fid,'%s',k(i,j));%���
            if mod(j,12)==0%�ж��Ƿ������11���ַ�
                fprintf(fid,';\n');%ÿ���11���ַ�Ҳ���������һ�У����һ���س�
            end
    end
end

fclose(fid);