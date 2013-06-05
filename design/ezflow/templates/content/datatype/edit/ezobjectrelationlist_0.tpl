{* Standard mode is browsing *}
    <div class="block" id="ezobjectrelationlist_browse_{$attribute.id}">
    {if is_set( $attribute.class_content.default_placement.node_id )}
         {set browse_object_start_node = $attribute.class_content.default_placement.node_id}
    {/if}

    {* Optional controls. *}
    {include uri='design:content/datatype/edit/ezobjectrelationlist_controls.tpl'}

    {* Advanced interface. *}
    {if eq( ezini( 'BackwardCompatibilitySettings', 'AdvancedObjectRelationList' ), 'enabled' )}

            {if $attribute.content.relation_list}
                <table class="list" cellspacing="0">
                <tr class="bglight">
                    <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
                    <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
                    <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
                    <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
                    <th><span title="{'The related objects will be edited in the same language as this object. If such translations do not exist they will be created, based on the source language of your choice.'|i18n( 'design/standard/content/datatype' )}">{'Translation base'|i18n( 'design/standard/content/datatype' )}</span></th>
                    <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
                </tr>
                {section name=Relation loop=$attribute.content.relation_list sequence=array( bglight, bgdark )}
                    <tr class="{$:sequence}">
                    {if $:item.is_modified}
                        {* Remove. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>
                        <td colspan="4">

                        {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )
                             version=fetch( content, version, hash( object_id, $:item.contentobject_id, version_id, $:item.contentobject_version ) )}
                        <fieldset>
                        <legend>{'Edit <%object_name> [%object_class]'|i18n( 'design/standard/content/datatype',, hash( '%object_name', $Relation:object.name, '%object_class', $Relation:object.class_name ) )|wash}</legend>

                        {section name=Attribute loop=$:version.contentobject_attributes}
                            <div class="block">
                            {if $:item.display_info.edit.grouped_input}
                                <fieldset>
                                <legend>{$:item.contentclass_attribute.name}</legend>
                                {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                                </fieldset>
                            {else}
                                <label>{$:item.contentclass_attribute.name}:</label>
                                {attribute_edit_gui attribute_base=concat( $attribute_base, '_ezorl_edit_object_', $Relation:item.contentobject_id ) html_class='half' attribute=$:item}
                            {/if}
                            </div>
                        {/section}
                        {/let}
                        </fieldset>
                        </td>

                        {* Order. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_order" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                    {else}
                        {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )}
                        {* Remove. *}
                        <td><input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_remove_{$Relation:index}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$:item.contentobject_id}" /></td>

                        {* Name *}
                        <td>{$Relation:object.name|wash()}</td>

                        {* Type *}
                        <td>{$Relation:object.class_name|wash()}</td>

                        {* Section *}
                        <td>{fetch( section, object, hash( section_id, $Relation:object.section_id ) ).name|wash()}</td>

                        {* Translation base *}
                        <td>
                            {if $Relation:object.language_codes|contains( $attribute.language_code )}
                                <span title="{'This object is already translated, the existing translation will be used.'|i18n( 'design/standard/content/datatype' )}">
                                    {$attribute.object.current_language_object.name|wash()}
                                </span>
                            {else}
                                {def $languages=$Relation:object.languages}
                                <select name="{$attribute_base}_translation_source_{$attribute.id}_{$Relation:object.id}" title="{'This object is not translated, please select the language the new translation will be based on.'|i18n( 'design/standard/content/datatype' )}">
                                    {foreach $languages as $language}
                                        <option value="{$language.locale}" {if $language.locale|eq( $Relation:object.initial_language_code )}selected="selected"{/if}>{$language.name}</option>
                                    {/foreach}
                                    <option value="">{'None'|i18n( 'design/standard/content/datatype' )}</option>
                                </select>
                                {undef $languages}
                            {/if}
                        </td>

                        {* Order. *}
                        <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$:item.priority}" /></td>
                        {/let}
                    {/if}
                    </tr>
                {/section}
                </table>
            {else}
                <p>{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
            {/if}

            {if $attribute.content.relation_list}
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" />
            {else}
                <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
                <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_edit_objects]" value="{'Edit selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
            {/if}

            {if array( 0, 2 )|contains( $class_content.type )}
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
                {if $browse_object_start_node}
                <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
                {/if}
            {else}
               <input class="button-disabled" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />
            {/if}

            {section show=and( $can_create, array( 0, 1 )|contains( $class_content.type ) )}
                <div class="block">
                <select id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" class="combobox" name="{$attribute_base}_new_class[{$attribute.id}]">
                {section name=Class loop=$class_list}
                   <option value="{$:item.id}">{$:item.name|wash}</option>
                {/section}
                </select>
                {if $new_object_initial_node_placement}
                    <input type="hidden" name="{$attribute_base}_object_initial_node_placement[{$attribute.id}]" value="{$new_object_initial_node_placement|wash}" />
                {/if} 
                <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_new_class]" value="{'Create new object'|i18n( 'design/standard/content/datatype' )}" />
                </div>
            {/section}

    {* Simple interface. *}
    {else}

        
        <table class="list{if $attribute.content.relation_list|not} hide{/if}" cellspacing="0">
        <thead>
        <tr>
            <th class="tight"><img src={'toggle-button-16x16.gif'|ezimage} alt="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" onclick="ezjs_toggleCheckboxes( document.editform, '{$attribute_base}_selection[{$attribute.id}][]' ); return false;" title="{'Invert selection.'|i18n( 'design/standard/content/datatype' )}" /></th>
            <th>{'Name'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Type'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Section'|i18n( 'design/standard/content/datatype' )}</th>
            <th>{'Published'|i18n( 'design/standard/content/datatype' )}</th>
            <th class="tight">{'Order'|i18n( 'design/standard/content/datatype' )}</th>
        </tr>
        </thead>
        <tbody>
        {if $attribute.content.relation_list}
            {foreach $attribute.content.relation_list as $item sequence array( 'bglight', 'bgdark' ) as $style}
              {def $object = fetch( content, object, hash( object_id, $item.contentobject_id ) )}
              <tr class="{$style}">
                {* Remove. *}
                <td><input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="{$item.contentobject_id}" />
                <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$item.contentobject_id}" /></td>

                {* Name *}
                <td>{$object.name|wash()}</td>

                {* Type *}
                <td>{$object.class_name|wash()}</td>

                {* Section *}
                <td>{fetch( section, object, hash( section_id, $object.section_id ) ).name|wash()}</td>

                {* Published. *}
                <td>{if $item.in_trash}
                        {'No'|i18n( 'design/standard/content/datatype' )}
                    {else}
                        {'Yes'|i18n( 'design/standard/content/datatype' )}
                    {/if}
                </td>

                {* Order. *}
                <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="{$item.priority}" /></td>

              </tr>
              {undef $object}
            {/foreach}
        {else}
          <tr class="bgdark">
            <td><input type="checkbox" name="{$attribute_base}_selection[{$attribute.id}][]" value="--id--" />
            <input type="hidden" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation" /></td>
            <td>--name--</td>
            <td>--class-name--</td>
            <td>--section-name--</td>
            <td>--published--</td>
            <td><input size="2" type="text" name="{$attribute_base}_priority[{$attribute.id}][]" value="0" /></td>
          </tr>
        {/if}
        </tbody>
        </table>
        {if $attribute.content.relation_list|not}
            <p class="ezobject-relation-no-relation">{'There are no related objects.'|i18n( 'design/standard/content/datatype' )}</p>
        {/if}

        <div class="block inline-block ezobject-relation-browse">
        <div class="left">
	        {if $attribute.content.relation_list}
	            <input class="button ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" />&nbsp;
	        {else}
	            <input class="button-disabled ezobject-relation-remove-button" type="submit" name="CustomActionButton[{$attribute.id}_remove_objects]" value="{'Remove selected'|i18n( 'design/standard/content/datatype' )}" disabled="disabled" />&nbsp;
	        {/if}

	        {if $browse_object_start_node}
	            <input type="hidden" name="{$attribute_base}_browse_for_object_start_node[{$attribute.id}]" value="{$browse_object_start_node|wash}" />
	        {/if}

            {if is_set( $attribute.class_content.class_constraint_list[0] )}
                <input type="hidden" name="{$attribute_base}_browse_for_object_class_constraint_list[{$attribute.id}]" value="{$attribute.class_content.class_constraint_list|implode(',')}" />
            {/if}

	        <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Add objects'|i18n( 'design/standard/content/datatype' )}" />
        </div>
        <div class="right">
            <input type="text" class="halfbox hide ezobject-relation-search-text" />
            <input type="submit" class="button hide ezobject-relation-search-btn" name="CustomActionButton[{$attribute.id}_browse_objects]" value="{'Find objects'|i18n( 'design/standard/content/datatype' )}" />
        </div>
        <div class="break"></div>
        <div class="block inline-block ezobject-relation-search-browse hide"></div>
        </div>
        {include uri='design:content/datatype/edit/ezobjectrelation_ajax_search.tpl'}
	{/if}
    </div><!-- /div class="block" id="ezobjectrelationlist_browse_{$attribute.id}" -->