CLASS zcl_users DEFINITION
  PUBLIC
  CREATE PUBLIC
  FINAL.
  PUBLIC SECTION.
    INTERFACES: zif_users.

    METHODS:
      constructor
        IMPORTING iv_personnel_id TYPE ztpersonnel_id.

  PRIVATE SECTION.
    DATA: mv_personnel_id TYPE ztpersonnel_id,
          mv_first_name   TYPE ztfirst_name,
          mv_last_name    TYPE ztlast_name,
          mv_department   TYPE ztdepartment.
ENDCLASS.



CLASS ZCL_USERS IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_USERS->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PERSONNEL_ID                TYPE        ZTPERSONNEL_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD constructor.
  SELECT SINGLE first_name last_name department
  INTO (mv_first_name, mv_last_name, mv_department)
  FROM zusers
  WHERE personnel_id = iv_personnel_id.


  IF sy-subrc = 0.
    mv_personnel_id = iv_personnel_id.
  ELSE.
    RAISE EXCEPTION TYPE cx_sy_no_handler.
  ENDIF.
ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_USERS->ZIF_USERS~GET_DEPARTMENT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_DEPARTMENT                  TYPE        ZTDEPARTMENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_users~get_department.
    rv_department = mv_department.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_USERS->ZIF_USERS~GET_FULL_NAME
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_FULL_NAME                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_users~get_full_name.
    CONCATENATE mv_first_name mv_last_name INTO rv_full_name SEPARATED BY space.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_USERS->ZIF_USERS~GET_PERSONNEL_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        ZTPERSONNEL_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD zif_users~get_personnel_id.
    rv_id = mv_personnel_id.
  ENDMETHOD.
ENDCLASS.
