# Included by headers/glib2.nim; do not import directly.
proc G_TYPE_PLUGIN*(inst: pointer): PGTypePlugin =
  result = PGTypePlugin(G_TYPE_CHECK_INSTANCE_CAST(inst, G_TYPE_TYPE_PLUGIN()))

