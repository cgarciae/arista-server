part of arista_server.models;

class FileDb
{
  @Field() String fileId;
  @Field() String filename;
  @Field() String contentType;
  @Field() DateTime fileUploadDate;
}