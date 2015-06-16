<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page session="true"%>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String reqGoodsID = request.getParameter("goodsID");

	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	String usr = "root";
	String pw = "";

	//データベースへの接続
	Connection cn = DriverManager.getConnection(url, usr, pw);

	String sql = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

%>

<!DOCTYPE html>
<html>
<head>
<%

	/*入力チェック
	if (request.getParameter("makerID") != null) {
		gName = request.getParameter("goodsName");
		gNote = request.getParameter("goodsNotes");
		gprice = request.getParameter("price");
		mID = request.getParameter("makerID");
		//session.invalidate();
		if (gName.matches(".+") && gprice.matches("\\d*")) {
			session.setAttribute("goodsID", gid);
			session.setAttribute("goodsName", gName);
			session.setAttribute("goodsNotes", gNote);
			session.setAttribute("price", gprice);
			session.setAttribute("makerID", mID);
			session.setAttribute("categoryID", cid);
			session.setAttribute("maintenanceMode", "2");

			pageContext.forward("/GoodsMaintenance2");
		}*/
%>
<%
	//if (!(gName.matches(".+"))) {
%>
<p>
	<font color="#FF0000">商品名を入力してください。</font>
</p>
<%
	/*}
		if (!(gprice.matches("\\d+"))) {*/
%>
<p>
	<font color="#FF0000">価格を入力してください。（半角数字のみ）</font>
</p>
<%/*
	}
	}*/
%>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品追加フォーム1」</title>
</head>
<body background="./images/hanep.gif">
	<h2 style="background-color: #ff00ff">商品マスターメンテナンス((追加処理))</h2>
	<form action="http://localhost:8080/developmentExercise/goodsMaintenance/GoodsMaintenance1_" method="POST">

		<p>
			商品ID
			<%=reqGoodsID%>
			<input type="hidden" name="goodsID" value="<%=reqGoodsID%>">
		</p>

		<p>
			カテゴリー <select name="categoryID">
<%
					sql = "SELECT * FROM goods WHERE goodsID = ?";
					pst = cn.prepareStatement(sql);
					pst.setString(1, reqGoodsID);
					rs = pst.executeQuery();
					int categoryID = 0;
					int makerID = 0;
					while(rs.next()) {
					categoryID = rs.getInt("categoryID");
					makerID = rs.getInt("makerID");
					}
					rs.close();

					sql = "SELECT * FROM categories";
					pst = cn.prepareStatement(sql);
					rs = pst.executeQuery();
					while(rs.next()) {
%>
				<option value="<%= rs.getInt("categoryID")%>"
<%				if(rs.getInt("categoryID") == categoryID) {
					out.print(" selected");
				}
%>
				><%= rs.getString("categoryName")%>
<%
				} //end of while
				rs.close();
%>
			</option>
			</select>
		</p>
<%
				sql = "SELECT * FROM goods WHERE goodsID = ?";
				pst = cn.prepareStatement(sql);
				pst.setString(1, reqGoodsID);
				rs = pst.executeQuery();
				while(rs.next()) {
					String goodsNotes = rs.getString("goodsNotes");
					if(goodsNotes == null) {
						goodsNotes = "";
					}
%>
		<p>
			商品名 <input type="text" name="goodsName" value="<%=rs.getString("goodsName")%>">
		</p>
		<p>
			価格 <input type="text" name="price" value="<%=rs.getInt("price")%>">
		</p>
		<p>
			備考 <input type="text" name="goodsNotes" value="<%=goodsNotes%>">
		</p>
<%
				} //end of while()
		rs.close();
%>
		<p>
			メーカー <select name="makerID">
<%
			sql = "SELECT * FROM makers";
			pst = cn.prepareStatement(sql);
			rs = pst.executeQuery();
			while(rs.next()) {
%>
				<option value="<%=rs.getInt("makerID")%>"
<%
				if(rs.getInt("makerID") == makerID) {
					out.print(" selected");
				}
%>
				><%=rs.getString("makerName")%></option>
<%
			} //end of while()
%>
			</select>
		</p>
		<br />
		<p>上記の商品を更新します。よろしいですか？</p>
		<a><input type="submit" value="更新" onclick='return check()'></a>
		<a><input type="reset" value="リセット"></a> <input type="hidden" name="maintenanceMode" value="2">
	</form>
	<br />
	<form action="listGoods1_.jsp" method="POST">
		<input type="submit" value="更新の取消"> <input type="hidden"
			name="categoryID" value="<%=categoryID%>">
	</form>
<%
	rs.close();
	cn.close();
%>
</body>
</html>