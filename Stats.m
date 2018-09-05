%Stats

Stnd_Dev=std(p2paramlist);
Avg=mean(p2paramlist);

pc_dev=(Avg+Stnd_Dev)./Avg-1;

overall_pc_dev= (Avg+Stnd_Dev)./Avg-1 ;
overall_pc_dev= mean(overall_pc_dev(1:11))*100;




