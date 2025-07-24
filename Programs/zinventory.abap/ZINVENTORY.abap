*&---------------------------------------------------------------------*
*&  Include           ZINVENTORY_PROJ_GLOBALS
*&---------------------------------------------------------------------*

" Tabstrip function codes
*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'STRIPTAB1'
CONSTANTS: BEGIN OF C_STRIPTAB1,
             TAB1 LIKE SY-UCOMM VALUE 'STRIPTAB1_FC1',
             TAB2 LIKE SY-UCOMM VALUE 'STRIPTAB1_FC2',
             TAB3 LIKE SY-UCOMM VALUE 'STRIPTAB1_FC3',
           END OF C_STRIPTAB1.
DATA: gt_materials TYPE TABLE OF zmaterials,
      ls2_mat        TYPE zmaterials.

*&SPWIZARD: DATA FOR TABSTRIP 'STRIPTAB1'
CONTROLS:  STRIPTAB1 TYPE TABSTRIP.
DATA:      BEGIN OF G_STRIPTAB1,
             SUBSCREEN   LIKE SY-DYNNR,
             PROG        LIKE SY-REPID VALUE 'Z_MEHMET_ODEV_DUMENDEN_03',
             PRESSED_TAB LIKE SY-UCOMM VALUE C_STRIPTAB1-TAB1,
           END OF G_STRIPTAB1.

TYPES: BEGIN OF ty_material,
         inventory_id    TYPE ztentry_id,         " NEW!
         material_name   TYPE ztmaterial_name,
         material_type   TYPE ztmaterial_type,
         material_group  TYPE ztmaterial_group,
         warehouse_id    TYPE ztwarehouse_id,
         warehouse_name  TYPE zwarehouses-warehouse_name,
         entry_date      TYPE sy-datum,
       END OF ty_material.

TYPES: BEGIN OF ty_mat_alv,
         inventory_id    TYPE ztentry_id,
         material_name   TYPE ztmaterial_name,
         material_type   TYPE ztmaterial_type,
         material_group  TYPE ztmaterial_group,
         warehouse_id    TYPE ztwarehouse_id,
         warehouse_name  TYPE zwarehouses-warehouse_name,
         entry_date      TYPE sy-datum,
       END OF ty_mat_alv.



" Mail row type definition
TYPES: BEGIN OF ty_mail_row,
         material_id    TYPE ztmaterial_id,
         material_name  TYPE ztmaterial_name,
         material_type  TYPE ztmaterial_type,
         material_group TYPE ztmaterial_group,
         warehouse_id   TYPE ztwarehouse_id,
         quantity       TYPE ztquantity,
         entry_date     TYPE sy-datum,
         entry_time     TYPE sy-uzeit,
         entry_user     TYPE sy-uname,
       END OF ty_mail_row.

" Inventory row type definition
TYPES: BEGIN OF ty_inv_row,
         material_id    TYPE ztmaterial_id,
         material_name  TYPE ztmaterial_name,
         material_type  TYPE ztmaterial_type,
         material_group TYPE ztmaterial_group,
         warehouse_id   TYPE ztwarehouse_id,
         quantity       TYPE ztquantity,
       END OF ty_inv_row.

" Table type definitions
TYPES: ty_t_mail_rows TYPE STANDARD TABLE OF ty_mail_row WITH EMPTY KEY,
       ty_t_inv_rows  TYPE STANDARD TABLE OF ty_inv_row WITH EMPTY KEY.

" Global data declarations
DATA: gt2_materials TYPE STANDARD TABLE OF ty_material WITH DEFAULT KEY,
      ls_mat        TYPE ty_material,
      wa_mat        TYPE zmaterials.

" Dropdown values
DATA: lt_material_values  TYPE vrm_values,
      lt_warehouse_values TYPE vrm_values,
      lt_type_values      TYPE vrm_values,
      lt_group_values     TYPE vrm_values,
      ls_value            TYPE vrm_value.

" Screen input/output fields
DATA: gv_sicil_no TYPE ztpersonnel_id,
      gv_ad       TYPE char100,
      gv_soyad    TYPE char100,
      ok_code     TYPE sy-ucomm.

