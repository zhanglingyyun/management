<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
 <head>
   <title> 游戏列表</title>
   <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="${pageContext.request.contextPath}/assets/css/dpl-min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/bui-min.css" rel="stylesheet" type="text/css" />
    <link href="${pageContext.request.contextPath}/assets/css/page-min.css" rel="stylesheet" type="text/css" />   <!-- 下面的样式，仅是为了显示代码，而不应该在项目中使用-->
   <link href="${pageContext.request.contextPath}/assets/css/prettify.css" rel="stylesheet" type="text/css" />
 </head>
 <body>
  
  <div class="container">
    <div class="row">
      <form id="searchForm" class="form-horizontal span24">
        <div class="row">
          <div class="control-group span8">
            <label class="control-label">游戏名称：</label>
            <div class="controls">
              <input type="text" class="control-text" name="gameName">
            </div>
          </div>
          <div class="control-group span8">
            <label class="control-label">游戏进程：</label>
            <div class="controls">
              <input type="text" class="control-text" name="gameProcess">
            </div>
          </div>
        </div>
        <div class="row">
          <div class="control-group span8">
            <label class="control-label">状态：</label>
            <div class="controls" >
              <select  id="state" name="state">
                <option value="">游戏状态</option>
                <option value="active">正常</option>
                <option value="forbidden">禁用</option>
              </select>
            </div>
          </div>
          <div class="control-group span8">
            <label class="control-label">游戏编号：</label>
            <div class="controls">
              <input type="text" class="control-text" name="gameCode">
            </div>
          </div>
          <div class="span3 offset5">
            <button  type="button" id="btnSearch" class="button button-primary">搜索</button>
          </div>
        </div>
      </form>
    </div>
    <div class="search-grid-container">
      <div id="grid"></div>
    </div>
  </div>
  
  
  <div id="content" class="hide">
  	  <label class="control-label" id="error_message"><s></s></label>
      <form id="J_Form" class="form-horizontal" action="add">
       <input type="hidden" name="id" id ="J_id">
        <div class="row">
          <div class="control-group span8">
            <label class="control-label"><s>*</s>游戏名称：</label>
            <div class="controls">
              <input name="gameName" id="gameName" type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
        </div>
        
        <div class="row">
          <div class="control-group span8">
            <label class="control-label"><s>*</s>游戏进程：</label>
            <div class="controls">
              <input name="gameProcess" id="gameProcess" type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
        </div>
        
                
        <div class="row">
          <div class="control-group span8">
            <label class="control-label"><s>*</s>游戏版本：</label>
            <div class="controls">
              <input name="gameVersion" id="gameVersion"  type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
        </div>
        
       <div class="row">
	        <div class="control-group span8">
	        	  <label class="control-label">计费时长(分钟)：</label>
	          <div class="controls">
	            <input type="text" class="control-text" name="billingTime"  id="billingTime" data-rules="{number:true}">
	          </div>
			</div>
        </div>
                
       <div class="row">
          <div class="control-group span8">
            <label class="control-label">游戏价格(元/次)：</label>
            <div class="controls">
              <input type="text" class="control-text"  id="defaultPrice" name="defaultPrice"  data-rules="{number:true}">
          </div>
        </div>
        </div>
      </form>
    </div>
  <script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/jquery-1.8.1.min.js"></script>
  <script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/bui-min.js"></script>
  <script type="text/javascript" src="${pageContext.request.contextPath}/assets/js/config-min.js"></script>
  <script type="text/javascript">
    BUI.use('common/page');
  </script>
