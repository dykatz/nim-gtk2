# Included by headers/atk.nim; do not import directly.
type
  TRegistry* = object of TGObject
    factory_type_registry*: PGHashTable
    factory_singleton_cache*: PGHashTable

  PRegistry* = ptr TRegistry
  TRegistryClass* = object of TGObjectClass
  PRegistryClass* = ptr TRegistryClass
