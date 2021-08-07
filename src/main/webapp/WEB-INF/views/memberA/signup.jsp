<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Sign-up</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.0/dist/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://www.google.com/recaptcha/api.js"></script>
<style>
* {
	box-sizing: border-box;
}

.container {
	max-width: 600px;
	margin: auto;
}

.wrapper {
	max-width: 300px;
	margin: auto;
}

.logo {
	text-align: center;
}

input {
	width: 100%;
}

button {
	width: 49.2%;
}
</style>
</head>
<body>
	<div class="container p-5 shadow bg-white rounded">
		<center>회원가입</center>

		<form action="${pageContext.request.contextPath}/aMember/signupProc"
			method="post" id="signupForm">
			<div class="wrapper">
				<div class="row">
					<div class="col-12">ID</div>
					<div class="col-12">
						<input type="text" name="emp_id" id="iid"
							placeholder="최소 4자, 영 소문자, 숫자 입력">
					</div>

				</div>
				<div class="row">
					<div class="col-12">PW</div>
					<div class="col-12">
						<input type="password" name="pw" id="ipw"
							placeholder="최소 8 자, 영문, 숫자, 특수 문자가 반드시 들어가야 함.">
					</div>

				</div>
				<div class="row">
					<div class="col-12">Confirm PW</div>
					<div class="col-12">
						<input type="password" id="ipwC" placeholder="비밀번호 확인">
					</div>
				</div>

				<div class="row">
					<div class="col-12" id="pwCheck"></div>
				</div>

				<div class="row">
					<div class="col-12">Name</div>
					<div class="col-12">
						<input type="text" name="name" id="iname"
							placeholder="Username (Only Visible for Reservation)">
					</div>
				</div>

				<div class="row">
					<div class="col-12">Phone</div>
					<div class="col-12">
						<input type="text" name="phone" id="iphone"
							placeholder="ex) 01012341234">
					</div>

				</div>
				<div class="row">
					<div class="col-12">Email</div>
					<div class="col-9">
						<input type="text" name="email" id="iemail"
							placeholder="Enter your Usable Email">
					</div>
					<div class="col-3">
						<button>인증</button>
					</div>
				</div>

				<div class="g-recaptcha"
					data-sitekey="6Ld-7eIbAAAAAO070jFLpuiXkJbkX408OJwZS2ZO"></div>

				<div class="row">
					<div class="col-12" style="text-align: center;">
						<button type="submit" id="signup">Sign Up</button>
					</div>

				</div>
			</div>

		</form>
	</div>

	<script>
	$("#signup").on("click", function() {
		var captcha = 1;
		$.ajax({
            url: '/aMember/verifyRecaptcha',
            type: 'post',
            data: {
                recaptcha: $("#g-recaptcha-response").val()
            },
            success: function(data) {
                switch (data) {
                    case 0:
                        console.log("자동 가입 방지 봇 통과");
                        captcha = 0;
                		$("#signupForm").submit();
                		break;
                    case 1:
                        alert("자동 가입 방지 봇을 확인 한뒤 진행 해 주세요.");
                        break;
                    default:
                        alert("자동 가입 방지 봇을 실행 하던 중 오류가 발생 했습니다. [Error bot Code : " + Number(data) + "]");
                   		break;
                }
            }
        });
		if(captcha != 0) {
			return false;
		} 
});

		let idRegex = /^[a-z0-9]{4,}$/;
		let pwRegex = /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
		let phoneRegex = /^010\d{3,4}\d{4}$/;
		let emailRegex = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;

		$("#iid").on("blur", function() {
			$.ajax({
				url : "/aMember/idExist",
				type : "get",
				data : {
					"emp_id" : $("#iid").val()
				}
			}).done(function(res) {
				if (res < 1) {
					alert("Your ID is not exist in our company.");
					$("#iid").val("");
					$("#iid").focus();
				}
			}).fail(function(a, b, c) {
				alert("Server is unstable. try again.");
			})
		})
		$("#iname").on("blur", function() {
			$.ajax({
				url : "/aMember/nameExist",
				type : "get",
				data : {
					"name" : $("#iname").val()
				}
			}).done(function(res) {
				if (res < 1) {
					alert("Your name is not exist in our company.");
					$("#iname").val("");
					$("#iname").focus();
				}
			}).fail(function(a, b, c) {
				alert("Server is unstable. try again.");
			})
		})

		$("#ipw").on("blur", function() {
			let resultpw = pwRegex.test($("#ipw").val());
			if (resultpw) {
				return;
			} else {
				alert("최소 8자 이상, 영문, 숫자,  특수문자");
				$("#ipw").val("");
				$("#ipw").focus();
			}
		})

		$("#ipwC").on("blur", function() {
			console.log("비밀번호: " + $("#ipw").val());
			console.log("비밀번호 확인: " + $("#ipwC").val())
			if ($("#ipw").val() != $("#ipwC").val()) {
				$("#pwCheck").css("color", "red");
				$("#pwCheck").html("비밀번호가 다릅니다.");
			} else {
				$("#pwCheck").css("color", "blue");
				$("#pwCheck").html("비밀번호 확인 완료");
			}
		})
		$("#iphone").on("blur", function() {
			let resultphone = phoneRegex.test($("#iphone").val());
			if (resultphone) {
				return;
			} else {
				alert("핸드폰 번호를 확인하세요. ex)01012341234");
				$("#iphone").val("");
				$("#iphone").focus();
			}
		})

		$("#iemail").on("blur", function() {
			let resultEmail = emailRegex.test($("#iemail").val());
			if (resultEmail) {
				return;
			} else {
				alert("사용불가능한 메일입니다. 다른 메일을 입력하세요.");

				$("#iemail").val("");
			}
		})
	</script>
</body>
</html>