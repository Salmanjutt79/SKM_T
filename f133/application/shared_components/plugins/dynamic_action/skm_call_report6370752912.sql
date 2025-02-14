prompt --application/shared_components/plugins/dynamic_action/skm_call_report6370752912
begin
--   Manifest
--     PLUGIN: SKM.CALL.REPORT6370752912
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>100000
,p_default_application_id=>133
,p_default_id_offset=>0
,p_default_owner=>'HMIS'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(1441938266659197575)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'SKM.CALL.REPORT6370752912'
,p_display_name=>'Call Object(s) - SKM'
,p_category=>'EXECUTE'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('DYNAMIC ACTION','SKM.CALL.REPORT6370752912'),'')
,p_javascript_file_urls=>'#WORKSPACE_FILES#print.min.js'
,p_css_file_urls=>'#WORKSPACE_FILES#print.min.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function F_RENDER(p_dynamic_action in apex_plugin.t_dynamic_action,',
'                  p_plugin         in apex_plugin.t_plugin)',
'  return apex_plugin.t_dynamic_action_render_result as',
'  --- declare local variables',
'  V_RESULT APEX_PLUGIN.T_DYNAMIC_ACTION_RENDER_RESULT;',
'  L_AJAX   VARCHAR2(4000) := APEX_JAVASCRIPT.ADD_VALUE(APEX_PLUGIN.GET_AJAX_IDENTIFIER,',
'                                                       FALSE);',
'',
'BEGIN',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin         => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  apex_javascript.add_library(p_name      => ''apps/js/reportPlugin'',',
'                              p_directory => p_plugin.file_prefix);',
'  V_RESULT.JAVASCRIPT_FUNCTION := '' ',
'  function () {',
'        let callBack = Function('' ||',
'                                  APEX_JAVASCRIPT.ADD_VALUE(P_DYNAMIC_ACTION.ATTRIBUTE_04,',
'                                                            FALSE) || '');',
'        let objList = callBack();',
'        callReport('' || L_AJAX || '', objList);',
'}'';',
'  RETURN V_RESULT;',
'',
'END;',
'',
'FUNCTION F_AJAX1(P_DYNAMIC_ACTION IN APEX_PLUGIN.T_DYNAMIC_ACTION,',
'                 P_PLUGIN         IN APEX_PLUGIN.T_PLUGIN)',
'  RETURN APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT IS',
'  V_RESULT    APEX_PLUGIN.T_DYNAMIC_ACTION_AJAX_RESULT;',
'  L_RESULT    JSON_OBJECT_t;',
'  L_CALL_TYPE VARCHAR2(500) := APEX_APPLICATION.G_X01;',
'BEGIN',
'  IF L_CALL_TYPE = ''1'' THEN',
'    DECLARE',
'      L_OBJECT_CODE VARCHAR2(500) := APEX_APPLICATION.G_X02;',
'      L_METHOD      VARCHAR2(2000) := APEX_APPLICATION.G_X03;',
'      L_COMM_MODE   VARCHAR2(1000);',
'      L_PARAMS_LIST VARCHAR2(4000) := APEX_APPLICATION.G_X04;',
'      L_APPLICATION VARCHAR2(100) := APEX_APPLICATION.G_X05;',
'      L_PAGE        VARCHAR2(100) := APEX_APPLICATION.G_X06;',
'      L_REPORT_URL  VARCHAR2(4000);',
'      L_STOP        CHAR(1);',
'      L_ALERT_TEXT  VARCHAR2(1000);',
'      L_PRINT_TYPE  VARCHAR2(100);',
'      l_auto_action VARCHAR2(100);',
'      L_BASE_URL    VARCHAR2(4000);',
'      L_SRVR_URL    VARCHAR2(1000);',
'      L_OUTPUT      VARCHAR2(4000);',
'    BEGIN',
'      L_PRINT_TYPE := CASE',
'                        WHEN L_METHOD = ''P1'' THEN',
'                         ''PRINTER''',
'                        ELSE',
'                         ''SCREEN''',
'                      END;',
'      his.pkg_report_calling.run_product_new(p_objectcode  => L_OBJECT_CODE,',
'                                             p_commmode    => L_COMM_MODE,',
'                                             p_paramlist   => L_PARAMS_LIST,',
'                                             p_printertype => L_PRINT_TYPE,',
'                                             p_autoaction  => L_AUTO_ACTION,',
'                                             p_as_name     => :GV_CONNECTED_SERVER,',
'                                             p_ws_url      => L_SRVR_URL,',
'                                             p_url         => L_REPORT_URL,',
'                                             p_stop        => L_STOP,',
'                                             p_alerttext   => L_ALERT_TEXT);',
'    ',
'      L_BASE_URL := APEX_PAGE.GET_URL(p_application => L_APPLICATION,',
'                                      p_page        => L_PAGE,',
'                                      p_items       => ''P'' || L_PAGE ||',
'                                                       ''_WS_URL,P'' || L_PAGE || ''_U'' || CASE',
'                                                         WHEN L_ALERT_TEXT IS NOT NULL THEN',
'                                                          '',P'' || L_PAGE || ''_ER''',
'                                                         ELSE',
'                                                          NULL',
'                                                       END,',
'                                      p_values      => L_SRVR_URL || '','' ||',
'                                                       HIS.ENCRYPT_VALUE(L_REPORT_URL) || CASE',
'                                                         WHEN L_ALERT_TEXT IS NOT NULL THEN',
'                                                          '','' || L_ALERT_TEXT',
'                                                         ELSE',
'                                                          NULL',
'                                                       END,',
'                                      p_plain_url   => TRUE);',
'      L_BASE_URL := APEX_UTIL.PREPARE_URL(P_URL       => L_BASE_URL,',
'                                          p_plain_url => TRUE);',
'      ',
'      L_OUTPUT := ''{',
'                  "type": "'' || L_PRINT_TYPE || ''",',
'                  "url": "'' || L_BASE_URL || ''",',
'                  "success": "'' || CASE',
'                    WHEN NVL(L_STOP, ''N'') = ''N'' THEN',
'                     L_ALERT_TEXT',
'                    ELSE',
'                     NULL',
'                  END || ''",',
'                  "error": "'' || CASE',
'                    WHEN NVL(L_STOP, ''N'') = ''Y'' THEN',
'                     L_ALERT_TEXT',
'                    ELSE',
'                     NULL',
'                  END || ''"',
'                }'';',
'      L_RESULT   := JSON_OBJECT_T.parse(L_OUTPUT);',
'      HIS.PKG_JSON_UTIL.RETURN_JSON(L_RESULT);',
'    END;',
'  ELSIF L_CALL_TYPE = ''2'' THEN',
'    DECLARE',
'      L_APPLICATION VARCHAR2(100) := APEX_APPLICATION.G_X02;',
'      L_PAGE        VARCHAR2(100) := APEX_APPLICATION.G_X03;',
'      L_PLIST       VARCHAR2(4000) := APEX_APPLICATION.G_X04;',
'      L_PVAL       VARCHAR2(4000) := APEX_APPLICATION.G_X05;',
'      L_STOP        CHAR(1);',
'      L_ALERT_TEXT  VARCHAR2(1000);',
'      l_auto_action VARCHAR2(100);',
'      L_BASE_URL    VARCHAR2(4000);',
'      L_SRVR_URL    VARCHAR2(1000);',
'      L_OUTPUT      VARCHAR2(4000);',
'      L_PLAIN_URL   BOOLEAN := FALSE;',
'    BEGIN',
'      L_BASE_URL := APEX_PAGE.GET_URL(p_application => L_APPLICATION,',
'                                      p_page        => L_PAGE,',
'                                      p_items       => L_PLIST,',
'                                      p_values      => L_PVAL,--APEX_UTIL.URL_ENCODE(L_PVAL),',
'                                      p_plain_url   => L_PLAIN_URL);',
'      L_BASE_URL := APEX_UTIL.PREPARE_URL(P_URL       => L_BASE_URL,',
'                                          p_plain_url => L_PLAIN_URL);',
'     -- L_BASE_URL := APEX_UTIL.URL_ENCODE(L_BASE_URL);',
'      L_OUTPUT := ''{',
'                  "type": "'' || NULL || ''",',
'                  "url": "'' || L_BASE_URL || ''",',
'                  "success": "'' || CASE',
'                    WHEN NVL(L_STOP, ''N'') = ''N'' THEN',
'                     L_ALERT_TEXT',
'                    ELSE',
'                     NULL',
'                  END || ''",',
'                  "error": "'' || CASE',
'                    WHEN NVL(L_STOP, ''N'') = ''Y'' THEN',
'                     L_ALERT_TEXT',
'                    ELSE',
'                     NULL',
'                  END || ''"',
'                }'';',
'      L_RESULT   := JSON_OBJECT_T.parse(L_OUTPUT);',
'      HIS.PKG_JSON_UTIL.RETURN_JSON(L_RESULT);',
'    END;',
'  END IF;',
'  RETURN V_RESULT;',
'END;',
''))
,p_default_escape_mode=>'HTML'
,p_api_version=>2
,p_render_function=>'F_RENDER'
,p_ajax_function=>'F_AJAX1'
,p_standard_attributes=>'BUTTON'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'2.2'
,p_files_version=>212
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1441938522383197567)
,p_plugin_id=>wwv_flow_imp.id(1441938266659197575)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Call Back Function'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>false
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let objectList = [];',
'',
'// Change start',
'let paramList = {"P_XXXXX": ''XXXXXXXX''};',
'let object = {',
'    "OBJECTCODE": ''S00REP00000'',',
'    "METHOD": ''S0'',//Reference is in Help',
'    "PARAMLIST": paramList',
'};',
'',
'objectList.push(object);',
'',
'// Change End',
'return objectList;'))
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let objectList = [];<br>',
'<br>',
'// Change start<br>',
'let paramList = {<br>',
'      "P_ENDOSCOPIC_NO": ''001200000315'',<br>',
'        };<br>',
'// to open a report',
'let object = {<br>',
'    "OBJECTCODE": ''S22REP00005'',<br>',
'    ''METHOD'': $v("P9987_METHOD"),<br>',
'    "PARAMLIST": paramList<br>',
'};<br>',
'// to navigate to a page',
'let object = {<br>',
'    APP_ID: ''138'',<br>',
'    PAGE_ID: 64,<br>',
'    PARAMLIST: paramList<br>',
'};<br>',
'<br>',
'objectList.push(object);<br>',
'<br>',
'// Change End<br>',
'return objectList;<br>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Methods<br>',
'--------------------<br>',
'S0 - Screen(Default)<br>',
'S1 - Screen(iframe)<br>',
'S2 - Screen(No Print)<br>',
'<br>',
'P0 - Print(Default)<br>',
'P1 - Print(Confidential)<br>',
'P2 - Print(PrintJS)<br>'))
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>100000
,p_default_application_id=>133
,p_default_id_offset=>0
,p_default_owner=>'HMIS'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '66756E6374696F6E20676574506172616D537472696E672865297B6C657420613D22223B72657475726E204F626A6563742E6B6579732865292E666F7245616368282828742C73293D3E7B612B3D733F2226223A22222C612B3D742B223D222B655B745D';
wwv_flow_imp.g_varchar2_table(2) := '7D29292C612E7265706C616365282F202F672C2225323022297D66756E6374696F6E20676574506172616D4E616D65732865297B6C657420613D22223B72657475726E204F626A6563742E6B6579732865292E666F7245616368282828652C74293D3E7B';
wwv_flow_imp.g_varchar2_table(3) := '612B3D743F222C223A22222C612B3D657D29292C617D66756E6374696F6E20676574506172616D56616C7565732865297B6C657420613D22223B72657475726E204F626A6563742E6B6579732865292E666F7245616368282828742C73293D3E7B612B3D';
wwv_flow_imp.g_varchar2_table(4) := '733F222C223A22222C612B3D655B745D7D29292C617D66756E6374696F6E206F70656E4F626A65637428652C61297B77696E646F772E6F70656E28652C225F626C616E6B22297D66756E6374696F6E20676574506167652865297B737769746368286529';
wwv_flow_imp.g_varchar2_table(5) := '7B63617365225330223A63617365225331223A63617365225332223A64656661756C743A72657475726E20323B63617365225030223A63617365225032223A72657475726E20343B63617365225031223A72657475726E7D7D6173796E632066756E6374';
wwv_flow_imp.g_varchar2_table(6) := '696F6E2063616C6C5265706F727428652C61297B612E666F724561636828286173796E6320613D3E7B6C657420742C732C723D612E4D4554484F443F612E4D4554484F443A225330223B696628612E4F424A454354434F4445262621612E4F424A454354';
wwv_flow_imp.g_varchar2_table(7) := '434F44452E696E636C756465732822402229297B6C6574206E3D612E4F424A454354434F44453B733D676574506172616D537472696E6728612E504152414D4C495354292C743D617761697420617065782E7365727665722E706C7567696E28652C7B78';
wwv_flow_imp.g_varchar2_table(8) := '30313A2231222C7830323A6E2C7830333A722C7830343A732C7830353A3230392C7830363A676574506167652872297D2C7B64617461547970653A226A736F6E222C6173796E633A21302C737563636573733A66756E6374696F6E2865297B696628652E';
wwv_flow_imp.g_varchar2_table(9) := '737461747573297B6C657420743D4A534F4E2E706172736528652E64617461292C7B75726C3A732C747970653A722C737563636573733A6E2C6572726F723A637D3D743B633F617065782E6D6573736167652E616C6572742863293A225052494E544552';
wwv_flow_imp.g_varchar2_table(10) := '223D3D3D723F617065782E6D6573736167652E616C65727428225072696E7420726571756573742073656E743A222B6E293A6F70656E4F626A65637428732C61297D656C736520636F6E736F6C652E6C6F6728225265706F7274206C696E6B206973206E';
wwv_flow_imp.g_varchar2_table(11) := '6F742067656E65726174656422297D7D297D656C73657B6C657420732C723B612E4F424A454354434F44452626612E4F424A454354434F44452E696E636C7564657328224022293F28733D65787472616374417070496428612E4F424A454354434F4445';
wwv_flow_imp.g_varchar2_table(12) := '292C723D6578747261637450616765496428612E4F424A454354434F444529293A28733D612E4150505F49442C723D612E504147455F4944292C73262672262628743D617761697420617065782E7365727665722E706C7567696E28652C7B7830313A22';
wwv_flow_imp.g_varchar2_table(13) := '32222C7830323A732C7830333A722C7830343A676574506172616D4E616D657328612E504152414D4C495354292C7830353A676574506172616D56616C75657328612E504152414D4C495354297D2C7B64617461547970653A226A736F6E222C6173796E';
wwv_flow_imp.g_varchar2_table(14) := '633A21302C737563636573733A66756E6374696F6E2865297B696628652E737461747573297B6C657420613D4A534F4E2E706172736528652E64617461292C7B75726C3A742C747970653A732C737563636573733A722C6572726F723A6E7D3D613B6E3F';
wwv_flow_imp.g_varchar2_table(15) := '617065782E6D6573736167652E616C657274286E293A617065782E6E617669676174696F6E2E72656469726563742874297D656C736520636F6E736F6C652E6C6F67282250616765206C696E6B206973206E6F742067656E65726174656422297D7D2929';
wwv_flow_imp.g_varchar2_table(16) := '7D7D29297D';
null;
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>100000
,p_default_application_id=>133
,p_default_id_offset=>0
,p_default_owner=>'HMIS'
);
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(734925554678949411)
,p_plugin_id=>wwv_flow_imp.id(1441938266659197575)
,p_file_name=>'apps/js/reportPlugin.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>100000
,p_default_application_id=>133
,p_default_id_offset=>0
,p_default_owner=>'HMIS'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2F206C657420676574506172616D537472696E67203D2028704C69737429203D3E207B0D0A2F2F202020202020202020202020206C657420737472203D2022223B0D0A2F2F202020202020202020202020204F626A6563742E6B65797328704C697374';
wwv_flow_imp.g_varchar2_table(2) := '292E666F724561636828286B65792C206929203D3E207B20737472202B3D2069203F20222622203A2022223B20737472202B3D206B6579202B20223D22202B20704C6973745B6B65795D207D293B0D0A2F2F202020202020202020202020207265747572';
wwv_flow_imp.g_varchar2_table(3) := '6E207374723B0D0A2F2F2020202020202020207D3B0D0A66756E6374696F6E20676574506172616D537472696E6728704C69737429207B0D0A202020206C657420737472203D2027273B0D0A202020204F626A6563742E6B65797328704C697374292E66';
wwv_flow_imp.g_varchar2_table(4) := '6F724561636828286B65792C206929203D3E207B20737472202B3D2069203F20272627203A2027273B20737472202B3D206B6579202B20223D22202B20704C6973745B6B65795D207D293B0D0A2020202072657475726E207374722E7265706C61636528';
wwv_flow_imp.g_varchar2_table(5) := '2F202F672C2725323027293B0D0A7D0D0A66756E6374696F6E20676574506172616D4E616D657328704C69737429207B0D0A202020206C657420737472203D2027273B0D0A202020204F626A6563742E6B65797328704C697374292E666F724561636828';
wwv_flow_imp.g_varchar2_table(6) := '286B65792C206929203D3E207B20737472202B3D2069203F20272C27203A2027273B20737472202B3D206B6579207D293B0D0A2020202072657475726E207374723B0D0A7D0D0A66756E6374696F6E20676574506172616D56616C75657328704C697374';
wwv_flow_imp.g_varchar2_table(7) := '29207B0D0A202020206C657420737472203D2027273B0D0A202020204F626A6563742E6B65797328704C697374292E666F724561636828286B65792C206929203D3E207B20737472202B3D2069203F20272C27203A2027273B20737472202B3D20704C69';
wwv_flow_imp.g_varchar2_table(8) := '73745B6B65795D207D293B0D0A2020202072657475726E207374723B0D0A7D0D0A66756E6374696F6E206F70656E4F626A6563742875726C2C206F626A44656629207B0D0A202020206A6176617363726970743A2077696E646F772E6F70656E2875726C';
wwv_flow_imp.g_varchar2_table(9) := '2C20225F626C616E6B22293B0D0A7D0D0A66756E6374696F6E2067657450616765286D29207B0D0A202020202F2F205330202D2053637265656E2844656661756C74290D0A202020202F2F205331202D2053637265656E28696672616D65290D0A202020';
wwv_flow_imp.g_varchar2_table(10) := '202F2F205332202D2053637265656E284E6F205072696E74290D0A0D0A202020202F2F205030202D205072696E742844656661756C74290D0A202020202F2F205031202D205072696E7428436F6E666964656E7469616C290D0A202020202F2F20503220';
wwv_flow_imp.g_varchar2_table(11) := '2D205072696E74285072696E744A53290D0A2020202073776974636820286D29207B0D0A20202020202020206361736520275330273A0D0A20202020202020206361736520275331273A0D0A20202020202020206361736520275332273A0D0A20202020';
wwv_flow_imp.g_varchar2_table(12) := '202020202020202072657475726E20323B0D0A20202020202020206361736520275030273A0D0A20202020202020206361736520275032273A0D0A20202020202020202020202072657475726E20343B0D0A20202020202020206361736520275031273A';
wwv_flow_imp.g_varchar2_table(13) := '0D0A20202020202020202020202072657475726E3B0D0A202020202020202064656661756C743A0D0A20202020202020202020202072657475726E20323B0D0A202020207D0D0A7D0D0A6173796E632066756E6374696F6E2063616C6C5265706F727428';
wwv_flow_imp.g_varchar2_table(14) := '616A617850726F2C206F626A4C69737429207B0D0A202020206F626A4C6973742E666F7245616368286173796E632072203D3E207B0D0A20202020202020206C657420702C20705374722C206D203D20722E4D4554484F44203F20722E4D4554484F4420';
wwv_flow_imp.g_varchar2_table(15) := '3A20275330273B0D0A20202020202020202F2F6966206F626A656374636F64652069732070726F76696465640D0A202020202020202069662028722E4F424A454354434F44452026262021722E4F424A454354434F44452E696E636C7564657328274027';
wwv_flow_imp.g_varchar2_table(16) := '2929207B0D0A2020202020202020202020206C6574206F626A436F6465203D20722E4F424A454354434F44453B0D0A20202020202020202020202070537472203D20676574506172616D537472696E6728722E504152414D4C495354293B0D0A20202020';
wwv_flow_imp.g_varchar2_table(17) := '202020202020202070203D20617761697420617065782E7365727665722E706C7567696E28616A617850726F2C207B0D0A202020202020202020202020202020207830313A202731272C0D0A202020202020202020202020202020207830323A206F626A';
wwv_flow_imp.g_varchar2_table(18) := '436F64652C0D0A202020202020202020202020202020207830333A206D2C0D0A202020202020202020202020202020207830343A20705374722C0D0A202020202020202020202020202020207830353A203230392C0D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(19) := '2020207830363A2067657450616765286D290D0A2020202020202020202020207D2C0D0A202020202020202020202020202020207B0D0A202020202020202020202020202020202020202064617461547970653A20226A736F6E222C0D0A202020202020';
wwv_flow_imp.g_varchar2_table(20) := '20202020202020202020202020206173796E633A20747275652C0D0A2020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0D0A0D0A202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(21) := '2020206966202870446174612E73746174757329207B0D0A202020202020202020202020202020202020202020202020202020206C657420646174614F626A203D204A534F4E2E70617273652870446174612E64617461293B0D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(22) := '202020202020202020202020202020202020206C6574207B2075726C2C20747970652C20737563636573732C206572726F72207D203D20646174614F626A3B0D0A2020202020202020202020202020202020202020202020202020202069662028657272';
wwv_flow_imp.g_varchar2_table(23) := '6F72290D0A2020202020202020202020202020202020202020202020202020202020202020617065782E6D6573736167652E616C657274286572726F72293B0D0A20202020202020202020202020202020202020202020202020202020656C7365207B0D';
wwv_flow_imp.g_varchar2_table(24) := '0A202020202020202020202020202020202020202020202020202020202020202074797065203D3D3D20275052494E54455227203F20617065782E6D6573736167652E616C65727428275072696E7420726571756573742073656E743A27202B20737563';
wwv_flow_imp.g_varchar2_table(25) := '6365737329203A206F70656E4F626A6563742875726C2C2072293B0D0A202020202020202020202020202020202020202020202020202020207D0D0A0D0A2020202020202020202020202020202020202020202020207D20656C7365207B0D0A20202020';
wwv_flow_imp.g_varchar2_table(26) := '202020202020202020202020202020202020202020202020636F6E736F6C652E6C6F6728275265706F7274206C696E6B206973206E6F742067656E65726174656427293B0D0A2020202020202020202020202020202020202020202020207D0D0A202020';
wwv_flow_imp.g_varchar2_table(27) := '20202020202020202020202020202020207D0D0A202020202020202020202020202020207D0D0A202020202020202020202020293B0D0A20202020202020207D20656C7365207B0D0A2020202020202020202020206C65742061707049442C2070616765';
wwv_flow_imp.g_varchar2_table(28) := '49443B0D0A20202020202020202020202069662028722E4F424A454354434F444520262620722E4F424A454354434F44452E696E636C75646573282740272929207B0D0A202020202020202020202020202020206170704944203D206578747261637441';
wwv_flow_imp.g_varchar2_table(29) := '7070496428722E4F424A454354434F4445293B0D0A20202020202020202020202020202020706167654944203D206578747261637450616765496428722E4F424A454354434F4445293B0D0A2020202020202020202020207D20656C7365207B0D0A2020';
wwv_flow_imp.g_varchar2_table(30) := '20202020202020202020202020206170704944203D20722E4150505F49443B0D0A20202020202020202020202020202020706167654944203D20722E504147455F49443B0D0A2020202020202020202020207D0D0A202020202020202020202020696620';
wwv_flow_imp.g_varchar2_table(31) := '2861707049442026262070616765494429207B0D0A2020202020202020202020202020202070203D20617761697420617065782E7365727665722E706C7567696E28616A617850726F2C207B0D0A20202020202020202020202020202020202020207830';
wwv_flow_imp.g_varchar2_table(32) := '313A202732272C0D0A20202020202020202020202020202020202020207830323A2061707049442C0D0A20202020202020202020202020202020202020207830333A207061676549442C0D0A20202020202020202020202020202020202020207830343A';
wwv_flow_imp.g_varchar2_table(33) := '20676574506172616D4E616D657328722E504152414D4C495354292C0D0A20202020202020202020202020202020202020207830353A20676574506172616D56616C75657328722E504152414D4C495354290D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(34) := '7D2C0D0A20202020202020202020202020202020202020207B0D0A20202020202020202020202020202020202020202020202064617461547970653A20226A736F6E222C0D0A2020202020202020202020202020202020202020202020206173796E633A';
wwv_flow_imp.g_varchar2_table(35) := '20747275652C0D0A202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2028704461746129207B0D0A0D0A20202020202020202020202020202020202020202020202020202020696620287044617461';
wwv_flow_imp.g_varchar2_table(36) := '2E73746174757329207B0D0A20202020202020202020202020202020202020202020202020202020202020206C657420646174614F626A203D204A534F4E2E70617273652870446174612E64617461293B0D0A2020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(37) := '2020202020202020202020202020206C6574207B2075726C2C20747970652C20737563636573732C206572726F72207D203D20646174614F626A3B0D0A202020202020202020202020202020202020202020202020202020202020202069662028657272';
wwv_flow_imp.g_varchar2_table(38) := '6F72290D0A202020202020202020202020202020202020202020202020202020202020202020202020617065782E6D6573736167652E616C657274286572726F72293B0D0A20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(39) := '20656C7365207B0D0A202020202020202020202020202020202020202020202020202020202020202020202020617065782E6E617669676174696F6E2E72656469726563742875726C293B0D0A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(40) := '2020202020202020207D0D0A202020202020202020202020202020202020202020202020202020207D20656C7365207B0D0A2020202020202020202020202020202020202020202020202020202020202020636F6E736F6C652E6C6F6728275061676520';
wwv_flow_imp.g_varchar2_table(41) := '6C696E6B206973206E6F742067656E65726174656427293B0D0A202020202020202020202020202020202020202020202020202020207D0D0A2020202020202020202020202020202020202020202020207D0D0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(42) := '202020207D0D0A20202020202020202020202020202020293B0D0A2020202020202020202020207D0D0A20202020202020207D0D0A202020207D293B0D0A7D0D0A';
null;
wwv_flow_imp.component_end;
end;
/
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2023.04.28'
,p_release=>'23.1.4'
,p_default_workspace_id=>100000
,p_default_application_id=>133
,p_default_id_offset=>0
,p_default_owner=>'HMIS'
);
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(1441939304132197550)
,p_plugin_id=>wwv_flow_imp.id(1441938266659197575)
,p_file_name=>'apps/js/reportPlugin.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
