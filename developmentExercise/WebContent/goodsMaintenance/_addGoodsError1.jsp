<%@ page contentType="text/html; charset=UTF-8" %>

<HTML>

<HEAD>
	<TITLE>addGoodsError1 「商品追加エラー1」</TITLE>

	<STYLE type="text/css">

		TD{filter:alpha(opacity=70);}
		TD#pageHead{width:1000px; color:white; background:mediumPurple; padding:8px;}

	</STYLE>
</HEAD>

<BODY background="images/hanep.gif">

	<CENTER>

	<!-- ページタイトル -->
	<TABLE align="center">
		<TD id="pageHead">■ 商品マスターメンテナンス《追加エラー》</TD>
	</TABLE>

<%
	// リクエストパラメーターを取得する。
	String goodsID = request.getParameter("goodsID");
	String categoryID = request.getParameter("categoryID");
%>

	<P>商品マスターへの追加処理でエラーが発生しました。</P>
	<P>指定された商品ID「<%= goodsID %>」は、すでに登録されている可能性があります。</P>

	<P><A href="_addGoods1.jsp?categoryID=<%= categoryID %>">
											「商品追加フォーム」へ戻る</A></P>

	<P>「商品追加フォーム」の入力データ－を保持したい場合は、
							ブラウザーの「戻る」をクリックしてください。</P>

	</CENTER>

</BODY>

</HTML>
