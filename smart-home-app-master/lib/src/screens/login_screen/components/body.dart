import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:domus/config/size_config.dart';
import 'package:domus/src/screens/home_screen/home_screen.dart';

class Body extends StatefulWidget {
	const Body({Key? key}) : super(key: key);

	@override
	_BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	bool _isLoading = false;
	String? _errorMessage;

	final String apiUrl = "https://ee1b-223-185-203-96.ngrok-free.app/login";
	final Dio _dio = Dio(); // Instantiate Dio

	Future<void> _login() async {
		setState(() {
			_isLoading = true;
			_errorMessage = null;
		});

		final String email = _emailController.text.trim();
		final String password = _passwordController.text.trim();

		if (email.isEmpty || password.isEmpty) {
			setState(() {
				_errorMessage = "Email and password cannot be empty";
				_isLoading = false;
			});
			return;
		}

		try {
			print(email);
			print(password);

			// Use Dio for the POST request
			final response = await _dio.post(
				apiUrl,
				data: {
					"email": email,
					"password": password,
				},
			);

			print("Response Status: ${response.statusCode}");
			print("Response Body: ${response.data}");

			if (response.statusCode == 200 && response.data.containsKey("token")) {
				final String token = response.data["token"]; // Store if needed
				Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
			} else {
				setState(() {
					_errorMessage = response.data["message"] ?? "Invalid email or password";
				});
			}
		} catch (error) {
			print("Error: $error");
			setState(() {
				_errorMessage = "Network error. Please try again.";
			});
		} finally {
			setState(() {
				_isLoading = false;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return SingleChildScrollView(
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Stack(
						children: [
							Image.asset(
								'assets/images/login.png',
								height: getProportionateScreenHeight(300),
								width: double.infinity,
								fit: BoxFit.fill,
							),
							Positioned(
								bottom: getProportionateScreenHeight(20),
								left: getProportionateScreenWidth(20),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											'SMART',
											style: Theme.of(context).textTheme.displayMedium!.copyWith(
													color: Colors.black, fontSize: 33),
										),
										Text(
											'HOME',
											style: Theme.of(context).textTheme.displayLarge!.copyWith(
													color: Colors.black, fontSize: 64),
										),
									],
								),
							),
						],
					),
					const Padding(
						padding: EdgeInsets.all(20.0),
						child: Text(
							'Sign into \nmanaging your device & accessories',
							style: TextStyle(fontSize: 18),
						),
					),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 20.0),
						child: TextField(
							controller: _emailController,
							decoration: InputDecoration(
								contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(70.0),
								),
								hintText: 'Email',
								suffixIcon: const Icon(Icons.email, color: Colors.black),
							),
						),
					),
					SizedBox(height: getProportionateScreenHeight(20)),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 20.0),
						child: TextField(
							controller: _passwordController,
							obscureText: true,
							decoration: InputDecoration(
								contentPadding: const EdgeInsets.only(left: 40.0, right: 20.0),
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(70.0),
								),
								hintText: 'Password',
								suffixIcon: const Icon(Icons.lock, color: Colors.black),
							),
						),
					),
					if (_errorMessage != null) ...[
						SizedBox(height: getProportionateScreenHeight(10)),
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 20.0),
							child: Text(
								_errorMessage!,
								style: const TextStyle(color: Colors.red, fontSize: 14),
							),
						),
					],
					SizedBox(height: getProportionateScreenHeight(20)),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 20.0),
						child: GestureDetector(
							onTap: _isLoading ? null : _login,
							child: Container(
								width: double.infinity,
								padding: const EdgeInsets.all(16.0),
								decoration: BoxDecoration(
									color: _isLoading ? Colors.grey : const Color(0xFF464646),
									borderRadius: BorderRadius.circular(70.0),
								),
								alignment: Alignment.center,
								child: _isLoading
										? const CircularProgressIndicator(color: Colors.white)
										: const Text(
									'Get Started',
									style: TextStyle(color: Colors.white),
								),
							),
						),
					),
					SizedBox(height: getProportionateScreenHeight(10)),
					const Center(child: Text("Don't have an account yet?")),
				],
			),
		);
	}
}
