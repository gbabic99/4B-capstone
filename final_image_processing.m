function final_image_processing(FREQ1,FREQ2,STEP,Tire_Diam,Number_Steps,DATA_FILE1)
% clear variables;
% close all;
% fclose('all');

%     gen=input('Number of antennas: '); % number of genereators
%     freq_f1=input('Start frequency (in GHz): ');
%     freq_f2=input('Stop frequency (in GHz): ');
%     freq_delta=input('Frequency step (in GHz): ');
%     freq_points=(freq_f2-freq_f1)/freq_delta+1; % number of frequency points
%     step=input('Step size of cross range (in mm): ');
%     cross_ex=input('Extension of cross range (in m): ');

load(DATA_FILE1);
data=DATA_FILE;
gen=size(data,1); % number of genereators
dx = 2*pi*Tire_Diam*STEP/360;
cross_ex=dx*Number_Steps/4000; % Extension of cross range (in m)
EPSILON=1;
%     data_comb=zeros(31,151);
%     for n=1:31
%         load(['Data' num2str(n) '.mat'])
%         data_comb(n,:)=data;
%     end


freq_points=length(freq); % number of frequency points
freq_delta=(FREQ2-FREQ1)/(freq_points-1); % Frequency step (in GHz)

%% The following codes come from Mohammed

tic

freq_q=(FREQ1:freq_delta:FREQ2)'*1e9; % frequency vector
du_x=dx/1000; %step size in m
B=zeros(round(cross_ex/du_x),freq_points); % Zero padding for cross-range

dz = 100*3e8/sqrt(EPSILON)/2/(freq_q(length(freq_q))-freq_q(1)); % range step in cm, c/2B, see sheen's paper
z_start=0; % starting range value in cm
rn=100*3e8/sqrt(EPSILON)/4/(freq_q(2)-freq_q(1)); %Range in cm, c/4/delta_f, see Sheen's paper;
%rn=100;

w=2*pi*freq_q;
k=w/(3e8/sqrt(EPSILON));

s_u=data;
fno=length(data);
s_u=cat(1,B,s_u,B);
[m1 m2]=size(s_u);
parfor f=1:m2
    S_ku(:,f)=fftshift(fft(fftshift(s_u(:,f))));
end

dku_x=2*pi/(m1*du_x);
ku_x=(dku_x)*(-m1/2:m1/2-1);
parfor g=1:m2
    for h=1:m1
        ku(h,g)=4*k(g)^2-ku_x(h)^2;
        %         s_c(h,g)=exp(1i*k(g)*((m1/2)*du_x));
    end
end
ku1=sqrt(ku.*(ku>0));

kk=1;

for x=z_start:dz:rn
    S_0=exp(1i.*ku1*x*10^-2);
    F=S_ku.*(S_0);
    F2=zeros(m1,1);
    sum=zeros(m1,1);
    for p=1:m2
        sum=F(:,p);
        F2(:,1)=sum+F2(:,1);
    end
    F1=fftshift(ifftn(fftshift(F2),[m1 1]));
    F3(:,kk)=F1;
    kk=kk+1;
end


[ss1 ss2]=size(F3);

scale_x=[-fix(m1/2):fix(m1/2)];

F4=F3.*(z_start:dz:rn);

image_of_Tire = figure;
%set(figure,'Visible','off');
set(figure,'Visible','on');
[Zc,Xc] = meshgrid(z_start:dz:rn,scale_x*(du_x*100));
map=20*log10(abs(F4));
map1=map(:,15/dz+1:end);
map_norm=map1-max(map1,[],'all');
surf(Zc(:,15/dz+1:end),Xc(:,15/dz+1:end),map_norm);
xlabel('Width cm');
ylabel('Circumference cm');
%title('reconstructed image');
% pbaspect([10 1 1]);
set(gcf,'color','w');
set(gca,'fontsize', 18, 'FontName', 'Times New Roman');
shading interp;
axis tight;
% xlim([15 50]);
view([0 90]);
pbaspect([(rn-z_start)/(m1*du_x*100) 1 1]);
%colorbar
% % caxis([-30 0])
saveas(gcf,'Final_Image.png');
close (image_of_Tire)

%figure('position', [100, 100, 330*2, 250*2])
%surf(Zc,Xc,20*log10(abs(F3(end:-1:1,:))));
%xlabel('Range (cm)');
%ylabel('Cross Range (cm)');
%title('Reconstructed image');
%set(gcf,'color','w');set(gca,'fontsize', 18, 'FontName', 'Times New Roman');
%shading interp
%pbaspect([(rn-z_start)/(m1*du_x*100) 1 1]);
%S=abs(F3);
%axis tight
%view([0 90]);
% save('data.mat','S','Zc','Xc','du_x','m1','m2');

% save('main_data_range1_box.mat');

%figure('position', [100, 100, 330*3, 250*3])
%surf(abs(F))
%shading interp

%Zm=ones(ss1/2,ss2)*-6.86861700066489e-07 + 7.65000744728896e-07i;
%mod=[F3 ;Zm];
%[Zcc,Xcc] = meshgrid(z_start:dz:rn,((-1*((ss1/2)-1)):m1)*(du_x*100));

%figure('position', [100, 100, 330*2, 250*2])
%surf(Zcc,Xcc,20*log10(abs(mod(end:-1:1,:))));
%xlabel('Range (cm)');
%ylabel('Cross Range (cm)');
%title('Reconstructed image');
%set(gcf,'color','w');set(gca,'fontsize', 18, 'FontName', 'Times New Roman');
%shading interp
%pbaspect([(rn-z_start)/(930*du_x*100) 1 1]);
%S=abs(F3);
%axis tight
%view([0 90]);

%txt1 = {'X'};
%text(0,181.5,txt1, 'FontSize',11,'Color',[1,0,0])
%txt2 = {'X'};
%text(73.4,181.5,txt2, 'FontSize',11,'Color',[1,0,0])
%txt3 = {'X'};
%text(73.4,57,txt3, 'FontSize',11,'Color',[1,0,0])
%txt4 = {'X'};
%text(0,57,txt4, 'FontSize',11,'Color',[1,0,0])

% save('raw_image_two_walls.mat','Zc','Xc','F3')

toc