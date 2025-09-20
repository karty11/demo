package com.example.bankapp.datalake;


import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;


public class DataLakeClient {
private final S3Client s3;


public DataLakeClient(String region) {
this.s3 = S3Client.builder()
.region(Region.of(region))
.credentialsProvider(DefaultCredentialsProvider.create())
.build();
}


public S3Client s3() {
return s3;
}
}
