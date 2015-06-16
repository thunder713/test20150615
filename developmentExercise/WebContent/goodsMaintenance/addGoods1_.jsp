<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>

<HTML>

<HEAD>
	<TITLE>addGoods1 「商品追加フォーム1」</TITLE>

	<STYLE type="text/css">

		TABLE#addGoods{font-size:90%;}

		TD{filter:alpha(opacity=70);}
		TD#pageHead{width:1000px; color:white; background:mediumPurple; padding:8px;}
		TD#name{width:100px; color:white; background:lightSlateGray; text-align:center;
					padding:4px;}
		TD#value{width:320px; background:lavender; padding:4px;}

	</STYLE>
</HEAD>

<BODY background="images/hanep.gif">

	<CENTER>

	<!-- ページタイトル -->
	<TABLE align="center">
		<TD id="pageHead">■ 商品マスターメンテナンス《追加処理》</TD>
	</TABLE>

<%
	// リクエストパラメーターを取得する。
	int reqCategoryID = Integer.parseInt(request.getParameter("categoryID"));

	// データベースへ接続する。
	   String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	    String usr = "root";
	    String pw = "";

	    //データベースへの接続
	    Connection cn = DriverManager.getConnection(url, usr, pw);

	String sql = null;
	PreparedStatement pst = null;
	ResultSet rs = null;
%>
	<!-- 商品追加フォーム -->
	<FORM method="POST" action="http://localhost:8080/developmentExercise/goodsMaintenance/GoodsMaintenance1_">

	<TABLE id="addGoods" style="margin-top:70px;">

		<CAPTION>商品追加フォーム</CAPTION>

		<TR>
			<TD id="name">商品ID</TD>
			<TD id="value">
				<INPUT type="text" name="goodsID" size="20" maxlength="9">
				XXX-XXXXX形式（Xは、数値）
			</TD>
		</TR>

		<TR>
			<TD id="name">カテゴリー</TD>
			<TD id="value">
				<!-- カテゴリー選択リスト -->
				<SELECT name="categoryID">
<%
				// カテゴリーマスターから結果セットを抽出する。
				sql = "SELECT * FROM categories ORDER BY categoryID";
				pst = cn.prepareStatement(sql);
				rs = pst.executeQuery();

				while(rs.next()){
					int categoryID = rs.getInt("categoryID");
%>
					<OPTION value="<%= categoryID %>"
<%
					// 選択済み項目の設定
					if(categoryID == reqCategoryID){
						out.println(" selected");
					}
%>
					>
						<%= rs.getString("categoryName") %>
					</OPTION>
<%
				}// end of while()

				rs.close();
%>
				</SELECT>
			</TD>
		</TR>

		<TR>
			<TD id="name">商品名</TD>
			<TD id="value"><INPUT type="text" name="goodsName" size="50"></TD>
		</TR>

		<TR>
			<TD id="name">価　格</TD>
			<TD id="value"><INPUT type="text" name="price" size="20"></TD>
		</TR>

		<TR>
			<TD id="name">備　考</TD>
			<TD id="value"><INPUT type="text" name="goodsNotes" size="50"></TD>
		</TR>

		<TR>
			<TD id="name">メーカー</TD>
			<TD id="value">
				<!-- メーカー選択リスト -->
				<SELECT name="makerID">
<%
				// メーカーマスターから結果セットを抽出する。
				sql = "SELECT * FROM makers ORDER BY makerID";
				pst = cn.prepareStatement(sql);
				rs = pst.executeQuery();

				while(rs.next()){
%>
					<OPTION value="<%= rs.getString("makerID") %>">
						<%= rs.getString("makerName") %>
					</OPTION>
<%
				}// end of while()

				rs.close();
%>
				</SELECT>
			</TD>
		</TR>

	</TABLE>

		<P>上記の商品を追加します。よろしいですか？</P>

		<INPUT type="submit" value="　追加　">
		<INPUT type="reset" value="　ﾘｾｯﾄ　">
		<INPUT type="hidden" name="maintenanceMode" value="1">
	</FORM>

	<!-- 追加処理取消しフォーム -->
	<FORM method="POST" action="listGoods1_.jsp">
		<INPUT type="submit" value="追加の取消し">
		<INPUT type="hidden" name="categoryID" value="<%= reqCategoryID %>">
	</FORM>
<%
	// データベースから切断する。
	cn.close();
%>

	</CENTER>

</BODY>

</HTML>