<script type="text/javascript">
  BUI.use(['common/search','bui/overlay'],function (Search,Overlay) {
      editing = new BUI.Grid.Plugins.DialogEditing({
          contentId : 'content', //设置隐藏的Dialog内容
          autoSave : true, //添加数据或者修改数据时，自动保存
          triggerCls : 'btn-edit',
        
        }),
      columns = [
		  {title:'序号',dataIndex:'id',width:'5%'},
          {title:'游戏进程',dataIndex:'gameProcess',width:'20%'},
          {title:'游戏名称',dataIndex:'gameName',width:'20%'},
          {title:'游戏编号',dataIndex:'gameCode',width:'15%'},
          {title:'计费时长(分钟)',dataIndex:'billingTime',width:'10%'},
          {title:'游戏价格(元/次)',dataIndex:'defaultPrice',width:'10%'},
          {title:'游戏版本',dataIndex:'gameVersion',width:'8%'},
          {title:'游戏状态',dataIndex:'state',width:'7%',
        	  renderer : function(value)
        	  {
        		  if ('active'==value) {return "正常"}
        		  if ('forbidden'==value) {return "禁用"}
          	  }
          },
		  {title : '修改',
		    	renderer : function() {
				return '<span class="grid-command update">修改</span>';
			
		    	}
		  }
        ],

        gridCfg = Search.createGridCfg(columns,{
            tbar : {
              items : [
                {text : '<i class="icon-plus"></i>新建',btnCls : 'button button-small',handler:addFunction},
                {text : '<i class="icon-remove"></i>激活',btnCls : 'button button-small',handler : activeFunction},
                {text : '<i class="icon-remove"></i>禁用',btnCls : 'button button-small',handler : delFunction}
              ]
            },
            plugins : [editing,BUI.Grid.Plugins.CheckSelection,BUI.Grid.Plugins.AutoFit] // 插件形式引入多选表格
          });
      
		store = Search.createStore('game_list',
		{
		    sortInfo : {
		    field : 'id',
		    direction : 'desc'
		 },
		 autoLoad : true,
		 pageSize : 10,
		    proxy : {
		        method : 'post',
		        dataType : 'json'
		 }
		});
    var  search = new Search({
        store : store,
        gridCfg : gridCfg
      }),
      grid = search.get('grid');
    
    function addFunction(){
    	dialog.show();
    }
    
    //删除操作
    function delFunction(){
      var selections = grid.getSelection();
      delItems(selections,"forbidden");
    }
    
    function activeFunction(){
        var selections = grid.getSelection();
        delItems(selections,"active");
      }

    function delItems(items,state){
      var ids = [];
      BUI.each(items,function(item){
        ids.push(item.id);
      });
      if(ids.length){
        BUI.Message.Confirm('确认要禁用选中的记录么？',function(){
          $.ajax({
            url : 'update_state',
            dataType : 'json',
            type : 'post',
            data : {"ids" : ids.join(","),"state":state},
            success : function(data){
              if(data.code=='success'){ //删除成功
                search.load();
              }else{ 
                BUI.Message.Alert('操作失败！');
              }
            }
        });
        },'question');
      }
    }

    //监听事件，删除一条记录
    grid.on('cellclick',function(ev){
      var sender = $(ev.domTarget); //点击的Dom
      if(sender.hasClass('btn-del')){
        var record = ev.record;
        delItems([record]);
      }
    });
    
	var Overlay = BUI.Overlay,
	Form = BUI.Form;
	var form = new Form.HForm({
	  srcNode : '#J_Form',
      submitType : 'ajax',
      callback : function(data){
        if(data.code=='success'){
        	 dialog.close();
        	 search.load();
        }else
        {
        	$("span[id='error_messge']").val(data.messge);
        	BUI.Message.Alert(data.message);
        	 return false;
        }
      }
	}).render();
	
	var dialog = new Overlay.Dialog({
	      title:'新增游戏',
	      contentId:'content',
	      success:function () {
	    	form && form.submit();
	        /* this.close(); */
	        return false;
	      }
	   });
	
	grid.on('cellclick', function(ev) {
		var record = ev.record, //点击行的记录
		field = ev.field, //点击对应列的dataIndex
		target = $(ev.domTarget); //点击的元素
		if (target.hasClass('update')) {
			$("#gameName").val(record.gameName);
			$("#gameProcess").val(record.gameProcess);
			$("#gameVersion").val(record.gameVersion);
			$("#billingTime").val(record.billingTime);
			$("#defaultPrice").val(record.defaultPrice);
			$("#J_id").val(record.id);
			dialog.show();
		}
	});
  });
</script>
</body>
</html>  
