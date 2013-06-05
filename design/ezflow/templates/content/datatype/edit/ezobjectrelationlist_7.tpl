          <div class="buttonblock">
            <div class="templatebasedeor">
                <ul>
                {section var=node loop=$nodesList}
                   <li>
                        <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
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