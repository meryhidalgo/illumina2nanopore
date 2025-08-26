process BAM_INDEX {
    label 'process_low'
    tag "$bam"

    publishDir "${params.output_dir}/dedup_bams",
        mode: 'copy',
        enabled: params.publish_mapped

    input:
        path bam

    output:
        path "${bam}", emit: indexed_bam
        path "${bam}.bai", emit: bam_index

    when:
        params.publish_mapped == true

    script:
    """
    samtools quickcheck -v $bam || { echo "Invalid BAM: $bam"; exit 1; }
    samtools index $bam
    """
}
