output "bucket_name" {
  value = aws_s3_bucket.datalake.bucket
}

output "s3_arn" {
  value = aws_s3_bucket.datalake.arn
}

output "glue_db" {
  value = length(aws_glue_catalog_database.bankapp_db) > 0 ? aws_glue_catalog_database.bankapp_db[0].name : ""
}

output "glue_job_name" {
  value = aws_glue_job.mysql_to_s3.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.mysql_export_crawler.name
}
