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

	String cID = request.getParameter("categoryID");
	int icID = 0;
	if (cID != null)
		icID = Integer.parseInt(cID);

	String gID = null;
	String gName = null;
	String gNote = null;
	String price = null;
	String mID = null;

	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
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
	while (rs.next()) {
		cname.add(rs.getString("categoryName"));
		cid.add(rs.getInt("categoryID"));
	}

	//qry2の列の値の取得
	ResultSet rs1 = st1.executeQuery(qry2);
	ArrayList<String> mname = new ArrayList<String>();
	ArrayList<Integer> mid = new ArrayList<Integer>();
	while (rs1.next()) {
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

<!DOCTYPE html>
<html>
<head>
<%
	//入力チェック
	if (request.getParameter("makerID") != null) {
		gID = request.getParameter("goodsID");
		gName = request.getParameter("goodsName");
		gNote = request.getParameter("goodsNotes");
		price = request.getParameter("price");
		mID = request.getParameter("makerID");
		if (gID.matches("^\\d{3}-\\d{5}") && gName.matches(".+") && price.matches("\\d+")) {
			session.setAttribute("goodsID", gID);
			session.setAttribute("goodsName", gName);
			session.setAttribute("goodsNotes", gNote);
			session.setAttribute("price", price);
			session.setAttribute("makerID", mID);
			session.setAttribute("categoryID", cID);
			session.setAttribute("maintenanceMode", "1");

			pageContext.forward("/GoodsMaintenance2");
		}
		if (!(gID.matches("^\\d{3}-\\d{5}"))) {
%>
<p>
	<font color="#FF0000">商品IDを入力してください。(xxx-xxxxx, (xは半角数字))</font>
</p>
<%
		}
		if (!(gName.matches(".+"))) {
%>
<p>
	<font color="#FF0000">商品名を入力してください。</font>
</p>
<%
		}
		if (!(price.matches("\\d+"))) {
%>
<p>
	<font color="#FF0000">価格を入力してください。（半角数字のみ）</font>
</p>
<%
		}
	}
%>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品追加フォーム1」</title>
</head>
<body background="./images/hanep.gif">
	<h2 style="background-color: #ff00ff">商品マスターメンテナンス((追加処理))</h2>
	<form action="./addGoods2.jsp" method="POST">
		<p>
			商品ID<input type="text" name="goodsID" size="20"
			<% if (request.getParameter("makerID") != null) { %>
			value="<%= gID %>"
			<% } %> >
			XXX-XXXXX形式（Xは、数値）
		</p>

		<p>
			カテゴリー <select name="categoryID">
				<%
					for (int i = 0; i < cname.size(); i++) {
						if (icID != cid.get(i)) {
				%>
				<option value="<%=cid.get(i)%>"><%=cname.get(i)%></option>
				<%
					} else {
				%>
				<option value="<%=cid.get(i)%>" selected><%=cname.get(i)%></option>
				<%
					}
					}
				%>
			</select>
		</p>

		<p>
			商品名 <input type="text" name="goodsName"
			<% if (request.getParameter("makerID") != null) { %>
			value="<%= gName%>"
			<% } %> >
		</p>
		<p>
			価格<input type="text" name="price"
			<% if (request.getParameter("makerID") != null) { %>
			value="<%= price%>"
			<% } %> >
		</p>
		<p>
			備考<input type="text" name="goodsNotes"
			<% if (request.getParameter("makerID") != null) { %>
			value="<%= gNote%>"
			<% } %> >
		</p>

		<p>
			メーカー <select name="makerID">
				<%
					for (int i = 0; i < mname.size(); i++) {
				%>
				<option value="<%=mid.get(i)%>"><%=mname.get(i)%></option>
				<%
					}
				%>
			</select>
		</p>
		<br />
		<p>上記の商品を追加します。よろしいですか？</p>
		<a><input type="submit" value="追加"></a> <input type="hidden"
			name="maintenanceMode" value="1"> <a><input type="reset"
			value="リセット"></a>
	</form>
	<br />

	<form action="./listGoods2.jsp" method="POST">
		<input type="submit" value="追加の取消し"> <input type="hidden"
			name="categoryID" value="<%=cID%>">
	</form>
</body>
</html>