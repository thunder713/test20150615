/*-------------------------------------------------------------------------------

	■システム開発演習 課題1

	『商品マスターメンテナンス』システム（追加処理のみ）


	プログラム名：『商品マスターメンテナンス処理1』

	プログラムID：GoodsMaintenance1.java

	プログラム分類：Servlet

	作成日：2008/3/6	更新日：

	作成者：横山やすし

-------------------------------------------------------------------------------*/
package goodsMaintenance;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/goodsMaintenance/_GoodsMaintenance1")
public class _GoodsMaintenance1 extends HttpServlet{
	public void doPost(HttpServletRequest request, HttpServletResponse response)
											throws ServletException, IOException{

		// リクエストのエンコーディングを設定する。
		request.setCharacterEncoding("UTF-8");

		// レスポンスのエンコーディングを設定する。
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();

		HttpSession hs = request.getSession(true);
		String goodsID = (String) hs.getAttribute("goodsID");
		int categoryID = new Integer(hs.getAttribute("categoryID").toString()).intValue();
		String goodsName = (String) hs.getAttribute("goodsName");
		int price = new Integer(hs.getAttribute("price").toString()).intValue();
		String goodsNotes = (String) hs.getAttribute("goodsNotes");
		int makerID = new Integer(hs.getAttribute("makerID").toString()).intValue();
		int mMode = new Integer(hs.getAttribute("maintenanceMode").toString()).intValue();


		Connection cn = null;
		String sql = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try{
			String url = "jdbc:mysql://localhost:3306/developmentExercise?useUnicode=true&characterEncoding=utf8";
	         String usr = "root";
	         String pw = "";
       //データベースへの接続
	         cn = DriverManager.getConnection(url, usr, pw);

		switch(mMode){
			case 1:
		// 商品マスターへ新規レコードを挿入する。
	         sql = "INSERT INTO goods VALUES(?, ?, ?, ?, ?, ?)";
	         pst = cn.prepareStatement(sql);
	         pst.setString(1, goodsID);
	         pst.setInt(2, categoryID);
	         pst.setString(3, goodsName);
	         pst.setInt(4, price);
	         pst.setString(5, goodsNotes);
	         pst.setInt(6, makerID);

	         try{
			// INSERT文を送信する。
	        	 pst.executeUpdate();
	         }
	         catch(SQLException e){

			// 挿入エラーが発生した場合は、「追加エラーメッセージ」へリダイレクトする。
	        	 response.sendRedirect("_addGoodsError1.jsp?goodsID=" + goodsID
										+ "&categoryID=" + categoryID);
	        	 return;
	         }

		//「カテゴリー別商品一覧」へリダイレクトする。
	         response.sendRedirect("_listGoods1.jsp?goodsID=" + goodsID
										+ "&categoryID=" + categoryID);
	         break;

			case 2:
				sql = "UPDATE goods SET categoryID = ?, goodsName = ?, price = ?, goodsNotes = ?, makerID = ? WHERE goodsID = ?";
				pst = cn.prepareStatement(sql);
				pst.setInt(1, categoryID);
				pst.setString(2, goodsName);
				pst.setInt(3, price);
				pst.setString(4, goodsNotes);
				pst.setInt(5, makerID);
				pst.setString(6, goodsID);

				try{
					pst.executeUpdate();
				}
				catch(SQLException e){
					response.sendRedirect("_addGoodsError1.jsp?goodsID=" + goodsID
							+ "&categoryID=" + categoryID);
					return;
				}
				response.sendRedirect("_listGoods1.jsp?goodsID=" + goodsID
						+ "&categoryID=" + categoryID);
				break;

			case 3:
				sql = "DELETE FROM goods WHERE goodsID = ?";
				pst = cn.prepareStatement(sql);
				pst.setString(1, goodsID);

				try{
					pst.executeUpdate();
				}
				catch(SQLException e){
					response.sendRedirect("_addGoodsError1.jsp?goodsID=" + goodsID
							+ "&categoryID=" + categoryID);
					return;
				}
				response.sendRedirect("_listGoods1.jsp?goodsID=" + goodsID
						+ "&categoryID=" + categoryID);
				break;

		} //end of switch()
		} //end of try
		catch(Exception e){

			out.println(e);
		}
		finally{

			try{

				// データベースから切断する。
				cn.close();
			}
			catch(Exception e){

				out.println(e);
			}
		}
	}// end of doPost()
}
