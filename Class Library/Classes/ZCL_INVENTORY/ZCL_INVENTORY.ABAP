CLASS zcl_inventory DEFINITION
  PUBLIC
  CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_inventory.
ENDCLASS.



CLASS ZCL_INVENTORY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~ADD_INVENTORY_RECORD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INVENTORY_ID                TYPE        ZTENTRY_ID
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [--->] IV_PERSONNEL_ID                TYPE        ZTPERSONNEL_ID
* | [--->] IV_ENTRY_DATE                  TYPE        DATS
* | [--->] IV_QUANTITY                    TYPE        ZTQUANTITY
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~add_inventory_record.
    DATA wa_record TYPE zinventoryrecord.

    wa_record-inventory_id   = iv_inventory_id.
    wa_record-material_id    = iv_material_id.
    wa_record-warehouse_id   = iv_warehouse_id.
    wa_record-personnel_id   = iv_personnel_id.
    wa_record-entry_date     = iv_entry_date.
    wa_record-quantity       = iv_quantity.

    INSERT zinventoryrecord FROM wa_record.
    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~DELETE_INVENTORY_RECORD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INVENTORY_ID                TYPE        ZTENTRY_ID
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~delete_inventory_record.
    DELETE FROM zinventoryrecord
      WHERE inventory_id = @iv_inventory_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~GET_INVENTORY_BY_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [<-()] RT_INVENTORY                   TYPE        TY_T_INVENTORY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~get_inventory_by_material.
    SELECT *
      FROM zinventoryrecord
      INTO TABLE @rt_inventory
      WHERE material_id = @iv_material_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~GET_INVENTORY_BY_USER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERSONNEL_ID                TYPE        ZTPERSONNEL_ID
* | [<-()] RT_INVENTORY                   TYPE        TY_T_INVENTORY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~get_inventory_by_user.
    SELECT *
      FROM zinventoryrecord
      INTO TABLE @rt_inventory
      WHERE personnel_id = @iv_personnel_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~GET_INVENTORY_BY_WAREHOUSE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_WAREHOUSE_ID                TYPE        ZTWAREHOUSE_ID
* | [<-()] RT_INVENTORY                   TYPE        TY_T_INVENTORY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~get_inventory_by_warehouse.
    SELECT *
      FROM zinventoryrecord
      INTO TABLE @rt_inventory
      WHERE warehouse_id = @iv_warehouse_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INVENTORY->ZIF_INVENTORY~UPDATE_INVENTORY_RECORD
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INVENTORY_ID                TYPE        ZTENTRY_ID
* | [--->] IV_QUANTITY                    TYPE        ZTQUANTITY
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_inventory~update_inventory_record.
    UPDATE zinventoryrecord
      SET quantity = @iv_quantity
      WHERE inventory_id = @iv_inventory_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
