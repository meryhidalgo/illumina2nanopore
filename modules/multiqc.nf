process multiqc {
    publishDir "${params.output_dir}/multiqc", mode: "copy"

    input:
        path logs
        path multiqc_custom_config

    output:
        path "multiqc_report.html"

    """
    multiqc ${logs} --config $multiqc_custom_config .
    """
}
