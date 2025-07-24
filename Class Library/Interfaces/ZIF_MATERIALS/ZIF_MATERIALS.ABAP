INTERFACE zif_materials PUBLIC.

  " -- Type Definitions --
  TYPES: BEGIN OF ty_material_record,
           material_id    TYPE ztmaterial_id,     " NUMC 6
           material_name  TYPE ztmaterial_name,   " CHAR 100
           material_type  TYPE ztmaterial_type,   " CHAR 30
           material_group TYPE ztmaterial_group,  " CHAR 30
         END OF ty_material_record.

  TYPES: ty_t_material TYPE STANDARD TABLE OF ty_material_record WITH EMPTY KEY.

  " -- Add a new material --
  METHODS add_material
    IMPORTING
      iv_material_id    TYPE ztmaterial_id
      iv_material_name  TYPE ztmaterial_name
      iv_material_type  TYPE ztmaterial_type
      iv_material_group TYPE ztmaterial_group
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Update material (by ID) --
  METHODS update_material
    IMPORTING
      iv_material_id    TYPE ztmaterial_id
      iv_material_name  TYPE ztmaterial_name
      iv_material_type  TYPE ztmaterial_type
      iv_material_group TYPE ztmaterial_group
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Delete material by ID --
  METHODS delete_material
    IMPORTING
      iv_material_id TYPE ztmaterial_id
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Get material by ID --
  METHODS get_material_by_id
    IMPORTING
      iv_material_id TYPE ztmaterial_id
    RETURNING VALUE(rs_material) TYPE ty_material_record.

  " -- Get all materials --
  METHODS get_all_materials
    RETURNING VALUE(rt_materials) TYPE ty_t_material.

ENDINTERFACE.
