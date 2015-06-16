<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.naming.*,java.sql.* ,javax.sql.* , java.text.*" %>

<html>
<head>
	<title>placeholder</title>
	<link href="./css/style.css" type="text/css" rel="stylesheet" />
</head>
<body>
<div id="wrap">
<%
//データベースへの接続
    String url = "jdbc:mysql://localhost:3306/developmentexercise?useUnicode=true&characterEncoding=utf8";
    String usr = "root";
    String pw = "";
    Connection cn = DriverManager.getConnection(url, usr, pw);
//  sql文字列セット用変数の型が違います。
	PreparedStatement pst = null;
//	Statement st = null;
	String sql = null;
	ResultSet rs = null;

%>
<!-- カテゴリー選択フォーム -->
<!-- formのaction先を空にすると自ファイル指定となります -->
	<form method="POST" action="">
		<select name="categoryID">
			<option value="1">ダイニング＆キッチン</option>
			<option value="2">リビングルーム</option>
			<option value="10">楽器</option>
		</select>
		<input type="submit" value="カテゴリーの変更">
			<p>カテゴリーを選択後、ボタンをクリックしてください。</p>
	</form>
	<!-- カテゴリー別商品一覧表 -->
<%
	int reqCategoryID = 1;
	//デフォルトで1の表示
	if(request.getParameter("categoryID") != null){
		reqCategoryID = Integer.parseInt(request.getParameter("categoryID"));
	}
	//「商品一覧」に表示する結果セットを抽出する。
	//ORDER BY句で指定カラムの降順、昇順で結果セットのsortが出来ます。
	//ASC(昇順：省略可能） DESC（降順）
	sql =  "SELECT * FROM goods, makers " +
		   "WHERE goods.makerID = makers.makerID " +
		   "AND categoryID = ? ORDER BY goodsID DESC";
	//埋め込み値の変数セット
	//プレースフォルダは?（パラメーター）の部分に後から埋め込めます。
	String reqGoodsID = request.getParameter("goodsID");
	//プリペアドステートメントセット
	pst = cn.prepareStatement(sql);
	//パラメーターセット
	//?の個数分1からの整数値でセット
	pst.setInt(1, reqCategoryID);
	rs = pst.executeQuery();
%>
	<table>
		<tr>
			<th class="first">No.</th>
			<th>商品ID</th>
			<th>商品名</th>
			<th>価格</th>
			<th>備 考</th>
			<th>メーカー</th>
		</tr>
<%
	// 通貨編集オブジェクトを生成する。
	//int,dobleを指定形式フォーマット
			DecimalFormat df = new DecimalFormat("\\#,##0");
	//「商品一覧」を出力する。
	int i;
	for(i = 1; rs.next(); i++){
		String goodsID = rs.getString("goodsID");
		String goodsNotes = rs.getString("goodsNotes");
		if(goodsNotes == null){
			goodsNotes = "";
		}
%>
		<tr>
			<td class="first"> <%= i %></td>
			<td><%= goodsID %></td>
			<td><%= rs.getString("goodsName") %></td>
			<td><%= df.format(rs.getInt("price")) %></td>
			<td><%= goodsNotes %></td>
			<td><%= rs.getString("makerName") %></td>
		</tr>
<%
	// 10行間隔で、ページトップへのリンク文字列を出力する。
		if(i % 10 == 0){
			out.println("<tr>\n<td class='notice' colspan='2'><a href='#'>ページトップ</td>\n</tr>\n");
		}// end of if()
	}// end of for()
	out.println("</table>\n");
	if(i == 1){
		out.println("<P>このカテゴリーに登録された商品は、ありません。</P>");
	}
	//プレースフォルダ複数セットの例
		sql = "INSERT INTO goods VALUES(?, 1, ?, ?, '素敵', ?)";
		pst = cn.prepareStatement(sql);
		pst.setString(1, "011-00000");
		String gname = "素敵なあれ";
		pst.setString(2, gname);
		pst.setInt(3, 900);
		pst.setInt(4, 911);
//		pst.executeUpdate();
	// データベースから切断する。
	cn.close();
%>
</div>
</body>
</html>