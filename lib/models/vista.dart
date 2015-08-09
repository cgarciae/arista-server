part of arista_server.models;

class VistaSchema {
  //Info general
  @Field() String ownerId;
  @Field() String vistaId;
  @Field() String type__;
  @Field() String nombre;

  bool get valid => throw new UnimplementedError();
}
class Vista3DSchema extends VistaSchema {
  @Field() String objetoUnityId;
  @Field() String localTargetId;
}

class Vista3D extends Vista3DSchema {
  @Field() User owner;
  @Field() ObjetoUnity objetoUnity;
  @Field() LocalTarget localTarget;
}