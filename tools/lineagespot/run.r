if (!require("lineagespot")) devtools::install_github("BiodataAnalysisGroup/lineagespot")
library(lineagespot)

d<-lineagespot(
       vcf_fls = "./sample.freebayes.ann.vcf",
       gff3_path = "./reqfiles/NC_045512.2_annot.gff3",
	   ref_folder = "./reqfiles/referenceLineages/"
     )
names(d)	 
write.table(d$variants.table, "output_variants.tsv", sep = "\t", col.names = TRUE, row.names = F)
write.table(d$lineage.hits, "output_lineagehits.tsv", sep = "\t", col.names = TRUE, row.names = F)
write.table(d$lineage.report, "output_lineagereport.tsv", sep = "\t", col.names = TRUE, row.names = F)
