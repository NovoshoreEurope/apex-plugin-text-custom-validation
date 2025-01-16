PROCEDURE render_plugin (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result )
AS
    --custom plugin attributes
    l_result                                apex_plugin.t_page_item_render_result;
    l_item_name                             varchar2(4000) := apex_plugin.get_input_name_for_page_item(false);
    l_item_value                            varchar2(4000) := p_param.value;
    --
    attr_short_text                         p_item.attribute_01%TYPE := p_item.attribute_01;
    attr_label                              p_item.attribute_02%TYPE := p_item.attribute_02;
    --
    l_html      varchar(4000);
    --
BEGIN
    --debug
    if apex_application.g_debug then
      apex_plugin_util.debug_page_item(p_plugin, p_item, p_param.value, p_param.is_readonly, p_param.is_printer_friendly);
    end if;
    --
    l_html := '<div class="t-Form-fieldContainer t-Form-fieldContainer--floatingLabel lto' || p_item.id || '_0 apex-item-wrapper apex-item-wrapper--text-field" id="' || l_item_name || '_CONTAINER">';
	l_html := l_html || '<div class="t-Form-labelContainer">';
	l_html := l_html || '<label for="' || l_item_name || '" id="' || l_item_name || '_LABEL" class="t-Form-label">' || attr_label || '</label>';
	l_html := l_html || '</div>';
	l_html := l_html || '<div class="t-Form-inputContainer">';
	l_html := l_html || '<div class="t-Form-itemWrapper">';
	l_html := l_html || '<input type="text" id="' || l_item_name || '" name="' || l_item_name || '" class="text_field apex-item-text" value="' || l_item_value || '" size="30" spellcheck="false" data-ms-editor="true"/>';
	l_html := l_html || '</div>';
	l_html := l_html || '<span id="' || l_item_name || '_error_placeholder" class="a-Form-error"/>';
	l_html := l_html || '</div>';
    l_html := l_html || '</div>';
    --
    htp.p(l_html);
    -- 
    apex_javascript.add_onload_code(p_code => 'textCustomValidation._initialize("'||attr_short_text||'", "'||l_item_name||'");');
    --
end render_plugin;