" User object reference
DATA: lo_user TYPE REF TO zif_users.

" Screen 101 fields
DATA: gv_selected_material  TYPE ztmaterial_id,
      gv_selected_warehouse TYPE ztwarehouse_id,
      gv_quantity           TYPE ztquantity,
      gv_entry_date         TYPE sy-datum.

" Inventory object reference
DATA: go_inventory TYPE REF TO zif_inventory.

" Create inventory object
CREATE OBJECT go_inventory TYPE zcl_inventory.

" ALV grid objects
DATA:
      gs_material  TYPE zmaterials,
      go_grid_102  TYPE REF TO cl_gui_alv_grid,
      go_cont_102  TYPE REF TO cl_gui_custom_container.

" Screen 0103 input fields
DATA: gv_mat_name      TYPE ztmaterial_name,
      gv_mat_type      TYPE ztmaterial_type,
      gv_mat_group     TYPE ztmaterial_group,
      gv_new_type      TYPE ztmaterial_type,
      gv_new_group     TYPE ztmaterial_group,
      gv_show_new_type  TYPE abap_bool VALUE abap_false,
      gv_show_new_group TYPE abap_bool VALUE abap_false,
      gv_next_id       TYPE ztmaterial_id.

" ALV fieldcatalog and layout
DATA: lt_fieldcat TYPE lvc_t_fcat,
      ls_fieldcat TYPE lvc_s_fcat,
      ls_layout   TYPE lvc_s_layo.

" Global tables for batch mail functionality
DATA: gt_mail_rows      TYPE STANDARD TABLE OF ty_mail_row WITH EMPTY KEY,
      gt_pending_adds   TYPE STANDARD TABLE OF ty_mail_row WITH EMPTY KEY,
      gt_pending_updates TYPE STANDARD TABLE OF ty_mail_row WITH EMPTY KEY.

*---------------------------------------------------------------------*
* TYPE-POOLS for mail functionality
*---------------------------------------------------------------------*
TYPE-POOLS: scms.

*--------------------------------------------------------------------*
*  LOCAL CLASS – ALV DATA-CHANGED HANDLER (Screen 102)
*--------------------------------------------------------------------*
CLASS lcl_alv_102_handler DEFINITION.
  PUBLIC SECTION.
    METHODS on_data_changed
      FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_alv_102_handler IMPLEMENTATION.
  METHOD on_data_changed.
    DATA: ls_good  TYPE lvc_s_modi,
          ls_mail  TYPE ty_mail_row,
          lv_index TYPE sy-tabix.

    LOOP AT er_data_changed->mt_good_cells INTO ls_good.
      lv_index = ls_good-row_id.

      " Read the modified row from gt2_materials
      READ TABLE gt2_materials ASSIGNING FIELD-SYMBOL(<fs_mat>) INDEX lv_index.

      IF sy-subrc = 0 AND <fs_mat> IS ASSIGNED.
        ASSIGN COMPONENT ls_good-fieldname OF STRUCTURE <fs_mat>
               TO FIELD-SYMBOL(<fs_val>).
        IF <fs_val> IS ASSIGNED.
          <fs_val> = ls_good-value.
        ENDIF.

        " Prepare row for mail update
        CLEAR ls_mail.
        MOVE-CORRESPONDING <fs_mat> TO ls_mail.
        ls_mail-entry_date = sy-datum.
        ls_mail-entry_time = sy-uzeit.
        ls_mail-entry_user = sy-uname.

        DELETE gt_pending_updates WHERE material_id = ls_mail-material_id.
        APPEND ls_mail TO gt_pending_updates.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

