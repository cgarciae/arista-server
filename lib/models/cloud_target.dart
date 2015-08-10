part of arista_server.models;

class CloudTargetSchema {
  @Field() String cloudTargetId;
  @Field() String imageId;
  @Field() String vuforiaTargetId;
  @Field() String ownerId;
}

class CloudTarget extends CloudTargetSchema {
  @Field() FileSchema image;
  @Field() VuforiaTargetRecord target;
}