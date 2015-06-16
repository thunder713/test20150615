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
	String gid = request.getParameter("goodsID");
	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	String usr = "root";
	String pw = "";

	//データベースへの接続
	Connection cn = DriverManager.getConnection(url, usr, pw);

	Statement st = cn.createStatement();
	Statement st1 = cn.createStatement();
	Statement st2 = cn.createStatement();

	//SQL文
	String qry1 = "SELECT goods.makerID, goods.categoryID, categories.categoryName, goods.goodsName, goods.price, goods.goodsNotes, makers.makerName FROM goods, makers, categories WHERE goods.goodsID = '"
			+ gid
			+ "' AND goods.categoryID = categories.categoryID AND goods.makerID = makers.makerID";

	String qry2 = "SELECT * FROM categories";

	String qry3 = "SELECT * FROM makers";

	ResultSet rs = st.executeQuery(qry1);

	//渡された商品IDのデータ格納
	String cname = null;
	String gname = null;
	String price = null;
	String gnote = null;
	String mname = null;
	int cid = 0;
	int mid = 0;
	while (rs.next()) {
		cname = rs.getString("categoryName");
		gname = rs.getString("goodsName");
		price = rs.getString("price");
		gnote = rs.getString("goodsNotes");
		mname = rs.getString("makerName");
		cid = rs.getInt("categoryID");
		mid = rs.getInt("makerID");
	}

	//qry2
	ResultSet rs1 = st1.executeQuery(qry2);
	ArrayList<Integer> pcid = new ArrayList<Integer>();
	ArrayList<String> pcname = new ArrayList<String>();
	while (rs1.next()) {
		pcid.add(rs1.getInt("categoryID"));
		pcname.add(rs1.getString("categoryName"));
	}

	//qry3の列の値の取得
	ResultSet rs2 = st2.executeQuery(qry3);
	ArrayList<Integer> pmid = new ArrayList<Integer>();
	ArrayList<String> pmname = new ArrayList<String>();
	while (rs2.next()) {
		pmid.add(rs2.getInt("makerID"));
		pmname.add(rs2.getString("makerName"));
	}

	//接続のクローズ
	rs.close();
	st.close();
	rs1.close();
	st1.close();
	rs2.close();
	st2.close();
	cn.close();
%>

<!DOCTYPE html>
<html>
<head>
<%
	String gID = null;
	String gName = null;
	String gNote = null;
	String gprice = null;
	String mID = null;

	//入力チェック
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
		}
%>
<%
	if (!(gName.matches(".+"))) {
%>
<p>
	<font color="#FF0000">商品名を入力してください。</font>
</p>
<%
	}
		if (!(gprice.matches("\\d+"))) {
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
	<form
		action="./updateGoods.jsp"
		method="POST">

		<p>
			商品ID
			<%=gid%>
			<input type="hidden" name="goodsID" value="<%=gid%>">
		</p>

		<p>
			カテゴリー <select name="categoryID">
				<%
					for (int i = 0; i < pcid.size(); i++) {
						if (cid != pcid.get(i)) {
				%>
				<option value="<%=pcid.get(i)%>"><%=pcname.get(i)%></option>
				<%
					} else {
				%>
				<option value="<%=pcid.get(i)%>" selected><%=pcname.get(i)%></option>
				<%
					}
					}
				%>
			</select>
		</p>

		<p>
			商品名 <input type="text" name="goodsName" value="<%=gname%>">
		</p>
		<p>
			価格 <input type="text" name="price" value="<%=price%>">
		</p>
		<p>
			備考 <input type="text" name="goodsNotes" value="<%=gnote%>">
		</p>

		<p>
			メーカー <select name="makerID">
				<%
					for (int i = 0; i < pmid.size(); i++) {
						if (mid != pmid.get(i)) {
				%>
				<option value="<%=pmid.get(i)%>"><%=pmname.get(i)%></option>
				<%
					} else {
				%>
				<option value="<%=pmid.get(i)%>" selected><%=pmname.get(i)%></option>
				<%
					}
					}
				%>
			</select>
		</p>
		<br />
		<p>上記の商品を更新します。よろしいですか？</p>
		<a><input type="submit" value="更新" onclick='return check()'></a>
		<a><input type="reset" value="リセット"></a> <input type="hidden"
			name="maintenanceMode" value="2">
	</form>
	<br />
	<form action="./listGoods2.jsp" method="POST">
		<input type="submit" value="更新の取消"> <input type="hidden"
			name="categoryID" value="<%=cid%>">
	</form>
</body>
</html>