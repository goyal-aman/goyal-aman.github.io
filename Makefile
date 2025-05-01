compile-and-run:
	@echo "Compiling..."
	@docker run --rm -p 1313:1313 -v $(PWD)/hello:/src -w /src peaceiris/hugo:v0.124.1 server --baseURL http://localhost:1313/ --bind 0.0.0.0 
	@echo "Running..."