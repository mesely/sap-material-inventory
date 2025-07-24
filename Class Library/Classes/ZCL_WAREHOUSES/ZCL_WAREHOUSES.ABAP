CLASS zcl_warehouses DEFINITION
  PUBLIC
  CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_warehouses.
ENDCLASS.



CLASS ZCL_WAREHOUSES IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_WAREHOUSES->ZIF_WAREHOUSES~ADD_WAREHOUSE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [--->] IV_WAREHOUSE_NAME              TYPE        ZTWAREHOUSE_NAME
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_warehouses~add_warehouse.
    DATA wa_warehouse TYPE zwarehouses.

    wa_warehouse-warehouse_id   = iv_warehouse_id.
    wa_warehouse-warehouse_name = iv_warehouse_name.

    INSERT zwarehouses FROM wa_warehouse.
    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_WAREHOUSES->ZIF_WAREHOUSES~DELETE_WAREHOUSE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_warehouses~delete_warehouse.
    DELETE FROM zwarehouses
      WHERE warehouse_id = @iv_warehouse_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_WAREHOUSES->ZIF_WAREHOUSES~GET_ALL_WAREHOUSES
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_WAREHOUSES                  TYPE        TY_T_WAREHOUSE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_warehouses~get_all_warehouses.
    SELECT * FROM zwarehouses INTO TABLE @rt_warehouses.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_WAREHOUSES->ZIF_WAREHOUSES~GET_WAREHOUSE_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [<-()] RS_WAREHOUSE                   TYPE        TY_WAREHOUSE_RECORD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_warehouses~get_warehouse_by_id.
    SELECT SINGLE *
      FROM zwarehouses
      INTO @rs_warehouse
      WHERE warehouse_id = @iv_warehouse_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_WAREHOUSES->ZIF_WAREHOUSES~UPDATE_WAREHOUSE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [--->] IV_WAREHOUSE_NAME              TYPE        ZTWAREHOUSE_NAME
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_warehouses~update_warehouse.
    UPDATE zwarehouses
      SET warehouse_name = @iv_warehouse_name
      WHERE warehouse_id = @iv_warehouse_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
