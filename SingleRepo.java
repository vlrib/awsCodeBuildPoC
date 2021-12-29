public synchronized static SingletonRepo getInstance() {
    if (singletonrepo == null) {
        singletonrepo = new SingletonRepo();

        ac = new BasicAWSCredentials(ACCESS_KEY, SECERET_KEY);

        dynamodb = AmazonDynamoDBClientBuilder
                .standard()
        .withRegion("us-west-2")
        .withCredentials(new AWSStaticCredentialsProvider(ac) )
        .build();
        System.out.println("singleton repo instance created");
    }
    return singletonrepo;
}
