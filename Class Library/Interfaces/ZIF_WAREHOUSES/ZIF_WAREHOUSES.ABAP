INTERFACE zif_warehouses PUBLIC.

  " -- Type Definitions --
  TYPES: BEGIN OF ty_warehouse_record,
           warehouse_id   TYPE ztwarehouse_id,     " CHAR 3
           warehouse_name TYPE ztwarehouse_name,   " CHAR 100
         END OF ty_warehouse_record.

  TYPES: ty_t_warehouse TYPE STANDARD TABLE OF ty_warehouse_record WITH EMPTY KEY.

  " -- Add a new warehouse --
  METHODS add_warehouse
    IMPORTING
      iv_warehouse_id   TYPE ztwarehouse_id
      iv_warehouse_name TYPE ztwarehouse_name
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Update warehouse name --
  METHODS update_warehouse
    IMPORTING
      iv_warehouse_id   TYPE ztwarehouse_id
      iv_warehouse_name TYPE ztwarehouse_name
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Delete warehouse by ID --
  METHODS delete_warehouse
    IMPORTING
      iv_warehouse_id TYPE ztwarehouse_id
    RETURNING VALUE(rv_success) TYPE abap_bool.

  " -- Get warehouse by ID --
  METHODS get_warehouse_by_id
    IMPORTING
      iv_warehouse_id TYPE ztwarehouse_id
    RETURNING VALUE(rs_warehouse) TYPE ty_warehouse_record.

  " -- Get all warehouses --
  METHODS get_all_warehouses
    RETURNING VALUE(rt_warehouses) TYPE ty_t_warehouse.

ENDINTERFACE.