*---------------------------------------------------------------------*
* LOCAL HELPER CLASS – LCL_MAIL_HELPER
*---------------------------------------------------------------------*
CLASS lcl_mail_helper DEFINITION.
  PUBLIC SECTION.
    " Public methods
    CLASS-METHODS send_changes_mail
      IMPORTING
        it_rows      TYPE ty_t_mail_rows
        iv_operation TYPE string OPTIONAL.

    CLASS-METHODS get_current_user_email
      RETURNING VALUE(rv_email) TYPE adr6-smtp_addr.

  PRIVATE SECTION.
    CLASS-METHODS build_html_table
      IMPORTING
        iv_operation TYPE string
        it_rows      TYPE ty_t_mail_rows
      RETURNING VALUE(rv_html) TYPE string.
ENDCLASS.

CLASS lcl_mail_helper IMPLEMENTATION.

  METHOD build_html_table.
    rv_html =
      '<html><head><style>' &&
      'table{border-collapse:collapse;width:100%;font-family:Arial,sans-serif;}' &&
      'th,td{border:1px solid #ddd;padding:8px;text-align:left;}' &&
      'th{background-color:#4CAF50;color:white;}' &&
      'tr:nth-child(even){background-color:#f2f2f2;}' &&
      'h3{color:#333;}' &&
      '</style></head><body>' &&
      |<h3>Inventory { iv_operation } Notification</h3>| &&
      |<p>Date: { sy-datum } &nbsp;&nbsp; Time: { sy-uzeit }</p>| &&
      |<p>User: { sy-uname }</p>| &&
      '<table><tr>' &&
      '<th>ID</th><th>Name</th><th>Type</th><th>Group</th>' &&
      '<th>Warehouse</th><th>Qty</th></tr>'.

    LOOP AT it_rows INTO DATA(ls_row).
      rv_html = rv_html &&
        |<tr><td>{ ls_row-material_id }</td>| &&
        |<td>{ ls_row-material_name }</td>| &&
        |<td>{ ls_row-material_type }</td>| &&
        |<td>{ ls_row-material_group }</td>| &&
        |<td>{ ls_row-warehouse_id }</td>| &&
        |<td align="right">{ ls_row-quantity }</td></tr>|.
    ENDLOOP.

    rv_html = rv_html &&
      '</table>' &&
      '<br><p><i>This is an automated notification from SAP Inventory System.</i></p>' &&
      '</body></html>'.
  ENDMETHOD.

  METHOD get_current_user_email.
    rv_email = 'sap@bmc.com.tr'.
  ENDMETHOD.

  METHOD send_changes_mail.
    " Exit if nothing to send
    IF it_rows IS INITIAL.
      RETURN.
    ENDIF.

    " Build HTML body as a single string
    DATA lv_html TYPE string.
    lv_html = build_html_table(
                iv_operation = iv_operation
                it_rows      = it_rows ).

    " Convert string # SOLI_TAB (255-char lines)
    DATA lt_html_tab TYPE soli_tab.
    lt_html_tab = cl_document_bcs=>string_to_soli( ip_string = lv_html ).

    " Mail subject (SO_OBJ_DES = c(50))
    DATA lv_subject TYPE so_obj_des.
    lv_subject = |Inventory { iv_operation } - { sy-datum } { sy-uzeit }|.

    " Send with BCS
    DATA: lo_bcs TYPE REF TO cl_bcs,
          lo_doc TYPE REF TO cl_document_bcs,
          lx_bcs TYPE REF TO cx_bcs.

    TRY.
        " Create persistent send request
        lo_bcs = cl_bcs=>create_persistent( ).

        " Create document (HTML)
        lo_doc = cl_document_bcs=>create_document(
                   i_type    = 'HTM'
                   i_text    = lt_html_tab
                   i_subject = lv_subject ).
        lo_bcs->set_document( lo_doc ).

        " Sender
        lo_bcs->set_sender(
          cl_cam_address_bcs=>create_internet_address( get_current_user_email( ) ) ).

        " Recipient(s)
        lo_bcs->add_recipient(
          cl_cam_address_bcs=>create_internet_address(
            'MEHMETSELMAN.YILMAZ@stajyer.bmc.com.tr' ) ).

        " Send and commit
        lo_bcs->send( i_with_error_screen = abap_false ).
        COMMIT WORK.

        MESSAGE 'Mail sent successfully' TYPE 'S'.

      CATCH cx_bcs INTO lx_bcs.
        MESSAGE lx_bcs->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& FORMS for Mail Processing
