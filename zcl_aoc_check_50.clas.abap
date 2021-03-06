CLASS zcl_aoc_check_50 DEFINITION
  PUBLIC
  INHERITING FROM zcl_aoc_super
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor.

    METHODS check
        REDEFINITION.
    METHODS get_message_text
        REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_AOC_CHECK_50 IMPLEMENTATION.


  METHOD check.

* abapOpenChecks
* https://github.com/larshp/abapOpenChecks
* MIT License

    DATA: lt_statements TYPE ty_statements,
          lv_category   TYPE seoclassdf-category.

    FIELD-SYMBOLS: <ls_statement> LIKE LINE OF lt_statements.


    IF object_type <> 'CLAS'.
      RETURN.
    ENDIF.

    SELECT SINGLE category FROM seoclassdf
      INTO lv_category
      WHERE clsname = object_name
      AND version = '1'.

    lt_statements = build_statements(
        it_tokens     = it_tokens
        it_statements = it_statements
        it_levels     = it_levels ).

    LOOP AT lt_statements ASSIGNING <ls_statement>.

      IF ( <ls_statement>-str CP 'ASSERT *'
          AND ( <ls_statement>-include CP '*CCAU'
          OR lv_category = seoc_category_test_class ) )
          OR ( <ls_statement>-str CP 'CL_ABAP_UNIT_ASSERT=>ASSERT*'
          AND NOT ( <ls_statement>-include CP '*CCAU'
          OR lv_category = seoc_category_test_class ) ).
        inform( p_sub_obj_type = c_type_include
            p_sub_obj_name = <ls_statement>-include
            p_line         = <ls_statement>-start-row
            p_kind         = mv_errty
            p_test         = myname
            p_code         = '001' ).
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    super->constructor( ).

    description    = 'ASSERT and unit test ASSERT'.         "#EC NOTEXT
    category       = 'ZCL_AOC_CATEGORY'.
    version        = '001'.
    position       = '050'.

    has_attributes = abap_true.
    attributes_ok  = abap_true.

    mv_errty = c_error.

    add_obj_type( 'CLAS' ).

  ENDMETHOD.                    "CONSTRUCTOR


  METHOD get_message_text.

    CLEAR p_text.

    CASE p_code.
      WHEN '001'.
        p_text = 'Use only unit test asserts in unit tests'. "#EC NOTEXT
      WHEN OTHERS.
        ASSERT 0 = 1.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.