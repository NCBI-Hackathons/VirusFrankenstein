#!/bin/bash

#Usage SRA_automatic_run_program.sh  SRR5675890


## Download and uncompress viral genomes, and makeblastdb to create BLAST database.

#wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz

#gzip -d viral.1.1.genomic.fna.gz

#makeblastdb -dbtype nucl -in viral.1.1.genomic.fna -out viralgenomes -parse_seqids

#export BLASTDB=${BLASTDB}:${PWD}

############

## Try VirusFrankenstein with a dataset e.g Zika Virus

## Zika virus dataset:

wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/882/815/GCF_000882815.3_ViralProj36615/GCF_000882815.3_ViralProj36615_genomic.fna.gz
gunzip GCF_000882815.3_ViralProj36615_genomic.fna.gz
makeblastdb -dbtype nucl -in GCF_000882815.3_ViralProj36615_genomic.fna -out zikavirus -parse_seqids
export BLASTDB=${BLASTDB}:${PWD}

## magicBLAST:   

/panfs/pan1.be-md.ncbi.nlm.nih.gov/product_manager_research_projects/Sean/Projects/Sidearm/Software/magicblast/bin/magicblast -db zikavirus -sra SRR5675890 -num_threads 8 -out zikavirus.mbo

############

##Virome Sniff:

#fastqdump:
/panfs/pan1.be-md.ncbi.nlm.nih.gov/product_manager_research_projects/Virus_Detection_SRA/VirusFrankenstein/ncbi/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --outdir ${PWD} --skip-technical  --readids --read-filter pass --dumpbase --split-spot --clip $1

## No need to trim

#trim-galore ( Also, activate cutadapt)
#/panfs/pan1.be-md.ncbi.nlm.nih.gov/product_manager_research_projects/Virus_Detection_SRA/VirusFrankenstein/TrimGalore-0.4.3/trim_galore -q 30 --length 20 $1_pass.fastq
 
#4545352 sequences processed in total
#Sequences removed because they became shorter than the length cutoff of 20 bp:  885509 (19.5%)


#MMseq

#mkdir MMseq_tmp
#mmseqs createdb $1'_pass_trimmed.fq' $1.DNAdb
#mmseqs translatenucs $1.DNAdb $1.PROdb
#mmseqs search  $1.PROdb '/panfs/pan1.be-md.ncbi.nlm.nih.gov/product_manager_research_projects/Virus_Detection_SRA/VirusFrankenstein/'MMSEQ_DB $1.RESULTdb MMseq_tmp
#mmseqs convertalis $1.PROdb '/panfs/pan1.be-md.ncbi.nlm.nih.gov/product_manager_research_projects/Virus_Detection_SRA/VirusFrankenstein/'MMSEQ_DB $1.RESULTdb $1.blastp  



