part of arista_server.models;

class VistaSchema {
  //Info general
  @Field() String vistaId;
  @Field() String ownerId;
  @Field() String nombre;
  @Field() String eventoId;
  @Field() int type;

  bool get valid => throw new UnimplementedError();

  //Vista3D
  @Field() String objetoUnityId;
  @Field() String localTargetId;
}

class Vista3D extends VistaSchema {
  @Field() final String type__ = "Arista.Models.Vista3D, Assembly-CSharp";//TODO: FALTA
  @Field() User owner;
  @Field() ObjetoUnity objetoUnity;
  @Field() LocalTarget localTarget;
  @Field() List<ElementoInteractivo> elementosInteractivos;
}

abstract class TiposVista {
  static const int vista3d = 1;
}