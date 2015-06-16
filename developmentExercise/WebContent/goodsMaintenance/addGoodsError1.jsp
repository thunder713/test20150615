<%@ page pageEncoding="UTF-8" %>
<%@ page session="true" %>
<% String goodsID = (String) session.getAttribute("goodsID");
Integer categoryID = (Integer) session.getAttribute("categoryID");
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>「商品追加エラー2」</title>
</head>

<body background="./images/hanep.gif">
<h2 style="background-color:#ff00ff">□商品マスターメンテナンス<<追加エラー>></h2>
<center><p>商品マスターへの追加処理でエラーが発生しました。</p>
<p>指定された商品ID<%= goodsID %>は、すでに登録されている可能性があります。</p>
<p><a href="./addGoods1.jsp">「商品追加フォーム」へ戻る</a></p>
<p>「商品追加フォーム」の入力データを保持したい場合は、ブラウザーの「戻る」をクリックしてください。</p>

</center>
</body>
</html>