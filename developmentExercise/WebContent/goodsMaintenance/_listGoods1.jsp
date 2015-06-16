<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.text.*" %>

<HTML>

<HEAD>
	<TITLE>listGoods1 「カテゴリー別商品一覧1」</TITLE>

	<STYLE type="text/css">

		TABLE#category_AddGoods{color:white; font-size:80%;}
		TABLE#listGoods{font-size:80%;}

		TR#listHead{color:white; background:lightSlateGray; text-align:center;}
		TR#listNormal{background:lavender;}
		TR#listReverse{color:white; background:black;}

		TD{filter:alpha(opacity=70);}
		TD#pageHead{width:1000px; color:white; background:mediumPurple; padding:8px;}
		TD#formCategory{width:500px; background:salmon; padding:8px;}
		TD#formAddGoods{width:500px; background:mediumAquaMarine; padding:8px;}
		TD#list{padding:4px;}

	</STYLE>
</HEAD>

<BODY background="images/hanep.gif">

	<!-- ページタイトル -->
	<TABLE align="center">
		<TD id="pageHead">■ カテゴリー別商品一覧
			《<A href="index_.jsp">演習メニューにもどる</A>》
		</TD>
	</TABLE>

<%
	// リクエストパラメーターを取得する。
	String reqGoodsID = request.getParameter("goodsID");
	int reqCategoryID = 1;
	if(request.getParameter("categoryID") != null){

		reqCategoryID = Integer.parseInt(request.getParameter("categoryID"));
	}

	// データベースへ接続する。
    String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
    String usr = "root";
    String pw = "";

    //データベースへの接続
    Connection cn = DriverManager.getConnection(url, usr, pw);

	String sql = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

	//「カテゴリーマスター」から結果セットを抽出する。
	sql = "SELECT * FROM categories ORDER BY categoryID";
	pst = cn.prepareStatement(sql);
	rs = pst.executeQuery();
%>
	<TABLE id="category_AddGoods" align="center">

	<TD id="formCategory">
		<!-- カテゴリー選択フォーム -->
		<FORM method="POST" action="_listGoods1.jsp">
			<SELECT name="categoryID">
<%
			while(rs.next()){
				int categoryID = rs.getInt("categoryID");
%>
				<OPTION value="<%= categoryID %>"
<%
					// リクエストされた「カテゴリーID」を選択済み項目に設定する。
					if(categoryID == reqCategoryID){

						out.print(" selected");
					}
%>
				>
					<%= rs.getString("categoryName") %>
				</OPTION>
<%
			}// end of while()
%>
			</SELECT>

			<INPUT type="submit" value="カテゴリーの変更">
			<P>カテゴリーを選択後、ボタンをクリックしてください。</P>
		</FORM>
	</TD>

	<TD id="formAddGoods">
		<!-- 商品追加リクエストフォーム -->
		<FORM method="POST" action="_addGoods1.jsp">
			<INPUT type="submit" value="新しい商品の追加">
			<P>新しい商品を追加する場合は、ボタンをクリックしてください。</P>

			<INPUT type="hidden" name="categoryID" value="<%= reqCategoryID %>">
		</FORM>
	</TD>

	</TABLE>

	<!-- カテゴリー別商品一覧表 -->
	<TABLE id="listGoods" align="center">
		<TR id="listHead">
			<TD id="list" style="width:25px;"></TD>
			<TD id="list" style="width:100px;">商品ID</TD>
			<TD id="list" style="width:300px;">商品名</TD>
			<TD id="list" style="width:75px;">価格</TD>
			<TD id="list" style="width:200px;">備 考</TD>
			<TD id="list" style="width:200px;">メーカー</TD>
			<TD id="list" style="width:50px;"></TD>
			<TD id="list" style="width:50px;"></TD>
		</TR>
<%
	//「商品一覧」に表示する結果セットを抽出する。
	sql = "SELECT * FROM goods, makers WHERE goods.makerID = makers.makerID "
					+ "AND categoryID = ? ORDER BY goodsID";
	pst = cn.prepareStatement(sql);
	pst.setInt(1, reqCategoryID);
	rs = pst.executeQuery();

	// 通貨編集オブジェクトを生成する。
	DecimalFormat df = new DecimalFormat("\\#,##0");

	//「商品一覧」を出力する。
	int i;
	for(i = 1; rs.next(); i++){

		String goodsID = rs.getString("goodsID");
		String goodsNotes = rs.getString("goodsNotes");
		if(goodsNotes == null){
			goodsNotes = "";
		}

		if(!goodsID.equals(reqGoodsID)){
%>
		<TR id="listNormal">
<%
		}else{
%>
		<TR id="listReverse">
<%
		}
%>
		<TD id="list" style="width:25px; text-align:right;"><%= i %></TD>
		<TD id="list" style="width:100px; text-align:center;">
					<%= goodsID %></TD>
		<TD id="list" style="width:300px; text-align:left;">
					<%= rs.getString("goodsName") %></TD>
		<TD id="list" style="width:75px; text-align:right;">
					<%= df.format(rs.getInt("price")) %></TD>
		<TD id="list" style="width:200px; text-align:left;">
					<%= goodsNotes %></TD>
		<TD id="list" style="width:200px; text-align:left;">
					<%= rs.getString("makerName") %></TD>
		<TD id="list" style="width:50px; text-align:center;"><a href="./_updateGoods.jsp?goodsID=<%= goodsID%>">更新</a></TD>
		<TD id="list" style="width:50px; text-align:center;"><a href="./_deleteGoods.jsp?goodsID=<%= goodsID%>">削除</a></TD>
	</TR>
<%
		// 10行間隔で、ページトップへのリンク文字列を出力する。
		if(i % 10 == 0){
%>
			<TR>
				<TD colspan="8"><A href="#">ページトップへスクロールする</TD>
			</TR>
<%
		}// end of if()

	}// end of for()
%>
	</TABLE>

<%
	if(i == 1){
		out.println("<P>このカテゴリーに登録された商品は、ありません。</P>");
	}

	// データベースから切断する。
	cn.close();
%>

</BODY>

</HTML>