<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page session="true"%>

<%
	request.setCharacterEncoding("UTF-8");
	String cID = request.getParameter("categoryID");
	if(cID == null) {
		cID = "1";
	}
	//接続の準備
	String url = "jdbc:mysql://localhost:3306/developmentExercise";
	String usr = "root";
	String pw = "";

	//データベースへの接続
	Connection cn = DriverManager.getConnection(url, usr, pw);

	Statement st = cn.createStatement();
	Statement st1 = cn.createStatement();

	String qry1 = "SELECT * FROM categories";

	String qry2 = "SELECT goods.goodsID, goods.goodsName, goods.price, goods.goodsNotes, makers.makerName FROM goods, makers WHERE goods.makerID = makers.makerID AND  goods.categoryID = "
			+ cID + " ORDER BY goods.goodsID ASC";
	//問い合わせ
	ResultSet rs = st.executeQuery(qry1);

	ArrayList<String> cname = new ArrayList<String>();
	ArrayList<Integer> cid = new ArrayList<Integer>();
	while (rs.next()) {
		cname.add(rs.getString("categoryName"));
		cid.add(rs.getInt("categoryID"));
	}

	ResultSet rs1 = st1.executeQuery(qry2);

	ArrayList<String> gid = new ArrayList<String>();
	ArrayList<String> gname = new ArrayList<String>();
	ArrayList<Integer> gprice = new ArrayList<Integer>();
	ArrayList<String> gnote = new ArrayList<String>();
	ArrayList<String> gmid = new ArrayList<String>();
	while (rs1.next()) {
		gid.add(rs1.getString("goodsID"));
		gname.add(rs1.getString("goodsName"));
		gprice.add(rs1.getInt("price"));
		gnote.add(rs1.getString("goodsNotes"));
		gmid.add(rs1.getString("makerName"));
	}

	//接続のクローズ
	rs.close();
	st.close();
	rs1.close();
	st1.close();
	cn.close();
%>

<% session.setAttribute("num", cID);
	String str1 = (String) session.getAttribute("num");
	int num1 = 0;
	if(str1 != null){
		num1 = Integer.parseInt(str1);
	}
	else{
		num1 = 15;
	}

%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; UTF-8">
<title>「カテゴリ別商品一覧表1」</title>
</head>
<body background="./images/hanep.gif">
<a name="top"></a>
	<h2 style="background-color: #ff00ff">
		□カテゴリー別商品一覧 <a href="./index.jsp"><<演習メニューにもどる>></a>
	</h2>
	<table border="1" width="100%" height="100">
		<tr>
			<td width="50%" valign="top" bgcolor="#FF05F2">
				<form action="./listGoods1.jsp" method="post">
					<select name="categoryID">
						<%
							for (int i = 0; i < cname.size(); i++) {
								if(num1 != cid.get(i)) {%>
						<option value="<%=cid.get(i) %>" ><%= cname.get(i) %></option>
						<% } else{ %>
						<option value="<%=cid.get(i)%>" selected><%=cname.get(i)%></option>
						<%
							} }
						%>
					</select> <input type="submit" value="カテゴリーの変更">
				</form> <br />
				<p>
					<font color="#FFF">カテゴリーを選択後、ボタンをクリックしてください。</font>
				</p>
			</td>
			<td valign="top" bgcolor="#03FD82">
				<form action="./addGoods1.jsp" method="POST">
					<input type="submit" value="新しい商品の追加">
				</form> <br />
				<p>
					<font color="#FFF">新しい商品を追加する場合は、ボタンをクリックしてください。</font>
				</p>
			</td>
		</tr>
	</table>


	<table border="1" width="99%">
		<tr bgcolor="#ACA2AE">
			<th></th>
			<th width="12%">商品ID</th>
			<th width="28%">商品名</th>
			<th width="12%">価格</th>
			<th width="23%">備考</th>
			<th width="23%">メーカー</th>
		</tr>
</table>
		<%
			for (int i = 0; i < gid.size(); i++) {
		%>
	<table border="1" width="99%">
		<tr>
			<td><%= (i+1)%></td>
			<td width="12%"><%=gid.get(i)%></td>
			<td width="28%"><%=gname.get(i)%></td>
			<td width="12%"><%=gprice.get(i)%></td>
			<td width="23%"><%=gnote.get(i)%></td>
			<td width="23%"><%=gmid.get(i)%></td>
		</tr>
	<% if( i%10 == 0 && i != 0) { %>

		<a href="#top"><font color="#FF0000">ページトップへスクロールする</font></a>
		<% } } %>
	</table>
	<%
	if(cID != null) {
	if(gid.size() == 0) { %>
		<p>このカテゴリーに登録された商品はありません。</p>
		<% } }%>
</body>
</html>