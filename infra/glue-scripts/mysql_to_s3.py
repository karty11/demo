import sys
import boto3
import json
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext

# Parse job args
args = getResolvedOptions(sys.argv, [
    'JOB_NAME',
    'connection_name',
    'secret_name',
    'output_path'
])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# --- Fetch DB credentials from Secrets Manager ---
secrets_client = boto3.client("secretsmanager")
secret_value = secrets_client.get_secret_value(SecretId=args['secret_name'])
secret_dict = json.loads(secret_value['SecretString'])
username = secret_dict['username']
password = secret_dict['password']
host     = secret_dict['host']
dbname   = secret_dict['dbname']

jdbc_url = f"jdbc:mysql://{host}:3306/{dbname}"

# --- Read data from MySQL ---
print("Reading data from MySQL...")
df = spark.read.format("jdbc").option("url", jdbc_url) \
    .option("dbtable", "transactions") \
    .option("user", username) \
    .option("password", password) \
    .option("driver", "com.mysql.cj.jdbc.Driver") \
    .load()

print(f"Row count: {df.count()}")

# --- Write data to S3 as Parquet ---
print(f"Writing data to {args['output_path']} ...")
df.write.mode("overwrite").parquet(args['output_path'])

print("Export complete.")

job.commit()
