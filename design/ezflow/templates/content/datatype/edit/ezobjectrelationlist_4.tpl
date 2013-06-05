            <div class="buttonblock">
            {if ne( count( $nodesList ), 0)}
            <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" size="10" multiple>
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