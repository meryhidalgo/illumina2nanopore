# Illumina2Nanopore
A pipeline to demultiplex, map, deduplicate and count target RNA sequences from nanopore sequencing. 

## Authors
- Álvaro Herrero Reiriz
- María Carazo Hidalgo

---

5’_AATGATACGGCGACCACCGAGATCTACACGTTCAG-AGTTCTACAGTCCGACGATC-TARGET-TGGAATTCTCGGGTGCCAAGGAACTCCAGTCAC-i7index-ATCTCGTATGCCGTCTTCTGCTTG_3’


## Input files

* csvs:
    * `barcodes.csv`: contains the barcodes for demultiplexing
        * structure:
            * `Barcode`: barcode sequence
            * `Sequence`: nucleotide sequence of the barcodes found in the reverse reads (5' end)
            * `Sample`: sample name. DO NOT use underscores `_` in the sample name. Use spaces or dashes `-` instead. Use underscores to separate the sample name from the tissue name.
            * `Reverse`: nucleotide sequence of the barcodes found in the forward reads (3' end)
    * `libraries.csv`: contains the *i7* barcodes for demultiplexing by library
        * structure:
            * `Library`: library name. USE A SINGLE WORD. No spaces, dashes or underscores allowed.
            * `Sequence`: i7 forward sequence
            * `Reverse`: i7 reverse sequence
    * `annotations.saf`: tab separated file containing the target sequence locations to be quantified by featureCounts
        * structure:
            * `Chr`: chromosome
            * `Start`: start position
            * `End`: end position
            * `Strand`: strand
            * `Name`: gene name
            * `Length`: length of the gene
         
---

## Workflow overview

The pipeline consists of the following main steps:

   **1. Basecalling (optional)** -> Perform Nanopore basecalling if raw signals are provided (fast5 files).

   **2. Quality control**

      FastQC + MultiQC reports for raw read quality.

   **3. Orientation demultiplexing** -> Reads are split into forward and reverse according to the Nanopore adapter sequence. Merged into forward_R1.fastq.gz and reverse_R2.fastq.gz = final_forward.fastq.gz

   **4. Library demultiplexing**-> Requires libraries.csv. Reads are split by library, according to cDNA primers targeting the gene/region of interest.

   **5. Internal adapter trimming**

   **6. Barcode demultiplexing** -> Reads are split by sample using barcodes.csv. Produces one FASTQ per cDNA primer and per sample.

   **7. UMI extraction** -> Unique Molecular Identifiers (UMIs) are extracted and removed to avoid interference in alignment.

   **8. Alignment** -> Reads are mapped to the reference genome/transcriptome.

   **9. BAM files are indexed**

   **10. UMI processing (optional)** 
   - params.enable_UMI_treatment: Deduplication of UMIs → collapses reads with identical UMI and mapping position.
   - params.enable_UMI_clustering: UMI clustering → groups reads by UMI similarity and mapping position (tolerates sequencing errors).
   - Other parameters: params.UMI_threshold and params.window_size.

   **11. Expression quantification**
   - params.enable_isoform_counting = true → run featureCounts on SAF annotation:

