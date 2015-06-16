<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>

<%
	String postCheck = request.getParameter("addSubmit");

	if(postCheck != null) {
		out.println(postCheck);

		session.setAttribute("goodsID", request.getParameter("goodsID"));
		session.setAttribute("categoryID", request.getParameter("categoryID"));
		session.setAttribute("goodsName", request.getParameter("goodsName"));
		session.setAttribute("price", request.getParameter("price"));
		session.setAttribute("goodsNotes", request.getParameter("goodsNotes"));
		session.setAttribute("makerID", request.getParameter("makerID"));
		session.setAttribute("maintenanceMode", request.getParameter("maintenanceMode"));

		String gID = (String) session.getAttribute("goodsID");

		String errorMessage1 = null;

		boolean errorFlg = false;

		if(gID == null){
			errorMessage1 = "空白です。";
			errorFlg = true;
			}

			if(!errorFlg) {
				RequestDispatcher rd = request.getRequestDispatcher("./listGoods2_.jsp");
				rd.forward(request, response);
				}
		}
%>
<html>
<head>
	<link href="./css/style.css" type="text/css" rel="stylesheet" />
	<TITLE>課題2:updateGoods 「商品更新フォーム」</TITLE>
	<STYLE type="text/css">
		TABLE#updateGoods{font-size:90%;}
		TD{filter:alpha(opacity=70);}
		TD#pageHead{width:1000px; color:white; background:mediumPurple; padding:8px;}
		TD#name{width:100px; color:white; background:lightSlateGray; text-align:center;
					padding:4px;}
		TD#value{width:320px; background:lavender; padding:4px;}
	</STYLE>
</HEAD>
<BODY background="images/hanep.gif">
	<div id="wrap">
	<!-- ページタイトル -->
	<TABLE>
		<TD id="pageHead">■ 商品マスターメンテナンス《更新処理》</TD>
	</TABLE>

<%
		String reqGoodsID = request.getParameter("goodsID");

		String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
		String usr = "root";
		String pw = "";

		Connection cn = DriverManager.getConnection(url, usr, pw);

		String sql = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		sql = "SELECT * FROM goods WHERE goodsID = ?";
		pst = cn.prepareStatement(sql);
		pst.setString(1, reqGoodsID);
		rs = pst.executeQuery();

		if(rs.next()) {
			String rsGoodsID = rs.getString("goodsID");
			int rsCategoryID = rs.getInt("categoryID");
			String rsGoodsName = rs.getString("goodsName");
			int rsPrice = rs.getInt("price");
			String rsGoodsNotes = rs.getString("goodsNotes");

			if(rsGoodsNotes == null) {
				rsGoodsNotes = "";
			}

			int rsMakerID = rs.getInt("makerID");
			rs.close();
%>
<FORM name="formUpdateGoods" method="POST" action="" >
	<TABLE id="updateGoods" >
		<CAPTION>商品更新フォーム</CAPTION>
		<TR>
			<TD id="name">商品ID</TD>
			<TD id="value"><%= rsGoodsID %>
				<INPUT type="hidden" name="goodsID" value="<%= rsGoodsID %>">
			</TD>
		</TR>

		<TR>
			<TD id="name">カテゴリー</TD>
			<TD id="value">
				<!-- カテゴリー選択リスト -->
				<SELECT name="categoryID">
<%
				sql = "SELECT * FROM categories ORDER BY categoryID";
				pst = cn.prepareStatement(sql);
				rs = pst.executeQuery();

				while(rs.next()){
					int categoryID = rs.getInt("categoryID");
%>
					<OPTION value="<%= categoryID %>"
<%
					// 選択済み項目の設定
					if(categoryID == rsCategoryID){
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
			<TD id="value"><INPUT type="text" name="goodsName" value="<%= rsGoodsName %>" size="50"></TD>
		</TR>
		<TR>
			<TD id="name">価　格</TD>
			<TD id="value"><INPUT type="text" name="price" value="<%= rsPrice %>" size="20"></TD>
		</TR>

		<TR>
			<TD id="name">備　考</TD>
			<TD id="value"><INPUT type="text" name="goodsNotes" value="<%= rsGoodsNotes %>" size="50"></TD>
		</TR>

		<TR>
			<TD id="name">メーカー</TD>
			<TD id="value">
				<!-- メーカー選択リスト -->
				<SELECT name="makerID">
<%
				sql = "SELECT * FROM makers ORDER BY makerID";
				pst = cn.prepareStatement(sql);
				rs = pst.executeQuery();

				while(rs.next()){
					int makerID = rs.getInt("makerID");
%>
					<OPTION value="<%= makerID %>"
<%
						// 選択済み項目の設定
						if(makerID == rsMakerID){
							out.println(" selected");
						}
%>
					>
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

		<P>上記の商品を更新します。よろしいですか？</P>

		<INPUT type="submit" name="addSubmit" value="更新">
		<INPUT type="reset" value="　ﾘｾｯﾄ　">

		<INPUT type="hidden" name="maintenanceMode" value="2">

	</FORM>

	<!-- 更新処理取消しフォーム -->
	<FORM method="POST" action="listGoods2_.jsp">
		<INPUT type="submit" value="更新の取消し">
		<INPUT type="hidden" name="categoryID" value="<%= rsCategoryID %>">
	</FORM>
<%
	}// end of if()
	else{

		out.println("<P>更新対象のレコードが見つかりません。</P>");
	}

	// データベースから切断する。
	cn.close();
%>

</div>
</BODY>
</HTML>