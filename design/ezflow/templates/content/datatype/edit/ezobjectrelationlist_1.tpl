 <div class="buttonblock">
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if ne( count( $nodesList ), 0)}
            <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
                {if $attribute.contentclass_attribute.is_required|not}
                    <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}</option>
                {/if}
                {section var=node loop=$nodesList}
                    <option value="{$node.contentobject_id}"
                    {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                         {if eq( $item.contentobject_id, $node.contentobject_id )}
                            selected="selected"
                            {break}
                         {/if}
                    {/foreach}
                    {/if}
                    >
                    {$node.name|wash}</option>
                {/section}
            </select>
            {/if}
            </div>