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

@WebServlet("/GoodsMaintenance2")
public class GoodsMaintenance2 extends HttpServlet
{

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException,
			IOException
	{
		request.setCharacterEncoding("UTF-8");

		String goodsID = null;
		String categoryID = null;
		String goodsName = null;
		String price = null;
		String goodsNotes = null;
		String makerID = null;
		String mMode = null;

		HttpSession session = request.getSession(true);
		if(((String) session.getAttribute("maintenanceMode")).equals("1")) {
			goodsID = (String) session.getAttribute("goodsID");
			goodsName = (String) session.getAttribute("goodsName");
			price = (String) session.getAttribute("price");
			goodsNotes = (String) session.getAttribute("goodsNotes");
			makerID = (String) session.getAttribute("makerID");
			categoryID = (String) session.getAttribute("categoryID");
			mMode = (String) session.getAttribute("maintenanceMode");
 		}
		else if(((String) session.getAttribute("maintenanceMode")).equals("2")) {
 			goodsID = (String) session.getAttribute("goodsID");
			goodsName = (String) session.getAttribute("goodsName");
			price = (String) session.getAttribute("price");
			goodsNotes = (String) session.getAttribute("goodsNotes");
			makerID = (String) session.getAttribute("makerID");
			categoryID = (String) session.getAttribute("categoryID");
			mMode = (String) session.getAttribute("maintenanceMode");
		}
		else if(((String) request.getParameter("maintenanceMode")).equals("3")) {
			goodsID = request.getParameter("goodsID");
			goodsName = request.getParameter("goodsName");
			price = (String) request.getParameter("price");
			goodsNotes = request.getParameter("goodsNotes");
			makerID = (String) request.getParameter("makerID");
			categoryID = (String) request.getParameter("categoryID");
			mMode = (String) request.getParameter("maintenanceMode");
		}

 		/*session = request.getSession(false);
		goodsID = request.getParameter("goodsID");
		categoryID = request.getParameter("categoryID");
		goodsName = request.getParameter("goodsName");
		price = request.getParameter("price");
		goodsNotes = request.getParameter("goodsNotes");
		makerID = request.getParameter("makerID");
		mMode = (String) request.getParameter("maintenanceMode");
 		}*/

		try {
			response.setContentType("text/html; charset=UTF-8");

			String url = "jdbc:mysql://localhost/developmentExercise?useUnicode=true&characterEncoding=utf8";
			String usr = "root";
			String pw = "";

			Connection cn = DriverManager.getConnection(url, usr, pw);

			Statement st = cn.createStatement();

			switch(mMode){
				case "1":
					String qry1 = "INSERT INTO goods(goodsID, categoryID, goodsName, price, goodsNotes, makerID) VALUES ('" + goodsID + "', '" + categoryID + "', '" + goodsName + "', '" + price + "', '" + goodsNotes + "', '" + makerID + "')";
					st.executeUpdate(qry1);
					st.close();
					cn.close();
					break;
				case "2":
					String qry2 = "UPDATE goods SET categoryID = '"
					+ categoryID + "', goodsName= '"
					+ goodsName + "', price= "
					+ price + ", goodsNotes = '"
					+ goodsNotes + "', makerID = '"
					+ makerID + "' WHERE goodsID = '"
					+ goodsID + "'";
					st.executeUpdate(qry2);
					st.close();
					cn.close();
					break;
				case "3":
					String qry3 = "DELETE FROM goods WHERE goodsID = '"
					+ goodsID + "'";
					st.executeUpdate(qry3);
					st.close();
					cn.close();
					break;
			}
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/listGoods2.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);

		}catch (SQLException e){
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError2.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
		catch (NumberFormatException e){
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError2.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
		catch (Exception e)
		{
			response.sendRedirect("http://localhost:8080/developmentExercise/goodsMaintenance/addGoodsError2.jsp?goodsID=" + goodsID + " &categoryID=" + categoryID);
		}
	}
}

