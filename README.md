
# VirusFrankenstein

![Schematic](VirusFrankenstein_Workflow.png)

# Overview:

A project that will make Virome Sniff read directly from SRA; i.e. given an input SRA dataset, Virus Frankenstein will output which viruses are likely to be in the SRA dataset. 
* Virome Sniff searches NGS reads using virus protein database, and finds known viral sequence and protein domains. 
* Sidearm detects viral sequences in SRA datasets using MagicBLAST.


# VIROME SNIFF

A NCBI Hackathon Project Generating a Pipeline that searches Next Generation Sequencing reads using virus protein database. 
This tool finds already known viral sequences and viruses-like proteins and discovers sequences that match Viral Protein Domains in any single genome or metagenome sequence pool. Initial development took place at New York Genome Center, June 19-21, 2017.



* [Introduction](#Introduction)

* [Command Line Interface Usage](#Command-Line-Interface-Usage)

* [Workflow schematics](#Workflow-schematics)

* [Sample Input Files](#Sample-Input-Files)
* [Building Database](#Building-Database)
* [Sample Input Files](#Software-Dependencies)
* [Resources and references](#Resources-and-references) 
 


## Background
We aimed to search for viruses in protein, rather than nucleotide space in order to capture and characterize larger number of viruses and detect virus- associated domains in the sample.  
 
Once we have taken in any Illumina base next generation sequencing datasets (and performed adapter trimming), the workflow takes FASTQ data reads  where the input genomic data is matched directly against viral protein database in order to filter out all the other sequences that are not related to viruses. The workflow further takes virus- related sequences and an assembly of those reads is performed. All the contigs that we successfully assembled are further characterized into known virus proteins, homologous virus proteins, and as virus protein domains. Know and homologous virus proteins are quantified and plotted, and taxonomical classification of those sequences is provided. Finally, samples geographical distribution and representation can be plotted on the map. 



## Command Line Interface Usage
```
usage: run_program.sh [-h] -f FASTQ [-r REVERSE FASTQ] -s SAMPLE SHEET -b
                   BARCODES [-e ERROR RATE]

optional arguments:
  -h, --help            show this help message and exit
  -f FASTQ, --Provide single-end, paire-end FASTQ file
  -s SRA, --sample-sheet SAMPLE SHEET
                        Sample table
 
  -e E-value, --provide optiaonal trashold for blast, deafualt values are .....
```

## Workflow schematics 
1. Building viral protein database
1. Trimming sequences for adapter 
2. Detecting NGS sequences for virus using MMseq2 k-mer based algorithm for protein detection
2. Assemble matched reads using Abyss
3. Characterize known sequences and their aboundaces
4. Visuaize viral content, taxonomy and geographical origin 


![alt text](http://i.imgur.com/02j3NGx.jpg)

## Sample Input Files
- FASTQ File: [link](/test.cases/FASTQ_short_example.txt)


## Building Database
This is an optional step. We build a Database containing multiple differetnt viral sequences by combining three databases using MMseq2.

Databases used to create our final database

Viral Zone DB (http://viralzone.expasy.org/)

VPR (https://www.viprbrc.org/brc/home.spg?decorator=vipr)

Viral Genomes (https://www.ncbi.nlm.nih.gov/genome/viruses/)

If a new database compatible with MMseq2 needs to be created the following commnads could be used: 
mmseqs createdb  virus_cluster.fasta MMSEQ_DB
mmseqs createindex MMSEQ_DB


## Software Dependencies

The following software needs to be installed: 

-sratoolkit (https://github.com/ncbi/sra-tools/)

-TrimGalore (https://github.com/FelixKrueger/TrimGalore)

-MMseq2 (https://github.com/soedinglab/MMseqs2)  

-Spades 3.10.1 (http://spades.bioinf.spbau.ru/release3.10.1/manual.html#sec2)


## Resources and references

* [How to use/run a Docker image](https://github.com/NCBI-Hackathons/Cancer_Epitopes_CSHL/blob/master/doc/Docker.md)
>>>>>>> origin/Virus_Domains
=======

[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/NCBI-Hackathons-Virus_Detection_SRA/Lobby)

# SIDEARM - Your weapon for viral discovery in the NCBI SRA database

Sidearm searches the SRA database for viruses using the NCBI magicBLAST tool. It generates a table describing the number of alignments to each virus and various metrics such as the sequence coverage and average depth. The reads aligning to virus are assembled into viral contigs to attempt to generate complete viral genomes.

## Installation

Clone the repository
```
git clone https://github.com/NCBI-Hackathons/Virus_Detection_SRA
```

## Dependencies

Install the following:

+ [magicblast (>= 1.2.0)](https://ftp.ncbi.nlm.nih.gov/blast/executables/magicblast/LATEST)
+ [samtools (>= 1.4)](http://samtools.sourceforge.net/)
+ [bioperl (>= 1.7)](http://search.cpan.org/~cjfields/BioPerl-1.007001/BioPerl.pm)
+ [cutadapt (>=
1.12)](http://cutadapt.readthedocs.io/en/stable/installation.html)
+ [abyss (>= 2.0.2)](https://github.com/bcgsc/abyss)
+ [cwltool (>= 1.0.20170309164828)](https://github.com/common-workflow-language/cwltool)

## Example Workflow

This example uses an RNA-seq dataset (SRR1553459) from an Ebola virus outbreak. After cloning this repository, do the following:

```
cd Virus_Detection_SRA/cwl/tools
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz
gunzip GCF_000848505.1_ViralProj14703_genomic.fna.gz
makeblastdb -dbtype nucl -in GCF_000848505.1_ViralProj14703_genomic.fna -out ebolazaire -parse_seqids
export BLASTDB=$BLASTDB:`pwd`
```

These steps downloaded the Ebola virus genome and uncompressed it. Using the Ebola virus genome, a BLAST database was created with `makeblastdb`. Then your local directory was added to the BLASTDB environmental variable.

```
sidearm.cwl sidearm.SRR1553459.ebola.yml
```

This steps runs Sidearm and generates the following primary output files.

+ SRR1553459.ebolazaire.bam - magicblast alignments to Ebola virus (sorted BAM file)
+ SRR1553459.ebolazaire.bam.summarize.tsv - aggregate information about the alignments to each reference sequence (in this case it is only Ebola virus)
+ SRR1553459.ebolazaire.bam.fa.trim.fa.assembly.fa - the contigs generated by the assembly of all sequences that aligned to the reference sequences.

The log files for the trim and assembly modules are also created

+ SRR1553459.ebolazaire.bam.fa.trim.log - the trim module logfile
+ SRR1553459.ebolazaire.bam.fa.trim.fa.assembly.log - the assembly module logfile

### Expected Results

Open the `summarize.tsv` file in a spreadsheet program. The number of alignments to Ebola virus should be ~15,000 (column 'aligns'), sequence coverage ~98% (column 'seqcov'), and average depth ~75 (column 'avgdepth'). The longest contig is ~12,500bp and a [BLASTN search](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) shows that it is Ebola virus.

The avg (average) fields are the average MAPQ (or Score or EditDist) across the alignments for each subject in the BAM file. MAPQ, Score and EditDist are taken from field 5, the AS flag, and the NM flag in the BAM file, respectively.

## Example workflow for all NCBI RefSeq viruses

```bash
cd Virus_Detection_SRA/cwl/tools
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/viral.1.1.genomic.fna.gz
gunzip viral.1.1.genomic.fna.gz
makeblastdb -dbtype nucl -in viral.1.1.genomic.fna -out viral.1.1.genomic -parse_seqids
export BLASTDB=$BLASTDB:`pwd`
```

Edit sidearm.SRR1553459.ebola.yml with the following changes and save it as sidearm.SRR073726.viral11genomic.yml:
+ srr: SRR073726
+ blastdb: viral.1.1.genomic
+ path: viral.1.1.genomic.fna

Then execute Sidearm with the command line below. Depending on your computer, this will take about 1 hour.

```
sidearm.cwl sidearm.SRR073726.viral11genomic.yml
```

### Expected results

Report of alignments (`summarize.tsv`)

| id          | vname    | vlen  | seqcov | avgdepth | aligns | avgMAPQ | avgScore | avgEditDist
| ----------- | ----- | ----- | ---- | ------------- | ------------- | ----- | ---- | ---- |
| NC_032111.1 | BeAn 58058 virus | 163005 | 0.78 | 6.7 | 51,012 | 255 | 22.7 | 0.34 |
| NC_001357.1 | HPV18 | 7857 | 22.2 | 130.7 | 26,067 | 255 | 39.1 | 0.05 |

The longest contig should be ~600bp. However, obtaining this result depends on the software and reference sequences versions that you used. A [BLASTN search](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) with the longest contig sequence should show that it is Human Papillomavirus 18.

## Troubleshooting

+ Please submit an [issue](https://github.com/NCBI-Hackathons/Virus_Detection_SRA/issues) if you run into any problems installing or running this software.

>>>>>>> origin/Virus_Detection_SRA_Master
