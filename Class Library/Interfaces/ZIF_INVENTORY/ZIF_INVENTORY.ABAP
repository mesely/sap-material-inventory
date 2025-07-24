INTERFACE zif_inventory PUBLIC.

  " -- Type Definitions --
  TYPES: BEGIN OF ty_inventory_record,
           inventory_id   TYPE ztentry_id,
           material_id    TYPE ztmaterial_id,
           warehouse_id   TYPE ztwarehouse_id,
           personnel_id   TYPE ztpersonnel_id,
           entry_date     TYPE dats,
           quantity       TYPE ztquantity,
         END OF ty_inventory_record.

  TYPES: ty_t_inventory TYPE STANDARD TABLE OF ty_inventory_record WITH EMPTY KEY.

  " -- Add inventory record --
  METHODS add_inventory_record
    IMPORTING
      iv_inventory_id TYPE ztentry_id
      iv_material_id  TYPE ztmaterial_id
      iv_warehouse_id TYPE ztwarehouse_id
      iv_personnel_id TYPE ztpersonnel_id
      iv_entry_date   TYPE dats
      iv_quantity     TYPE ztquantity
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Update quantity --
  METHODS update_inventory_record
    IMPORTING
      iv_inventory_id TYPE ztentry_id
      iv_quantity     TYPE ztquantity
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Delete inventory record --
  METHODS delete_inventory_record
    IMPORTING
      iv_inventory_id TYPE ztentry_id
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Get inventory by personnel ID --
  METHODS get_inventory_by_user
    IMPORTING
      iv_personnel_id TYPE ztpersonnel_id
    RETURNING
      VALUE(rt_inventory) TYPE ty_t_inventory.

  " -- Get inventory by material ID --
  METHODS get_inventory_by_material
    IMPORTING
      iv_material_id TYPE ztmaterial_id
    RETURNING
      VALUE(rt_inventory) TYPE ty_t_inventory.

  " -- Get inventory by warehouse ID --
  METHODS get_inventory_by_warehouse
    IMPORTING
      iv_warehouse_id TYPE ztwarehouse_id
    RETURNING
      VALUE(rt_inventory) TYPE ty_t_inventory.

ENDINTERFACE.
