#!/bin/bash -e

s3_bucket="kaonashi-aws-sam-deploy-dev"

echo "** Start to deploy and build. **"
mkdir -p deploy
pip3 install -r src/requirements.txt -t deploy
cp -r src/* deploy
cp /usr/lib64/mysql/libmysqlclient.so.18 deploy
cd deploy
zip -r ../kaonashi-function.zip *
cd ..

echo "Upload applicaiton zip and swagger spec to s3 bucket..."
aws s3 cp kaonashi-function.zip s3://${s3_bucket}/ \
  --region us-west-2

aws s3 cp api/swagger.yaml s3://${s3_bucket}/ \
  --region us-west-2

echo "Build kaonashi api..."
aws cloudformation package \
  --template-file aws-sam.yaml \
  --output-template-file aws-sam-deploy.yaml \
  --s3-bucket ${s3_bucket} \
  --region us-west-2 

echo "Deploy kaonashi api..."
aws cloudformation deploy \
  --template-file aws-sam-deploy.yaml \
  --stack-name kaonash-aws-sam-deploy-dev \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ArtifactBucket=${s3_bucket} \
  --region us-west-2 

echo "** All complete! **"
rm -rf deploy