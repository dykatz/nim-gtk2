# Included by headers/glib2.nim; do not import directly.
proc G_OBJECT*(anObject: pointer): PGObject =
  result = cast[PGObject](G_TYPE_CHECK_INSTANCE_CAST(anObject, G_TYPE_OBJECT))

proc G_OBJECT_CLASS*(class: pointer): PGObjectClass =
  result = cast[PGObjectClass](G_TYPE_CHECK_CLASS_CAST(class, G_TYPE_OBJECT))

proc G_IS_OBJECT*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, G_TYPE_OBJECT)

proc G_IS_OBJECT_CLASS*(class: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(class, G_TYPE_OBJECT)

proc G_OBJECT_GET_CLASS*(anObject: pointer): PGObjectClass =
  result = cast[PGObjectClass](G_TYPE_INSTANCE_GET_CLASS(anObject, G_TYPE_OBJECT))

proc G_OBJECT_TYPE*(anObject: pointer): GType =
  result = G_TYPE_FROM_INSTANCE(anObject)

proc G_OBJECT_TYPE_NAME*(anObject: pointer): cstring =
  result = g_type_name(G_OBJECT_TYPE(anObject))

proc G_OBJECT_CLASS_TYPE*(class: pointer): GType =
  result = G_TYPE_FROM_CLASS(class)

proc G_OBJECT_CLASS_NAME*(class: pointer): cstring =
  result = g_type_name(G_OBJECT_CLASS_TYPE(class))

proc G_VALUE_HOLDS_OBJECT*(value: pointer): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_OBJECT)

proc G_OBJECT_WARN_INVALID_PROPERTY_ID*(anObject: gpointer, property_id: gint,
                                        pspec: gpointer) =
  G_OBJECT_WARN_INVALID_PSPEC(anObject, "property", property_id, pspec)

proc G_OBJECT_WARN_INVALID_PSPEC*(anObject: gpointer, pname: cstring,
                                  property_id: gint, pspec: gpointer) =
  var
    theObject: PGObject
    pspec2: PGParamSpec
    property_id: guint
  theObject = cast[PGObject](anObject)
  pspec2 = cast[PGParamSpec](pspec)
  property_id = (property_id)
  write(stdout, "invalid thingy\x0A")
  #g_warning("%s: invalid %s id %u for \"%s\" of type `%s\' in `%s\'", "", pname,
  #          `property_id`, `pspec` . name,
  #          g_type_name(G_PARAM_SPEC_TYPE(`pspec`)),
  #          G_OBJECT_TYPE_NAME(theobject))

proc G_TYPE_TYPE_PLUGIN*(): GType =
  result = g_type_plugin_get_type()

