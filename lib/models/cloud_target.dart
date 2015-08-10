part of arista_server.models;

class CloudTargetSchema {
  @Field() String cloudTargetId;
  @Field() String imageFileId;
  @Field() String vuforiaTargetId;
  @Field() String ownerId;
}

class CloudTarget extends CloudTargetSchema {
  @Field() String href;
  @Field() FileSchema image;
  @Field() VuforiaTargetRecord target;
}