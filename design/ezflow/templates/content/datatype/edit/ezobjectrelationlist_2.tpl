<input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if $attribute.contentclass_attribute.is_required|not}
                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation"
                {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />{/if}
            {section var=node loop=$nodesList}
                <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                {foreach $attribute.content.relation_list as $item}
                     {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                     {/if}
                {/foreach}
                {/if}
                >
                {$node.name|wash} <br/>
            {/section}