process fastqc {
    tag "${fastq_files}"
    
    input:
        path fastq_files
    output:
        path "${task.process}/"
    
    """
    mkdir -p ${task.process}
    for fq in ${fastq_files}; do
        base=\$(basename \$fq)
        base_noext=\${base%%.*}
        fastqc -t 4 -o ${task.process} --outprefix \${base_noext}_${task.process} \$fq
    done
    """
}
