
# VirusFrankenstein

## Graphical Overview:

![Schematic](VirusFrankenstein_Workflow.png)

## Overview:

A project that will make Virome Sniff read directly from SRA i.e. given an input SRA dataset, Virus Frankenstein will output which viruses are likely to be in the SRA dataset. 
* Virome Sniff searches NGS reads using virus protein database, and finds known viral sequence and protein domains. 
* Sidearm detects viral sequences in SRA datasets using MagicBLAST.

## Usage:

1. Download virus genomes and create BLAST database with makeblastdb. 

* This example uses an RNA-seq dataset (SRR5675890) from a Zika virus outbreak. After cloning this repository, do the following:

```wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/882/815/GCF_000882815.3_ViralProj36615/GCF_000882815.3_ViralProj36615_genomic.fna.gz```

```gunzip GCF_000882815.3_ViralProj36615_genomic.fna.gz```

```makeblastdb -dbtype nucl -in GCF_000882815.3_ViralProj36615_genomic.fna -out zikavirus -parse_seqids```

```export BLASTDB=${BLASTDB}:${PWD}```

2. MagicBLAST extracts the viral sequences, aligns the SRA dataset onto the viral genome blast database, and assembles all the reads.

```magicblast -db zikavirus -sra SRR5675890 -num_threads 8 -out zikavirus.mbo```

*3. Fastq-dump utility will convert SRA data to fastq and fasta format.*

*```fastq-dump --outdir ${PWD} --skip-technical  --readids --read-filter pass --dumpbase --split-spot --clip $1```*

*4. Trim_Galore performs quality and adapter trimming to fastq files. (For trim_galore to work, install cutadapt and FastQC)*

*```trim_galore -q 30 --length 20 $1_pass.fastq```*

5. MMseq (Virome Sniff) matches the input sequences at an amino acid level to a viral protein database, sequences showing no similarity to viral proteins will be filtered out resulting in a reduced set of viral-like sequences.

6.  Spades is used to generate contigs

7.  Contigs are run against protein domains using RPStBLASTn.  















