<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page session="true"%>

<%
	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise";
	String usr = "root";
	String pw = "";

	//データベースへの接続
	Connection cn = DriverManager.getConnection(url, usr, pw);

	Statement st = cn.createStatement();
	Statement st1 = cn.createStatement();

	//SQL文
	String qry1 = "SELECT * FROM categories";

	String qry2 = "SELECT * FROM makers";

	//qry1の列の値の取得
	ResultSet rs = st.executeQuery(qry1);
	ArrayList<String> cname = new ArrayList<String>();
	ArrayList<Integer> cid = new ArrayList<Integer>();
	while(rs.next()) {
		cname.add(rs.getString("categoryName"));
		cid.add(rs.getInt("categoryID"));
	}

	//qry2の列の値の取得
	ResultSet rs1 = st1.executeQuery(qry2);
	ArrayList<String> mname = new ArrayList<String>();
	ArrayList<Integer> mid = new ArrayList<Integer>();
	while(rs1.next()) {
		mname.add(rs1.getString("makerName"));
		mid.add(rs1.getInt("makerID"));
	}

	//接続のクローズ
	rs.close();
	st.close();
	rs1.close();
	st1.close();
	cn.close();
%>

<%
	String str1 = (String) session.getAttribute("num");
	int num1 = 0;
	if(str1 != null){
		num1 = Integer.parseInt(str1);
	}
	else{
		num1 = 15;
	}
%>
<% 			String str2 = null;
			String str3 = null;
			String str4 = null;
			int str5 = 0;
			int str6 = 0;
			String str7 = null;
				if(session.getAttribute("goodsID") != null){
					str7 = (String) session.getAttribute("goodsID");
				}

				if(session.getAttribute("categoryID") != null) {
					str6 = (Integer) session.getAttribute("categoryID");
				}
				if(session.getAttribute("goodsName") != null) {
					str2 = (String) session.getAttribute("goodsName");
				}

				if(session.getAttribute("price") != null) {
					str3 = (String) session.getAttribute("price");
				}
				if(session.getAttribute("goodsNotes") != null) {
					str4 = (String) session.getAttribute("price");
				}
				if(session.getAttribute("makerID") != null) {
					str5 = (Integer) session.getAttribute("makerID");
				}
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品追加フォーム1」</title>
</head>
<body background="./images/hanep.gif">
	<h2 style="background-color: #ff00ff">商品マスターメンテナンス((追加処理))</h2>
	<form
		action="http://localhost:8080/developmentExercise/GoodsMaintenance1"
		method="POST">
		<p>
			商品ID<input type="text" name="goodsID" size="20" maxlength="9"
			<% if(str7 != null) { %>value="<%= str7%>" <% } %>>
			XXX-XXXXX形式（Xは、数値）
		</p>

		<p>
			カテゴリー <select name="categoryID">
				<% for(int i=0; i< cname.size(); i++) {
					if(num1 != cid.get(i)) {%>
				<option value="<%= cid.get(i) %>"><%= cname.get(i) %></option>
				<%  } else{%>
				<option value="<%= cid.get(i) %>" selected><%= cname.get(i) %></option>
				<%  } }%>
			</select>
		</p>

		<p>
			商品名 <input type="text" name="goodsName"
			<% if(str2 != null) { %>value="<%= str2 %>"<% } %>>
		</p>
		<p>
			価格<input type="text" name="price"
			<% if(str3 != null) {%>value="<%= str3 %>"<% } %>>
		</p>
		<p>
			備考<input type="text" name="goodsNotes"
			<% if(str4 != null) {%>value="<%= str4%>"<% } %>>
		</p>

		<p>
			メーカー <select name="makerID">
				<% for(int i=0; i< mname.size(); i++) {
					if(str5 != mid.get(i)) {%>
				<option value="<%= mid.get(i) %>"><%= mname.get(i) %></option>
				<%  } else{%>
				<option value="<%= mid.get(i)%>" selected><%= mname.get(i) %></option>
				<% } } %>
			</select>
		</p>
		<br />
		<p>上記の商品を追加します。よろしいですか？</p>
		<a><input type="submit" value="追加"></a>
		<a><input type="reset" value="リセット"></a>
	</form>
	<form action="./addGoods1.jsp" name="rs">
		<% session.invalidate();
			session = request.getSession(false);%>
		<a><input type="submit" value="最強のリセット"></a>
		</form>
</body>
</html>