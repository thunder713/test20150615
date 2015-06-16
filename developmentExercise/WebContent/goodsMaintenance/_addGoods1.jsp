<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page session = "true" %>
<%@ page import="java.util.regex.*"%>

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

	<!--  <CENTER>  -->

	<!-- ページタイトル -->
	<TABLE align="center">
		<TD id="pageHead">■ 商品マスターメンテナンス《追加処理》</TD>
	</TABLE>

<%


// データベースへ接続する。
   String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
    String usr = "root";
    String pw = "";

    //データベースへの接続
    Connection cn = DriverManager.getConnection(url, usr, pw);

	String sql = null;
	PreparedStatement pst = null;
	ResultSet rs = null;

// リクエストパラメーターを取得する。
	int reqCategoryID = Integer.parseInt(request.getParameter("categoryID"));

	//セッションの追分
	String sGoodsID = null;
	String sGoodsName = null;
	int sPrice = 0;
	String sGoodsNotes = null;
	int sMakerID = 0;
	int mMode = 0;



	if(request.getParameter("makerID") != null) {
//商品IDのチェック
	if(request.getParameter("goodsID").matches("^\\d{3}-\\d{5}")) {
		sGoodsID = request.getParameter("goodsID");
	}else {
		out.print("<P><font color=\"#FF0000\">商品IDを入力してください。(xxx-xxxxx形式です。(xは半角数値0~9))</font></P>");
	}
//カテゴリーIDのチェック
	sql = "SELECT * FROM categories";
	pst = cn.prepareStatement(sql);
	rs = pst.executeQuery();
	for(int i=1; rs.next(); i++) {
		if(rs.next() == false) {
			out.print("<P>" + request.getParameter("categoryID") + "なんてカテゴリーIDは存在しません。</P>");
		}
		else if(Integer.parseInt(request.getParameter("categoryID")) == rs.getInt("categoryID")) {

			break;
		}
		} //end of for
	rs.close();
//商品名のチェック
	if(request.getParameter("goodsName").matches(".{1,40}")) {
		sGoodsName = request.getParameter("goodsName");
	} else {
		out.print("<P><font color=\"#FF0000\">商品名を入力してください。(40文字以内)</font></P>");
	}
//価格のチェック
	if(request.getParameter("price").matches("\\d.{1,10}&&^\\s&&^\\x20&&^□")) {
		sPrice = Integer.parseInt(request.getParameter("price"));
	} else {
		out.print("<P><font color=\"#FF0000\">価格を入力してください。(数値のみ、\\2147483647までの価格)</font></P>");
	}
//備考のチェック
	if(request.getParameter("goodsNotes").matches(".{1,40}")) {
		sGoodsNotes = request.getParameter("goodsNotes");
	} else {
		out.print("<P><font color=\"#FF0000\">備考を40文字以内で入力してください。</font></P>");
	}
//メーカーIDのチェック
	sql = "SELECT * FROM makers";
	pst = cn.prepareStatement(sql);
	rs = pst.executeQuery();

	for(int i=1; rs.next(); i++) {
		if(rs.next() == false) {
			out.print("<P>" + request.getParameter("makerID") + "なんてメーカーIDは存在しません。</P>");
		}
		else if(request.getParameter("makerID").matches(Integer.toString(rs.getInt("makerID")))) {
			sMakerID = Integer.parseInt(request.getParameter("makerID"));
			break;
		}
		} //end of for
	rs.close();
//モードチェック
	if(request.getParameter("maintenanceMode").matches("1")) {
		mMode = Integer.parseInt(request.getParameter("maintenanceMode"));
	} else {
		out.print("ありえないんだけど！？");
	}

//int型の範囲  -2147483648 ～ 2147483647
	session.setAttribute("goodsID", sGoodsID);
	session.setAttribute("categoryID", reqCategoryID);
	session.setAttribute("goodsName", sGoodsName);
	session.setAttribute("price", sPrice);
	session.setAttribute("goodsNotes", sGoodsNotes);
	session.setAttribute("makerID", sMakerID);
	session.setAttribute("maintenanceMode", mMode);

	//サーブレットに処理投げましょう！
	if(sGoodsID == "999-99999") {
	pageContext.forward("/goodsMaintenance/_GoodsMaintenance1");
	}//end of 正規表現if
	else{
		out.print("おかしいね");
	}
	} //end of get(makerID)のif

%>
	<!-- 商品追加フォーム -->
	<FORM method="POST" action="_addGoods1.jsp">

	<TABLE id="addGoods" style="margin-top:70px;">

		<CAPTION>商品追加フォーム</CAPTION>

		<TR>
			<TD id="name">商品ID</TD>
			<TD id="value">
<%
	if(request.getParameter("makerID") == null) {
%>
				<INPUT type="text" name="goodsID" size="20">
				XXX-XXXXX形式（Xは、数値）
<%
	} else {
%>
				<INPUT type="text" name="goodsID" value="<%= request.getParameter("goodsID")%>">
<%
	}
%>
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
			<TD id="value">
<%
		if(request.getParameter("makerID") == null) {
%>
			<INPUT type="text" name="goodsName" size="50">
<%
		} else {
%>
			<INPUT type="text" name="goodsName" value="<%= request.getParameter("goodsName")%>">
<%
		}
%>
		</TD>
		</TR>

		<TR>
			<TD id="name">価　格</TD>
			<TD id="value">
<%
		if(request.getParameter("makerID") == null) {
%>
			<INPUT type="text" name="price" size="20">
<%
		} else {
%>
		<INPUT type="text" name="price" value="<%= request.getParameter("price")%>">
<%
		}
%>
		</TD>
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
					<OPTION value="<%= rs.getInt("makerID") %>">
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
	<FORM method="POST" action="_listGoods1.jsp">
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
