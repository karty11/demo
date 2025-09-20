package com.example.bankapp.datalake;


import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import com.fasterxml.jackson.databind.ObjectMapper;


import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.ZoneOffset;
import java.util.Map;


public class S3Uploader {
private final S3Client s3;
private final String bucket;
private final ObjectMapper mapper = new ObjectMapper();


public S3Uploader(S3Client s3, String bucket) {
this.s3 = s3;
this.bucket = bucket;
}


public String uploadEvent(Map<String, Object> event) throws Exception {
String now = Instant.now().toString();
event.putIfAbsent("ingested_at", now);


Instant ts = Instant.parse((String) event.get("ingested_at"));
int year = ts.atZone(ZoneOffset.UTC).getYear();
int month = ts.atZone(ZoneOffset.UTC).getMonthValue();
int day = ts.atZone(ZoneOffset.UTC).getDayOfMonth();


String key = String.format("events/year=%04d/month=%02d/day=%02d/%s.json",
year, month, day, java.util.UUID.randomUUID().toString());


String json = mapper.writeValueAsString(event);
PutObjectRequest req = PutObjectRequest.builder()
.bucket(bucket)
.key(key)
.contentType("application/json")
.build();


s3.putObject(req, RequestBody.fromBytes(json.getBytes(StandardCharsets.UTF_8)));
return key; // return the object key for logging/tests
}
}
