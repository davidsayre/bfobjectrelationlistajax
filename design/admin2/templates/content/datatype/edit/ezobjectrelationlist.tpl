{* DJS @ BFC customized ezobjectrelationlist datatype edit; 
    look in ezflow design content/datatype/edit/ezobjectrelationlist_<N>.tpl *}
{def $class_content=$attribute.class_content
     $class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
     $can_create=true()
     $new_object_initial_node_placement=false()
     $browse_object_start_node=false()}

        
{default attribute_base=ContentObjectAttribute}

{def $parent_node=cond( and( is_set( $class_content.default_placement.node_id ),
                       $class_content.default_placement.node_id|eq( 0 )|not ),
                       $class_content.default_placement.node_id, 1 )
}

{* skip fetch for 0 = browse and 5=ajax*}
{if array(0,5)|contains($class_content.selection_type)|not()}
    {if and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) )}              
        {def $nodesList=fetch( content, tree,
                                hash( parent_node_id, $parent_node,
                                      class_filter_type,'include',
                                      class_filter_array, $class_content.class_constraint_list,
                                      limit, 1000,
                                      sort_by, array( 'name',true() ),
                                      main_node_only, true() ) )
                         
        }
    {else}
        {def $nodesList=fetch( content, list,
                hash( parent_node_id, $parent_node,
                      limit, 1000,
                      sort_by, array( 'name', true() )
                     ) )
        }
    {/if}
{/if}

{switch match=$class_content.selection_type}

        {case match=0}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_0.tpl"}
    {/case}

    {case match=1} {* Dropdown list *}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_1.tpl"}
    {/case}

    {case match=2} {* radio buttons list *}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_2.tpl"}
    {/case}

    {case match=3} {* check boxes list *}
       {include uri="design:content/datatype/edit/ezobjectrelationlist_3.tpl"}
    {/case}

    {case match=4} {* Multiple List *}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_4.tpl"}
    {/case}

    {case match=5} {* inline AJAX *}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_5.tpl"}
    {/case}
    
    {case match=6} {* Template based, single *}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_6.tpl"}
    {/case}

    {case match=7} {* Template based, multi 5-> 7*}
        {include uri="design:content/datatype/edit/ezobjectrelationlist_7.tpl"}
    {/case}

{/switch}

{if is_set($nodesList)}
    {if eq( count( $nodesList ), 0 )}
        {def $parentnode = fetch( 'content', 'node', hash( 'node_id', $parent_node ) )}
        {if is_set( $parentnode )}
            <p>{'Parent node'|i18n( 'design/standard/content/datatype' )}: {node_view_gui content_node=$parentnode view=objectrelationlist} </p>
        {/if}
        <p>{'Allowed classes'|i18n( 'design/standard/content/datatype' )}:</p>
        {if ne( count( $class_content.class_constraint_list ), 0 )}
             <ul>
             {foreach $class_content.class_constraint_list as $class}
                   <li>{$class}</li>
             {/foreach}
             </ul>
        {else}
             <ul>
                   <li>{'Any'|i18n( 'design/standard/content/datatype' )}</li>
             </ul>
        {/if}
        <p>{'There are no objects of allowed classes'|i18n( 'design/standard/content/datatype' )}.</p>
    {/if}
{/if}

{* BFC wrap 'Create Object' short div in !=0 and !=5 *}
{if array(0,5)|contains($class_content.selection_type)|not()}
    Create object 
    {section show = and( is_set( $class_content.default_placement.node_id ), ne( 0, $class_content.default_placement.node_id ), ne( '', $class_content.object_class ) )}
        {def $defaultNode = fetch( content, node, hash( node_id, $class_content.default_placement.node_id ))}
        {if and( is_set( $defaultNode ), $defaultNode.can_create )}
            <div id='create_new_object_{$attribute.id}' style="display:none;">
                 <p>{'Create new object with name'|i18n( 'design/standard/content/datatype' )}:</p>
                 <input name="attribute_{$attribute.id}_new_object_name" id="attribute_{$attribute.id}_new_object_name"/>
            </div>
            <input class="button" type="button" value="Create New" name="CustomActionButton[{$attribute.id}_new_object]"
                   onclick="var divfield=document.getElementById('create_new_object_{$attribute.id}');divfield.style.display='block';
                            var editfield=document.getElementById('attribute_{$attribute.id}_new_object_name');editfield.focus();this.style.display='none';return false;" />
       {/if}
    {/section}
{/if}
