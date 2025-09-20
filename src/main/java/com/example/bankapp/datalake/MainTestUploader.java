package com.example.bankapp.datalake;


import software.amazon.awssdk.services.s3.S3Client;
import java.util.HashMap;
import java.util.Map;


public class MainTestUploader {
public static void main(String[] args) throws Exception {
String region = System.getenv().getOrDefault("AWS_REGION", "ap-south-1");
String bucket = System.getenv().getOrDefault("DATALAKE_S3_BUCKET", "bankapp-datalake-dev");


DataLakeClient client = new DataLakeClient(region);
S3Uploader uploader = new S3Uploader(client.s3(), bucket);


Map<String,Object> event = new HashMap<>();
event.put("userId", 12345);
event.put("action", "transfer");
event.put("amount", 250.0);


String key = uploader.uploadEvent(event);
System.out.println("Uploaded sample event to s3://" + bucket + "/" + key);
}
}
