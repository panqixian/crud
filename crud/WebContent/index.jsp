<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,com.newsclan.crud.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home</title>
<link rel=stylesheet href='bs/css/bootstrap.css' type='text/css'>
<script src="jq/jquery.min.js"></script>
<script src="bs/js/bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="jq/css/jquery-ui.min.css" />
<link rel="stylesheet" type="text/css" href="jq/css/jquery.wysiwyg.css" />

<script type="text/javascript" src="jq/jquery-ui.min.js"></script>
<script type="text/javascript" src="jq/jquery-ui-datepicker.js"></script>

<script src="ckeditor/ckeditor.js"></script>
<script src="ckeditor/adapters/jquery.js"></script>

</head>
<body>


<div class="navbar navbar-default" role="navigation">
  <!-- Brand and toggle get grouped for better mobile display -->
  
  <!-- Collect the nav links, forms, and other content for toggling -->
  <div class="navbar bs-navbar" >
    <a class="navbar-brand" href="#"><%=Config.get("system.name") %></a>
      <%
      	List<String> tables=com.newsclan.crud.DAO.getTables();
		Iterator<String> it=tables.iterator();
		while(it.hasNext()){
			String table=it.next();
			out.println("<a class=\"btn navbar-brand\" href=\"#"+table+"\" onclick='mainLoad(\""+table+"\")'>"
			 +DAO.translate(table)+"</a>");
		}
      %>
     <a class="btn navbar-brand" href="#" onclick='addTable();'><span class='glyphicon glyphicon-plus'></span></a>;
   
  </div><!-- /.navbar-collapse -->
</div>

<div id=main class="container"></div>
	
</body>
<script>
    
	function dbid(evt){
		var data=$(evt.target).parent().parent().attr("id");
		return parseInt(data);
	}
	function edit(rowid){
		var tbname=$("#tbname").val();
		$("#main").load("add.jsp",{"tb":tbname,"id":rowid},reformatform);
	}
	function del(rowid){
		var ans=confirm('确定删除编号'+rowid);
		var tbname=$("#tbname").val();
		if(ans){
			$.post("del.jsp",{"tbname":tbname,"id":rowid},new function(){
				 mainLoad(tbname);
			});
		}
	}
	function addButton(main){
		//$("#main tr :last-child").css("background","#eeeeee");
		$("#main tr").append("<td><span class='glyphicon glyphicon-edit'></span>"
										+"<span class='glyphicon glyphicon-trash' ></span></td>");
		$(".glyphicon-trash").bind("click",function(evt){
			del(dbid(evt));
		});
		$(".glyphicon-edit").bind("click",function(evt){
			edit(dbid(evt));
		});
		
		
	}
	function loadSelect(input){
		var input_name=input.attr("name");
		var default_value=input.val();
		var tbname=input_name.substring(0,input_name.length-3);
		var td=input.parent();
		td.load("select.jsp?tbname="+tbname+"&value="+default_value);
		
	}
	function reformatform(){
		$("input[name$=_id]").each(function(){
			loadSelect($(this));
		});
		$(".input_date").datepicker();
		$("textarea").ckeditor();
	}
	function mainLoad(tbname){
		$("#main").load("list.jsp?tb="+tbname,function(text,status,http){
			
			if(status=="success"){
				addButton($("#main"));
				$("#tbname").after("<span id='addrow' class='glyphicon glyphicon-plus'></span>");
				$("#addrow").click(function(){
					$("#main").load("add.jsp",{tb:tbname},reformatform);
				});
			}
		});
		
	}
	function submitAdd(tbname){
		var data=$("#addForm").serialize();
		$.post("add.jsp",data,new function(){
			 mainLoad(tbname);
		});
	}
	function submitTable(){
		var data=$("#frmAddTable").serialize();
		var tbname=$("#tb_name").val();
		
		$.post("addTable.jsp",data,new function(){
			 window.setTimeout("mainLoad('"+tbname+"')",500);
		});
	}
	function addTable(){
		$("#main").empty();
		$("#main").append("<form method=post onSubmit='submitTable()' id='frmAddTable'><table id='tb_adding' class='table table-striped table-hover'></table></form>");
		$("#tb_adding").append("<tr><td>表名<input type=text id=tb_name name=tb_name value='tb_'></td><td>中文<input type=text name=tb_title value='信息'></td></tr>");
		$("#tb_adding").append("<tr><td>列名</td><td>类型</td><td>中文</td><td><a href=# onclick='addColumn();'><span class='glyphicon glyphicon-plus'></span></a></td></tr>");
		$("#frmAddTable").append("<input type=button onclick='submitTable()' value='确定'><input type=reset value='重置'>");
		addColumn();
		
	}
	function addColumn(){
		var row="<tr>";
		row+="<td><input name=fd_name type=text></td>";
		row+="<td><input name=fd_type type=text value='varchar(32)'></td>";
		row+="<td><input name=fd_title type=text></td>";
		row+="</tr>";
		$("#tb_adding").append(row);
	}
	

</script>
</html>