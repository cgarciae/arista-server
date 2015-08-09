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
  @Field() String href;
  @Field() User owner;

  @Field() FileSchema image;

  @Field () bool get active => activeDat == true && activeXml == true;

  @Field() FileSchema dat;
  @Field() bool get activeDat => notNullOrEmpty(datId);

  @Field() FileSchema xml;
  @Field() bool get activeXml => notNullOrEmpty(xmlId);
}