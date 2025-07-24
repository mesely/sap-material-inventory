CLASS zcl_materials DEFINITION
  PUBLIC
  CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_materials.
ENDCLASS.



CLASS ZCL_MATERIALS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MATERIALS->ZIF_MATERIALS~ADD_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [--->] IV_MATERIAL_NAME               TYPE        ZTMATERIAL_NAME
* | [--->] IV_MATERIAL_TYPE               TYPE        ZTMATERIAL_TYPE
* | [--->] IV_MATERIAL_GROUP              TYPE        ZTMATERIAL_GROUP
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_materials~add_material.
    DATA wa_material TYPE zmaterials.

    wa_material-material_id    = iv_material_id.
    wa_material-material_name  = iv_material_name.
    wa_material-material_type  = iv_material_type.
    wa_material-material_group = iv_material_group.

    INSERT zmaterials FROM wa_material.
    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MATERIALS->ZIF_MATERIALS~DELETE_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_materials~delete_material.
    DELETE FROM zmaterials
      WHERE material_id = @iv_material_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MATERIALS->ZIF_MATERIALS~GET_ALL_MATERIALS
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_MATERIALS                   TYPE        TY_T_MATERIAL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_materials~get_all_materials.
    SELECT * FROM zmaterials INTO TABLE @rt_materials.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MATERIALS->ZIF_MATERIALS~GET_MATERIAL_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [<-()] RS_MATERIAL                    TYPE        TY_MATERIAL_RECORD
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_materials~get_material_by_id.
    SELECT SINGLE *
      FROM zmaterials
      INTO @rs_material
      WHERE material_id = @iv_material_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MATERIALS->ZIF_MATERIALS~UPDATE_MATERIAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MATERIAL_ID                 TYPE        ZTMATERIAL_ID
* | [--->] IV_MATERIAL_NAME               TYPE        ZTMATERIAL_NAME
* | [--->] IV_MATERIAL_TYPE               TYPE        ZTMATERIAL_TYPE
* | [--->] IV_MATERIAL_GROUP              TYPE        ZTMATERIAL_GROUP
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_materials~update_material.
    UPDATE zmaterials
      SET material_name  = @iv_material_name,
          material_type  = @iv_material_type,
          material_group = @iv_material_group
      WHERE material_id = @iv_material_id.

    rv_success = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.
ENDCLASS.
