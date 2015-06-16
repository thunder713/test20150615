<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page session="true"%>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*"%>
<%@ page contentType="text/html; charset=UTF-8" %>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品更新フォーム1」</title>
</head>
<body background="./images/hanep.gif">
	<h2 style="background-color: #ff00ff">商品マスターメンテナンス<<削除処理>></h2>
	<p>商品削除フォーム</p>

<%
	String reqGoodsID = request.getParameter("goodsID");
	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	String usr = "root";
	String pw = "";

	Connection cn = DriverManager.getConnection(url, usr, pw);

	String sql = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

	sql = "SELECT * FROM goods, categories, makers WHERE goods.categoryID = categories.categoryID AND goods.makerID = makers.makerID AND goods.goodsID = ?";
	pst = cn.prepareStatement(sql);
	pst.setString(1, reqGoodsID);
	rs = pst.executeQuery();
%>
	<FORM method="POST" action="http://localhost:8080/developmentExercise/goodsMaintenance/_GoodsMaintenance1">
<%
	int i;
	for(i = 1; rs.next(); i++) {
		String goodsID = rs.getString("goodsID");
		int categoryID = rs.getInt("categoryID");
		String goodsNotes = rs.getString("goodsNotes");
		if(goodsNotes == null) {
			goodsNotes = "";
		}

%>
	<P>商品ID<%= goodsID %></P>
	<INPUT type="hidden" name="goodsID" value="<%= goodsID %>">
	<P>カテゴリー名<%= rs.getString("categoryName") %></P>
	<INPUT type="hidden" name="categoryID" value="<%= categoryID %>">
	<P>商品名<%= rs.getString("goodsName") %></P>
	<P>価格<%= rs.getInt("price") %></P>
	<P>備考<%= rs.getString("goodsNotes") %></P>
	<P>メーカー名<%= rs.getString("makerName") %></P>

	<P>上記の商品を削除します。よろしいですか？</P>
	<INPUT type="submit" value="削除">
	<INPUT type="hidden" name="maintenanceMode" value="3">
	</FORM>

<!-- カテゴリ一覧表に戻る -->
	<FORM method="POST" action="_listGoods1.jsp">
	<INPUT type="submit" value="削除の取消し">
	<INPUT type="hidden" name="categoryID" value="<%= categoryID %>">
	</FORM>

<%

	} // end of for()
	pst.close();
	rs.close();
	cn.close();
%>

</body>
</html>