*&---------------------------------------------------------------------*

" Store successful additions for later batch mail sending
FORM store_for_mail
  USING p_success TYPE abap_bool.

  DATA ls_mail TYPE ty_mail_row.

  IF p_success = abap_true.
    CLEAR ls_mail.

    ls_mail-material_id    = gv_selected_material.
    ls_mail-warehouse_id   = gv_selected_warehouse.
    ls_mail-quantity       = gv_quantity.
    ls_mail-entry_date     = sy-datum.
    ls_mail-entry_time     = sy-uzeit.
    ls_mail-entry_user     = sy-uname.

    SELECT SINGLE material_name, material_type, material_group
      FROM zmaterials
      INTO CORRESPONDING FIELDS OF @ls_mail
      WHERE material_id = @gv_selected_material.

    APPEND ls_mail TO gt_pending_adds.

    MESSAGE i001(z01)
      WITH 'Record added to pending mail list.'
           'Use SUBMIT button to send notifications.'.
  ENDIF.
ENDFORM.

" Handle FC_SUBMIT - Send batch mail for all pending additions
FORM handle_fc_submit_mail_101.
  DATA: lv_count TYPE i.

  " Check if there are pending additions
  lv_count = lines( gt_pending_adds ).

  IF lv_count > 0.
    " Copy pending additions to mail table
    gt_mail_rows = gt_pending_adds.

    " Send batch mail
    lcl_mail_helper=>send_changes_mail(
      EXPORTING
        it_rows      = gt_mail_rows
        iv_operation = 'Batch Addition' ).

    " Clear pending additions after successful mail
    CLEAR: gt_pending_adds, gt_mail_rows.

    " Success message
    MESSAGE s001(z01) WITH 'Batch mail sent for' lv_count 'new additions.'.
  ELSE.
    MESSAGE i001(z01) WITH 'No pending additions to send via mail'.

  ENDIF.
ENDFORM.

" Handle FC_SUBMIT - Send batch mail for all pending updates (Screen 102)
FORM handle_fc_submit_mail_102.
  DATA: lv_count TYPE i.

  " Check if there are pending updates
  lv_count = lines( gt_pending_updates ).

  IF lv_count > 0.
    " Copy pending updates to mail table
    gt_mail_rows = gt_pending_updates.

    " Send batch mail
    lcl_mail_helper=>send_changes_mail(
      EXPORTING
        it_rows      = gt_mail_rows
        iv_operation = 'Batch Update' ).

    " Clear pending updates after successful mail
    CLEAR: gt_pending_updates, gt_mail_rows.

    " Success message
    MESSAGE s001(z01) WITH 'Batch mail sent for' lv_count 'updated records.'.
  ELSE.
    " No pending records
    MESSAGE i001(z01) WITH 'No pending updates to send via mail.'.
  ENDIF.
ENDFORM.

" Display pending additions count (for screen display)
FORM display_additions_count.
  DATA: lv_count TYPE i,
        lv_text  TYPE string.

  lv_count = lines( gt_pending_adds ).

  IF lv_count > 0.
    lv_text = |Pending mail notifications: { lv_count } records|.
    " You can display this text on screen 101 somewhere
  ENDIF.
ENDFORM.

" Control mail buttons visibility
FORM control_mail_buttons.
  " Screen 101
  IF sy-dynnr = '0101'.
    IF lines( gt_pending_adds ) > 0.
      " Enable SUBMIT button
      LOOP AT SCREEN.
        IF screen-name = 'FC_SUBMIT'.
          screen-active = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ELSE.
      " Disable SUBMIT button
      LOOP AT SCREEN.
        IF screen-name = 'FC_SUBMIT'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

  " Screen 102
  IF sy-dynnr = '0102'.
    IF lines( gt_pending_updates ) > 0.
      " Enable SUBMIT button
      LOOP AT SCREEN.
        IF screen-name = 'FC_SUBMIT'.
          screen-active = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.
