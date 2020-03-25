#!/bin/bash
#组装转录本并定量表达基因
#for i in `ls *.sorted.bam`
#	do
#	i=${i%.sorted.bam}
#	stringtie -p 16 -G /home/l/backup1/refgenome/Arabidopsis/Arabidopsis_thaliana.TAIR10.41.gtf -o FPKM/$i.output.gtf ${i}.sorted.bam
#	stringtie -e -B -p 16 -G /home/l/backup1/refgenome/Arabidopsis/Arabidopsis_thaliana.TAIR10.41.gtf -o FPKM2/ballgown/$i/$i.output.gtf ${i}.sorted.bam
#	done
#echo `ls FPKM/*.gtf` > FPKM/stringtie.mergelist.txt
#cd FPKM
#sed -i 's/ /\n/g' stringtie.mergelist.txt
#cd ..
#将所有转录本合并
stringtie --merge -p 16 -G /home/l/backup1/refgenome/Arabidopsis/Arabidopsis_thaliana.TAIR10.41.gtf -o FPKM/stringtie_merged.gtf FPKM/stringtie.mergelist.txt
#重新组装转录本并估算基因表达丰度，并为ballgown创建读入文件
for i in `ls *.sorted.bam`
        do
        i=${i%.sorted.bam}
        stringtie -e -B -p 16 -G FPKM/stringtie_merged.gtf -o FPKM/ballgown/$i/$i.output.gtf ${i}.sorted.bam
        done


