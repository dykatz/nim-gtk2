# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TABLE*(): GType =
  result = gtk2.table_get_type()

proc TABLE*(obj: pointer): PTable =
  result = cast[PTable](CHECK_CAST(obj, gtk2.TYPE_TABLE()))

proc TABLE_CLASS*(klass: pointer): PTableClass =
  result = cast[PTableClass](CHECK_CLASS_CAST(klass, gtk2.TYPE_TABLE()))

proc IS_TABLE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, gtk2.TYPE_TABLE())

proc IS_TABLE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, gtk2.TYPE_TABLE())

proc TABLE_GET_CLASS*(obj: pointer): PTableClass =
  result = cast[PTableClass](CHECK_GET_CLASS(obj, gtk2.TYPE_TABLE()))

proc homogeneous*(a: PTable): guint =
  result = (a.Tableflag0 and bm_TGtkTable_homogeneous) shr
      bp_TGtkTable_homogeneous

proc set_homogeneous*(a: PTable, `homogeneous`: guint) =
  a.Tableflag0 = a.Tableflag0 or
      (uint16(`homogeneous` shl bp_TGtkTable_homogeneous) and
      bm_TGtkTable_homogeneous)

proc xexpand*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_xexpand) shr
      bp_TGtkTableChild_xexpand

proc set_xexpand*(a: PTableChild, `xexpand`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`xexpand` shl bp_TGtkTableChild_xexpand) and
      bm_TGtkTableChild_xexpand)

proc yexpand*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_yexpand) shr
      bp_TGtkTableChild_yexpand

proc set_yexpand*(a: PTableChild, `yexpand`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`yexpand` shl bp_TGtkTableChild_yexpand) and
      bm_TGtkTableChild_yexpand)

proc xshrink*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_xshrink) shr
      bp_TGtkTableChild_xshrink

proc set_xshrink*(a: PTableChild, `xshrink`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`xshrink` shl bp_TGtkTableChild_xshrink) and
      bm_TGtkTableChild_xshrink)

proc yshrink*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_yshrink) shr
      bp_TGtkTableChild_yshrink

proc set_yshrink*(a: PTableChild, `yshrink`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`yshrink` shl bp_TGtkTableChild_yshrink) and
      bm_TGtkTableChild_yshrink)

proc xfill*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_xfill) shr
      bp_TGtkTableChild_xfill

proc set_xfill*(a: PTableChild, `xfill`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`xfill` shl bp_TGtkTableChild_xfill) and bm_TGtkTableChild_xfill)

proc yfill*(a: PTableChild): guint =
  result = (a.TableChildflag0 and bm_TGtkTableChild_yfill) shr
      bp_TGtkTableChild_yfill

proc set_yfill*(a: PTableChild, `yfill`: guint) =
  a.TableChildflag0 = a.TableChildflag0 or
      (uint16(`yfill` shl bp_TGtkTableChild_yfill) and bm_TGtkTableChild_yfill)

proc need_expand*(a: PTableRowCol): guint =
  result = (a.flag0 and bm_TGtkTableRowCol_need_expand) shr
      bp_TGtkTableRowCol_need_expand

proc set_need_expand*(a: PTableRowCol, `need_expand`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`need_expand` shl bp_TGtkTableRowCol_need_expand) and
      bm_TGtkTableRowCol_need_expand)

proc need_shrink*(a: PTableRowCol): guint =
  result = (a.flag0 and bm_TGtkTableRowCol_need_shrink) shr
      bp_TGtkTableRowCol_need_shrink

proc set_need_shrink*(a: PTableRowCol, `need_shrink`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`need_shrink` shl bp_TGtkTableRowCol_need_shrink) and
      bm_TGtkTableRowCol_need_shrink)

proc expand*(a: PTableRowCol): guint =
  result = (a.flag0 and bm_TGtkTableRowCol_expand) shr
      bp_TGtkTableRowCol_expand

proc set_expand*(a: PTableRowCol, `expand`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`expand` shl bp_TGtkTableRowCol_expand) and
      bm_TGtkTableRowCol_expand)

proc shrink*(a: PTableRowCol): guint =
  result = (a.flag0 and bm_TGtkTableRowCol_shrink) shr
      bp_TGtkTableRowCol_shrink

proc set_shrink*(a: PTableRowCol, `shrink`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`shrink` shl bp_TGtkTableRowCol_shrink) and
      bm_TGtkTableRowCol_shrink)

proc empty*(a: PTableRowCol): guint =
  result = (a.flag0 and bm_TGtkTableRowCol_empty) shr
      bp_TGtkTableRowCol_empty

proc set_empty*(a: PTableRowCol, `empty`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`empty` shl bp_TGtkTableRowCol_empty) and
      bm_TGtkTableRowCol_empty)

