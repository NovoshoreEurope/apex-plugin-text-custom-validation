PROCEDURE render_plugin (
    p_item   IN            apex_plugin.t_item,
    p_plugin IN            apex_plugin.t_plugin,
    p_param  IN            apex_plugin.t_item_render_param,
    p_result IN OUT NOCOPY apex_plugin.t_item_render_result
) AS
    -- Custom plugin attributes
    l_result          apex_plugin.t_page_item_render_result;
    l_item_name       VARCHAR2(4000) := apex_plugin.get_input_name_for_page_item(false);
    l_item_value      VARCHAR2(4000) := p_param.value;

    -- Plugin-specific attributes (defined by developer in the plugin attributes)
    attr_short_text   p_item.attribute_01%TYPE := p_item.attribute_01; -- Example: Short descriptive text or validation text
    attr_label        p_item.attribute_02%TYPE := p_item.attribute_02; -- Label for the input field

    -- Variable to store generated HTML
    l_html            CLOB;

BEGIN
    -- Debugging information, useful for tracking plugin behavior during development
    IF apex_application.g_debug THEN
        apex_plugin_util.debug_page_item(p_plugin, p_item, p_param.value, p_param.is_readonly, p_param.is_printer_friendly);
    END IF;

    -- Set the item's value in APEX session state to ensure synchronization
    apex_util.set_session_state(l_item_name, l_item_value);

    -- Build the HTML structure for the plugin output
    l_html :=
          '<div class="t-Form-fieldContainer t-Form-fieldContainer--floatingLabel lto'
       || p_item.id || '_0 apex-item-wrapper apex-item-wrapper--text-field" id="'
       || l_item_name || '_CONTAINER">'
       || '<div class="t-Form-labelContainer">'
       || '<label for="' || l_item_name || '" id="' || l_item_name || '_LABEL" class="t-Form-label">'
       || attr_label || '</label>'
       || '</div>'
       || '<div class="t-Form-inputContainer">'
       || '<div class="t-Form-itemWrapper">'
       || '<input type="text" id="' || l_item_name || '" name="' || l_item_name || '" class="text_field apex-item-text"'
       || ' value="' || l_item_value || '" size="30" spellcheck="false" data-ms-editor="true"/>'
       || '</div>'
       || '<span id="' || l_item_name || '_error_placeholder" class="a-Form-error"></span>'
       || '</div>'
       || '</div>';

    -- Output the generated HTML to the page
    htp.p(l_html);

    -- Add JavaScript to initialize client-side functionality for the plugin
    apex_javascript.add_onload_code(p_code => 'textCustomValidation._initialize("' || attr_short_text || '", "' || l_item_name || '");');

END render_plugin;