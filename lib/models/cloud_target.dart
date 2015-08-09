part of arista_server.models;

class CloudTargetSchema {
  @Field() String cloudTargetId;
  @Field() String imageFileId;
  @Field() String vuforiaTargetId;
}

class CloudTarget extends CloudTargetSchema {
  @Field() String href;
  @Field() FileSchema image;
  @Field() VuforiaTargetRecord target;
}