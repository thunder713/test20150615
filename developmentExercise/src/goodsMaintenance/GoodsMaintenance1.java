package goodsMaintenance;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/GoodsMaintenance1")
public class GoodsMaintenance1 extends HttpServlet
{

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException
	{
		request.setCharacterEncoding("UTF-8");

		String	goodsID = request.getParameter("goodsID");

		int categoryID = Integer.parseInt(request.getParameter("categoryID"));

		String goodsName = request.getParameter("goodsName");

		String	price = request.getParameter("price");

		String goodsNotes = request.getParameter("goodsNotes");

		int makerID = Integer.parseInt(request.getParameter("makerID"));


		HttpSession hs = request.getSession(true);
		hs.setAttribute("goodsID", goodsID);
		hs.setAttribute("categoryID", categoryID);
		hs.setAttribute("goodsName", goodsName);
		hs.setAttribute("price", price);
		hs.setAttribute("goodsNotes", goodsNotes);
		hs.setAttribute("makerID", makerID);
		try {
			response.setContentType("text/html; charset=UTF-8");

			String url = "jdbc:mysql://localhost/developmentExercise";
			String usr = "root";
			String pw = "";

			Connection cn = DriverManager.getConnection(url, usr, pw);

			Statement st = cn.createStatement();
			if(goodsID.length() == 9){
			String qry1 = "INSERT INTO goods(goodsID, categoryID, goodsName, price, goodsNotes, makerID) VALUES ('" + goodsID + "', '" + categoryID + "', '" + goodsName + "', '" + price + "', '" + goodsNotes + "', '" + makerID + "')";
			st.executeUpdate(qry1);
			}

			st.close();
			cn.close();
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/listGoods1.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);

		}catch (SQLException e){
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError1.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
		catch (NumberFormatException e){
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError1.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
		catch (Exception e)
		{
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError1.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
	}
}

