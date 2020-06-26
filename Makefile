build: ## Build the container
	docker build -t this-moon-cow-does-not-exist .

run: build
	docker run this-moon-cow-does-not-exist:latest