part of arista_server.models;

class LocalTargetSchema {
  @Field() String localTargetId;
  @Field() String nombre;
  @Field() bool public;
  @Field() String ownerId;

  @Field() String imageId;
  @Field() bool updatePending;
  @Field () int version;

  @Field() String datId;
  @Field() String xmlId;
}

class LocalTarget extends LocalTargetSchema {
  @Field() User owner;
  @Field() FileSchema image;
  @Field() FileSchema dat;
  @Field() FileSchema xml;

  @Field () bool get active => notNullOrEmpty(datId) && notNullOrEmpty(xmlId);
}