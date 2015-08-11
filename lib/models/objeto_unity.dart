part of arista_server.models;

class ObjetoUnitySchema {
  @Field() String objetoUnityId;
  @Field() String nombre;
  @Field() String descripcion;
  @Field() bool public;
  @Field() List<TagSchema> tags;

  @Field() String ownerId;
  @Field() String userFileId;
  @Field() int version;

  @Field() String screenshotId;
  @Field() bool updatePending;

  @Field() String androidId;
  @Field() String iosId;
  @Field() String windowsId;
  @Field() String osxId;
}

class ObjetoUnity extends ObjetoUnitySchema {
  @Field() final String nameGameObject = "aristaGameObject";

  @Field() User owner;
  @Field() FileSchema userFile;

  @Field() bool get active => notNullOrEmpty (androidId) && notNullOrEmpty (iosId);
  @Field() bool get activeAll => notNullOrEmpty (androidId) && notNullOrEmpty (iosId) && notNullOrEmpty (windowsId) && notNullOrEmpty (osxId);

  @Field() FileSchema screenshot;
  @Field() FileSchema android;
  @Field() FileSchema ios;
  @Field() FileSchema windows;
  @Field() FileSchema osx;
}