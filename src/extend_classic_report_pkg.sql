  CREATE OR REPLACE EDITIONABLE PACKAGE "EXTEND_CLASSIC_REPORT"."EXTEND_CLASSIC_REPORT_PKG" 
as


  function render (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result;

end EXTEND_CLASSIC_REPORT_pkg;

/
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "EXTEND_CLASSIC_REPORT"."EXTEND_CLASSIC_REPORT_PKG" as

  function render (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result 
  as
    v_result apex_plugin.t_dynamic_action_render_result;

    v_attr_freeze_type          APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_01%TYPE := p_dynamic_action.attribute_01;
    v_attr_columns_to_freeze    APEX_APPLICATION_PAGE_DA_ACTS.ATTRIBUTE_02%TYPE := p_dynamic_action.attribute_02;

  begin

    if v_attr_columns_to_freeze < 0 then
      APEX_ERROR.ADD_ERROR (
        p_message          => 'Pretius Freeze Report',
        p_additional_info  => 'Number of columns to freeze should be larger than 0',
        p_display_location => apex_error.c_on_error_page
      );
    end if;
    if floor(v_attr_columns_to_freeze) != v_attr_columns_to_freeze then
      APEX_ERROR.ADD_ERROR (
        p_message          => 'Pretius Freeze Report',
        p_additional_info  => 'Number of columns to freeze should be a number without decimal point',
        p_display_location => apex_error.c_on_error_page
      );
    end if;

    apex_javascript.add_library (
      p_name      => 'pretius.FreezeWidget',
      p_directory => p_plugin.file_prefix
    );

    apex_css.add_file (
      p_name => 'pretius.FreezeWidget',
      p_directory => p_plugin.file_prefix
     );

    v_result.ajax_identifier     := wwv_flow_plugin.get_ajax_identifier;
    v_result.attribute_02        := v_attr_columns_to_freeze;
    v_result.attribute_01        := v_attr_freeze_type;
    v_result.javascript_function := '
      function(){
        var debugName = ''# ''+this.action.action;
        $(this.triggeringElement).freezeWidget({           
            plugin          : this
          } );
      }
    ';

    return v_result;
  end;    

end EXTEND_CLASSIC_REPORT_PKG;

/

