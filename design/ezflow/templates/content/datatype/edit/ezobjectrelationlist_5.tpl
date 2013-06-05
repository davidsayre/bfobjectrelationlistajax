<!-- Start ORL AJAX -->
	
		
			<script language="javascript"  type="text/javascript">

				//BFC ORL field syntax
				var ObjectRelationListField = '{$attribute_base}_data_object_relation_list_';

				{run-once}
				
				{literal}

					function ORLHandler(AjaxURL) {	
						this.url				= AjaxURL;
						this.attribute_id			= 0;
						this.handleHttpResponse			= ORLHandleHttpResponse;
						this.isWorking				= false;
						this.updateNameDelayed			= ORLUpdateNameDelayed;
						this.updateName				= ORLUpdateName;
						this.setTitle				= ORLSetTitle;
						this.getHTTPObject			= ORLGetHTTPObject;
						this.moveItem				= ORLMoveItem;
						this.selectall				= ORLSelectAll;
						this.up					= ORLUp;
						this.down				= ORLDown;
						this.viceversa				= ORLViceversa;
						this.showInput				= ORLShowInput;
						this.showOutput				= ORLShowOutput;
						this.msgNoneSelected			= "please select an item first";
						this.maxStringLength			= 99;
						this.delayTimer				= null; // onKeyUp delay
						this.delay				= 250; // msecs
						this.http				= this.getHTTPObject(); // get the http handler
					}


					function ORLHandleHttpResponse() {

						 // this is an event callback. 
						 // the 'this' keyword will not work

						 if (ORL.http.readyState == 4) {
								if (ORL.http.responseText.indexOf('invalid') == -1) {
									// Use the XML DOM to unpack the objectid and objectname data
									document.getElementById("count_"+ORL.attribute_id).innerHTML='loading...';
									var xmlDocument = ORL.http.responseXML;
									var countelms = xmlDocument.getElementsByTagName('count');
									if (countelms && countelms.length) var count = countelms.item(0).firstChild.data;
									else var count = 0;

									var objectlist = '<select id="items_input_'+ORL.attribute_id+'" style="width: 100%;" multiple size="6" ';
									objectlist += " onChange=\"ORL.setTitle(items_input_"+ORL.attribute_id+","+ORL.attribute_id+");\">";

									var nodelist = '';
									var namelist = '';


									for (i = 0; i < count; i++)
									{
										if (xmlDocument.getElementsByTagName('objectid'))
											var objectid = xmlDocument.getElementsByTagName('objectid').item(i).firstChild.data;

										if (xmlDocument.getElementsByTagName('objectname'))
											var objectname = xmlDocument.getElementsByTagName('objectname').item(i).firstChild.data;

										if (xmlDocument.getElementsByTagName('nodeid'))
											var nodeid = xmlDocument.getElementsByTagName('nodeid').item(i).firstChild.data;

										if (objectid && objectname && nodeid) {
											if (objectname.length>ORL.maxStringLength) {
												objectname=objectname.substring(0,ORL.maxStringLength-3)+"...";
											}
											objectlist += "<option value='"+ objectid + "'>" + objectname.substring(0,48) + "</option>";
											nodelist += "<input type='hidden' name='node_" + objectid + "' value='" + nodeid + "'/>";
											namelist += "<input type='hidden' name='name_" + objectid + "' value='" + objectname + "'/>";
										}
									}

									document.getElementById("selectbox_input_"+ORL.attribute_id).innerHTML=objectlist + '</select>';
									document.getElementById("nodelist_"+ORL.attribute_id).innerHTML=nodelist;
									document.getElementById("namelist_"+ORL.attribute_id).innerHTML=namelist;
									document.getElementById('count_'+ORL.attribute_id).innerHTML= count;
									if (count>0) 
									{
										document.getElementById("items_input_"+ORL.attribute_id).options[0].selected=true;
										from=document.getElementById("items_input_"+ORL.attribute_id);
										ORL.setTitle(from,ORL.attribute_id);
									}

								 if (count > 99)
								 {
									document.getElementById("count_"+ORL.attribute_id).innerHTML='100+';
								 }

								ORL.isWorking = false;

							}
						}
					}

					function ORLUpdateNameDelayed(id) 
					{
						clearTimeout(this.delayTimer);
						this.delayTimer = setTimeout("ORL.updateName('"+id+"')", this.delay);
					}

					function ORLUpdateName(id) 
					{

					  clearTimeout(this.delayTimer);
					  this.attribute_id=id;
					  document.getElementById("selectedtitle_" + id).innerHTML="";					  
					  var class_attribute_id=document.getElementById("contentclass_attribute_" + id).value;
					  document.getElementById("count_" +id ).innerHTML='loading.';
					  if (!this.isWorking && this.http && class_attribute_id) {
						var objectnameValue = document.getElementById("objectname_" +id ).value;
						this.http.open("GET", this.url + "/" + class_attribute_id  + "/" + escape(objectnameValue), true);
						this.http.onreadystatechange = this.handleHttpResponse;
						this.isWorking = true;
						this.http.send(null);
						document.getElementById("count_" + id).innerHTML='loading..';
					  }
					}



					function ORLSetTitle(from,id)
					{
						if (!id) id = ORL.attribute_id; // shouldnt hap, sync
						SI=from.selectedIndex;
						object_title=from.options[SI].text;
						keyword=document.getElementById("objectname_"+id).value.split(" ");
						for (var i in keyword)
						{
							object_title=object_title.replace(keyword[i],'<b>' + keyword[i] + '</b>');
						}	
						document.getElementById("selectedtitle_" +id).innerHTML=object_title;

					}

					function ORLGetHTTPObject() 
					{
						var xmlhttp;
						/*@cc_on
							@if (@_jscript_version >= 5)
								try {
									xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
								} catch (e) {
									try {
										xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
									} catch (E) {
										xmlhttp = false;
									}
								}
							@else
								xmlhttp = false;
						@end @*/
						if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
							try {
								xmlhttp = new XMLHttpRequest();
								xmlhttp.overrideMimeType("text/xml");
							} catch (e) {
								xmlhttp = false;
							}
						}
						return xmlhttp;
					}

					function ORLMoveItem(from, to, silent)
					{
						var f;
						var SI; /* selected Index */
						if (from.options.length==0 || from.selectedIndex==-1) 
						{
							if (!silent) alert(this.msgNoneSelected);
							return false;
						}
						if(from.options.length>0)
						{
							for(i=0;i<from.length;i++)
							{
								if(from.options[i].selected)
								{
									SI=from.selectedIndex;
									f=from.options[SI].index;
									to.options[to.length]=new Option(from.options[SI].text,from.options[SI].value);

									from.options[f]=null;

									i--; /* make the loop go through them all */
								}
							}
						}
					}

					function ORLSelectAll(obj,attrid) {
						if (obj.length < 1) return false;
						obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
						if (obj.tagName.toLowerCase() != "select") return false;
						sellist = "";
						if (obj.length==0) {
							// ORB sellist += "<input type='hidden' name='SelectedObjectIDArray_" + attrid + "[]' value=''/>";
							sellist += "<input type='hidden' name='" + ObjectRelationListField + attrid + "[]' value=''/>"; //ORL

						} else {
							for (var i=0; i<obj.length; i++) {
								//obj[i].selected = true;
								// ORB sellist += "<input type='hidden' name='SelectedObjectIDArray_" + attrid + "[]' value='" + obj[i].value + "'/>";
								sellist += "<input type='hidden' name='" + ObjectRelationListField + attrid + "[]' value='" + obj[i].value + "'/>"; //ORL

							}

						}
						document.getElementById("sellist_"+attrid).innerHTML=sellist;
						if (obj.length==0) return false;
						else return true;
					}


					function ORLUp(obj) {
						obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
						if (obj.tagName.toLowerCase() != "select" && obj.length < 2)
							return false;
						var sel = new Array();
						for (i=0; i<obj.length; i++) {
							if (obj[i].selected == true) {
								sel[sel.length] = i;
							}
						}
						for (i in sel) {
							if (sel[i] != 0 && !obj[sel[i]-1].selected) {
								var tmp = new Array(obj[sel[i]-1].text, obj[sel[i]-1].value, obj[sel[i]-1].style.color, obj[sel[i]-1].style.backgroundColor, obj[sel[i]-1].className, obj[sel[i]-1].id);
								obj[sel[i]-1].text 			= obj[sel[i]].text;
								obj[sel[i]-1].value 		= obj[sel[i]].value;
								obj[sel[i]-1].style.color 	= obj[sel[i]].style.color;
								obj[sel[i]-1].style.backgroundColor = obj[sel[i]].style.backgroundColor;
								obj[sel[i]-1].className 	= obj[sel[i]].className;
								obj[sel[i]-1].id 			= obj[sel[i]].id;
								obj[sel[i]].text 			= tmp[0];
								obj[sel[i]].value 			= tmp[1];
								obj[sel[i]].style.color 	= tmp[2];
								obj[sel[i]].style.backgroundColor = tmp[3];
								obj[sel[i]].className 		= tmp[4];
								obj[sel[i]].id 				= tmp[5];
								obj[sel[i]-1].selected 		= true;
								obj[sel[i]].selected 		= false;
							}
						}
					}

					function ORLDown(obj) {
						obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
						if (obj.tagName.toLowerCase() != "select" && obj.length < 2)
							return false;
						var sel = new Array();
						for (i=obj.length-1; i>-1; i--) {
							if (obj[i].selected == true) {
								sel[sel.length] = i;
							}
						}
						for (i in sel) {
							if (sel[i] != obj.length-1 && !obj[sel[i]+1].selected) {
								var tmp = new Array(obj[sel[i]+1].text, obj[sel[i]+1].value, obj[sel[i]+1].style.color, obj[sel[i]+1].style.backgroundColor, obj[sel[i]+1].className, obj[sel[i]+1].id);
								obj[sel[i]+1].text = obj[sel[i]].text;
								obj[sel[i]+1].value = obj[sel[i]].value;
								obj[sel[i]+1].style.color = obj[sel[i]].style.color;
								obj[sel[i]+1].style.backgroundColor = obj[sel[i]].style.backgroundColor;
								obj[sel[i]+1].className = obj[sel[i]].className;
								obj[sel[i]+1].id = obj[sel[i]].id;
								obj[sel[i]].text = tmp[0];
								obj[sel[i]].value = tmp[1];
								obj[sel[i]].style.color = tmp[2];
								obj[sel[i]].style.backgroundColor = tmp[3];
								obj[sel[i]].className = tmp[4];
								obj[sel[i]].id = tmp[5];
								obj[sel[i]+1].selected = true;
								obj[sel[i]].selected = false;
							}
						}
					}

					function ORLViceversa(obj) {
						obj = (typeof obj == "string") ? document.getElementById(obj) : obj;
						if (obj.tagName.toLowerCase() != "select" && obj.length < 2)
							return false;
						var elements = new Array();
						for (i=obj.length-1; i>-1; i--) {
							elements[elements.length] = new Array(obj[i].text, obj[i].value, obj[i].style.color, obj[i].style.backgroundColor, obj[i].className, obj[i].id, obj[i].selected);
						}
						for (i=0; i<obj.length; i++) {
							obj[i].text = elements[i][0];
							obj[i].value = elements[i][1];
							obj[i].style.color = elements[i][2];
							obj[i].style.backgroundColor = elements[i][3];
							obj[i].className = elements[i][4];
							obj[i].id = elements[i][5];
							obj[i].selected = elements[i][6];
						}
					}
					function ORLShowInput(id) {
						document.getElementById("panel_output_"+id).style.display="none";
						document.getElementById("panel_input_"+id).style.display="block";
					}
					function ORLShowOutput(id) {
						document.getElementById("panel_input_"+id).style.display="none";
						document.getElementById("panel_output_"+id).style.display="block";
					}


				{/literal}
				ORL  = new ORLHandler("{concat("objectrelationlistajax/list/",ezini( 'ModuleSettings', 'DynamicListLimit', 'module.ini' ),"/")|ezurl(no)}");
				if (!ORL.http) alert("{"Unable to initialize AJAX handler"|i18n('design/standard/content/view')}");
				if (!ORL.http) ORL = null;
	
				{/run-once}
					
			</script>
	

		<input type="hidden" name="SelectionType_{$attribute.id}" value="1" />
		<input type="hidden" name="{$attribute_base}_id[]" value="{$attribute.id}" />
		<input type="hidden" name="contentclass_attribute_{$attribute.id}" id="contentclass_attribute_{$attribute.id}" value="{$attribute.contentclassattribute_id}" />

		<div id="panel_output_{$attribute.id}">
			<table border="0" class="list" style="width:100%" cellpadding=3 cellspacing=0>
				<tr>
					<td colspan="2">
						<input type="button" class="button" value = "{'Search...'|i18n('design/standard/content/view')}" 
							onClick="if (ORL) ORL.showInput({$attribute.id})" />
						<input type="button" class="button" value = "{'Remove selected'|i18n('design/standard/content/view')}" 
							onClick="if (ORL) ORL.moveItem(items_output_{$attribute.id},items_input_{$attribute.id}); if (ORL) ORL.selectall('items_output_{$attribute.id}',{$attribute.id});return false;"  style="width: 100px;">
						<input type="submit" class="button" value="{'Update priorities'|i18n( 'design/standard/content/datatype' )}"
							onClick="if (ORL) ORL.selectall('items_output_{$attribute.id}',{$attribute.id});" name="CustomActionButton[{$attribute.id}_update_priorities]"  />
					</td>
				</tr>
				<tr>
					<td valign="top">
						<div id="selectbox_output_{$attribute.id}" style="width:100%;">
							<select id="items_output_{$attribute.id}" multiple size="8" style="width:100%;">
							</select>
						</div>
					</td>
					<td width="20" valign="top">
						<img src={"move-up.gif"|ezimage} onclick="if (ORL) ORL.up('items_output_{$attribute.id}');" 
								title="{'Move selected item up'|i18n('design/standard/content/view')}" /><br/><br/>
							<img src={"move-down.gif"|ezimage} onclick="if (ORL) ORL.down('items_output_{$attribute.id}');" 
								title="{'Move selected item down'|i18n('design/standard/content/view')}" />
					</td>
				</tr>
			</table>
		</div>

		<div id="panel_input_{$attribute.id}" style="display:none">
			<table  border="0" class="list" style="width:100%" cellpadding=3 cellspacing=0 >
				<tr>
					<td colspan="2">
						<input type="text" size="32" name="objectname_{$attribute.id}" id="objectname_{$attribute.id}" 
							autocomplete="off"  onKeyUp="if (ORL) ORL.updateName('{$attribute.id}');"/>
						<input type="submit" class="button" value="{'Go'|i18n('design/standard/content/view')}" 
							onClick="if (ORL) ORL.updateName('{$attribute.id}');return false;">
						<span id="count_{$attribute.id}" style="display: inline;">0</span>
							{'results'|i18n('design/standard/content/view')} 
					</td>
				</tr>
				<tr>
					<td valign="top">
						<div id="selectbox_input_{$attribute.id}" style="width:100%;">
							<select size="6" style="width:100%;" id="items_input_{$attribute.id}" multiple>
								<option value="">{'Enter your search term(s)'|i18n('design/standard/content/view')}</option>
								{* BFC loop over relation_list *}
								{section loop=$attribute.content.relation_list}
									{let term=fetch( 'content', 'object', hash( 'object_id', $:item.contentobject_id) )}
										<option value='{$:item.contentobject_id}' selected>{$term.name|shorten(99)}</option>
									{/let}
								{/section}
							</select>
						</div>
					</td>
					<td valign="top" width="20">
						<img src={"reverse.gif"|ezimage} class="button"  onclick="if (ORL) ORL.viceversa('items_input_{$attribute.id}');" 
								title="{'Reverse list'|i18n('design/standard/content/view')}" />
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div id="selectedtitle_{$attribute.id}" class="small" style="height:20px;">&nbsp;</div>
						<input type="button" class="button"  value = "{'Add selected'|i18n('design/standard/content/view')}" 
							onClick="if (ORL) ORL.moveItem(items_input_{$attribute.id}, items_output_{$attribute.id}); if (ORL) ORL.selectall('items_output_{$attribute.id}',{$attribute.id}); if (ORL) ORL.showOutput({$attribute.id}); return false;" style="width: 100px;">
						<input type="button" class="button"  value = "{'Cancel'|i18n('design/standard/content/view')}" 
							onClick="if (ORL) ORL.showOutput({$attribute.id})" />
					</td>
				</tr>
			</table>
		</div>

		<!-- the real data containers -->		
		<div id="nodelist_{$attribute.id}" style="display:inline;"></div>
		<div id="namelist_{$attribute.id}" style="display:inline;"></div>
		<div id="sellist_{$attribute.id}" style="display:inline;"></div>

		<script language="javascript"  type="text/javascript">
			if (ORL) ORL.moveItem( document.getElementById("items_input_{$attribute.id}"),  document.getElementById("items_output_{$attribute.id}"), true); 
			if (ORL) ORL.selectall("items_output_{$attribute.id}",{$attribute.id});
		</script>
		
		<!-- END ORL AJAX -->