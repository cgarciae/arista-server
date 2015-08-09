part of arista_server.models;

class ObjetoUnitySchema {
  @Field() String objetoUnityId;
  @Field() String nombre;
  @Field() String descripcion;
  @Field() bool public;
  @Field() List<String> tags;

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
  @Field() String href;

  @Field() User owner;
  @Field() FileSchema userFile;


  @Field() bool get active => activeAndroid && activeIOS;
  @Field() bool get activeAll => activeAndroid && activeIOS && activeMAC && activeWindows;
  @Field() FileSchema screenshot;

  @Field() FileSchema android;
  @Field() bool get activeAndroid => notNullOrEmpty (androidId);

  @Field() FileSchema ios;
  @Field() bool get activeIOS => notNullOrEmpty (iosId);

  @Field() FileSchema windows;
  @Field() bool get activeWindows => notNullOrEmpty (windowsId);

  @Field() FileSchema osx;
  @Field() bool get activeMAC => notNullOrEmpty (osxId);
}