<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page session="true"%>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
	request.setCharacterEncoding("UTF-8");
	String gid = request.getParameter("goodsID");
	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	String usr = "root";
	String pw = "";

	//データベースへの接続
	Connection cn = DriverManager.getConnection(url, usr, pw);

	Statement st = cn.createStatement();

	//SQL文
	String qry1 = "SELECT goods.categoryID, categories.categoryName, goods.goodsName, goods.price, goods.goodsNotes, makers.makerName FROM goods, makers, categories WHERE goods.goodsID = '"
	+ gid
	+ "' AND goods.categoryID = categories.categoryID AND goods.makerID = makers.makerID";

	//qry1の実行
	ResultSet rs = st.executeQuery(qry1);

	//渡された商品IDのデータ格納
	String cname = null;
	String gname = null;
	String price = null;
	String gnote = null;
	String mname = null;
	String cid = null;
	while(rs.next()) {
	cname = rs.getString("categoryName");
	gname = rs.getString("goodsName");
	price = rs.getString("price");
	gnote = rs.getString("goodsNotes");
	mname = rs.getString("makerName");
	cid = rs.getString("categoryID");
	}

	//接続のクローズ
	rs.close();
	st.close();
	cn.close();
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品更新フォーム1」</title>
</head>
<body background="./images/hanep.gif">
	<h2 style="background-color: #ff00ff">商品マスターメンテナンス<<削除処理>></h2>
	<p>商品削除フォーム</p>

<!-- 商品削除フォーム　サーブレットに処理を渡す -->
	<form action="http://localhost:8080/developmentExercise/GoodsMaintenance2"
		method="POST">
		<p>
			商品ID <%= gid %>
			<input type="hidden" name="goodsID" value="<%= gid %>">
		</p>

		<p>
			カテゴリー <%= cname %>
			<input type="hidden" name="categoryID" value="<%= cid %>">
		</p>

		<p>
			商品名 <%= gname %>
		</p>
		<p>
			価格 <%= price %>
		</p>
		<p>
			備考 <%= gnote %>
		</p>
		<p>
			メーカー <%= mname %>
		</p><br/>

		<p>上記の商品を削除します。よろしいですか？</p>
		<a><input type="submit" value="削除"></a>
		<input type="hidden" name="maintenanceMode" value="3">
		</form>

<!-- 削除の取り消しフォーム -->
		<form action="./listGoods2.jsp" method="post">
		<input type="submit" value="削除の取消し">
		<input type="hidden" name="categoryID" value="<%= cid %>">
		</form>

</body>
</html>