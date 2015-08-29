 part of arista_server.models;

class FileSchema
{
  @Field() String fileId;
  @Field() String filename;
  @Field() String contentType;
  @Field() DateTime fileUploadDate;
  @Field() String ownerId;
}