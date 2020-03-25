# 首先是几个包的载入
library(ballgown)
library(genefilter)
library(dplyr)
library(devtools)
# 随后是数据的读入.
group_data <- read.csv("group_Y3M.csv")
# dataDir指的是数据储存的地方，samplePattern则依据样本的名字来，pheno_data则指明了样本数据的关系，这个里面第一列样本名需要和ballgown下面的文件夹的样本名一样，不然>会报错
bg=ballgown(dataDir = "ballgown_Y3M",samplePattern = "Ara_", pData = group_data)
# 这里滤掉了样本间差异少于一个转录本的数据
#bg_filt=subset(bg,"rowVars(texpr(bg))>1",genomesubset=TRUE)
#feature指定分析参数为"transcripts"，主变量为"sex"，修正变量为"population"，getFC可以指定输出结果显示组间表达量的foldchange。
#确认组间有差异的转录本
exon_transcript_table = indexes(bg)$e2t
transcript_gene_table = indexes(bg)$t2g
transcript_fpkm=texpr(bg, 'FPKM')
whole_tx_table=texpr(bg, 'all')
gene_expression=gexpr(bg)
write.csv(transcript_fpkm, "RNAseq_Y3M_transcript_fpkm.csv",row.names=TRUE)
write.csv(whole_tx_table, "RNAseq_Y3M_whole_tx_table.csv",row.names=TRUE)
write.csv(gene_expression, "RNAseq_Y3M_gene_expression.csv",row.names=TRUE)
result_transcripts=stattest(bg,feature = "transcript",covariate = "type",getFC=TRUE,meas="FPKM")
#确认组间有差异的基因
result_genes=stattest(bg,feature = "gene",covariate = "type",getFC=TRUE,meas="FPKM")
indices <- match(result_genes$id, texpr(bg, 'all')$gene_id)
gene_names_for_result <- texpr(bg, 'all')$gene_name[indices]
result_genes <- data.frame(geneNames=gene_names_for_result, result_genes)
#把结果写入csv文件
write.csv(result_transcripts, "RNAseq_Y3M_transcript_results.csv",row.names=FALSE)
write.csv(result_genes, "RNAseq_Y3M_gene_results.csv",row.names=FALSE)
