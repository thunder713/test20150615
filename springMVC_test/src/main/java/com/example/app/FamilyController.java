package com.example.app;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 家族の名前をJSON形式で返却するAPIクラスです。
 */
@Controller
public class FamilyController {

	private static final Logger logger = LoggerFactory
			.getLogger(FamilyController.class);

	@RequestMapping(value = "/family", method = RequestMethod.GET)
	public String home(HttpServletRequest request, Locale locale, Model model) {
		logger.debug("API start");

		model.addAttribute("callback", request.getParameter("callback"));

		// ファミリークラスに名前をセットします。
		Family family = new Family();
		family.setFirstName("カツオ");
		family.setLastName("磯野");

		// リターンコード＆メッセージをセットします。
		Message message = new Message();
		message.setReturnCode(0);
		message.setMessage("success");

		// ファミリークラス、メッセージクラスをJSON化します。
		String jsonFamily = JSON.encode(family);
		String jsonMessage = JSON.encode(message);

		// jspにJSONを表示させるよう設定します。
		model.addAttribute("responseData", jsonFamily);
		// jspにメッセージを表示させるよう設定します。
		model.addAttribute("responsMessage", jsonMessage);

		return "response";
	}

	/**
	 * 家族の名前を入れるクラスです。
	 */
	private class Family {
		// 名
		private String firstName;
		// 姓
		private String lastName;

		public String getFirstName() {
			return firstName;
		}

		public void setFirstName(String firstName) {
			this.firstName = firstName;
		}

		public String getLastName() {
			return lastName;
		}

		public void setLastName(String lastName) {
			this.lastName = lastName;
		}
	}

	/**
	 * APIのリターンメッセージを入れるクラスです。
	 */
	private class Message {
		// 戻り値
		private int returnCode;
		// メッセージ
		private String message;

		public int getReturnCode() {
			return returnCode;
		}

		public void setReturnCode(int returnCode) {
			this.returnCode = returnCode;
		}

		public String getMessage() {
			return message;
		}

		public void setMessage(String message) {
			this.message = message;
		}
	}
}
