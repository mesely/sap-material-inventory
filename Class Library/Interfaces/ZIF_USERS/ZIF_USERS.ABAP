interface ZIF_USERS
  public .


  methods GET_FULL_NAME
    returning
      value(RV_FULL_NAME) type STRING .
  methods GET_DEPARTMENT
    returning
      value(RV_DEPARTMENT) type ZTDEPARTMENT .
  methods GET_PERSONNEL_ID
    returning
      value(RV_ID) type ZTPERSONNEL_ID .
endinterface.
