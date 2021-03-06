<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>订单管理</title>
    
	
	<script type="text/javascript" src="${pageContext.request.contextPath }/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/easyui/locale/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/easyui/themes/icon.css">
	<link id="themeLink" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath }/easyui/themes/default/easyui.css">
	
	


  </head>
  
  <body>

	
	
	<table id="list" style="height:350px;"></table>
	 
	
    <!-- 工具条 -->
    <div id="toolbar">
    	
		<input id="searchContext" style="width:200px;"/>
		<div id="searchRadio" style="width:100px" >
			 <div data-options="name:'null',iconCls:'icon-tip',selected:true">所有</div>
			
		</div>
		
		&nbsp;&nbsp;&nbsp;
    	<a id="deleteBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:'true'">删除</a>
   		<a id="detailBtn" href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-more',plain:'true'" 
   		                  pageUrl="${pageContext.request.contextPath }/manager/orderGoodsDetail.action">查看详细</a>

	
	</div>
    

    <div id="detail" class="easyui-panel" title="详细信息"  
		 style="padding: 10px; background: rgb(250, 250, 250); width: 100%; height: 100px; display: block;"  
            data-options="iconCls:'icon-more',closable:false,    
                collapsible:true,minimizable:false,maximizable:false,fit:true,collapsed:true">   
		    
		 <div id="Goodsdetail" class="easyui-tabs" style="width:100%;height:130px" data-options="plain:true,">
		    	
		    </div> 
    
    
    
    
    <script type="text/javascript">
    	$(function() {
    

    
    		$("#list").datagrid({
    		
    			title:'数据列表',
				resizable:true,
				striped: true ,	
    			height:400 ,
    			rownumbers:true ,
    			
				url:"${pageContext.request.contextPath }/manager/selectOrderList.action",  
    			columns:[[
    				 {field:"id",title:"id",width:150}, 
    				{field:"deliverMethod",title:"配送方式",width:100},
    				{field:"username",title:"用户名",width:100,formatter: function(value,row,index){
                          if (row.user){
                        return row.user.username;
                     }}},    
    				{field:"shopName",title:"商店名",width:110,formatter:function(value,row,index){
    						if(row.shop){
    						return row.shop.shopName;
    						}
    				}},
    				
    				{field:"totalMoney",title:"费用",width:80},
    				{field:"userAddress",title:"用户地址",width:170},
    				{field:"usercomment",title:"用户评论",width:270},
    				
    				{field:"createTime",title:"开始时间",width:150,formatter:function(value,row,index){
    						if(value != null) {
    								da = new Date(value) ;
    								var year = da.getFullYear() ;
    								var month = da.getMonth() ;
    								var date = da.getDate();
	    							var hours = da.getHours();
	    							var minutes = da.getMinutes();
	    							var seconds = da.getSeconds();
    							return year+"-"+month+"-"+date+"-"+hours+"-"+minutes+"-"+seconds;
    								}
    				}},
    				
    				{field:"orderState",title:"订单状态",width:120,formatter:function(value,row,index){
    						if(value != null){
    						
    						if(value == 0){
    						return value="<font color='red'>未付款</font>";
    						}
    						if(value == 1){
    						return value="<font color='#FFDEAD'>未接单</font>";
    						}
    						if(value == 2){
    						return value="<font color='#EE7621'>已接单</font>";
    						}
    						if(value == 3){
    						return value="<font color='#FF7256'>已接单并发货</font>";
    						}
    						if(value == 4){
    						return value="<font color='#FF3030'>已取消</font>";
    						}
    						if(value == 5){
    						return value="<font color='green'>确认收货</font>";
    						}
    						if(value == 6){
    						return value="<font color='#CDAA7D'>删除订单</font>";
    						}
    						if(value == 7){
    						return value="<font color='#CD853F'>申请取消未接单</font>";
    						}
    						if(value == 8){
    						return value="<font color='#CD853F'>确认收货且已评价</font>";
    						}
    						if(value == 9){
    						return value="<font color=''>失效订单</font>";
    						}
    					}	
    						
    				}},
    				
    				/* {field:"id",title:"id",width:100,}, 
    				 {field:"goodName",title:"商品名",width:100},
    				{field:"styleName",title:"商品类型",width:100}, 
                     
                     {field:"shopName",title:"商店名",width:100},
    				 */
    			]],
    			pagination:true,
    			//工具条件
    			toolbar:"#toolbar",
    			sortName:"id",
    			sortOrder:'desc',
    		});
    		
    		
    		//删除商品
    		$("#deleteBtn").click(function(){
    			//1.获取选择的商品
    			var rows = $("#list").datagrid("getSelections");
    			
    			if(rows.length==0){
    				$.messager.alert("提示","至少选择一个订单","warning");
    				return;
    			}
    			
    			//2.获取商品的id 格式： 字符串  1,2,3 
    			var ids = new Array();
    			$(rows).each(function(i){
    				ids.push(rows[i].id);
    			});
    			
    			ids = ids.join(",");
    			
    			//3.发送商品id到后台进行删除
    			$.post("${pageContext.request.contextPath }/manager/deleteOrder.action",{"ids":ids},function(data){
    				if(data.success){
    					//刷新datagrid
    					$("#list").datagrid("reload");
    					//提示
    					$.messager.show({
							title:"提示",
							msg:"删除成功",
							timeout:1500
						});
    				}else{
    					$.messager.alert("提示","删除失败:"+data.msg,"error");
    				}
    			},"json");
    			
    		});
    	
    	//查看详情
    		$("a[pageUrl]").click(function(){
    	
    			var rows = $("#list").datagrid("getSelections");
    			if(rows.length != 1){
    				$.messager.alert("提示","只能有一个","warning");
    				return;
    			}
    			
    			$("#detail").panel({
    			collapsed:false,
    		});
    			
    			alert(6666);
    			var id = rows[0].id;
    			
    			
    	
    			
    			//1.获取pageUrl属性值（需要跳转的页面地址）
    			var pageUrl = $(this).attr("pageUrl");
    		
    			var url =  pageUrl+"?id="+id;
    			alert(url);
    			//获取a标签的内容，标题
    			var title = $(this).text();
    			
    			//2.判断是否存在指定标题的选项卡
    			 if( $("#Goodsdetail").tabs("exists",title)  )  {
	    			//3.如果存在，则选项该选项卡
    				//$("#context").tabs("select",title);
    				$("#Goodsdetail").tabs("close",title);
    				
    				$("#Goodsdetail").tabs("add",{
    					title:title,
    					content:"<iframe src='"+url+"' width='100%' height='100%' frameborder='0'><iframe>",
    					closable:true
    				});	
    								
    			}else{
	    			//4.如果不存在，则添加选项卡
    				$("#Goodsdetail").tabs("add",{
    					title:title,
    					content:"<iframe src='"+url+"' width='100%' height='100%' frameborder='0'><iframe>",
    					closable:true
    				});				
    			} 
    		});
    		
    		
    
    
    		$('#searchContext').searchbox({
    			searcher : function(value, name) {
    				alert(value + "," + name);
    				
    				var url= "${pageContext.request.contextPath }/manager/searchOrderByContext.action";
    				if(value != null && value !="".trim()){
    					url = url+"?userAddress="+value;
    					
    					if(name != "null" && name !=""){
    					url = url+"&orderState="+name;
    					alert(url);
    				    }
    				}else{
    					
    					if(name != "null" && name !=""){
    					url = url+"?orderState="+name;
    					alert(url);
    				    }
    				}
    				
    				$('#list').datagrid('options').url = url;
    				
    				$("#list").datagrid('load');  
    			},
    			
    			menu : '#searchRadio',
    			prompt : '请输入值'
    		});
    		
    		
    		
    		$.ajax({
    			type:"post",
    			url : "${pageContext.request.contextPath }/manager/orderState.action",
    			datatype : "json", //回调
    			success : function(data) {
    
    				
    				var array =  data.orderVo;
    				var state = data.stateName;
    					
        			$(array).each(function(i){
    					
        
    					 $('#searchRadio').menu('appendItem', {
    						text : state[i],
    						name : array[i].orderState,
    						iconCls : 'icon-ok',
    						/* onclick : function() {
    							alert('新增');
    						}, */
    					});
    					}); 
    				}
    		}); 
    	});	
    
    	
    	
    </script>
  </body>
</html>
