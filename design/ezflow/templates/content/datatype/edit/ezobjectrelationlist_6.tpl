          <div class="buttonblock">
            <div class="templatebasedeor">
            <ul>
                {if $attribute.contentclass_attribute.is_required|not}
            <li>
                         <input value="no_relation" type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />
                    </li>
                {/if}
                {section var=node loop=$nodesList}
                    <li>
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
                        {node_view_gui content_node=$node view=objectrelationlist}
                    </li>
                {/section}
           </ul>
           </div>
           </div>